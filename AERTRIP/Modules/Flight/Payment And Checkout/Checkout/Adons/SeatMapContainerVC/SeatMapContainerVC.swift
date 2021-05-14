//
//  SeatMapContainerVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

class SeatMapContainerVC: UIViewController {

    // MARK: Properties
    
    internal var viewModel = SeatMapContainerVM()
    internal var allChildVCs = [SeatMapVC]()
    internal var didBeginDraggingPlaneLayout = false
    
    private var hidePlaneLayoutWorkItem: DispatchWorkItem?
    private var highlightView: UIView?
    private var hasDisplayedInitialLoader = false
        
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    weak var delegate : AddonsUpdatedDelegate?

    // MARK: IBOutlets
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var seatMapContainerView: UIView!
    @IBOutlet weak var planeLayoutView: UIView!
    @IBOutlet weak var planeLayoutTopSeparatorView: UIView!
    @IBOutlet weak var planeLayoutBottomSeparatorView: UIView!
    @IBOutlet weak var planeLayoutScrollView: UIScrollView!
    @IBOutlet weak var planeLayoutScrollContentView: UIView!
    @IBOutlet weak var planeShadowView: UIView!
    @IBOutlet weak var bodyImgView: UIImageView!
    @IBOutlet weak var noseImgView: UIImageView!
    @IBOutlet weak var topWingImgView: UIImageView!
    @IBOutlet weak var bottomWingImgView: UIImageView!
    @IBOutlet weak var tailImgView: UIImageView!
    @IBOutlet weak var planeLayoutCollView: UICollectionView!
    @IBOutlet weak var planeLayoutCollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var totalSeatAmountView: UIView!
    @IBOutlet weak var bottomWhiteView: UIView!
    @IBOutlet weak var totalSeatAmountTopSeparatorView: UIView!
    @IBOutlet weak var seatTotalTitleLbl: UILabel!
    @IBOutlet weak var seatTotalLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var totalSeatAmountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var highlightContainerView: UIView!
    @IBOutlet weak var apiProgressView: UIProgressView!
    @IBOutlet weak var apiIndicatorView: UIActivityIndicatorView!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.seatMapContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !hasDisplayedInitialLoader else { return }
        hasDisplayedInitialLoader = true
        if viewModel.setupFor == .preSelection {
            if AddonsDataStore.shared.originalSeatMapModel == nil {
                animateProgressView(duration: 3, progress: 0.25, completion: nil)
            } else {
                animateProgressView(duration: 1, progress: 1, completion: {
                    DispatchQueue.delay(1) { [weak self] in
                        self?.apiProgressView.setProgress(0, animated: false)
                    }
                })
            }
        } else {
            animateProgressView(duration: 1, progress: 0.25, completion: nil)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        if viewModel.setupFor == .preSelection {
            AddonsDataStore.shared.seatsArray = viewModel.selectedSeats
            AddonsDataStore.shared.originalSeatMapModel = viewModel.seatMapModel
            AddonsDataStore.shared.seatsAllFlightsData = viewModel.allFlightsData
            viewModel.getSeatTotal { [weak self] (seatTotal) in
                self?.delegate?.seatsUpdated(amount: seatTotal)
            }
            dismiss(animated: true, completion: nil)
        } else {
            viewModel.hitPostSeatConfirmationAPI()
        }
                
        viewModel.selectedSeats.forEach { (seat) in
            FirebaseEventLogs.shared.logAddons(with: FirebaseEventLogs.EventsTypeName.addSeatAddons,  flightTitle: "\(seat.ttl)", value: "SeatNumber:\(seat.columnData.ssrCode), Price:\(seat.columnData.amount)")
        }
        
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        setupNavBar()
        setupViews()
        addHighlightView()
        viewModel.delegate = self
        planeLayoutScrollView.delegate = self
        self.planeLayoutView.isHidden = true
        self.planeShadowView.isHidden = true
//        delay(seconds: 0.2) {
        delay(seconds: 1) {
            self.viewModel.fetchSeatMapData()
        }
            
            self.setupPlaneLayoutCollView()
            self.addPanToHighlightView()
//            self.planeLayoutView.isHidden = false
//            self.planeShadowView.isHidden = false
//        }
    }
    
