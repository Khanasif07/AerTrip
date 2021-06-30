//
//  PeriodicStatementVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment
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
    
    //fileprivate weak var categoryView: ATCategoryView!
    fileprivate var parchmentView : PagingViewController?
    private var allChildVCs: [PeriodicStatementListVC] = []
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        
        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsPeriodicStatement, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

    }
    
    override func viewDidLayoutSubviews() {
        self.parchmentView?.view.frame = self.dataContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        topNavView.darkView.isHidden = isLightTheme()
    }
    
    override func bindViewModel() {
    }
    
    override func setupColors() {
        self.view.backgroundColor = AppColors.themeWhite
        dataContainerView.backgroundColor = AppColors.themeBlack26
        topNavView.darkView.backgroundColor = AppColors.themeBlack26
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {        
        self.currentIndex = 0
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.PeriodicStatement.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        
        self.setupPagerView()
        //for header blur
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        topNavView.backgroundColor = AppColors.clear
        topNavView.darkView.isHidden = isLightTheme()
    }
    
    private func setupPagerView() {
        
        self.allChildVCs.removeAll()
        
        for idx in 0..<self.viewModel.allYears.count {
            let vc = PeriodicStatementListVC.instantiate(fromAppStoryboard: .Account)
            
            if let data = self.viewModel.periodicEvents[self.viewModel.allYears[idx]] as? JSONDictionary {
                vc.viewModel.yearData = data
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
    
    // Added to replace the existing page controller, added Asif Khan
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 35
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 50)
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
        self.dataContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        
        parchmentView?.menuBackgroundColor = .clear
        parchmentView?.collectionView.backgroundColor = .clear
    }
    private func reloadList() {
        self.setupPagerView()
    }
    
    //MARK:- Public
}


extension PeriodicStatementVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {

        FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .navigateBack, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

        AppFlowManager.default.popViewController(animated: true)
    }
}

extension PeriodicStatementVC : PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int{
        self.viewModel.allYears.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: self.viewModel.allYears[index], index: index, isSelected:false)
    }
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as?  MenuItem {
        self.currentIndex = pagingIndexItem.index
        }
    }
}
