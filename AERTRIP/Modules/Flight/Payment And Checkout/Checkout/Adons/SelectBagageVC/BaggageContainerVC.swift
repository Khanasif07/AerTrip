//
//  BagageContainerVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment


class BaggageContainerVC : BaseVC {

    // MARK: Properties
       fileprivate var parchmentView : PagingViewController?
//       private let allTabsStr: [String] = ["BOM → LON", "LON → NYC", "NYC → DEL"]
       

       let baggageContainerVM = BaggageContainerVM()
    
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
           
       }
       
       override func setupColors() {
           super.setupColors()
           
       }
       
       override func initialSetup() {
           super.initialSetup()
           setupNavBar()
           setUpViewPager()
       }

        @IBAction func addButtonTapped(_ sender: UIButton) {
            let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
    }
    
    
}

extension BaggageContainerVC {
    
    private func configureNavigation(){
        self.topNavBarView.delegate = self
        self.topNavBarView.configureNavBar(title: LocalizedString.Baggage.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : false)
        
        self.topNavBarView.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen)
        
        self.topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
    }
    
    private func setUpViewPager() {
        self.baggageContainerVM.allChildVCs.removeAll()
        for index in 0..<AddonsDataStore.shared.allFlightKeys.count {
            let vc = SelectBaggageVC.instantiate(fromAppStoryboard: .Adons)
            vc.initializeVm(selectBaggageVM: SelectBaggageVM(vcIndex: index, currentFlightKey: AddonsDataStore.shared.allFlightKeys[index]))
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
    
}


extension BaggageContainerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension BaggageContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.title
            
            let font = isSelected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            return text.widthOfString(usingFont: font)
        }
        
        return 100.0
    }
    
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return AddonsDataStore.shared.allFlights.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return self.baggageContainerVM.allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        
        let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.allFlightKeys[index] }
          guard let firstFlight = flightAtINdex.first else {
              return MenuItem(title: "", index: index, isSelected:false)
          }
          return MenuItem(title: "\(firstFlight.fr) → \(firstFlight.to)", index: index, isSelected:false)
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        if let pagingIndexItem = pagingItem as? MenuItem {
            self.baggageContainerVM.currentIndex = pagingIndexItem.index
        }
    }
}

extension BaggageContainerVC : SelectBaggageDelegate {

    func addContactButtonTapped(){
        
    }
    
    func addPassengerToBaggage(vcIndex: Int, currentFlightKey: String, baggageIndex: Int) {
        let vc = SelectPassengerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
        vc.modalPresentationStyle = .overFullScreen
        vc.selectPassengersVM.contactsComplition = {[weak self] (contacts) in
            guard let weakSelf = self else { return }
            AddonsDataStore.shared.setContactsForBaggage(vcIndex: vcIndex, currentFlightKey: currentFlightKey, baggageIndex: baggageIndex, contacts: contacts)
            weakSelf.baggageContainerVM.allChildVCs[vcIndex].reloadData(index: baggageIndex)
        }
        present(vc, animated: true, completion: nil)
    }
    
}