    func setViewModel(_ vm: SeatMapContainerVM) {
        self.viewModel = vm
    }
    
    func setupFor(_ type: SeatMapContainerVM.SetupFor,_ bookingId: String) {
        viewModel.setupFor = type
        viewModel.bookingId = bookingId
    }
    
    func setBookingFlightLegsAndAddOns(_ legs: [BookingLeg],_ addOns: [BookingAddons]) {
        viewModel.bookingFlightLegs = legs
        viewModel.bookingAddOns = addOns.filter { $0.addonType.lowerCaseFirst() == "seat" }
    }
    
    private func setupPlaneLayoutCollView() {
        planeLayoutScrollContentView.backgroundColor = AppColors.greyO4
        planeLayoutScrollView.backgroundColor = AppColors.greyO4
        planeLayoutCollView.showsHorizontalScrollIndicator = false
        planeLayoutCollView.register(UINib(nibName: "LayoutSeatCollCell", bundle: nil), forCellWithReuseIdentifier: "LayoutSeatCollCell")
        planeLayoutCollView.backgroundColor = AppColors.themeGray10
        planeLayoutCollView.delegate = self
        planeLayoutCollView.dataSource = self
        planeShadowView.addShadow(ofColor: .black, radius: 60, opacity: 0.5)
        planeLayoutView.isHidden = true
        self.planeShadowView.isHidden = true
    }
    
    private func setupNavBar() {
        topNavBarView.configureNavBar(title: LocalizedString.seatMap.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        topNavBarView.configureLeftButton(normalTitle: clearStr, normalColor: AppColors.themeGreen)
        
        topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen)
        
        topNavBarView.delegate = self
    }
    
    private func setupViews() {
        setupApiIndicatorView()
        planeLayoutTopSeparatorView.backgroundColor = AppColors.themeGray214
        planeLayoutBottomSeparatorView.backgroundColor = AppColors.themeGray214
        totalSeatAmountTopSeparatorView.backgroundColor = AppColors.themeGray214
        seatTotalTitleLbl.text = LocalizedString.seatTotal.localized
        seatTotalTitleLbl.font = AppFonts.Regular.withSize(12)
        seatTotalTitleLbl.textColor = AppColors.themeGray60
        seatTotalLbl.font = AppFonts.SemiBold.withSize(19)
        seatTotalLbl.text = "₹ 0"
        addBtn.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        addBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        let addBtnTitle = viewModel.setupFor == .postSelection ? LocalizedString.CheckoutTitle.localized : LocalizedString.Add.localized
        addBtn.setTitle(addBtnTitle, for: .normal)
        totalSeatAmountView.addShadow(ofColor: .black, radius: 20, opacity: 0.1)
        apiProgressView.progressTintColor = UIColor.AertripColor
        apiProgressView.trackTintColor = .clear
        apiProgressView.setProgress(0, animated: false)
    }
    
    private func setupApiIndicatorView() {
        apiIndicatorView.color = AppColors.themeGreen
        apiIndicatorView.isHidden = true
    }
    
