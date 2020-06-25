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
        self.delegate?.mealsUpdated()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        for (index,item) in self.mealsContainerVM.allChildVCs.enumerated() {
            AddonsDataStore.shared.flightsWithData[index].meal = item.selectMealsVM.addonsDetails
        }
        self.delegate?.mealsUpdated()
        self.dismiss(animated: true, completion: nil)
    }
}

extension MealsContainerVC {
    
    private func configureNavigation(){
        self.topNavBarView.delegate = self
        self.topNavBarView.configureNavBar(title: LocalizedString.Meals.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : false)
        self.topNavBarView.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen)
        self.topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
    }
    
    private func setUpViewPager() {
        self.mealsContainerVM.allChildVCs.removeAll()
        for index in 0..<AddonsDataStore.shared.flightKeys.count {
            let vc = SelectMealsdVC.instantiate(fromAppStoryboard: .Adons)
            let initData = SelectMealsVM(vcIndex: index, currentFlightKey: AddonsDataStore.shared.flightKeys[index],addonsDetails: AddonsDataStore.shared.flightsWithData[index].meal, freeMeal : AddonsDataStore.shared.flightsWithData[index].freeMeal)
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
        self.parchmentView?.menuItemSpacing = (self.view.width - 251.5) / 2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 33.0, bottom: 0.0, right: 38.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 40)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
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
        var totalPrice = 0
        for item in self.mealsContainerVM.allChildVCs {
            let mealsArray = item.selectMealsVM.getMeals()
            let selectedMeals = mealsArray.filter { !$0.mealsSelectedFor.isEmpty && $0.ssrName?.isReadOnly == 0 }
            selectedMeals.forEach { (meal) in
                totalPrice += (meal.price * meal.mealsSelectedFor.count)
            }
        }
        self.totalLabel.text = "₹ \(totalPrice)"
    }
}


extension MealsContainerVC: TopNavigationViewDelegate {
  
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        for (index,item) in self.mealsContainerVM.allChildVCs.enumerated() {
            let mealsArray = item.selectMealsVM.getMeals()
            mealsArray.enumerated().forEach { (addonIndex,_) in
                item.selectMealsVM.updateContactInMeal(mealIndex: addonIndex, contacts: [], autoSelectedFor: [])
            AddonsDataStore.shared.flightsWithData[index].meal.addonsArray[addonIndex].mealsSelectedFor = []
             
                item.selectMealsVM.initializeFreeMealsToPassengers()
            }
            item.reloadData()
        }
        calculateTotalAmount()
        self.delegate?.mealsUpdated()
        self.delegate?.resetMeals()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MealsContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return AddonsDataStore.shared.flightKeys.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.mealsContainerVM.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.flightKeys[index] }
     
        guard let firstFlight = flightAtINdex.first else {
            return MenuItem(title: "", index: index, isSelected:false)
        }
        return MenuItem(title: "\(firstFlight.fr) → \(firstFlight.to)", index: index, isSelected:false)
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        if let pagingIndexItem = pagingItem as? MenuItem {
            self.mealsContainerVM.currentIndex = pagingIndexItem.index
        }
    }    
}

extension MealsContainerVC : SelectMealDelegate {

    func addPassengerToMeal(forAdon : AddonsDataCustom, vcIndex : Int, currentFlightKey : String, mealIndex: Int, selectedContacts : [ATContact]) {
                let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
                vc.modalPresentationStyle = .overFullScreen
                vc.selectPassengersVM.selectedContacts = selectedContacts
                vc.selectPassengersVM.adonsData = forAdon
                vc.selectPassengersVM.setupFor = .baggage
                vc.selectPassengersVM.flightKys = [currentFlightKey]
                vc.selectPassengersVM.freeMeal = self.mealsContainerVM.allChildVCs[vcIndex].selectMealsVM.freeMeal
                vc.selectPassengersVM.contactsComplition = {[weak self] (contacts) in
                guard let weakSelf = self else { return }
                weakSelf.mealsContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, mealIndex: mealIndex, contacts: contacts)
                    weakSelf.calculateTotalAmount()
                }
                present(vc, animated: true, completion: nil)
            }
//
//     func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, mealIndex: Int, selectedContacts: [ATContact]) {
//        let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//        vc.modalPresentationStyle = .overFullScreen
//        vc.selectPassengersVM.selectedContacts = selectedContacts
//        vc.selectPassengersVM.adonsData = forAdon
//        vc.selectPassengersVM.setupFor = .meals
//
//        vc.selectPassengersVM.contactsComplition = {[weak self] (contacts) in
//            guard let weakSelf = self else { return }
//        weakSelf.mealsContainerVM.allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray.enumerated().forEach { (mealIndex,meal) in
//                contacts.forEach { (contact) in
//                    if let contIndex = weakSelf.mealsContainerVM.allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray[mealIndex].mealsSelectedFor.lastIndex(where: { (cont) -> Bool in
//                        return cont.id == contact.id
//                    }){
//                        weakSelf.mealsContainerVM.allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray[mealIndex].mealsSelectedFor.remove(at: contIndex)
//                    }
//                  }
//                }
//        weakSelf.mealsContainerVM.allChildVCs[vcIndex].updateContactInMeal(mealIndex: mealIndex, contacts: contacts)
//            weakSelf.mealsContainerVM.allChildVCs[vcIndex].reloadData()
//            weakSelf.calculateTotalAmount()
//        }
//
//        present(vc, animated: true, completion: nil)
//    }
    
    func addContactButtonTapped() {
        
    }
}
