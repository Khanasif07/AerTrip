//
//  FlightBookingsDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 27/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import SafariServices
import UIKit

class FlightBookingsDetailsVC: BaseVC {
    // MARK: - Variables
    
    // MARK: -
    
    let viewModel = BookingProductDetailVM()
    var headerView: OtherBookingDetailsHeaderView?
    var eventTypeImage: UIImage {
        return #imageLiteral(resourceName: "flightIcon")
    }
    
    private var navBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 84.0 : 64.0
    }
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var topNavBar: TopNavigationView!
    @IBOutlet var bookingDetailsTableView: ATTableView! {
        didSet {
            self.bookingDetailsTableView.estimatedRowHeight = 100.0
            self.bookingDetailsTableView.rowHeight = UITableView.automaticDimension
            self.bookingDetailsTableView.contentInset = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.bookingDetailsTableView.estimatedSectionHeaderHeight = CGFloat.zero
            self.bookingDetailsTableView.sectionHeaderHeight = CGFloat.zero
        }
    }
    
    @IBOutlet var topNavBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.statusBarStyle = .lightContent
    }
    
    override func initialSetup() {
        self.statusBarStyle = .default
        self.topNavBarHeightConstraint.constant = self.navBarHeight
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 147.0))
        self.headerView?.dividerView.isHidden = true
        self.setupParallaxHeader()
        self.registerNibs()
        
        // Call to get booking detail
        self.viewModel.getBookingDetail()
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
    
    // MARK: - Functions
    
    // MARK: -
    
    /// ConfigureCheckInOutView
    func configureTableHeaderView() {
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: self.viewModel.bookingDetail?.id ?? "", bookingIdNumbers: self.viewModel.bookingDetail?.bookingNumber ?? "", date: self.viewModel.bookingDetail?.bookingDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.toString(dateFormat: "d MMM ''yy") ?? "")
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(147.0)
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74 // 105
        self.bookingDetailsTableView.parallaxHeader.view = self.headerView
        self.bookingDetailsTableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.bookingDetailsTableView.parallaxHeader.height = parallexHeaderHeight
        self.bookingDetailsTableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.bookingDetailsTableView.parallaxHeader.delegate = self
        self.view.bringSubviewToFront(self.topNavBar)
    }
    
    private func registerNibs() {
        self.bookingDetailsTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightBookingsRequestTitleTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightBookingRequestsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightCarriersTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightBoardingAndDestinationTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TravellersPnrStatusTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingTravellersDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingDocumentsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: PaymentInfoTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: PaymentPendingTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: FlightsOptionsTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherHeaderTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherInfoTableViewCell.reusableIdentifier)
    }
    
    func webCheckinServices(url: String) {
        // TODO: - Need to be synced with backend Api key
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        AppFlowManager.default.mainNavigationController.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
}