    private func addHighlightView() {
        highlightView = UIView(frame: .zero)
        highlightView?.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.1)
        highlightContainerView.addSubview(highlightView!)
    }
    
    private func animateProgressView(duration: TimeInterval = 1, progress: Float, completion: (() -> ())?) {
        UIView.animate(withDuration: duration, animations: {
            self.apiProgressView.setProgress(progress, animated: true)
        }, completion: { _ in
            completion?()
        })
    }
    
    private func setUpViewPager() {
        self.allChildVCs.removeAll()

        for index in 0..<viewModel.allFlightsData.count {
            let vc = SeatMapVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
            vc.setFlightData(viewModel.allFlightsData[index], viewModel.setupFor)
            vc.onReloadPlaneLayoutCall = { [weak self] updatedFlightData in
                guard let self = self else { return }
                if let flightData = updatedFlightData {
                    self.viewModel.allFlightsData[index] = flightData
                    self.viewModel.getSeatTotal { [weak self] (seatTotal) in
                        guard let self = self else { return }
                        self.seatTotalLbl.text = "₹ \(seatTotal.formattedWithCommaSeparator)"
                    }
                }
                self.planeLayoutCollView.reloadData()
                DispatchQueue.delay(0.5) { [weak self] in
                    self?.setCurrentPlaneLayout()
                }
            }
            vc.onScrollViewScroll = { [weak self] visibleRect in
                guard let self = self else { return }
                self.showPlaneLayoutView()
                self.updateVisibleRectInLayout(visibleRect)
            }
            self.allChildVCs.append(vc)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 30
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 55)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: -400, bottom: 0, right: -400))
        let nib = UINib(nibName: "MenuItemWithLogoCollCell", bundle: nil)
        self.parchmentView?.register(nib, for: LogoMenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeGray214
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        if self.parchmentView != nil{
            self.seatMapContainerView.addSubview(self.parchmentView!.view)
        }
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
        self.parchmentView?.contentInteraction = .none
    }
    
    private func createAttHeaderTitle(_ origin: String,_ destination: String) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: origin + "" )
        let desinationAtrributedString = NSAttributedString(string: "" + destination)
        let imageString = getStringFromImage(name : "oneway")
        fullString.append(imageString)
        fullString.append(desinationAtrributedString)
        return fullString
    }
    
    private func getStringFromImage(name : String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
//        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
        let sourceSansPro18 = AppFonts.SemiBold.withSize(18)
        let iconImage = UIImage(named: name )!
        imageAttachment.image = iconImage
        
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    internal func setCurrentPlaneLayout() {
        if planeLayoutCollViewWidth.constant == planeLayoutCollView.contentSize.width {
            return
        }
        planeLayoutCollView.reloadData()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.planeLayoutCollViewWidth.constant = self.planeLayoutCollView.contentSize.width
            self.planeLayoutScrollView.layoutIfNeeded()
        })
    }
    
    internal func showPlaneLayoutView(_ callHide: Bool = true) {
        
        hidePlaneLayoutWorkItem?.cancel()
        hidePlaneLayoutWorkItem = DispatchWorkItem(block: { [weak self] in
            self?.hidePlaneLayoutView()
        })
        
        UIView.animate(withDuration: 0.33, animations: { [weak self] in
            guard let self = self else { return }
            self.planeLayoutView.isHidden = false
            self.planeShadowView.isHidden = false
            self.planeLayoutView.alpha = 1
        }, completion:  {[weak self] _ in
            guard let self = self else { return }
            if callHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: self.hidePlaneLayoutWorkItem!)
            }
        })
    }
    
    private func hidePlaneLayoutView() {
        UIView.animate(withDuration: 0.33, animations:  { [weak self] in
            self?.planeLayoutView.alpha = 0
        })
        DispatchQueue.delay(0.34) { [weak self] in
            self?.planeLayoutView.isHidden = true
        }
    }
}

// MARK: Highlight View Methods
extension SeatMapContainerVC {
    
