//
//  SeatMapVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SeatMapVC: UIViewController {

    // MARK: Properties
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var legSegmentView: HMSegmentedControl!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: IBActions
    
    
    
    // MARK: Functions
    
    private func initialSetup() {
        setupNavBar()
        setupSegmentView()
    }
    
    private func setupNavBar() {
        topNavBarView.configureNavBar(title: LocalizedString.seatMap.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        
        topNavBarView.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen)
        
        topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
        
        topNavBarView.delegate = self
    }
    
    //MARK:- HMSegmentedControl SegmentView UI Methods
    
    fileprivate func setupSegmentView(){
        self.legSegmentView.backgroundColor = .clear
        self.legSegmentView.selectionIndicatorLocation = .down;
        self.legSegmentView.segmentWidthStyle = .dynamic
        self.legSegmentView.segmentEdgeInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0);
        self.legSegmentView.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 40.0);
        
        self.legSegmentView.autoresizingMask = .flexibleWidth
        self.legSegmentView.selectionStyle = .textWidthStripe
        self.legSegmentView.selectionIndicatorLocation = .down;
        self.legSegmentView.selectionIndicatorHeight = 2
        self.legSegmentView.isVerticalDividerEnabled = false
        self.legSegmentView.selectionIndicatorColor = .clear
        
        self.legSegmentView.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Regular" , size: 16)! ]
        self.legSegmentView.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black , NSAttributedString.Key.font : UIFont(name:"SourceSansPro-Semibold" , size: 16)!]
//        self.legSelectionView .addTarget(self, action: #selector(filtersegmentChanged(_:)), for: .valueChanged)
        
//        self.legSegmentView.sectionTitles = ["A", "B", "C", "D"]
        
//        self.legSelectionView.sectionTitles = flightSearchResultVM.segmentTitles(showSelection: false, selectedIndex: filterSegmentView.selectedSegmentIndex)
        self.legSegmentView.selectedSegmentIndex = .min
    }
}

extension SeatMapVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
