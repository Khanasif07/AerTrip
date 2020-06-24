//
//  MyBookingFilterVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
// Asif Change =================
import UIKit
import Parchment

class MyBookingFilterVC: BaseVC {
    
    //MARK:- Variables
    //MARK:- Private
    private var currentIndex: Int = 0
    private let allTabsStr: [String] = [LocalizedString.TravelDate.localized, LocalizedString.EventType.localized, LocalizedString.BookingDate.localized]
    //    private var allTabButtons: [PKCategoryButton] {
    //        return [travelDateButton, eventTypeButton, bookingDateButton]
    //    }
    
    private var minDate: Date?
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    private var allChildVCs :[UIViewController] = []
    private var isFilterArray:[Bool] = [true,true,true]
    private var previousOffset = CGPoint.zero
    
    //MARK:- IBOutlets
    @IBOutlet weak var topNavBar: TopNavigationView!{
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet weak var childContainerView: UIView!
    @IBOutlet weak var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var mainContainerHeightConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    override func initialSetup() {
        self.mainContainerHeightConstraint.constant = 498 + UIApplication.shared.statusBarFrame.height
        self.fetchMinDateFromCoreData()
        self.setCounts()
        
        self.topNavBar.configureNavBar(title: "\(MyBookingFilterVM.shared.filteredResultCount) of \(MyBookingFilterVM.shared.totalResultCount) Results", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        self.topNavBar.firstRightBtnTrailingConst.constant = 0.0
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        let doneStr = "\(LocalizedString.Done.localized)  "
        self.topNavBar.configureLeftButton(normalTitle: clearStr, selectedTitle: clearStr, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavBar.configureFirstRightButton(normalTitle: doneStr, selectedTitle: doneStr, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        self.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 4)
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
        self.setupGesture()
        self.setUpViewPager()
        self.setBadge()
    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.topNavBar.navTitleLabel.textColor = AppColors.themeGray40
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printDebug("viewDidLayoutSubviews")
        self.parchmentView?.view.frame = self.childContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    //MARK:- Functions
    private func setCounts() {
        
        self.topNavBar.navTitleLabel.text = "\(MyBookingFilterVM.shared.filteredResultCount) of \(MyBookingFilterVM.shared.totalResultCount) Results"
        
        
    }
    private func notifyToFilterApplied() {
        
        self.setBadge()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // dalay for 1 seconds for the filter applied same as Android
        perform(#selector(sendNotification), with: nil, afterDelay: 0.2)
    }
    
    @objc private func sendNotification() {
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterApplied)
        
        delay(seconds: 0.5) { [weak self] in
            self?.setCounts()
        }
    }
    
    private func checkDoneBtnState() {
        if  MyBookingFilterVM.shared.isFilterAplied() {
            self.topNavBar.firstRightButton.isEnabled = true
            self.topNavBar.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        } else {
            self.topNavBar.firstRightButton.isEnabled = false
            self.topNavBar.firstRightButton.setTitleColor(AppColors.themeGray40, for: .normal)
        }
    }
    
    private func fetchMinDateFromCoreData() {
        if let dict = CoreDataManager.shared.fetchData(fromEntity: "BookingData", forAttribute: "dateHeader", usingFunction: "min").first, let minDt = dict["min"] as? String {
            
            //2019-08-07 00:00:00
            printDebug("Min date \(minDt)")
            self.minDate = minDt.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
    }
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { (isDone) in
            //            self.allTabDetailConatinerView.delegate = self
        }
    }
    
    private func cancelAllOperation() {
        //cancel all the operation if user trying to close the filter screen
        //        for obj in self.allChildVCs {
        //            NSObject.cancelPreviousPerformRequests(withTarget: obj)
        //        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        self.mainBackView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setUpViewPager() {
        self.currentIndex = 0
        self.allChildVCs.removeAll()
        self.allChildVCs.append(self.setUPTravelDateVC())
        self.allChildVCs.append(self.setUpEventTypeVC())
        self.allChildVCs.append(self.setUpBookingVC())
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    // Added to replace the existing page controller, added Hitesh Soni, 28-29Jan'2020
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = (UIDevice.screenWidth - 335.5) / 2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 13.0, bottom: 0.0, right: 11.0)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0), insets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0))
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 52)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.childContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
    }
    
    //MARK:- IBActions
    @objc func  outsideAreaTapped() {
        self.cancelAllOperation()
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- Extensions
extension MyBookingFilterVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //clear all
        self.sendDataChangedNotification(data: ATNotification.myBookingFilterCleared)
       // self.hide(animated: true, shouldRemove: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Filters \(MyBookingFilterVM.shared)")
        self.hide(animated: true, shouldRemove: true)
    }
}