    /// updates highlighted view's frame
    private func updateVisibleRectInLayout(_ visibleRect: SeatMapVC.visibleRectMultipliers) {
        let rectForHighlightView = CGRect(x: highlightContainerView.width * visibleRect.xMul, y: highlightContainerView.height * visibleRect.yMul, width: highlightContainerView.width * visibleRect.widthMul, height: highlightContainerView.height * visibleRect.heightMul)
        highlightView?.frame = rectForHighlightView
        
        // To scroll main layout scrollview to visible area
        let convertedRectForHighlightView = highlightContainerView.convert(highlightView?.frame ?? .zero, to: planeLayoutScrollView)
        
        let convertedRectMaxXOffset = convertedRectForHighlightView.origin.x + convertedRectForHighlightView.width
        let scrollViewMaxXOffset = planeLayoutScrollView.contentOffset.x + planeLayoutScrollView.width - 100
        
        if convertedRectMaxXOffset > scrollViewMaxXOffset {
            
            self.planeLayoutScrollView.contentOffset.x += convertedRectMaxXOffset - scrollViewMaxXOffset
        }
        
        let convertedRectXOffset = convertedRectForHighlightView.origin.x
        let scrollViewXOffset = planeLayoutScrollView.contentOffset.x + 100
        if convertedRectXOffset < scrollViewXOffset {
            
            self.planeLayoutScrollView.contentOffset.x -= (scrollViewXOffset - convertedRectXOffset)
        }
    }
    
    /// adds pan gesture to highlighted view
    private func addPanToHighlightView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragHighlightedView(_:)))
        highlightView?.isUserInteractionEnabled = true
        highlightView?.addGestureRecognizer(panGesture)
    }
    
    @objc private func dragHighlightedView(_ sender: UIPanGestureRecognizer) {
        guard let highlighterView = highlightView else { return }
        let translation = sender.translation(in: highlightContainerView)
        
        highlightView?.center = CGPoint(x: highlighterView.center.x + translation.x, y: highlighterView.center.y + translation.y)
        if highlighterView.origin.x < 0 {
            highlightView?.origin.x = 0
        }
        if highlighterView.origin.y < 0 {
            highlightView?.origin.y = 0
        }
        if highlighterView.frame.maxX > highlightContainerView.width {
            highlightView?.origin.x = highlightContainerView.width - highlighterView.width
        }
        if highlighterView.frame.maxY > highlightContainerView.height {
            highlightView?.origin.y = highlightContainerView.height - highlighterView.height
        }
        showExtraScrollArea(translation.x)
        sender.setTranslation(.zero, in: highlightContainerView)
        moveLegScrollViewToPoint(highlighterView.frame.origin.x, highlighterView.frame.origin.y > 0 ? highlighterView.frame.origin.y : 0)
        showPlaneLayoutView()
    }
    
    private func showExtraScrollArea(_ translationX: CGFloat) {
        let convertedRectForHighlightView = highlightContainerView.convert(highlightView?.frame ?? .zero, to: planeLayoutScrollView)
        if translationX > 0 {
            let convertedRectMaxXOffset = convertedRectForHighlightView.origin.x + convertedRectForHighlightView.width
            let scrollViewMaxXOffset = planeLayoutScrollView.contentOffset.x + planeLayoutScrollView.width - 100
            if convertedRectMaxXOffset > scrollViewMaxXOffset {
                
                self.planeLayoutScrollView.contentOffset.x += 1
                self.highlightView?.origin.x += 1
            }
        } else {
            let convertedRectXOffset = convertedRectForHighlightView.origin.x
            let scrollViewXOffset = planeLayoutScrollView.contentOffset.x + 100
            if convertedRectXOffset < scrollViewXOffset {
                self.planeLayoutScrollView.contentOffset.x -= 1
                self.highlightView?.origin.x -= 1
            }
        }
    }
    
    private func moveLegScrollViewToPoint(_ originX: CGFloat,_ originY: CGFloat) {
        let xMul = originX / highlightContainerView.width
        let yMul = originY / highlightContainerView.height
        
        if let seatMapCollView = allChildVCs[viewModel.currentIndex].seatMapCollView {
            seatMapCollView.contentOffset = CGPoint(x: seatMapCollView.contentSize.width * xMul, y: seatMapCollView.contentSize.height * yMul)
        }
        
    }
}

