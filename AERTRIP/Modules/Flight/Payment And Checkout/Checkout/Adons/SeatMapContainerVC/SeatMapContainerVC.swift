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
    @IBOutlet weak var totalSeatAmountTopSeparatorView: UIView!
    @IBOutlet weak var seatTotalTitleLbl: UILabel!
    @IBOutlet weak var seatTotalLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var totalSeatAmountViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var highlightContainerView: UIView!
    
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
    
    // MARK: IBActions
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        if viewModel.setupFor == .preSelection {
            AddonsDataStore.shared.seatsArray = viewModel.selectedSeats
            AddonsDataStore.shared.originalSeatMapModel = viewModel.seatMapModel
            AddonsDataStore.shared.seatsAllFlightsData = viewModel.allFlightsData
            self.delegate?.seatsUpdated()
            dismiss(animated: true, completion: nil)
        } else {
            viewModel.hitPostSeatConfirmationAPI()
        }
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        setupNavBar()
        setupViews()
        addHighlightView()
        viewModel.delegate = self
        viewModel.fetchSeatMapData()
        setupPlaneLayoutCollView()
        planeLayoutScrollView.delegate = self
        addPanToHighlightView()
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
        viewModel.bookingAddOns = addOns.filter { $0.addonType == "seat" }
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
    }
    
    private func setupNavBar() {
        topNavBarView.configureNavBar(title: LocalizedString.seatMap.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        
        topNavBarView.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen)
        
        topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
        
        topNavBarView.delegate = self
    }
    
    private func setupViews() {
        planeLayoutTopSeparatorView.backgroundColor = AppColors.themeGray20
        planeLayoutBottomSeparatorView.backgroundColor = AppColors.themeGray20
        totalSeatAmountTopSeparatorView.backgroundColor = AppColors.themeGray20
        seatTotalTitleLbl.text = LocalizedString.seatTotal.localized
        seatTotalTitleLbl.font = AppFonts.Regular.withSize(12)
        seatTotalTitleLbl.textColor = AppColors.themeGray60
        seatTotalLbl.font = AppFonts.SemiBold.withSize(19)
        seatTotalLbl.text = "₹ 0"
        addBtn.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        addBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        addBtn.setTitle(LocalizedString.Add.localized, for: .normal)
    }
    
    private func addHighlightView() {
        highlightView = UIView(frame: .zero)
        highlightView?.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.1)
        highlightContainerView.addSubview(highlightView!)
    }
    
    private func setUpViewPager() {
        self.allChildVCs.removeAll()

        for index in 0..<viewModel.allTabsStr.count {
            let vc = SeatMapVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
            vc.setFlightData(viewModel.allFlightsData[index])
//            if viewModel.setupFor == .postSelection {
//                vc.setPassengersFromBooking(viewModel.bookedPassengersArr)
//            }
            vc.onReloadPlaneLayoutCall = { [weak self] updatedFlightData in
                guard let self = self else { return }
                if let flightData = updatedFlightData {
                    self.viewModel.allFlightsData[index] = flightData
                    self.viewModel.getSeatTotal { [weak self] (seatTotal) in
                        guard let self = self else { return }
                        self.seatTotalLbl.text = "₹ \(seatTotal)"
                    }
                }
                self.planeLayoutCollView.reloadData()
                DispatchQueue.delay(0.5) {
                    self.setCurrentPlaneLayout()
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
        self.parchmentView?.menuItemSpacing = (self.view.width - 251.5) / 2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 33.0, bottom: 0.0, right: 38.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 56)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets.zero)
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.seatMapContainerView.addSubview(self.parchmentView!.view)
        
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
        let fullString = NSMutableAttributedString(string: origin + " " )
        let desinationAtrributedString = NSAttributedString(string: " " + destination)
        let imageString = getStringFromImage(name : "oneway")
        fullString.append(imageString)
        fullString.append(desinationAtrributedString)
        return fullString
    }
    
    private func getStringFromImage(name : String) -> NSAttributedString {
        
        let imageAttachment = NSTextAttachment()
        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
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
        UIView.animate(withDuration: 0.3, animations: {
            self.planeLayoutCollViewWidth.constant = self.planeLayoutCollView.contentSize.width
            self.planeLayoutScrollView.layoutIfNeeded()
        })
    }
    
    internal func showPlaneLayoutView(_ callHide: Bool = true) {
        
        hidePlaneLayoutWorkItem?.cancel()
        hidePlaneLayoutWorkItem = DispatchWorkItem(block: {
            hidePlaneLayoutView()
        })
        
        func hidePlaneLayoutView() {
            UIView.animate(withDuration: 0.33, animations:  {
                self.planeLayoutView.alpha = 0
            })
            DispatchQueue.delay(0.34) {
                self.planeLayoutView.isHidden = true
            }
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            self.planeLayoutView.isHidden = false
            self.planeLayoutView.alpha = 1
        }, completion:  { _ in
            if callHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: self.hidePlaneLayoutWorkItem!)
            }
        })
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
        let scrollViewMaxXOffset = planeLayoutScrollView.contentOffset.x + planeLayoutScrollView.width
        
        if convertedRectMaxXOffset > scrollViewMaxXOffset {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.planeLayoutScrollView.contentOffset.x += 20
            }, completion: nil)
        }
        
        let convertedRectXOffset = convertedRectForHighlightView.origin.x
        let scrollViewXOffset = planeLayoutScrollView.contentOffset.x
        if convertedRectXOffset < scrollViewXOffset {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                self.planeLayoutScrollView.contentOffset.x -= 20
            }, completion: nil)
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
            let scrollViewMaxXOffset = planeLayoutScrollView.contentOffset.x + planeLayoutScrollView.width
            if convertedRectMaxXOffset > scrollViewMaxXOffset {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.planeLayoutScrollView.contentOffset.x += 5
                    self.highlightView?.origin.x += 5
                }, completion: nil)
            }
        } else {
            let convertedRectXOffset = convertedRectForHighlightView.origin.x
            let scrollViewXOffset = planeLayoutScrollView.contentOffset.x
            if convertedRectXOffset < scrollViewXOffset {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.planeLayoutScrollView.contentOffset.x -= 5
                    self.highlightView?.origin.x -= 5
                }, completion: nil)
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
        viewModel.allFlightsData = viewModel.originalAllFlightsData
        if viewModel.setupFor == .preSelection {
            AddonsDataStore.shared.seatsAllFlightsData = viewModel.originalAllFlightsData
            AddonsDataStore.shared.seatsArray.removeAll()
            self.delegate?.seatsUpdated()
        }
        allChildVCs.enumerated().forEach { (index, seatMapVC) in
            seatMapVC.setFlightData(viewModel.allFlightsData[index])
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
    
    func willFetchSeatMapData() {
        
        delay(seconds: 0.2) {
            AppGlobals.shared.startLoading()
            
        }
    }
    
    func failedToFetchSeatMapData() {
        AppGlobals.shared.stopLoading()
    }
    
    func didFetchSeatMapData() {
        AppGlobals.shared.stopLoading()
        var totalFlightsData = [SeatMapModel.SeatMapFlight]()
        viewModel.seatMapModel.data.leg.forEach {
            let flightsArr = $0.value.flights.map { $0.value }
            totalFlightsData.append(contentsOf: flightsArr)
            
            let flightsStr = $0.value.flights.map {
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
                self.seatTotalLbl.text = "₹ \(seatTotal)"
            }
        } else if viewModel.setupFor == .postSelection {
            createPassengerContactsArr()
            // Resetting after setting passengers on seat
            viewModel.originalAllFlightsData = viewModel.allFlightsData
            viewModel.getSeatTotal { [weak self] (seatTotal) in
                guard let self = self else { return }
                self.seatTotalLbl.text = "₹ \(seatTotal)"
            }
        }
        setUpViewPager()
        planeLayoutCollView.reloadData()
        DispatchQueue.delay(0.5) {
            self.setCurrentPlaneLayout()
        }
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
                newContact.id = passenger.paxId
                newContact.apiId = passenger.paxId
                newContact.firstName = passenger.firstName
                newContact.lastName = passenger.lastName
                newContact.image = passenger.profileImage
                passArr.append(newContact)
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
                    newFlightData.md.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.columnData.passenger = passengerModel.passenger
                    
                    viewModel.originalBookedAddOnSeats.append(newFlightData.md.rows[passengerModel.rowNum]![passengerModel.columnStr]!)
                    
                } else if upperDeckData.rowsArr.contains("\(passengerModel.rowNum)"), mainDeckData.columns.contains(passengerModel.columnStr) {
                    newFlightData.ud.rows[passengerModel.rowNum]?[passengerModel.columnStr]?.columnData.passenger = passengerModel.passenger
                    
                    viewModel.originalBookedAddOnSeats.append(newFlightData.ud.rows[passengerModel.rowNum]![passengerModel.columnStr]!)
                }
            }
            
            return newFlightData
        }
    }
}
