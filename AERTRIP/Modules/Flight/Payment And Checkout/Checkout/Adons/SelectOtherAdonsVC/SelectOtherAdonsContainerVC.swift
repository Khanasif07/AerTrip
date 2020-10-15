//
//  SelectOtherAdonsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

protocol SelectOtherDelegate : class {
    func addContactButtonTapped()
    func addPassengerToMeal(forAdon : AddonsDataCustom, vcIndex : Int, currentFlightKey : String, othersIndex: Int, selectedContacts : [ATContact])
    func specialRequestUpdated(txt : String, currentFk : String, vcIndex : Int)
}

class SelectOtherAdonsContainerVC: BaseVC {
    
    // MARK: Properties
    fileprivate var parchmentView : PagingViewController?
    weak var delegate : AddonsUpdatedDelegate?
    let othersContainerVM = SelectOtherAdonsContainerVM()
    
    // MARK: IBOutlets
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var mealsContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var MealTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalContainerView: UIView!
    @IBOutlet weak var specialRequestLabel: UILabel!
    
    
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
        self.specialRequestLabel.font = AppFonts.SemiBold.withSize(12)
    }
    
    override func setupTexts() {
        super.setupTexts()
        self.specialRequestLabel.text = " + \(LocalizedString.Special_Request.localized)"
    }
    
    override func setupColors() {
        super.setupColors()
    }
    
    override func initialSetup() {
        super.initialSetup()
        setupNavBar()
        setUpViewPager()
        calculateTotalAmount()
        totalContainerView.addShadow(ofColor: .black, radius: 20, opacity: 0.1)
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        for (index,item) in self.othersContainerVM.allChildVCs.enumerated() {
            AddonsDataStore.shared.flightsWithData[index].special = item.otherAdonsVm.addonsDetails
            AddonsDataStore.shared.flightsWithData[index].specialRequest = item.otherAdonsVm.specialRequest
        }
        let price = self.totalLabel.text ?? ""
        self.delegate?.othersUpdated(amount: price.replacingLastOccurrenceOfString("₹", with: "").replacingLastOccurrenceOfString(" ", with: ""))
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SelectOtherAdonsContainerVC {
    
    private func configureNavigation(){
        self.topNavBarView.delegate = self
        let isDivider = othersContainerVM.allChildVCs.count > 1 ? false : true
        self.topNavBarView.configureNavBar(title: LocalizedString.Others.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : isDivider)
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        self.topNavBarView.configureLeftButton(normalTitle: clearStr, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18))
        self.topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18))
    }
    
    private func setUpViewPager() {
        self.othersContainerVM.allChildVCs.removeAll()
        for index in 0..<AddonsDataStore.shared.flightKeys.count {
            let vc = SelectOtherAdonsVC.instantiate(fromAppStoryboard: .Adons)
            let initData = SelectOtherAdonsVM(vcIndex: index, currentFlightKey: AddonsDataStore.shared.flightKeys[index],addonsDetails: AddonsDataStore.shared.flightsWithData[index].special, specialRequest : AddonsDataStore.shared.flightsWithData[index].specialRequest)
            vc.initializeVm(otherAdonsVm: initData)
            vc.delegate = self
            self.othersContainerVM.allChildVCs.append(vc)
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
        
        if self.othersContainerVM.allChildVCs.count < 2 && AddonsDataStore.shared.itinerary.details.legsWithDetail.count < 2 {
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
        self.totalLabel.text = "₹ \(self.othersContainerVM.calculateTotalAmount().commaSeprated)"
        self.specialRequestLabel.isHidden = !self.othersContainerVM.containsSpecialRequest()
    }
}

extension SelectOtherAdonsContainerVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.othersContainerVM.clearAll()
        calculateTotalAmount()
        let price = self.totalLabel.text ?? ""
        self.delegate?.othersUpdated(amount: price.replacingLastOccurrenceOfString("₹", with: "").replacingLastOccurrenceOfString(" ", with: ""))
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectOtherAdonsContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
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
        return AddonsDataStore.shared.flightKeys.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.othersContainerVM.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.flightKeys[index] }
        
        guard let firstFlight = flightAtINdex.first else {
            return LogoMenuItem(index: index, isSelected:true)
        }
        
        return LogoMenuItem(index: index, isSelected: true, attributedTitle: self.othersContainerVM.createAttHeaderTitle(firstFlight.fr, firstFlight.to), logoUrl: AppConstants.airlineMasterBaseUrl + firstFlight.al + ".png")
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        if let pagingIndexItem = pagingItem as? LogoMenuItem {
            self.othersContainerVM.currentIndex = pagingIndexItem.index
        }
    }
}


extension SelectOtherAdonsContainerVC : SelectOtherDelegate {
  
    func specialRequestUpdated(txt: String, currentFk: String, vcIndex: Int) {
        self.specialRequestLabel.isHidden = !self.othersContainerVM.containsSpecialRequest()

        self.othersContainerVM.updateSpecialRequest(txt: txt, currentFk: currentFk, vcIndex: vcIndex)
        
    }
    
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, othersIndex: Int, selectedContacts: [ATContact]) {
        
        let allowedPassengers = self.othersContainerVM.getAllowedPassengerForParticularAdon(forAdon: forAdon)
        if allowedPassengers.count == 0 { return }
        
        if allowedPassengers.count == 1{
            let passengersToBeAdded = !selectedContacts.isEmpty ? [] : allowedPassengers
            self.othersContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, othersIndex: othersIndex, contacts: passengersToBeAdded)
            self.calculateTotalAmount()
        } else {
            let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            vc.selectPassengersVM.selectedContacts = selectedContacts
            vc.selectPassengersVM.adonsData = forAdon
            vc.selectPassengersVM.setupFor = .others
            vc.selectPassengersVM.currentFlightKey = currentFlightKey
            vc.selectPassengersVM.contactsComplition = {[weak self] (contacts) in
                guard let weakSelf = self else { return }
                weakSelf.othersContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, othersIndex: othersIndex, contacts: contacts)
                weakSelf.calculateTotalAmount()
            }
            present(vc, animated: false, completion: nil)
        }
    }
    
    func addContactButtonTapped() {
        
    }
    
}