extension SeatMapContainerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        if viewModel.selectedSeats.isEmpty { return }
        viewModel.allFlightsData = viewModel.originalAllFlightsData
        if viewModel.setupFor == .preSelection {
            AddonsDataStore.shared.seatsAllFlightsData = viewModel.originalAllFlightsData
            AddonsDataStore.shared.seatsArray.removeAll()
            delegate?.seatsUpdated(amount: 0)
        }
        allChildVCs.enumerated().forEach { (index, seatMapVC) in
            seatMapVC.setFlightData(viewModel.allFlightsData[index], viewModel.setupFor)
            if seatMapVC.viewModel.deckData.rows.count > 0 {
                if seatMapVC.seatMapCollView != nil {
                    seatMapVC.seatMapCollView.reloadData()
                }
            }
        }
        seatTotalLbl.text = "₹ 0"
        planeLayoutCollView.reloadData()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SeatMapContainerVC: SeatMapContainerDelegate {    
    
    func updateProgress(_ progress: Float) {
        if viewModel.isInternational {
            animateProgressView(progress: progress) {
                DispatchQueue.delay(1) { [ weak self] in
                    self?.apiProgressView.setProgress(0, animated: false)
                }
            }
        } else {
            let totalProgress = apiProgressView.progress
            animateProgressView(progress: progress + totalProgress) { [weak self] in
                guard let self = self else { return }
                if self.apiProgressView.progress >= 1 {
                    DispatchQueue.delay(1) { [ weak self] in
                        self?.apiProgressView.setProgress(0, animated: false)
                    }
                }
            }
        }
    }
    
    func willFetchSeatMapData() {
        
    }
    
    func failedToFetchSeatMapData() {
        
    }
    
    func willHitPostConfAPI() {
        
    }
    
    func didHitPostConfAPI() {
        
    }
    
    func didFetchSeatMapData() {
        var totalFlightsData = [SeatMapModel.SeatMapFlight]()
        viewModel.allTabsStr.removeAll()
        let legs = viewModel.seatMapModel.data.leg.values
        let legValues = legs.sorted(by: { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) })
    
        legValues.forEach {
            let flightsArr = $0.flights.map { $0.value }
            totalFlightsData.append(contentsOf: flightsArr)
            
            let flightsStr = $0.flights.map {
                createAttHeaderTitle($0.value.fr, $0.value.to)
            }
            viewModel.allTabsStr.append(contentsOf: flightsStr)
        }
        viewModel.originalAllFlightsData = totalFlightsData
        viewModel.allFlightsData = totalFlightsData
        if let allFlightsData = AddonsDataStore.shared.seatsAllFlightsData, viewModel.setupFor == .preSelection {
            viewModel.allFlightsData = allFlightsData
            viewModel.getSeatTotal { [weak self] (seatTotal) in
                guard let self = self else { return }
                self.seatTotalLbl.text = "₹ \(seatTotal.formattedWithCommaSeparator)"
            }
        } else if viewModel.setupFor == .postSelection {
            createPassengerContactsArr()
            // Resetting after setting passengers on seat
            viewModel.originalAllFlightsData = viewModel.allFlightsData
            viewModel.getSeatTotal { [weak self] (seatTotal) in
                guard let self = self else { return }
                self.seatTotalLbl.text = "₹ \(seatTotal.formattedWithCommaSeparator)"
            }
        }
        guard !viewModel.allTabsStr.isEmpty else { return }
        DispatchQueue.delay(0.3) {
            self.setUpViewPager()
            self.planeLayoutCollView.reloadData()
        }
        DispatchQueue.delay(0.5) {
            self.setCurrentPlaneLayout()
        }
    }
    
    
    func willFetchQuotationData(){
        apiIndicatorView.isHidden = false
        apiIndicatorView.startAnimating()
        addBtn.setTitleColor(.clear, for: .normal)
    }
    
    func didFetchQuotationData(_ quotationModel: AddonsQuotationsModel){
        apiIndicatorView.stopAnimating()
        apiIndicatorView.isHidden = true
        addBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        let vc = PostBookingAddonsPaymentVC.instantiate(fromAppStoryboard: .FlightPayment)
        vc.viewModel.addonsDetails = quotationModel
        vc.viewModel.bookingIds = self.viewModel.bookingIds
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func faildToFetchQuotationData(){
        apiIndicatorView.stopAnimating()
        apiIndicatorView.isHidden = true
        addBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        AppToast.default.showToastMessage(message: "Something went worng!")
    }
    
}

