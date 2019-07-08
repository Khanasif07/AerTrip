//
//  OtherBookingsDetails.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OtherBookingsDetailsVC: BaseVC {

    
    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var dataTableView: UITableView! {
        didSet {
            self.dataTableView.delegate = self
            self.dataTableView.dataSource = self
            self.dataTableView.estimatedRowHeight = 100.0
            self.dataTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true)
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.registerNibs()
    }
    
    override func bindViewModel() {
        self.topNavBar.delegate = self
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.dataTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
    //================
}

//Mark:- Extensions
//=================
extension OtherBookingsDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.getTitleAndSubTitleCell(tableView, indexPath: indexPath)
        return cell
    }
}


extension OtherBookingsDetailsVC {
    func getTitleAndSubTitleCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        if indexPath.row  == 0 {
            cell.configCell(title: "Travel Insurance", subTitle: "Non Refundable")
        } else {
            cell.configCell(title: "Policy Certificate No.:", titleFont: AppFonts.SemiBold.withSize(16.0), titleColor: AppColors.themeBlack, subTitle: "4110/O-GTASPL/P/47450/00/000 GOLD TAG PNR : B11828D", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        }
        return cell
    }
}


extension OtherBookingsDetailsVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
