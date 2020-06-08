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
    internal let hotelImageHeight: CGFloat = 211.0
    internal var didsmissOnScrollPosition: CGFloat = 200.0
    internal var viewTranslation = CGPoint(x: 0, y: 0)
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
            self.smallLineView.cornerRadius = self.smallLineView.height/2.0
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
        self.configureUI()
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
        let buttonImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "saveHotels")
        let selectedFevImage: UIImage = self.hotelInfo?.fav == "1" ? #imageLiteral(resourceName: "saveHotelsSelected") : #imageLiteral(resourceName: "save_icon_green")
        self.headerView.configureLeftButton(normalImage: buttonImage, selectedImage: selectedFevImage, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.hotelDetailsTableView.roundTopCorners(cornerRadius: 10.0)
        self.smallLineView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
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