//MARK: Methods for Post Booking
extension SeatMapContainerVC {
    
    private func createPassengerContactsArr() {
        let passengers = viewModel.bookingFlightLegs.flatMap { $0.pax }
        
        var localPassengers: [ATContact] {
            var passArr = [ATContact]()
            passengers.forEach { (passenger) in
                var newContact = ATContact()
                newContact.id = passenger.uPid
                newContact.apiId = passenger.paxId
                newContact.firstName = passenger.firstName
                newContact.lastName = passenger.lastName
                newContact.image = passenger.profileImage
                if passArr.contains(where: { $0.id == newContact.id }) {
                    
                } else {
                    if passenger.paxType != "INF" {
                        passArr.append(newContact)
                    }
                }
            }
            return passArr
        }
        
        viewModel.bookedPassengersArr = localPassengers
        GuestDetailsVM.shared.guests[0] = viewModel.bookedPassengersArr
        createPassengerToSeatArray()
    }
    
    private func createPassengerToSeatArray() {
        var passengersToSeat: [SeatMapContainerVM.AddOnPassengersToSeatModel] {
            var passArr = [SeatMapContainerVM.AddOnPassengersToSeatModel]()
            viewModel.bookingAddOns.forEach { (addOn) in
                if let localPass = viewModel.bookedPassengersArr.first(where: { $0.apiId == addOn.paxId }) {
                    let seatStrComponents = addOn.extraDetails.components(separatedBy: ",")
                    var seatDict = JSONDictionary()
                    seatStrComponents.forEach { (component) in
                        let pair = component.components(separatedBy: "=")
                        if pair.count == 2 {
                            seatDict[pair[0]] = pair[1]
                        }
                    }
                    let seatJson = JSON(seatDict)
                    
                    let addOnFlightId = addOn.flightId
                    let rowNum = seatJson["Row"].intValue
                    let columnStr = seatJson["Column"].stringValue
                    
                    let passToSeat = SeatMapContainerVM.AddOnPassengersToSeatModel(localPass, addOnFlightId, rowNum, columnStr)
                    
                    passArr.append(passToSeat)
                }
            }
            return passArr
        }
        
        passengersToSeat.forEach { (passModel) in
            setPassengerOnSeat(passModel)
        }
    }
    
    private func setPassengerOnSeat(_ passengerModel: SeatMapContainerVM.AddOnPassengersToSeatModel) {
        
        viewModel.allFlightsData = viewModel.allFlightsData.map { (flightData) in
            var newFlightData = flightData
            if newFlightData.ffk == passengerModel.flightId {
                let mainDeckData = newFlightData.md
                let upperDeckData = newFlightData.ud
                if mainDeckData.rowsArr.contains("\(passengerModel.rowNum)"), mainDeckData.columns.contains(passengerModel.columnStr) {
                    newFlightData.md.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.isPreselected = true
                    newFlightData.md.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.columnData.passenger = passengerModel.passenger
                    
                    viewModel.originalBookedAddOnSeats.append(newFlightData.md.rows[passengerModel.rowNum]![passengerModel.columnStr]!)
                    
                } else if upperDeckData.rowsArr.contains("\(passengerModel.rowNum)"), mainDeckData.columns.contains(passengerModel.columnStr) {
                    
                    newFlightData.ud.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.isPreselected = true
                    newFlightData.ud.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.columnData.passenger = passengerModel.passenger
                    
                    viewModel.originalBookedAddOnSeats.append(newFlightData.ud.rows[passengerModel.rowNum]![passengerModel.columnStr]!)
                }
            }
            
            return newFlightData
        }
    }
}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithCommaSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
