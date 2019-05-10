//
//  PeriodicStatementVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PeriodicStatementVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var dataContainerView: UIView!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = PeriodicStatementVM()
    
    //MARK:- Private
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    
    fileprivate weak var categoryView: ATCategoryView!
    
    private var allChildVCs: [PeriodicStatementListVC] = []
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    override func bindViewModel() {
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.currentIndex = 0
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.PeriodicStatement.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        
        self.setupPagerView()
    }
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 51.0
        style.interItemSpace = 5.0
        style.itemPadding = 8.0
        style.isScrollable = true
        style.layoutAlignment = .center
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.Regular.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.indicatorHeight = 2.0
        style.indicatorCornerRadius = 2.0
        style.normalColor = AppColors.themeBlack
        style.selectedColor = AppColors.themeBlack
        
        self.allChildVCs.removeAll()
        
        for idx in 0..<self.viewModel.allYears.count {
            let vc = PeriodicStatementListVC.instantiate(fromAppStoryboard: .Account)
            vc.viewModel.currentFinYear = self.viewModel.allYears[idx]
            self.allChildVCs.append(vc)
        }
        
        if let _ = self.categoryView {
            self.categoryView.removeFromSuperview()
            self.categoryView = nil
        }
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.viewModel.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.delegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
    }
    
    private func reloadList() {
        self.setupPagerView()
    }
    
    //MARK:- Public
}


extension PeriodicStatementVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension PeriodicStatementVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}
