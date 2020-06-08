//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AddOnVC : BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var adonsTableView: UITableView!
    
    let adonsVm = AdonsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func setupColors() {
        super.setupColors()
        
    }
    
    override func setupTexts() {
        super.setupTexts()
        
    }
}

//MARK:- Methods
extension AddOnVC {
    
    private func initialSetups() {
        configureTableView()
    }
    
    func configureNavigation(){
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false,isDivider : false)
        self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Skip.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
    }
    
    private func configureTableView(){
        self.adonsTableView.register(UINib(nibName: "AdonsCell", bundle: nil), forCellReuseIdentifier: "AdonsCell")
        self.adonsTableView.separatorStyle = .none
        //        self.adonsTableView.estimatedRowHeight = 104
        self.adonsTableView.rowHeight = UITableView.automaticDimension
        self.adonsTableView.dataSource = self
        self.adonsTableView.delegate = self
    }
}

extension AddOnVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        
    }
}

extension AddOnVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adonsVm.addOnsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.adonsVm.getCellHeight(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdonsCell", for: indexPath) as? AdonsCell else { fatalError("AdonsCell not found") }
        
        cell.populateData(type: AdonsVM.AdonsType(rawValue: indexPath.row) ?? AdonsVM.AdonsType.meals, data: self.adonsVm.addOnsData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = AdonsVM.AdonsType(rawValue: indexPath.row) ?? AdonsVM.AdonsType.meals
        
        switch type {
            
        case .meals:
            let vc = MealsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
//            vc.mealsContainerVM.itinerary = AddonsDataStore.shared.itinerary
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            
        case .baggage:
            let vc = BagageContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            
        case .seat:
            let vc = SeatMapContainerVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
            vc.setViewModel(adonsVm.getSeatMapContainerVM())
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            
        case .otheres:
            let vc = SelectOtherAdonsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
            
        }
    }
    
}
