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
    private var viewPager:PKViewPagerController!
    private var options:PKViewPagerOptions!
    private var currentIndex: Int = 0
    
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
        
        options.viewPagerFrame = self.view.bounds
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
        if let data = note.object as? [CityHotels] {
            self.viewModel.hotels = data
            self.viewDidLoad()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        options = PKViewPagerOptions(viewPagerWithFrame: dataContainerView.bounds)
        options.tabType = PKViewPagerTabType.basic
        options.tabViewImageSize = CGSize.zero
        options.tabViewTextFont = AppFonts.Regular.withSize(16.0)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.tabViewBackgroundDefaultColor = AppColors.themeWhite
        options.tabViewBackgroundHighlightColor = AppColors.themeWhite
        options.tabViewTextDefaultColor = AppColors.themeBlack
        options.tabViewTextHighlightColor = AppColors.themeBlack
        options.tabIndicatorViewHeight = 2.0
        options.tabIndicatorViewBackgroundColor = AppColors.themeGreen
        
        if let obj = viewPager {
            obj.removeFromParentVC
            viewPager = nil
        }
        viewPager = PKViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.dataContainerView.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
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

extension ViewAllHotelsVC: ViewAllHotelsVMDelegate {
    func willUpdateFavourite() {
        
    }
    
    func updateFavouriteSuccess() {
        self.viewModel.hotels.remove(at: self.currentIndex)
        self.viewDidLoad()
        self.sendDataChangedNotification(data: self)
    }
    
    func updateFavouriteFail() {
        
    }
}

extension ViewAllHotelsVC: PKViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return self.viewModel.allTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        let vc = HotelsListVC.instantiate(fromAppStoryboard: .HotelPreferences)
        vc.delegate = self
        vc.viewModel.forCity = self.viewModel.hotels[position]
        return vc
    }
    
    func tabsForPages() -> [PKViewPagerTab] {
        return self.viewModel.allTabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension ViewAllHotelsVC: HotelsListVCDelegate {
    func removeAllForCurrentPage() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: ["OK"], colors: [AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheet("Title", message: "Do you wish to remove all hotels from \(self.viewModel.hotels[self.currentIndex].cityName)?", sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { (alert, index) in
            if index == 0 {
                self.viewModel.updateFavourite(forHotels: self.viewModel.hotels[self.currentIndex].holetList)
            }
        }
    }
}

extension ViewAllHotelsVC: PKViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        self.currentIndex = index
        print("Moved to page \(index)")
    }
}

