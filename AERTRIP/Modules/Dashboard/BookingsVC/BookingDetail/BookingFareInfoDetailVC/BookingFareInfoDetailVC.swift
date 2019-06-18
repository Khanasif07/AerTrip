//
//  BookingFareInfoDetailVC.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFareInfoDetailVC: BaseVC {
    
    enum UsingFor {
        case fareRules
        case both
    }
    
    // MARK: - IB Outlet
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var dataContainerView : UIView!
    
    // MARK: - Properties
    var currentlyUsingAs = UsingFor.fareRules {
        didSet {
            self.updateTitles()
        }
    }
    
    let viewModel = BookingFareInfoDetailVM()
    
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    private var allChildVCs : [UIViewController]  = [UIViewController]()
    private var allTabsStr: [String] = []
    
    fileprivate weak var categoryView: ATCategoryView!
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        return temp
    }
    
    
    override func initialSetup() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.currentIndex = 0
        
        if self.currentlyUsingAs == .fareRules {
            let vc = FareRulesVC.instantiate(fromAppStoryboard: .Bookings)
            self.allChildVCs.append(vc)
        }
        else {
            for i in 0..<self.allTabsStr.count {
                if i == 0 {
                    let vc = FareInfoVC.instantiate(fromAppStoryboard: .Bookings)
                    vc.viewModel.legDetails = self.viewModel.legDetails
                    vc.viewModel.bookingFee = self.viewModel.bookingFee
                    self.allChildVCs.append(vc)
                } else if i == 1 {
                    let vc = FareRulesVC.instantiate(fromAppStoryboard: .Bookings)
                    self.allChildVCs.append(vc)
                }
            }
        }
        self.setupPagerView()
        
        self.viewModel.getFareRules()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    override func setupFonts() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(13.0)
        
    }
    
    
    override func setupColors() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.dateLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        // configuration title label
        self.routeLabel.text = "Mumbai → Plaine Magnien"
        self.dateLabel.text = "1 Jul 2018"
    }
    
    private func updateTitles() {
        if self.currentlyUsingAs == .fareRules {
            self.allTabsStr = [LocalizedString.FareRules.localized]
        }
        else {
            self.allTabsStr = [LocalizedString.FareInfo.localized, LocalizedString.FareRules.localized]
        }
    }
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 49.0 // category bar Height
        style.interItemSpace = 110.0
        style.itemPadding = 8.0
        style.isScrollable = false
        style.layoutAlignment = .center
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.themeBlack
        
        style.badgeDotSize = CGSize(width: 4.0, height: 4.0)
        style.badgeBackgroundColor = AppColors.themeGreen
        style.badgeBorderColor = AppColors.clear
        style.badgeBorderWidth = 0.0
        
        
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
    }
    
    @IBAction func crossButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - ATCategoryNavBarDelegate
extension BookingFareInfoDetailVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
        
    }
}

extension BookingFareInfoDetailVC: BookingFareInfoDetailVMDelegate{
    func willGetFareRules() {
    }
    
    func getFareRulesSuccess(fareRules: String, ruteString: String) {
        
        var fareVC: FareRulesVC?
        for vc in self.allChildVCs {
            if let obj = vc as? FareRulesVC {
                fareVC = obj
                break
            }
        }
        
        DispatchQueue.mainAsync {
            fareVC?.set(fareRules: fareRules, ruteString: ruteString)
        }
    }
    
    func getFareRulesFail() {
        
    }
}
