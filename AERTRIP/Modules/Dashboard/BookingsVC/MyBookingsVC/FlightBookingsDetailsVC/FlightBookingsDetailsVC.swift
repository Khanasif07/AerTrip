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
    
    var tripChangeIndexPath: IndexPath?
    var updatedTripDetail: TripModel?
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var topNavBar: TopNavigationView!
    @IBOutlet var bookingDetailsTableView: ATTableView! {
        didSet {
            self.bookingDetailsTableView.estimatedRowHeight = 100.0
            self.bookingDetailsTableView.rowHeight = UITableView.automaticDimension
            self.bookingDetailsTableView.estimatedSectionHeaderHeight = 0
            self.bookingDetailsTableView.sectionHeaderHeight = 0
        }
    }
    
    @IBOutlet var topNavBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func initialSetup() {
        self.topNavBarHeightConstraint.constant = self.navBarHeight
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 147.0))
        self.configureTableHeaderView()
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
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .myBookingCasesRequestStatusChanged {
            self.viewModel.getBookingDetail()
        }
    }
    
    // MARK: - Functions
    
    // MARK: -
    
    /// ConfigureCheckInOutView
    func configureTableHeaderView() {
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: self.viewModel.bookingDetail?.id ?? "", bookingIdNumbers: self.viewModel.bookingDetail?.bookingNumber ?? "", date: self.viewModel.bookingDetail?.bookingDate?.toString(dateFormat: "d MMM''yy") ?? "")
            
            view.dividerView.isHidden = true
            if let note = self.viewModel.bookingDetail?.bookingDetail?.note, !note.isEmpty {
                view.dividerView.isHidden = false
            }
            else if let cases = self.viewModel.bookingDetail?.cases, !cases.isEmpty {
                view.dividerView.isHidden = false
            }
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(147.0)
        let parallexHeaderMinHeight = CGFloat(0.0)//navigationController?.navigationBar.bounds.height ?? 74 // 105
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
        self.bookingDetailsTableView.registerCell(nibName: WeatherFooterTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: WeatherInfoTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: TripChangeTableViewCell.reusableIdentifier)
        self.bookingDetailsTableView.registerCell(nibName: BookingCommonActionTableViewCell.reusableIdentifier)
    }
    
    func webCheckinServices(url: String) {
        // TODO: - Need to be synced with backend Api key
        guard let url = url.toUrl else { return }
        AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Web Checkin")
    }
    
    // Present Request Add on Frequent Flyer VC
    func presentRequestAddOnFrequentFlyer() {
        AppFlowManager.default.presentBookingReuqestAddOnVC(bookingdata: self.viewModel.bookingDetail,delegate: self)
    }
    
    // Present Booking Rescheduling VC
    func presentBookingReschedulingVC() {
        if let leg = self.viewModel.bookingDetail?.bookingDetail?.leg {
            AppFlowManager.default.presentBookingReschedulingVC(legs: leg)
        }
    }
}
