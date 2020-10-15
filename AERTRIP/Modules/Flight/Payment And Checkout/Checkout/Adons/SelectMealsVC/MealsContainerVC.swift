//
//  MealsContainerVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

protocol SelectMealDelegate : class {
    func addContactButtonTapped()
    func addPassengerToMeal(forAdon : AddonsDataCustom, vcIndex : Int, currentFlightKey : String, mealIndex: Int, selectedContacts : [ATContact])
}

class MealsContainerVC: BaseVC {
    
    // MARK: Properties
    fileprivate var parchmentView : PagingViewController?
    weak var delegate : AddonsUpdatedDelegate?
    let mealsContainerVM = MealsContainerVM()
    
    // MARK: IBOutlets
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var mealsContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var MealTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalContainerView: UIView!
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.mealsContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    override func setupFonts() {
        super.setupFonts()
        self.addButton.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        self.MealTotalLabel.font = AppFonts.Regular.withSize(12)
        self.totalLabel.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func setupTexts() {
        super.setupTexts()
        self.MealTotalLabel.text = LocalizedString.MealTotal.localized
    }
    
    override func setupColors() {
        super.setupColors()
        
    }
    
    override func initialSetup() {
        super.initialSetup()
        setupNavBar()
        setUpViewPager()
        calculateTotalAmount()
              let price = self.totalLabel.text ?? ""
        self.delegate?.mealsUpdated(amount: price.replacingLastOccurrenceOfString("₹", with: "").replacingLastOccurrenceOfString(" ", with: ""))
        totalContainerView.addShadow(ofColor: .black, radius: 20, opacity: 0.1)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.mealsContainerVM.updateMealsToDataStore()
        let price = self.totalLabel.text ?? ""
        self.delegate?.mealsUpdated(amount: price.replacingLastOccurrenceOfString("₹", with: "").replacingLastOccurrenceOfString(" ", with: ""))
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MealsContainerVC {
    
    private func configureNavigation(){
        self.topNavBarView.delegate = self
        let isDivider = mealsContainerVM.allChildVCs.count > 1 ? false : true
        self.topNavBarView.configureNavBar(title: LocalizedString.Meals.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : isDivider)
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        self.topNavBarView.configureLeftButton(normalTitle: clearStr, normalColor: AppColors.themeGreen, font : AppFonts.Regular.withSize(18))
        self.topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18))
    }
    
    private func setUpViewPager() {
        self.mealsContainerVM.allChildVCs.removeAll()
        for index in 0..<AddonsDataStore.shared.flightsWithDataForMeals.count {
            let vc = SelectMealsdVC.instantiate(fromAppStoryboard: .Adons)
         
            let currentFlight = AddonsDataStore.shared.flightsWithDataForMeals[index]
            
            let initData = SelectMealsVM(vcIndex: index, currentFlightKey: currentFlight.flightId,addonsDetails: currentFlight.meal, freeMeal : currentFlight.freeMeal)
            vc.initializeVm(selectMealsVM : initData)
            vc.delegate = self
            self.mealsContainerVM.allChildVCs.append(vc)
        }
        
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    
    private func setupParchmentPageController(){
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = 30
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15)
        
        if self.mealsContainerVM.allChildVCs.count < 2 && AddonsDataStore.shared.itinerary.details.legsWithDetail.count < 2 {
            self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 0, height: 0)
            self.parchmentView?.indicatorOptions = PagingIndicatorOptions.hidden
            self.parchmentView?.borderOptions = PagingBorderOptions.hidden
        } else {
            
            self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 53)
            self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
           self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5, zIndex: Int.max - 1, insets: UIEdgeInsets(top: 0, left: -400, bottom: 0, right: -400))
        }
        
        let nib = UINib(nibName: "MenuItemWithLogoCollCell", bundle: nil)
        self.parchmentView?.register(nib, for: LogoMenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeGray214
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.mealsContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
    }
    
    func calculateTotalAmount(){
        self.totalLabel.text = "₹ \(self.mealsContainerVM.calculateTotalAmount().commaSeprated)"
    }
}


extension MealsContainerVC: TopNavigationViewDelegate {
  
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.mealsContainerVM.clearAll()
        calculateTotalAmount()
        let price = self.totalLabel.text ?? ""
        self.delegate?.mealsUpdated(amount: price.replacingLastOccurrenceOfString("₹", with: "").replacingLastOccurrenceOfString(" ", with: ""))
        self.delegate?.resetMeals()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MealsContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
       if let pagingIndexItem = pagingItem as? LogoMenuItem, let text = pagingIndexItem.attributedTitle {
           
           
           let attText = NSMutableAttributedString(attributedString: text)
           attText.addAttribute(.font, value: AppFonts.SemiBold.withSize(16), range: NSRange(location: 0, length: attText.length))
           let width = attText.widthOfText(50, font: AppFonts.SemiBold.withSize(16))
           return width + 50
           
       }
          
          return 100.0
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return AddonsDataStore.shared.flightsWithDataForMeals.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.mealsContainerVM.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.flightsWithDataForMeals[index].flightId }
     
        guard let firstFlight = flightAtINdex.first else {
            return LogoMenuItem(index: index, isSelected:true)
        }
        
        return LogoMenuItem(index: index, isSelected: true, attributedTitle: self.mealsContainerVM.createAttHeaderTitle(firstFlight.fr, firstFlight.to), logoUrl: AppConstants.airlineMasterBaseUrl + firstFlight.al + ".png")

//        return MenuItem(title: "", index: index, isSelected: true, attributedTitle: self.mealsContainerVM.createAttHeaderTitle(firstFlight.fr, firstFlight.to))
        
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        if let pagingIndexItem = pagingItem as? LogoMenuItem {
            self.mealsContainerVM.currentIndex = pagingIndexItem.index
        }
    }    
}

extension MealsContainerVC : SelectMealDelegate {

    func addPassengerToMeal(forAdon : AddonsDataCustom, vcIndex : Int, currentFlightKey : String, mealIndex: Int, selectedContacts : [ATContact]) {
        
        let allowedPassengers = self.mealsContainerVM.getAllowedPassengerForParticularAdon(forAdon: forAdon)
        
        if allowedPassengers.count == 0 { return }
        
        if allowedPassengers.count == 1 {
            
            let passengersToBeAdded = !selectedContacts.isEmpty ? [] : allowedPassengers
            
            self.mealsContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, mealIndex: mealIndex, contacts: passengersToBeAdded)
            self.calculateTotalAmount()
            
        } else {
            let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selectPassengersVM.selectedContacts = selectedContacts
                    vc.selectPassengersVM.adonsData = forAdon
                    vc.selectPassengersVM.setupFor = .meals
                    vc.selectPassengersVM.currentFlightKey = currentFlightKey
                    vc.selectPassengersVM.freeMeal = self.mealsContainerVM.allChildVCs[vcIndex].selectMealsVM.freeMeal
                    vc.selectPassengersVM.contactsComplition = { [weak self] (contacts) in
                    guard let weakSelf = self else { return }
                    weakSelf.mealsContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, mealIndex: mealIndex, contacts: contacts)
                        weakSelf.calculateTotalAmount()
                    }
                    present(vc, animated: false, completion: nil)
            }
        }
    
    func addContactButtonTapped() {
        
    }
    
}
