//
//  MainDashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 10/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class MainDashboardVC: BaseVC {
    
    enum Segment: Int, CaseIterable {
        case aerin = 0
        case flight = 1
        case hotel = 2
        case trip = 3
        
        var title: String {
            switch self {
            case .aerin:
                return LocalizedString.aerin.localized
                
            case .flight:
                return LocalizedString.flights.localized
                
            case .hotel:
                return LocalizedString.hotels.localized
                
            case .trip:
                return LocalizedString.trips.localized
            }
        }
        
        var next: Segment? {
            return Segment(rawValue: min(self.rawValue+1, Segment.allCases.count-1))
        }
        
        var previous: Segment? {
            return Segment(rawValue: max(self.rawValue-1, 0))
        }
    }
    
    //MARK:- Properties
    //MARK:- Private
    private var oldOffset: CGPoint = CGPoint.zero
    private var headerViewHeightToHide: CGFloat = 44.0
    private var segmentViewContainerActualHeight: CGFloat = 0.0
    private var segmentMinimizableHeight: CGFloat = 22.0
    
    private let selectedSegmentAlpha: CGFloat = 1.0
    private let deSelectedSegmentAlpha: CGFloat = 0.7
    
    private let selectedSegmentFontSize: CGFloat = 18.0
    private let deSelectedSegmentFontSize: CGFloat = 14.0
    
    private var segmentMinimizedHeight: CGFloat {
        return segmentMaxmizedHeight - segmentMinimizableHeight
    }
    
    private var segmentMaxmizedHeight: CGFloat {
        return self.segmentViewContainer.height
    }
    
    private var currentSegmentLabel: UILabel {
        switch self.currentSegment {
        case .aerin:
            return self.aerinTitleLabel
            
        case .flight:
            return self.flightsTitleLabel
            
        case .hotel:
            return self.hotelsTitleLabel
            
        case .trip:
            return self.tripsTitleLabel
        }
    }
    
    private var selectedFontSizeForCurrentState: CGFloat {
        let diff = self.mainScrollView.contentOffset.y
        guard diff <= self.headerViewHeightToHide else {
            return self.selectedSegmentFontSize
        }
        
        let ratio = (self.selectedSegmentFontSize / self.headerViewHeightToHide)
        return ((ratio * (self.headerViewHeightToHide-diff)) < 2.0) ? 0.0 : (ratio * (self.headerViewHeightToHide-diff))
    }
    
    private var deSelectedFontSizeForCurrentState: CGFloat {
        let diff = self.mainScrollView.contentOffset.y
        guard diff <= self.headerViewHeightToHide else {
            return self.deSelectedSegmentFontSize
        }
        
        let ratio = (self.deSelectedSegmentFontSize / self.headerViewHeightToHide)
        return ((ratio * (self.headerViewHeightToHide-diff)) < 2.0) ? 0.0 : (ratio * (self.headerViewHeightToHide-diff))
    }
    
    private var selectedSegmentHeightForVerticalState: CGFloat {
        let diff = self.mainScrollView.contentOffset.y
        guard diff <= self.headerViewHeightToHide else {
            return self.segmentMinimizedHeight
        }
        
        let ratio = (self.segmentMaxmizedHeight / self.headerViewHeightToHide)
        let finalH = max((ratio * (self.headerViewHeightToHide-diff)), self.segmentMinimizedHeight)
        return min(finalH, self.segmentMaxmizedHeight)
    }
    
    private var selectedSegmentHeightForHorizentalState: CGFloat {
        let diff = self.bottomScrollView.contentOffset.x.truncatingRemainder(dividingBy: self.bottomScrollView.frame.width)
        guard diff <= self.bottomScrollView.width else {
            return self.selectedSegmentHeightForVerticalState
        }
        
        let ratio = (self.selectedSegmentHeightForVerticalState / self.bottomScrollView.width)
        let finalH = max((ratio * (self.bottomScrollView.width-diff)), self.segmentMinimizedHeight)
        return min(finalH, self.selectedSegmentHeightForVerticalState)
    }
    
    private var deSelectedSegmentHeightForHorizentalState: CGFloat {
        let diff = self.bottomScrollView.contentOffset.x.truncatingRemainder(dividingBy: self.bottomScrollView.frame.width)
        guard diff <= self.bottomScrollView.width else {
            return self.selectedSegmentHeightForVerticalState
        }
        
        let ratio = (self.selectedSegmentHeightForVerticalState / self.bottomScrollView.width)
        let finalH = (self.segmentMinimizedHeight) + (ratio * diff)
        return min(finalH, self.selectedSegmentHeightForVerticalState)
    }
    
    private var aerinVC: AerinVC!
    private var flightsVC: FlightsVC!
    private var hotelsVC: HotelsVC!
    private var tripsVC: TripsVC!
    
    private var moveableSegment: Segment?
    
    //MARK:- Public
    var currentSegment: Segment = Segment.aerin {
        didSet {
            self.updateSegments()
        }
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headerViewContainer: UIView!
    @IBOutlet weak var segmentViewContainer: UIView!
    @IBOutlet weak var profileButton: ATNotificationButton!
    
    @IBOutlet weak var aerinTitleLabel: UILabel!
    @IBOutlet weak var flightsTitleLabel: UILabel!
    @IBOutlet weak var hotelsTitleLabel: UILabel!
    @IBOutlet weak var tripsTitleLabel: UILabel!
    
    @IBOutlet weak var aerinContainerView: UIView!
    @IBOutlet weak var flightsContainerView: UIView!
    @IBOutlet weak var hotelsContainerView: UIView!
    @IBOutlet weak var tripsContainerView: UIView!
    
    @IBOutlet weak var aerinHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var flightHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tripHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomScrollView: UIScrollView! {
        didSet {
            bottomScrollView.alwaysBounceHorizontal = false
            bottomScrollView.alwaysBounceVertical = false
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.profileButton.cornerRadius = self.profileButton.height/2
    }
    
    override func initialSetup() {
        self.view.addGredient()
        
        let image = UIImage(named: "userPlaceholder")
        self.profileButton.setImage(image, for: .normal)
        let userData = UserModel(json: AppUserDefaults.value(forKey: .userData))
        if !userData.picture.isEmpty {
            
            if let url = URL(string: userData.picture){
                self.profileButton.kf.setImage(with: url, for: .normal)
            }
        }
        
        self.segmentViewContainerActualHeight = self.segmentViewContainer.height
        
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.showsHorizontalScrollIndicator = false
        self.mainScrollView.delegate = self
        
        self.bottomScrollView.showsVerticalScrollIndicator = false
        self.bottomScrollView.showsHorizontalScrollIndicator = false
        self.bottomScrollView.delegate = self
        self.bottomScrollView.isPagingEnabled = true
        
        self.mainScrollView.backgroundColor = AppColors.clear
        self.mainContentView.backgroundColor = AppColors.clear
        self.headerViewContainer.backgroundColor = AppColors.clear
        self.segmentViewContainer.backgroundColor = AppColors.clear
        
        self.updateSegments()
        self.setupBottomScrollView()
        
//        self.mainScrollView.isScrollEnabled = false
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
//        self.view.addGestureRecognizer(pan)
    }
    
    @objc func panHandler(_ sender: UIGestureRecognizer) {
        print("pan : \(sender.location(in: self.view))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.aerinVC?.viewWillAppear(animated)
        self.flightsVC?.viewWillAppear(animated)
        self.hotelsVC?.viewWillAppear(animated)
        self.tripsVC?.viewWillAppear(animated)
        
        AppFlowManager.default.sideMenuController?.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.aerinVC?.viewWillDisappear(animated)
        self.flightsVC?.viewWillDisappear(animated)
        self.hotelsVC?.viewWillDisappear(animated)
        self.tripsVC?.viewWillDisappear(animated)
    }
    
    override func setupFonts() {
        self.aerinTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.flightsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.hotelsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.tripsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
    }
    
    override func setupTexts() {
        self.aerinTitleLabel.text = Segment.aerin.title
        self.flightsTitleLabel.text = Segment.flight.title
        self.hotelsTitleLabel.text = Segment.hotel.title
        self.tripsTitleLabel.text = Segment.trip.title
    }
    
    override func setupColors() {
        self.aerinTitleLabel.textColor = AppColors.themeWhite
        self.flightsTitleLabel.textColor = AppColors.themeWhite
        self.hotelsTitleLabel.textColor = AppColors.themeWhite
        self.tripsTitleLabel.textColor = AppColors.themeWhite
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func getSegmentLabel(forSegment: Segment) -> UILabel {
        
        switch forSegment {
        case .aerin:
            return self.aerinTitleLabel
            
        case .flight:
            return self.flightsTitleLabel
            
        case .hotel:
            return self.hotelsTitleLabel
            
        case .trip:
            return self.tripsTitleLabel
        }
    }
    
    private func getSegmentContainerView(forSegment: Segment) -> UIView {
        
        switch forSegment {
        case .aerin:
            return self.aerinContainerView
            
        case .flight:
            return self.flightsContainerView
            
        case .hotel:
            return self.hotelsContainerView
            
        case .trip:
            return self.tripsContainerView
        }
    }
    
    private func getSegmentHeightConstraint(forSegment: Segment? = nil) -> NSLayoutConstraint {
        let final = forSegment ?? self.currentSegment
        switch final {
        case .aerin:
            return self.aerinHeightConstraint
            
        case .flight:
            return self.flightHeightConstraint
            
        case .hotel:
            return self.hotelHeightConstraint
            
        case .trip:
            return self.tripHeightConstraint
        }
    }
    
    private func updateSegments() {

        //update alpha for view
        let allSegmentContainers = [self.aerinContainerView, self.flightsContainerView, self.hotelsContainerView, self.tripsContainerView]
        let shadowH:CGFloat = self.selectedSegmentHeightForVerticalState * 0.52
        for segmentView in allSegmentContainers {
            guard let segV = segmentView else {return}
            if segV === self.getSegmentContainerView(forSegment: self.currentSegment) {
                UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
                segV.alpha = self.selectedSegmentAlpha
                segV.layer.masksToBounds = false
                segV.layer.shadowColor = AppColors.themeBlack.cgColor
                segV.layer.shadowOpacity = 0.4
                segV.layer.shadowOffset = CGSize(width: 0, height: 1)
                segV.layer.shadowRadius = 15
                
                segV.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: (segV.width - shadowH)/2.0, y: ((segV.height - shadowH)/2.0) + 15.0, width: shadowH, height: shadowH), cornerRadius: shadowH/2.0).cgPath
                }.startAnimation()
            }
            else {
                segV.alpha = self.deSelectedSegmentAlpha
                segV.layer.masksToBounds = true
                segV.layer.shadowColor = AppColors.clear.cgColor
            }
        }
        
        //update font size for label
        let allSegmentLabels = [self.aerinTitleLabel, self.flightsTitleLabel, self.hotelsTitleLabel, self.tripsTitleLabel]
        for segmentLabel in allSegmentLabels {
            guard let lbl = segmentLabel else {return}
            if (lbl === self.currentSegmentLabel) {
                UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
                lbl.font = AppFonts.SemiBold.withSize(self.selectedFontSizeForCurrentState)
                }.startAnimation()
            }
            else {
                lbl.font = AppFonts.SemiBold.withSize(self.deSelectedFontSizeForCurrentState)
            }
        }
        
        //update size for icon
        let allSegmentIconH = [self.aerinHeightConstraint, self.flightHeightConstraint, self.hotelHeightConstraint, self.tripHeightConstraint]
        for segmentIconH in allSegmentIconH {
            guard let iconH = segmentIconH else {return}
            if (iconH === self.getSegmentHeightConstraint()) {
                UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
                iconH.constant = self.selectedSegmentHeightForVerticalState
                }.startAnimation()
            }
            else {
                iconH.constant = self.segmentMinimizedHeight
            }
        }
    }
    
    private func setupBottomScrollView() {
        
        self.bottomScrollView.contentSize = CGSize(width: (4 * self.bottomScrollView.width), height: self.bottomScrollView.height)
        
        //add aerin vc view
        self.aerinVC = AerinVC.instantiate(fromAppStoryboard: .Dashboard)
        self.aerinVC.view.frame = CGRect(x: (0 * self.bottomScrollView.width), y: 0.0, width: self.bottomScrollView.width, height: self.aerinVC.contentView.height)
        self.aerinVC.view.backgroundColor = AppColors.clear
        
        self.bottomScrollView.addSubview(self.aerinVC.view)
        
        
        //add flights vc view
        self.flightsVC = FlightsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.flightsVC.view.frame = CGRect(x: (1 * self.bottomScrollView.width), y: 0.0, width: self.bottomScrollView.width, height: self.bottomScrollView.height)
        self.flightsVC.view.backgroundColor = AppColors.clear
        
        self.bottomScrollView.addSubview(self.flightsVC.view)
        
        
        //add hotels vc view
        self.hotelsVC = HotelsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.hotelsVC.view.frame = CGRect(x: (2 * self.bottomScrollView.width), y: 0.0, width: self.bottomScrollView.width, height: self.bottomScrollView.height)
        self.hotelsVC.view.backgroundColor = AppColors.clear
        
        self.bottomScrollView.addSubview(self.hotelsVC.view)
        
        
        //add trips vc view
        self.tripsVC = TripsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.tripsVC.view.frame = CGRect(x: (3 * self.bottomScrollView.width), y: 0.0, width: self.bottomScrollView.width, height: self.bottomScrollView.height)
        self.tripsVC.view.backgroundColor = AppColors.clear
        
        self.bottomScrollView.addSubview(self.tripsVC.view)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.sideMenuController?.toggleMenu()
    }
}


