//
//  HotelCheckoutDetailVC.swift
//  AERTRIP
//
//  Created by Admin on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCheckoutDetailVC: BaseVC {
    
    //Mark:- Variables
    //================
    internal var sectionData: [[TableCellType]] = []
    internal var viewModel: HotelDetails?
    internal var placeModel: PlaceModel?
    internal var hotelInfo: HotelSearched?
    internal var allIndexPath = [IndexPath]()
    internal weak var delegate: HotelCheckOutDetailsVIewDelegate?
    internal var roomRates = [[RoomsRates : Int]]()
    internal var requestParameters:RequestParameters?
    internal var hotelImageHeight: CGFloat{
        if (self.sectionData.first?.contains(.imageSlideCell) ?? true){
            return UIScreen.width
        }else{
            return 85.0
        }
    }
    internal var didsmissOnScrollPosition: CGFloat = 200.0
    internal var viewTranslation = CGPoint(x: 0, y: 0)
    var isAllImageDownloadFails = false
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelDetailsTableView: UITableView! {
        didSet {
            self.hotelDetailsTableView.delegate = self
            self.hotelDetailsTableView.dataSource = self
            self.hotelDetailsTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var headerView: TopNavigationView! {
        didSet{
            self.headerView.roundTopCorners(cornerRadius: 10.0)
        }
    }
    @IBOutlet weak var smallLineView: UIView! {
        didSet {
            self.smallLineView.cornerradius = self.smallLineView.height/2.0
            self.smallLineView.clipsToBounds = true
        }
    }
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfHeader: NSLayoutConstraint!

    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(seconds: 0.2) {
            self.hotelDetailsTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        printDebug("HotelCheckoutDetailVC deinit")
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        if #available(iOS 13.0, *) {} else {
        self.headerTopConstraint.constant = AppFlowManager.default.safeAreaInsets.top + 8
            self.tableViewTopConstraint.constant = AppFlowManager.default.safeAreaInsets.top + 8
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
            self.view.backgroundColor = AppColors.clear
        }
        DispatchQueue.main.async {
            self.configureUI()
        }
        delay(seconds: 0.2) {
            self.downloadImages()
        }
    }
    
    ///ConfigureUI
    private func configureUI() {
        self.registerXibs()
        self.headerViewSetUp()
    }
    
    internal func updateData() {
        self.headerViewSetUp()
        self.hotelDetailsTableView.reloadData()
    }
    
    private func headerViewSetUp() {
        self.view.backgroundColor = .clear
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: nil , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        let buttonImage: UIImage = self.hotelInfo?.fav == "1" ? AppImages.saveHotelsSelected : AppImages.saveHotels
        let selectedFevImage: UIImage = self.hotelInfo?.fav == "1" ? AppImages.saveHotelsSelected : AppImages.save_icon_green
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: AppImages.CancelButtonWhite, selectedImage: AppImages.CancelButtonWhite, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.firstRightButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.headerView.firstLeftButtonLeadingConst.constant = 4.5
        self.headerView.firstRightButtonTrailingConstraint.constant = -3
        self.hotelDetailsTableView.roundTopCorners(cornerRadius: 10.0)
        self.smallLineView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.headerView.navTitleLabel.numberOfLines = 1
    }
    
    private func registerXibs() {
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsImgSlideCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HCDataHotelRatingInfoTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailAmenitiesCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: TripAdvisorTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsBedsTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HCCheckInOutTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: HCRoomTableViewCell.reusableIdentifier)
        self.hotelDetailsTableView.registerCell(nibName: NoImageDetailsCell.reusableIdentifier)
    }
    
    func downloadImages(){
        let downloadGroup = DispatchGroup()
        for (index, image) in (self.viewModel?.atImageData ?? []).enumerated(){
            let imageView = UIImageView()
            if let imageurl = image.imagePath{
                downloadGroup.enter()
                imageView.setImageWithUrl(imageUrl: imageurl, placeholder: UIImage(), showIndicator: false) {[weak self] (img, err) in
                    guard let self = self else { return ()}
                    self.viewModel?.atImageData[index].image = img
                    downloadGroup.leave()
                    return ()
                }
            }
        }
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else {return}
            for image in (strongSelf.viewModel?.atImageData ?? []){
                if image.image == nil, let index = strongSelf.viewModel?.atImageData.firstIndex(where: {$0.imagePath == image.imagePath}){
                    strongSelf.viewModel?.atImageData.remove(at: index)
                    strongSelf.viewModel?.photos.remove(at: index)
                }
            }
            if strongSelf.viewModel?.atImageData.count != 0{
                strongSelf.hotelDetailsTableView.reloadData()
            }else{
                strongSelf.removeImageCell()
                strongSelf.hotelDetailsTableView.reloadData()
            }
        }
    }
    
    func removeImageCell(){
        if self.sectionData.count != 0, let index = self.sectionData.first?.firstIndex(where: {$0 == .imageSlideCell}){
            self.sectionData[0].remove(at: index)
            self.sectionData[0].insert(.noImageCell, at: 0)
        }
    }
}
extension HotelCheckoutDetailVC {
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.hotelDetailsTableView.contentOffset.y <= 0
            else {
            reset()
            return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
