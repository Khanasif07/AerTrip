//
//  BookingHotelDetailVC.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHotelDetailVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var hotelDetailTableView: ATTableView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    // MARK: - Variables
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationHeaderTopConstraint: NSLayoutConstraint!
    let viewModel = BookingHotelDetailVM()
    let headerIdentifier = "BookingHDRoomDetailHeaderView"
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    private var navBarHeight: CGFloat {
        return AppFlowManager.default.mainNavigationController.navigationBar.bounds.height + AppFlowManager.default.safeAreaInsets.top
    }
    internal var completion: (() -> Void)? = nil
    internal var hotelImageHeight: CGFloat{
        
        if !(self.viewModel.bookingDetail?.bookingDetail?.atImageData.isEmpty ?? true){
            return UIScreen.width
        }else{
            return 85.0
        }
        
    }
    
    var presentingStatusBarStyle: UIStatusBarStyle = .darkContent,
    dismissalStatusBarStyle: UIStatusBarStyle = .darkContent
    
    // MARK: - Override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = presentingStatusBarStyle
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = dismissalStatusBarStyle
        }
    }
    
    override func initialSetup() {
        
        //self.tableViewTopConstraint.constant = -navBarHeight
        self.registerXib()
        self.hotelDetailTableView.dataSource = self
        self.hotelDetailTableView.delegate = self
        self.hotelDetailTableView.reloadData()
        self.hotelDetailTableView.backgroundColor = AppColors.themeGray04
        hotelDetailTableView.showsVerticalScrollIndicator = true
        self.configureNavBar()
        if self.viewModel.bookingDetail == nil {
            self.hotelDetailTableView.backgroundColor = AppColors.themeWhite
            self.viewModel.getBookingDetail()
        }else{
            self.setupTAViewmodel()
            self.downloadImages()
        }
        
        self.completion = { [weak self] in
            self?.hotelDetailTableView.reloadData()
            self?.viewModel.getBookingDetail()
        }
        if #available(iOS 13.0, *) {} else {
            self.navigationHeightConstraint.constant = 64
        }
        
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // Register xib file
    private func registerXib() {
        self.hotelDetailTableView.registerCell(nibName: HotelDetailsImgSlideCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName:
            HotelNameRatingTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingCancellationPolicyTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: HotelDetailAmenitiesCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: TripAdvisorTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: BookingHDWebPhoneTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingHDRoomDetailTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.register(UINib(nibName: self.headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerIdentifier)
        self.hotelDetailTableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: BookingCheckinCheckOutTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: BookingHotelsDetailsTravellerTableCell.reusableIdentifier)
        
        self.hotelDetailTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        
        self.hotelDetailTableView.registerCell(nibName: HotelDetailsLoaderTableViewCell.reusableIdentifier)
        self.hotelDetailTableView.registerCell(nibName: NoImageDetailsCell.reusableIdentifier)

        self.hotelDetailTableView.registerCell(nibName: HCPhoneTableViewCell.reusableIdentifier)

    }
    
    // configure nav bar
    private func configureNavBar() {
        self.topNavigationView.configureNavBar(title: nil , isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        
        self.topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.topNavigationView.firstRightButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        self.topNavigationView.navTitleLabel.numberOfLines = 1
        self.topNavigationView.firstRightButtonTrailingConstraint.constant = -3
        //self.topNavigationView.configureLeftButton(normalImage: UIImage(named: "Back"), selectedImage: UIImage(named: "Back"))
        self.topNavigationView.delegate = self
        self.topNavigationView.backgroundColor = .clear
        self.view.bringSubviewToFront(self.topNavigationView)
    }
    
    func setupTAViewmodel(){
        
        TAViewModel.shared.clearData()
        TAViewModel.shared.hotelId = self.viewModel.bookingDetail?.bookingDetail?.hotelId ?? ""
        TAViewModel.shared.getTripAdvisorDetails()
        
    }
}
extension BookingHotelDetailVC: BookingHotelDetailVMDelgate {
    func getHotelDetailsSuccess() {
        self.hotelDetailTableView.backgroundColor = AppColors.themeGray04
        self.setupTAViewmodel()
        self.downloadImages()
        self.hotelDetailTableView.reloadData()
    }
    
    func getHotelDetailsFail() {
        let index = IndexPath(row: 2, section: 0)
        if let cell = self.hotelDetailTableView.cellForRow(at: index) as? HotelDetailsLoaderTableViewCell {
            cell.activityIndicator.stopAnimating()
            delay(seconds: AppConstants.kAnimationDuration) {
                cell.activityIndicator.isHidden = true
            }
        }
        AppToast.default.showToastMessage(message: LocalizedString.InformationUnavailable.localized, onViewController: self, buttonTitle: LocalizedString.ReloadResults.localized, buttonAction: self.completion)
    }
    
    
    func downloadImages(){
        let downloadGroup = DispatchGroup()
        for (index, image) in (self.viewModel.bookingDetail?.bookingDetail?.atImageData ?? []).enumerated(){
            let imageView = UIImageView()
            if let imageurl = image.imagePath{
                downloadGroup.enter()
                imageView.setImageWithUrl(imageUrl: imageurl, placeholder: UIImage(), showIndicator: false) {[weak self] (img, err) in
                    guard let self = self else { return ()}
                    self.viewModel.bookingDetail?.bookingDetail?.atImageData[index].image = img
                    downloadGroup.leave()
                    return ()
                }
            }
        }
        downloadGroup.notify(queue: .main) {
            for image in (self.viewModel.bookingDetail?.bookingDetail?.atImageData ?? []){
                if image.image == nil, let index = self.viewModel.bookingDetail?.bookingDetail?.atImageData.firstIndex(where: {$0.imagePath == image.imagePath}){
                    self.viewModel.bookingDetail?.bookingDetail?.atImageData.remove(at: index)
                    self.viewModel.bookingDetail?.bookingDetail?.photos.remove(at: index)
                }
            }
            self.hotelDetailTableView.reloadData()
        }
    }
    
    
}
