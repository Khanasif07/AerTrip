//
//  HotelFilterVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelFilterVC: BaseVC {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var clearAllButton : UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var dataContainerView:UIView!
    @IBOutlet weak var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - Private
    private var currentIndex: Int = 0 {
        didSet {
          //
        }
    }
    fileprivate weak var categoryView: ATCategoryView!
    
    
    
    // MARK: - Variables
    private let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Range.localized, LocalizedString.Price.localized,LocalizedString.Ratings.localized,LocalizedString.Amenities.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        
        return temp
    }
    
   
    private var allChildVCs: [UIViewController] = [UIViewController]()

    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetups()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    
    
    
    
    
    
    // MARK: - Overrider methods
    
    override func setupTexts() {
        self.clearAllButton.setTitle(LocalizedString.ClearAll.localized, for: .normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        
    }
    override func setupFonts() {
        self.clearAllButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.clearAllButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    
    // MARK: - Helper methods
    func initialSetups() {
        self.mainContainerView.layer.cornerRadius = 10.0
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 4)
        for i in 0..<allTabsStr.count {
            if i != 1 {
                let vc = SortVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else {
                let vc = RangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            }
            
        }
        
        let height = UIDevice.isIPhoneX ? 44.0 : 20.0
        self.navigationViewTopConstraint.constant = CGFloat(height)
       self.setupPagerView()
       self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func show(animated: Bool) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
  
    
    private func setupPagerView() {
        
        var style = ATCategoryNavBarStyle()
        style.height = 50.0
        style.interItemSpace = 15.0
        style.itemPadding = 8.0
        style.isScrollable = true
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.textFieldTextColor51
        
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
    }


    // MARK: - IB Action
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func doneButtonTapped(_ sender:Any) {
      self.hide(animated: true, shouldRemove: true)
    }
    
    
    

}


// MARK:- ATCategoryNavBarDelegate

extension HotelFilterVC : ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

