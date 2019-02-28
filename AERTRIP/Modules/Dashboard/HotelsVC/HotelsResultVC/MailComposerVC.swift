//
//  MailComposerVC.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MailComposerVC: BaseVC {
    // MARK: IB Outlets
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Variables
    
    let cellIdenitifer = "HotelMailComposerCardViewTableViewCell"
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doInitialSetup()
    }
    
    // MARK: - Helper methods
    
    private func doInitialSetup() {
        self.navBarSetUp()
        self.tableViewSetup()
        self.registerXib()
        self.setupHeader()
    }
    
    private func navBarSetUp() {
        self.topNavView.backgroundColor = AppColors.clear
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Edit.rawValue, selectedTitle: LocalizedString.Send.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
    }
    
    private func tableViewSetup() {
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerXib() {
        self.tableView.register(UINib(nibName: cellIdenitifer, bundle: nil), forCellReuseIdentifier: cellIdenitifer)
    }
    
    private func setupHeader() {
        
    }
}

// MARK: - Top Navigation Bar Delegate methods

extension MailComposerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Send mail")
    }
}


// MARK: - TableViewDataSource and TableViewDelegate methods

extension MailComposerVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenitifer, for: indexPath) as? HotelMailComposerCardViewTableViewCell else {
            printDebug("cell not found")
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 395
    }
    
}
