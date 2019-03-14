//
//  EmailItinerariesVC.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCEmailItinerariesVC: BaseVC {

    //Mark:- Variables
    //================
    let viewModel = HCEmailItinerariesVM()
    var selectedIndexPath: [IndexPath] = []
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.headerViewSetUp()
        self.registerNibs()
    }
    
    override func setupFonts() {
        self.headerView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.headerView.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
//        self.headerView.navTitleLabel.text = LocalizedString.SpecialRequest.localized
    }
    
    //Mark:- Functions
    //================
    private func headerViewSetUp() {
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: LocalizedString.EmailItineraries.localized , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.headerView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.headerView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.SendToAll.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    private func registerNibs() {
        self.tableView.registerCell(nibName: HCEmailItinerariesTableViewCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
}

extension HCEmailItinerariesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCEmailItinerariesTableViewCell.reusableIdentifier, for: indexPath) as? HCEmailItinerariesTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        if self.selectedIndexPath.contains(indexPath) {
            cell.configCell(isMailSended: true, name: self.viewModel.names[indexPath.row])
        } else {
            cell.configCell(isMailSended: false, name: self.viewModel.names[indexPath.row])
        }
        return cell
    }
}

extension HCEmailItinerariesVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
    }
}

extension HCEmailItinerariesVC: SendToEmailIDDelegate {

    func sendToEmailId(indexPath: IndexPath) {
        if !self.selectedIndexPath.contains(indexPath) {
            self.selectedIndexPath.append(indexPath)
            self.tableView.reloadData()
        }
        else {
            printDebug("Email already sended")
        }
    }
    
    func sendEmailText(emailId: String) {
        printDebug(emailId)
    }
}
