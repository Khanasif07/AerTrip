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
        return #imageLiteral(resourceName: "flightIconDetailPage")
    }
    var eventTypeNavigationBarImage: UIImage {
        return #imageLiteral(resourceName: "BookingDetailFlightNavIcon")
    }
    
    
    private var navBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    
    var tripChangeIndexPath: IndexPath?
    var updatedTripDetail: TripModel?
    
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
            bookingDetailsTableView.showsVerticalScrollIndicator = true
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
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true, isDivider: false, backgroundType: .color(color: .white))
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        //self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.topNavBar.configureFirstRightButton(normalTitle: LocalizedString.Request.localized, normalColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18))
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 147.0))
        self.configureTableHeaderView(hideDivider: true)
        self.setupParallaxHeader()
        self.registerNibs()
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        //self.bookingDetailsTableView.refreshControl = refreshControl
        
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
            switch noti {
            case .myBookingCasesRequestStatusChanged:
                self.viewModel.getBookingDetail(showProgress: true)
            default:
                break
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
    
    // MARK: - Functions
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.getBookingDetail(showProgress: false)
    }
    // MARK: -
    
    /// ConfigureCheckInOutView
    func configureTableHeaderView(hideDivider: Bool) {
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: self.viewModel.bookingDetail?.id ?? "", bookingIdNumbers: self.viewModel.bookingDetail?.bookingNumber ?? "", date: self.viewModel.bookingDetail?.bookingDate?.toString(dateFormat: "d MMM’ yy") ?? "")
            
            view.dividerView.isHidden = true
            view.isBottomStroke = false
            view.progressBottomConstraint.constant = 0.0
            if let note = self.viewModel.bookingDetail?.bookingDetail?.note, !note.isEmpty {
                //                view.dividerView.isHidden = false
                view.isBottomStroke = true
                //                view.progressBottomConstraint.constant = 2.0
            }
            else if let cases = self.viewModel.bookingDetail?.cases, !cases.isEmpty {
                //                view.dividerView.isHidden = false
                view.isBottomStroke = true
                //                view.progressBottomConstraint.constant = 2.0
            }
            if !hideDivider {
                view.dividerView.isHidden = !view.isBottomStroke
            }
        }
    }
    
    
    func whatNextForSameFlightBook()-> WhatNext?{
        guard let detail = self.viewModel.bookingDetail, let fDetails = detail.bookingDetail else { return nil}
        var whatNext = WhatNext(isFor: "Hotel")
        if let leg = fDetails.leg.first {
            whatNext.departCity = (leg.title.components(separatedBy: "→").first ?? "").trimmingCharacters(in: .whitespaces)
            whatNext.arrivalCity = (leg.title.components(separatedBy: "→").last ?? "").trimmingCharacters(in: .whitespaces)
            whatNext.origin = leg.origin
            whatNext.destination = leg.destination
            whatNext.cabinclass = leg.flight.first?.cabinClass ?? "Economy"
            
            whatNext.depart = leg.flight.first?.departDate?.toString(dateFormat: "dd-MM-yyyy") ?? ""
            whatNext.tripType = detail.tripType
            whatNext.adult = "\((leg.pax.filter{$0.paxType.uppercased() == "ADT"}).count)"
            whatNext.child = "\((leg.pax.filter{$0.paxType.uppercased() == "CHD"}).count)"
            whatNext.infant = "\((leg.pax.filter{$0.paxType.uppercased() == "INF"}).count)"
        }else{
            return nil
        }
        
        switch detail.tripType{
        case "single", "return":
            if detail.tripType != "single"{
                whatNext.returnDate = fDetails.leg.last?.flight.first?.departDate?.toString(dateFormat: "dd-MM-yyyy") ?? ""
            }
            return whatNext
            
        case "multi":
            var depart = [String]()
            var origin = [String]()
            var destination = [String]()
            var departCity = [String]()
            var arrivalCity = [String]()
            
            for leg in fDetails.leg{
                depart.append(leg.flight.first?.departDate?.toString(dateFormat: "dd-MM-yyyy") ?? "")
                origin.append(leg.origin)
                destination.append(leg.destination)
                departCity.append((leg.title.components(separatedBy: "→").first ?? "").trimmingCharacters(in: .whitespaces))
                arrivalCity.append((leg.title.components(separatedBy: "→").last ?? "").trimmingCharacters(in: .whitespaces))
                whatNext.departArr = depart
                whatNext.originArr = origin
                whatNext.destinationArr = destination
                whatNext.departCityArr = departCity
                whatNext.arrivalCityArr = arrivalCity
            }
            return whatNext
        default : break;
        }
        
        return nil
        
    }
    
    func bookSameFlightWith(_ whatNext:WhatNext){
        FlightWhatNextData.shared.isSettingForWhatNext = true
        FlightWhatNextData.shared.whatNext = whatNext
        AppFlowManager.default.goToDashboard(toBeSelect: .flight)
        
    }
    
    func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            switch index {
            case 0:
                //PayOnline
                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData, usingToPaymentFor: .booking)
                
            case 1:
                //PayOfflineNRegister
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, usingToPaymentFor: .addOns, paymentModeDetail: self.viewModel.itineraryData?.chequeOrDD, netAmount: self.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("PayOfflineNRegister")
                
            default:
                printDebug("no need to implement")
            }
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(147.0)
        let parallexHeaderMinHeight = CGFloat(0.0)//navigationController?.navigationBar.bounds.height ?? 74 // 105
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.headerView?.widthAnchor.constraint(equalToConstant: bookingDetailsTableView?.width ?? 0.0).isActive = true
        
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
        //guard let url = url.toUrl else { return }
        //AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Web Checkin")
        self.openUrl( url)
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
