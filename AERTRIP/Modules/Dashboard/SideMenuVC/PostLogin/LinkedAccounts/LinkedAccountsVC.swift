//
//  LinkedAccountsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class LinkedAccountsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private(set) var viewModel = LinkedAccountsVM()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = LocalizedString.LinkedAccounts.localized
        self.topNavigationView.configureNavBar(title: LocalizedString.LinkedAccounts.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false)
        self.messageLabel.text = LocalizedString.LinkedAccountsMessage.localized
    }
    
    override func setupColors() {
        self.navTitleLabel.textColor = AppColors.themeBlack
        self.messageLabel.textColor = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        topNavigationView.delegate = self
        self.viewModel.fetchLinkedAccounts()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- View Model Delegate Methods
//MARK:-
extension LinkedAccountsVC: LinkedAccountsVMDelegate {
    func willFetchLinkedAccount() {
//        showLoaderOnView(view: self.view, show: true)
    }
    
    func fetchLinkedAccountSuccess() {
//        showLoaderOnView(view: self.view, show: false)
        self.tableView.reloadData()
    }
    
    func fetchLinkedAccountFail() {
//        showLoaderOnView(view: self.view, show: false)
    }
}

//MARK:- Table View Delegate and Datasource Methods
//MARK:-
extension LinkedAccountsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.linkedAccounts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LinkedAccountsTableCell") as? LinkedAccountsTableCell else {
            return UITableViewCell()
        }
        
        cell.linkedAccount = self.viewModel.linkedAccounts[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

extension LinkedAccountsVC: LinkedAccountsCellDelegate {
    
    func connect(_ sender: UIButton, forType: LinkedAccount.SocialType) {
        switch forType {
        case .facebook:
            self.viewModel.fbLogin(vc: self, completionBlock: nil)
            
        case .linkedin:
            self.viewModel.linkedLogin(vc: self)
            
        case .google:
            self.viewModel.googleLogin(vc: self, completionBlock: nil)
            
        default:
            printDebug("not required")
        }
    }
    
    func disConnect(_ sender: UIButton, forType: LinkedAccount.SocialType) {
        if let indexPath = self.tableView.indexPath(forItem: sender) {
            self.viewModel.disConnect(account: self.viewModel.linkedAccounts[indexPath.row])
        }
    }
}

// MARK: - Top navigation view Delegate methods

extension LinkedAccountsVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
    }
    
    
}
