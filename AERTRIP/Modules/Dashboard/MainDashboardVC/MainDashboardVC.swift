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
    private var previousSegmentHeight: CGFloat = 0.0
    private var oldOffset: CGPoint = CGPoint.zero
    private var headerViewHeightToHide: CGFloat = 44.0
    private var segmentViewContainerActualHeight: CGFloat = 0.0
    private var segmentMinimizableHeight: CGFloat = 22.0
    
    private let selectedSegmentAlpha: CGFloat = 1.0
    private let deSelectedSegmentAlpha: CGFloat = 0.7
    
    private let selectedSegmentFontSize: CGFloat = 18.0
    private let deSelectedSegmentFontSize: CGFloat = 14.0
    
    private var currentSegmentHeightConstraint: NSLayoutConstraint {
        switch self.currentSegment {
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
    
    private weak var aerinVC: AerinVC!
    private weak var flightsVC: FlightsVC!
    private weak var hotelsVC: HotelsVC!
    private weak var tripsVC: TripsVC!
    
    private var previousSelectedSegment: Segment?
    
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
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialSetup() {
        self.view.addGredient()
        
        self.previousSegmentHeight = self.segmentViewContainer.frame.height
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
        
        self.profileButton.set(count: 5, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppFlowManager.default.sideMenuController?.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    private func currentSegmentContainerView(forSegment: Segment) -> UIView {
        
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
    
    private func updateSegments() {
        
        //update alpha for view
        let allSegmentContainers = [self.aerinContainerView, self.flightsContainerView, self.hotelsContainerView, self.tripsContainerView]
        for segmentView in allSegmentContainers {
            guard let segV = segmentView else {return}
            segV.alpha = (segV === self.currentSegmentContainerView(forSegment: self.currentSegment)) ? self.selectedSegmentAlpha : self.deSelectedSegmentAlpha
        }
        
        //update font size for label
        let allSegmentLabels = [self.aerinTitleLabel, self.flightsTitleLabel, self.hotelsTitleLabel, self.tripsTitleLabel]
        for segmentLabel in allSegmentLabels {
            guard let lbl = segmentLabel else {return}
            lbl.font = AppFonts.SemiBold.withSize((lbl === self.currentSegmentLabel) ? self.selectedSegmentFontSize : self.deSelectedSegmentFontSize)
        }
        
        //update size for icon
        let allSegmentIconH = [self.aerinHeightConstraint, self.flightHeightConstraint, self.hotelHeightConstraint, self.tripHeightConstraint]
        for segmentIconH in allSegmentIconH {
            guard let iconH = segmentIconH else {return}
            iconH.constant = (iconH === self.currentSegmentHeightConstraint) ? self.previousSegmentHeight : (self.segmentViewContainer.height - self.segmentMinimizableHeight)
        }
    }
    
    private func setupBottomScrollView() {
        
        self.bottomScrollView.contentSize = CGSize(width: (4 * self.bottomScrollView.width), height: self.bottomScrollView.height)
        
        //add aerin vc view
        self.aerinVC = AerinVC.instantiate(fromAppStoryboard: .Dashboard)
        self.aerinVC.view.frame = CGRect(x: (0 * self.bottomScrollView.width), y: 0.0, width: self.bottomScrollView.width, height: self.bottomScrollView.height)
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
        
//        self.currentSegmentContainerView(forSegment: self.currentSegment).addDropShadow(withColor: AppColors.themeBlack)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func profileButtonAction(_ sender: UIButton) {
        AppFlowManager.default.sideMenuController?.toggleRight()
    }
}


extension MainDashboardVC {
    
    func manageScrolling(_ scrollView: UIScrollView) {
        if scrollView === self.mainScrollView {
            //handling for vertical scrolling
            if 0...self.headerViewHeightToHide ~= scrollView.contentOffset.y {
                let diff: CGFloat = scrollView.contentOffset.y
                
                let selectedFont = (0.41 * (self.headerViewHeightToHide-diff))
                let deSelectedFont = (0.32 * (self.headerViewHeightToHide-diff))
                
                for segmentLabel in [self.aerinTitleLabel, self.flightsTitleLabel, self.hotelsTitleLabel, self.tripsTitleLabel] {
                    guard let lbl = segmentLabel else {return}
                    lbl.font = AppFonts.SemiBold.withSize((lbl === self.currentSegmentLabel) ? selectedFont : deSelectedFont)
                }
                
                let diffH = (diff * 0.5)
                if diff > 0, self.currentSegmentHeightConstraint.constant > (self.segmentViewContainerActualHeight - self.segmentMinimizableHeight) {
                    
                    //decreas
                    let finalH = (self.segmentViewContainerActualHeight - diffH)
                    let maxH = (self.segmentViewContainerActualHeight - self.segmentMinimizableHeight)
                    self.currentSegmentHeightConstraint.constant = max(finalH, maxH)
                }
                else {
                    //increas
                    let finalH = (self.segmentViewContainerActualHeight + diffH)
                    self.currentSegmentHeightConstraint.constant = min(finalH, self.segmentViewContainerActualHeight)
                }
            }
            else if scrollView.contentOffset.y >= 0 {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: self.headerViewHeightToHide), animated: false)
            }
        }
        else if scrollView === self.bottomScrollView {
            //handling for horizontal scrolling

            let alphaProgress = ((self.selectedSegmentAlpha - self.deSelectedSegmentAlpha) / self.bottomScrollView.frame.width) * (scrollView.contentOffset.x.truncatingRemainder(dividingBy: self.bottomScrollView.frame.width))

            if scrollView.contentOffset.x > self.oldOffset.x {
                //increasing or next
                self.currentSegmentContainerView(forSegment: self.currentSegment).alpha = self.selectedSegmentAlpha - alphaProgress
                if let next = self.currentSegment.next {
                    self.currentSegmentContainerView(forSegment: next).alpha = self.selectedSegmentAlpha + alphaProgress
                }
                print("+++++++")
            }
            else {
                //descreasing or previous
                self.currentSegmentContainerView(forSegment: self.currentSegment).alpha = self.selectedSegmentAlpha - alphaProgress
                if let prev = self.currentSegment.previous {
                    self.currentSegmentContainerView(forSegment: prev).alpha = self.selectedSegmentAlpha + alphaProgress
                }
                print("--------")
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageScrolling(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.oldOffset = scrollView.contentOffset
        if scrollView === self.bottomScrollView {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if let seg = Segment(rawValue: currentPage) {
                self.previousSegmentHeight = self.currentSegmentHeightConstraint.constant
                self.currentSegment = seg
            }
        }
    }
}