extension MainDashboardVC {
    
    func manageScrolling(_ scrollView: UIScrollView) {
        if scrollView === self.mainScrollView {
            //handling for vertical scrolling
            if 0...self.headerViewHeightToHide ~= scrollView.contentOffset.y {
                for segmentLabel in [self.aerinTitleLabel, self.flightsTitleLabel, self.hotelsTitleLabel, self.tripsTitleLabel] {
                    guard let lbl = segmentLabel else {return}
                    lbl.font = AppFonts.SemiBold.withSize((lbl === self.currentSegmentLabel) ? self.selectedFontSizeForCurrentState : self.deSelectedFontSizeForCurrentState)
                }
                
                self.getSegmentHeightConstraint().constant = self.selectedSegmentHeightForVerticalState
                self.updateSegments()
            }
            else if scrollView.contentOffset.y >= 0 {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: self.headerViewHeightToHide), animated: false)
            }
        }
        else if scrollView === self.bottomScrollView {
            //handling for horizontal scrolling
            guard 0...(scrollView.contentSize.width-scrollView.width) ~= scrollView.contentOffset.x else {
                return
            }
            
            let currentStep = (scrollView.contentOffset.x.truncatingRemainder(dividingBy: self.bottomScrollView.frame.width))
            let alphaProgress = ((self.selectedSegmentAlpha - self.deSelectedSegmentAlpha) / self.bottomScrollView.frame.width) * currentStep
            
            let fontProgress = ((self.selectedFontSizeForCurrentState - self.deSelectedFontSizeForCurrentState) / self.bottomScrollView.frame.width) * currentStep
            let selectedFont = (40...44 ~= mainScrollView.contentOffset.y) ? 0.0 : (self.selectedSegmentFontSize - fontProgress)
            let deSelectedFont = (40...44 ~= mainScrollView.contentOffset.y) ? 0.0 : (self.deSelectedSegmentFontSize + fontProgress)
            
            //clear all pre alpha
            self.updateSegments()
//            let allSegmentContainers = [self.aerinContainerView, self.flightsContainerView, self.hotelsContainerView, self.tripsContainerView]
//            for segmentView in allSegmentContainers {
//                guard let segV = segmentView else {return}
//                if segV === self.getSegmentContainerView(forSegment: self.currentSegment) {
//                    segV.alpha = self.selectedSegmentAlpha
//                }
//                else {
//                    segV.alpha = self.deSelectedSegmentAlpha
//                }
//            }
            
            if self.oldOffset.x.truncatingRemainder(dividingBy: self.bottomScrollView.frame.width) == 0 {
               //current item selected
//                let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
//                if let seg = Segment(rawValue: currentPage+1) {
//                    self.currentSegment = seg
//                }
                self.moveableSegment = nil
            }
            else {
                self.moveableSegment = (scrollView.contentOffset.x > self.oldOffset.x) ? self.currentSegment.next : self.currentSegment.previous
            }
            
            self.getSegmentContainerView(forSegment: self.currentSegment).alpha = self.selectedSegmentAlpha - alphaProgress
            self.getSegmentHeightConstraint().constant = self.selectedSegmentHeightForHorizentalState
            self.getSegmentLabel(forSegment: self.currentSegment).font = AppFonts.SemiBold.withSize(selectedFont)
            
            if let move = self.moveableSegment {
                self.getSegmentHeightConstraint(forSegment: move).constant = self.deSelectedSegmentHeightForHorizentalState
                self.getSegmentContainerView(forSegment: move).alpha = self.deSelectedSegmentAlpha + alphaProgress
                self.getSegmentLabel(forSegment: move).font = AppFonts.SemiBold.withSize(deSelectedFont)
            }
//            if scrollView.contentOffset.x > self.oldOffset.x {
//                //increasing or next
//                if let next = self.currentSegment.next {
//                    self.getSegmentContainerView(forSegment: next).alpha = self.deSelectedSegmentAlpha + alphaProgress
//                    self.getSegmentHeightConstraint(forSegment: next).constant = self.deSelectedSegmentHeightForHorizentalState
//
//                    print("from \(self.currentSegment.rawValue) to \(next.rawValue)")
//                }
//            }
//            else {
//                //descreasing or previous
//                if let prev = self.currentSegment.previous {
//                    self.getSegmentContainerView(forSegment: prev).alpha = self.deSelectedSegmentAlpha + alphaProgress
//                    self.getSegmentHeightConstraint(forSegment: prev).constant = self.deSelectedSegmentHeightForHorizentalState
//                    print("from \(self.currentSegment.rawValue) to \(prev.rawValue)")
//                }
//            }
            print(scrollView.contentOffset)
            self.oldOffset = scrollView.contentOffset
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageScrolling(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.manageScrolling(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.oldOffset = scrollView.contentOffset
        if scrollView === self.bottomScrollView {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if let seg = Segment(rawValue: currentPage) {
                self.currentSegment = seg
            }
        }
        else {
            self.manageScrolling(scrollView)
        }
    }
}
