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
        
           let labelWidth = tableView.frame.width - (16 + 104 + 19 + 46)
       
//          let headingHeight = self.adonsVm.addOnsData[indexPath.row].heading.heightOfText(labelWidth, font: AppFonts.SemiBold.withSize(18))
        
        let headingHeight = self.adonsVm.addOnsData[indexPath.row].heading.getTextHeight(width: labelWidth,font: AppFonts.SemiBold.withSize(18),  numberOfLines: 1)
        
//        let descHeight = self.adonsVm.addOnsData[indexPath.row].desc.heightOfText(labelWidth, font: AppFonts.Regular.withSize(14))
        
        let descHeight = self.adonsVm.addOnsData[indexPath.row].desc.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(14),  numberOfLines: 2)

        let complementHeight = self.adonsVm.addOnsData[indexPath.row].complement.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(12),  numberOfLines: 1) + 4
   
        let complementHeightToBeAddedOrNot : CGFloat = self.adonsVm.addOnsData[indexPath.row].shouldShowComp ? complementHeight : 0

        let midSpacing : CGFloat = 7
        
        let topAndBottomSpacing : CGFloat = 19 + 19
        
        let totalHeight = headingHeight + descHeight + complementHeightToBeAddedOrNot + midSpacing + topAndBottomSpacing
        
        let finalheight = totalHeight <= 104 ? 104 : totalHeight
        
        return finalheight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdonsCell", for: indexPath) as? AdonsCell else { fatalError("AdonsCell not found") }
              
        cell.populateData(type: AdonsVM.AdonsType(rawValue: indexPath.row) ?? AdonsVM.AdonsType.meals, data: self.adonsVm.addOnsData[indexPath.row])
        
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MealsContainerVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
