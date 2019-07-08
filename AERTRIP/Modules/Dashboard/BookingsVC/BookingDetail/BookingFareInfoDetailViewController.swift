//
//  BookingFareInfoDetailViewController.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFareInfoDetailVC: BaseVC {
    
    // MARK: - IB Outlet
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var dataContainerView : UIView!
    
    // MARK: - Properties
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    private var allChildVCs : [UIViewController]  = [UIViewController]()
     private let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Range.localized]
    
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
        
        for i in 0..<self.allTabsStr.count {
            if i == 1 {
                let vc = RangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 2 {
                let vc = PriceVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            }
        }
        self.setupPagerView()
        
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
    
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 24.0
        style.interItemSpace = 15.0
        style.itemPadding = 4.0
        style.isScrollable = true
        style.layoutAlignment = .left
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
