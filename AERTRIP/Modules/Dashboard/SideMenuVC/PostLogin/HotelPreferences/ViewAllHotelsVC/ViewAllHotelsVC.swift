//
//  ViewAllHotelsVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewAllHotelsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var dataContainerView: UIView!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = ViewAllHotelsVM()
    private var currentIndex: Int = 0
    private let selectedIndex:Int = 0
    
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    fileprivate weak var categoryView: ATCategoryView!
    
    private var allChildVCs: [HotelsListVC] = [HotelsListVC]()
    
    //MARK:- Private
    
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
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(17.0)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = LocalizedString.FavouriteHotels.localized
    }
    
    override func setupColors() {
        self.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let _ = note.object as? HotelSearchVC {
            self.initialSetups()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.setupPagerView()
        self.viewModel.webserviceForGetHotelPreferenceList()
    }
    
    private func setupPagerView() {
        if self.viewModel.hotels.isEmpty {
            self.emptyView.frame = CGRect(x: 0.0, y: -30.0, width: self.dataContainerView.width, height: self.dataContainerView.height)
            self.dataContainerView.addSubview(self.emptyView)
        }
        else {
            self.emptyView.removeFromSuperview()
            var style = ATCategoryNavBarStyle()
            style.height = 45.0
            style.interItemSpace = 5.0
            style.itemPadding = 8.0
            style.isScrollable = true
            style.layoutAlignment = .left
            style.isEmbeddedToView = true
            style.showBottomSeparator = true
            style.bottomSeparatorColor = AppColors.themeGray40
            style.defaultFont = AppFonts.Regular.withSize(16.0)
            style.selectedFont = AppFonts.Regular.withSize(16.0)
            style.indicatorColor = AppColors.themeGreen
            style.normalColor = AppColors.themeBlack
            style.selectedColor = AppColors.themeBlack
            
            self.allChildVCs.removeAll()
            for idx in 0..<self.viewModel.allTabs.count {
                let vc = HotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
                vc.delegate = self
                vc.viewModel.forCity = self.viewModel.hotels[idx]
                
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
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    @IBAction func addNewButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToHotelSearchVC()
    }
}

extension ViewAllHotelsVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

extension ViewAllHotelsVC: ViewAllHotelsVMDelegate {
    func willGetHotelPreferenceList() {
        
    }
    
    func getHotelPreferenceListSuccess() {
        self.setupPagerView()
    }
    
    func getHotelPreferenceListFail() {
        
    }
    
    func willUpdateFavourite() {
        
    }
    
    func updateFavouriteSuccess() {
        self.viewModel.removeHotels(fromIndex: self.currentIndex)
        self.viewDidLoad()
        self.sendDataChangedNotification(data: self)
    }
    
    func updateFavouriteFail() {
        
    }
}

//extension ViewAllHotelsVC: PKViewPagerControllerDataSource {
//
//    func numberOfPages() -> Int {
//        return self.viewModel.allTabs.count
//    }
//
//    func viewControllerAtPosition(position: Int) -> UIViewController {
//        let vc = HotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
//        vc.delegate = self
//        vc.viewModel.forCity = self.viewModel.hotels[position]
//        return vc
//    }
//
//    func tabsForPages() -> [PKViewPagerTab] {
//        return self.viewModel.allTabs
//    }
//
//    func startViewPagerAtIndex() -> Int {
//        return selectedIndex
//    }
//}

extension ViewAllHotelsVC: HotelsListVCDelegate {
    func removeAllForCurrentPage() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Remove.localized], colors: [AppColors.themeRed])
        _ = PKAlertController.default.presentActionSheet(nil, message: "\(LocalizedString.DoYouWishToRemoveAllHotelsFrom.localized) \(self.viewModel.hotels[self.currentIndex].cityName)?", sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { (alert, index) in
            if index == 0 {
                self.viewModel.updateFavourite(forHotels: self.viewModel.hotels[self.currentIndex].holetList)
            }
        }
    }
}

//extension ViewAllHotelsVC: PKViewPagerControllerDelegate {
//
//    func willMoveToControllerAtIndex(index:Int) {
//        print("Moving to page \(index)")
//
//    }
//
//    func didMoveToControllerAtIndex(index: Int) {
//        self.currentIndex = index
//        print("Moved to page \(index)")
//    }
//}

