//
//  HotlelBookingsDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

class HotlelBookingsDetailsVC: BaseVC {
    // MARK: - Variables
    
    // MARK: -
    
    let viewModel = BookingProductDetailVM()
    var headerView: OtherBookingDetailsHeaderView?
    var eventTypeImage: UIImage {
        return #imageLiteral(resourceName: "hotelAerinIcon")
    }
    
    private var navBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    
    var tripChangeIndexPath: IndexPath?
    var updatedTripDetail: TripModel?
    var navigationTitleText: String = ""
    
    var maxValue: CGFloat = 1.0
    var minValue: CGFloat = 0.0
    var finalMaxValue: Int = 0
    var currentProgress: CGFloat = 0
    var currentProgressIntValue: Int = 0
    
    var isScrollingFirstTime: Bool = true
    var isNavBarHidden:Bool = true
    let headerHeightToAnimate: CGFloat = 30.0
    var isHeaderAnimating: Bool = false
    var isBackBtnTapped = false
    let refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var bookingDetailsTableView: ATTableView! {
        didSet {
            self.bookingDetailsTableView.estimatedRowHeight = 100.0
            self.bookingDetailsTableView.rowHeight = UITableView.automaticDimension
            self.bookingDetailsTableView.estimatedSectionHeaderHeight = 0
            self.bookingDetailsTableView.sectionHeaderHeight = 0
            self.bookingDetailsTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .bookingDetailFetched, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func initialSetup() {
        self.topNavBarHeightConstraint.constant = self.navBarHeight
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true, isDivider: false, backgroundType:.color(color: .white))
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.topNavBar.navTitleLabel.numberOfLines = 1
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 147.0))
        self.configureTableHeaderView(hideDivider: true)
        self.setupParallaxHeader()
        self.registerNibs()
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.bookingDetailsTableView.refreshControl = refreshControl
        
        // Call to get booking detail
        self.viewModel.getBookingDetail(showProgress: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bookingDetailFetched(_:)), name: .bookingDetailFetched, object: nil)
    }
    
    override func setupColors() {
        self.topNavBar.backgroundColor = AppColors.clear
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
        self.topNavBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let view = self.headerView {
            view.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0)
        }
    }
    
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification {
            if noti == .myBookingCasesRequestStatusChanged {
                self.viewModel.getBookingDetail(showProgress: true)
            }
        }
    }
    @objc func bookingDetailFetched(_ note: Notification) {
        if let object = note.object as? BookingDetailModel {
            printDebug("BookingDetailModel")
            if self.viewModel.bookingId == object.id {
                self.viewModel.bookingDetail = object
                self.getBookingDetailSucces(showProgress: false)
            }
        }
    }
    
    func getUpdatedTitle() -> String {
        var updatedTitle = self.viewModel.bookingDetail?.bookingDetail?.hotelName ?? ""
        //        if updatedTitle.count > 24 {
        //            updatedTitle = updatedTitle.substring(from: 0, to: 8) + "..." +  updatedTitle.substring(from: updatedTitle.count - 8, to: updatedTitle.count)
        //        }
        return updatedTitle
    }
    
    // MARK: - Functions
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.getBookingDetail(showProgress: false)
    }
    // MARK: -
    
    /// ConfigureCheckInOutView
    
    private func configureTableHeaderView(hideDivider: Bool) {
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: self.viewModel.bookingDetail?.id ?? "", bookingIdNumbers: self.viewModel.bookingDetail?.bookingNumber ?? "", date: self.viewModel.bookingDetail?.bookingDate?.toString(dateFormat: "d MMM''yy") ?? "")
            
            //view.dividerView.isHidden = hideDivider //true
            view.isBottomStroke = false
            if let note = self.viewModel.bookingDetail?.bookingDetail?.note, !note.isEmpty {
                //                view.dividerView.isHidden = false
                view.isBottomStroke = true
            }
            else if let cases = self.viewModel.bookingDetail?.cases, !cases.isEmpty {
                //                view.dividerView.isHidden = false
                view.isBottomStroke = true
            }
            if !hideDivider {
                view.dividerView.isHidden = !view.isBottomStroke
            }
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(147.0)
        let parallexHeaderMinHeight = CGFloat(0.0)//(navigationController?.navigationBar.bounds.height ?? 74) - 2
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.headerView?.widthAnchor.constraint(equalToConstant: bookingDetailsTableView?.width ?? 0.0).isActive = true
        self.bookingDetailsTableView.parallaxHeader.view = self.headerView
        self.bookingDetailsTableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.bookingDetailsTableView.parallaxHeader.height = parallexHeaderHeight
        self.bookingDetailsTableView.parallaxHeader.mode = MXParallaxHeaderMode.top
        self.bookingDetailsTableView.parallaxHeader.delegate = self
        self.view.bringSubviewToFront(self.topNavBar)
    }
    
    private func registerNibs() {
        self.bookingDetailsTableView.registerCell(nibName: HotelBookingAddressDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TravellersDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightBookingsRequestTitleTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightBookingRequestsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingTravellersDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingDocumentsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: PaymentInfoTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: PaymentPendingTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightsOptionsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherHeaderTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherInfoTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherFooterTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TripChangeTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingCommonActionTableViewCell.reusableIdentifier)
    }
}

extension HotlelBookingsDetailsVC: BookingProductDetailVMDelegate {
    func willGetBookingDetail(showProgress: Bool) {
        //AppGlobals.shared.startLoading()
        if showProgress {
            self.headerView?.startProgress()
        }
    }
    
    func getBookingDetailSucces(showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
            self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        self.configureTableHeaderView(hideDivider: showProgress)
        self.bookingDetailsTableView.delegate = self
        self.bookingDetailsTableView.dataSource = self
        self.viewModel.getSectionDataForHotelDetail()
        self.navigationTitleText = getUpdatedTitle()
        self.bookingDetailsTableView.reloadData()
        self.viewModel.getTripOwnerApi()
    }
    
    func getBookingDetailFaiure(error: ErrorCodes,showProgress: Bool) {
        //AppGlobals.shared.stopLoading()
        if showProgress {
            self.headerView?.stopProgress()
        }
        self.refreshControl.endRefreshing()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
    
    func willGetTripOwner() {
        
    }
    func getBTripOwnerSucces() {
        self.bookingDetailsTableView.reloadData()
    }
    func getTripOwnerFaiure(error: ErrorCodes) {
        self.bookingDetailsTableView.reloadData()
    }
}
