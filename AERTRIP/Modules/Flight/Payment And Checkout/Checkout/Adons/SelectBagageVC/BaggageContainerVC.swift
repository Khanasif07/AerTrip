//
//  BagageContainerVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectBaggageDelegate : class {
    func addContactButtonTapped()
    func addPassengerToBaggage(forAdon : AddonsDataCustom, vcIndex : Int, currentFlightKey : String, baggageIndex: Int, selectedContacts : [ATContact])
}


class BaggageContainerVC : BaseVC {
    
    // MARK: IBOutlets
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var mealsContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var MealTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalContainerView: UIView!
    
    // MARK: Properties
    fileprivate var parchmentView : PagingViewController?
    let baggageContainerVM = BaggageContainerVM()
    weak var delegate : AddonsUpdatedDelegate?
    
    lazy var noResultsemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noBaggageData
        return newEmptyView
    }()
    
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
        
    }
    
    override func setupColors() {
        super.setupColors()
        self.MealTotalLabel.textColor = AppColors.themeGray60
        self.totalLabel.textColor = AppColors.themeBlack
        self.addButton.setTitleColor(AppColors.commonThemeGreen, for: UIControl.State.normal)
    }
    
    override func initialSetup() {
        super.initialSetup()
        setupNavBar()
        setUpViewPager()
        calculateTotalAmount()
        totalContainerView.addShadow(ofColor: .black, radius: 20, opacity: 0.1)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

        parchmentView?.reloadMenu()
        }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        self.baggageContainerVM.updateBaggageToDataStore()
//        let price = self.totalLabel.text ?? ""
        let price = self.baggageContainerVM.calculateTotalAmount()
        self.delegate?.baggageUpdated(amount: price.toString)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BaggageContainerVC {
    
    private func configureNavigation(){
        self.topNavBarView.delegate = self
        let isDivider = baggageContainerVM.allChildVCs.count > 1 ? false : true
        self.topNavBarView.configureNavBar(title: LocalizedString.Baggage.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : isDivider)
        let clearStr = "  \(LocalizedString.ClearAll.localized)"
        self.topNavBarView.configureLeftButton(normalTitle: clearStr, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18), isLeftButtonEnabled : self.baggageContainerVM.isAnyThingSelected())
        self.topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18))
        topNavBarView.darkView.isHidden = false
        topNavBarView.darkView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    private func setUpViewPager() {
        self.baggageContainerVM.allChildVCs.removeAll()
        for index in 0..<AddonsDataStore.shared.flightsWithDataForBaggage.count {
            let vc = SelectBaggageVC.instantiate(fromAppStoryboard: .Adons)
            
            let currentData = AddonsDataStore.shared.flightsWithDataForBaggage[index]
            vc.initializeVm(selectBaggageVM: SelectBaggageVM(vcIndex: index, currentFlightKey: currentData.flightId,addonsDetails: currentData.bags))
            vc.delegate = self
            self.baggageContainerVM.allChildVCs.append(vc)
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
        
        if self.baggageContainerVM.allChildVCs.count < 2 && AddonsDataStore.shared.itinerary.details.legsWithDetail.count < 2  {
            
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
        self.parchmentView?.borderColor = AppColors.divider.color
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        if parchmentView != nil{
            self.mealsContainerView.addSubview(self.parchmentView!.view)
        }
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = AppColors.themeWhiteDashboard
        self.parchmentView?.collectionView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    func calculateTotalAmount(){
//        self.totalLabel.text = "₹ \(self.baggageContainerVM.calculateTotalAmount().commaSeprated)"
        self.totalLabel.attributedText = self.baggageContainerVM.calculateTotalAmount().getConvertedAmount(using: AppFonts.SemiBold.withSize(18))
    }
    
}


extension BaggageContainerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.baggageContainerVM.clearAll()
        calculateTotalAmount()
//        let price = self.totalLabel.text ?? ""
        let price = self.baggageContainerVM.calculateTotalAmount()
        self.delegate?.baggageUpdated(amount: price.toString)
        configureNavigation()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension BaggageContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
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
        return AddonsDataStore.shared.flightsWithDataForBaggage.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.baggageContainerVM.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.flightsWithDataForBaggage[index].flightId }
        guard let firstFlight = flightAtINdex.first else {
            return LogoMenuItem(index: index, isSelected:true)
        }
        
        return LogoMenuItem(index: index, isSelected: true, attributedTitle: self.baggageContainerVM.createAttHeaderTitle(firstFlight.fr, firstFlight.to), logoUrl: AppKeys.airlineMasterBaseUrl + firstFlight.al + ".png")
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        if let pagingIndexItem = pagingItem as? LogoMenuItem {
            self.baggageContainerVM.currentIndex = pagingIndexItem.index
        }
    }
}

extension BaggageContainerVC : SelectBaggageDelegate {
    
    
    func addContactButtonTapped(){
        
    }
    
    func addPassengerToBaggage(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, baggageIndex: Int, selectedContacts: [ATContact]) {
        
        var currentSelectedCountForAddon = selectedContacts.count
        
        let allowedPassengers = self.baggageContainerVM.getAllowedPassengerForParticularAdon(forAdon: forAdon)
        if allowedPassengers.count == 0 { return }
        
        if allowedPassengers.count == 1 {
            
            let passengersToBeAdded = !selectedContacts.isEmpty ? [] : allowedPassengers
            
            self.baggageContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, baggageIndex: baggageIndex, contacts: passengersToBeAdded)
            self.calculateTotalAmount()
            
            if !passengersToBeAdded.isEmpty && forAdon.isInternational {
                
                let baggageTermsVC = BaggageTermsVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
                baggageTermsVC.modalPresentationStyle = .overFullScreen
                baggageTermsVC.baggageTermsVM.agreeCompletion = {[weak self] (agree) in
                    guard let weakSelf = self else { return }
                    if !agree {
                        weakSelf.baggageContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, baggageIndex: baggageIndex, contacts: [])
                        weakSelf.calculateTotalAmount()
                        return }
                }
                self.present(baggageTermsVC, animated: true, completion: nil)
            }
            
        } else {
            let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            vc.selectPassengersVM.selectedContacts = selectedContacts
            vc.selectPassengersVM.adonsData = forAdon
            vc.selectPassengersVM.setupFor = .baggage
            vc.selectPassengersVM.currentFlightKey = currentFlightKey
            vc.selectPassengersVM.contactsComplition = {[weak self] (contacts) in
                guard let weakSelf = self else { return }
                currentSelectedCountForAddon = contacts.count
                weakSelf.baggageContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, baggageIndex: baggageIndex, contacts: contacts)
                weakSelf.calculateTotalAmount()
            }
            
            vc.onDismissCompletion = {[weak self] in
                if currentSelectedCountForAddon == 0 || !forAdon.isInternational { return }
                let baggageTermsVC = BaggageTermsVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
                baggageTermsVC.modalPresentationStyle = .overFullScreen
                baggageTermsVC.baggageTermsVM.agreeCompletion = {[weak self] (agree) in
                    guard let weakSelf = self else { return }
                    if !agree {
                        weakSelf.baggageContainerVM.addPassengerToMeal(forAdon: forAdon, vcIndex: vcIndex, currentFlightKey: currentFlightKey, baggageIndex: baggageIndex, contacts: [])
                        weakSelf.calculateTotalAmount()
                        return }
                }
                self?.present(baggageTermsVC, animated: true, completion: nil)
            }
            self.present(vc, animated: false, completion: nil)
        }
        configureNavigation()

    }
    
    func openBaggageTerms(){
        
    }
    
}