extension MyBookingFilterVC: EventTypeVCDelegate {
    
    func didSelectEventTypes(selection: [Int]) {
        MyBookingFilterVM.shared.isFirstTime = false
        MyBookingFilterVM.shared.eventType = selection
        self.notifyToFilterApplied()
    }
}

extension MyBookingFilterVC: TravelDateVCDelegate {
    func didSelect(fromDate: Date?, forType: TravelDateVC.UsingFor) {
        if forType == .bookingDate {
            MyBookingFilterVM.shared.bookingFromDate = fromDate
        }
        else if forType == .travelDate {
            MyBookingFilterVM.shared.travelFromDate = fromDate
        }
        self.notifyToFilterApplied()
    }
    
    func didSelect(toDate: Date?, forType: TravelDateVC.UsingFor) {
        if forType == .bookingDate {
            MyBookingFilterVM.shared.bookingToDate = toDate
        }
        else if forType == .travelDate {
            MyBookingFilterVM.shared.travelToDate = toDate
        }
        self.notifyToFilterApplied()
    }
}

extension MyBookingFilterVC {
    
   
    //  Asif Change
    func setUpBookingVC() -> UIViewController {
        let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
        vc.delegate = self
        vc.minFromDate = minDate
        vc.oldFromDate = MyBookingFilterVM.shared.bookingFromDate
        vc.oldToDate = MyBookingFilterVM.shared.bookingToDate
        vc.currentlyUsingAs = .bookingDate
        return vc
    }
    
    func setUpEventTypeVC() -> UIViewController{
        let vc = EventTypeVC.instantiate(fromAppStoryboard: .Bookings)
        vc.delegate = self
        if MyBookingFilterVM.shared.isFirstTime {
            vc.oldSelection = []
        } else {
            vc.oldSelection = MyBookingFilterVM.shared.eventType
        }
        return vc
    }
    
    func setUPTravelDateVC() -> UIViewController {
        let vc = TravelDateVC.instantiate(fromAppStoryboard: .Bookings)
        vc.delegate = self
        vc.minFromDate = minDate
        vc.oldFromDate = MyBookingFilterVM.shared.travelFromDate
        vc.oldToDate = MyBookingFilterVM.shared.travelToDate
        vc.currentlyUsingAs = .travelDate
        return vc
    }
    
    
    private func setBadge() {
      
        for tab in self.allTabsStr {
            switch tab.lowercased() {
            case LocalizedString.TravelDate.localized.lowercased():
                self.isFilterArray[0] = (MyBookingFilterVM.shared.travelToDate != nil || MyBookingFilterVM.shared.travelFromDate != nil) ? false : true
            case LocalizedString.EventType.localized.lowercased():
                self.isFilterArray[1] = MyBookingFilterVM.shared.eventType.isEmpty ? true : false
            case LocalizedString.BookingDate.localized.lowercased():
                self.isFilterArray[2] = (MyBookingFilterVM.shared.bookingToDate != nil || MyBookingFilterVM.shared.bookingFromDate != nil) ? false : true
            default:
                printDebug("not useable case")
            }
        }
          self.parchmentView?.reloadMenu()
        self.checkDoneBtnState()
    }
}

extension MyBookingFilterVC: PagingViewControllerDataSource , PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        // depending onthe text size, give the width of the menu item
        if let pagingIndexItem = pagingItem as? MenuItem {
            let text = pagingIndexItem.title
            
            let font = AppFonts.SemiBold.withSize(16.0)
            return text.widthOfString(usingFont: font) + 22.5
        }
        
        return 100.0
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        self.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: self.allTabsStr[index], index: index, isSelected: isFilterArray[index] )
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) where T : PagingItem, T : Comparable, T : Hashable {
        
        let pagingIndexItem = pagingItem as! MenuItem
        self.currentIndex = pagingIndexItem.index
        MyBookingFilterVM.shared.lastSelectedIndex =  self.currentIndex
    }
}


