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
    @IBOutlet weak var dividerView: UIView!

    var atButton: ATButton?
    

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let atButton = atButton {
            atButton.isLoading = false
        }
        
        
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = LocalizedString.LinkedAccounts.localized
        self.topNavigationView.configureNavBar(title: LocalizedString.LinkedAccounts.localized, isLeftButton: true,isFirstRightButton: false, isSecondRightButton: false,isDivider: false)
        self.messageLabel.numberOfLines = 2
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
        self.view.backgroundColor = AppColors.themeWhite
        self.dividerView.backgroundColor = AppColors.dividerColor

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
        delay(seconds: 0.1) { [weak self] in 
            guard let self = self else {
                return
            }
            
            self.tableView.reloadData()
            
        }
       
    }
    
    func fetchLinkedAccountFail(error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .login)
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
    
    func connect(_ sender: ATButton, forType: LinkedAccount.SocialType) {
        atButton = sender
        switch forType {
        case .facebook:
            displayIndicatorOnButtons(sender: sender, show: true, titleLabel: "", color: .white)
            self.viewModel.fbLogin(vc: self) { (_) in
                self.displayIndicatorOnButtons(sender: sender, show: false, titleLabel: sender.titleLabel?.text ?? "",color: .white)
            }
            
//        case .linkedin:
//            sender.isLoading = true
//            self.viewModel.linkedLogin(vc: self) { (_) in
//                sender.isLoading = false
//            }
            
        case .google:
            displayIndicatorOnButtons(sender: sender, show: true, titleLabel: "", color: .gray)

            self.viewModel.googleLogin(vc: self) { (_) in
                self.displayIndicatorOnButtons(sender: sender, show: false, titleLabel: sender.titleLabel?.text ?? "",color: .gray)

            }
          
         case .apple:
            displayIndicatorOnButtons(sender: sender, show: true, titleLabel: "", color: .white)

            self.viewModel.appleLogin(vc: self) { (_) in
                self.displayIndicatorOnButtons(sender: sender, show: false, titleLabel: sender.titleLabel?.text ?? "",color: .white)

            }
        default:
            printDebug("not required")
        }
    }
    
    func disConnect(_ sender: UIButton, forType: LinkedAccount.SocialType) {
        
        if let loggedSocial = UserInfo.loggedInUser?.socialLoginType, loggedSocial == forType, (UserInfo.loggedInUser?.hasPassword == false) {
            showAlert(title: "Disconnect?", message: LocalizedString.KindlyDisconnectMessage.localized + forType.socialTitle + ".", buttonTitle: "Ok") {
                printDebug("")
            }
        } else {
            if let indexPath = self.tableView.indexPath(forItem: sender) {
                let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Disconnect.localized], colors: [AppColors.themeRed])
                _ = PKAlertController.default.presentActionSheet("Do you wish to disconnect linked account", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, message: nil, messageFont: nil, messageColor: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: { [weak self] _, index in
                    if index == 0, let account =  (self?.viewModel.linkedAccounts[indexPath.row]){
                        self?.viewModel.disConnect(account: account)
                    }
                })
            }
        }
    
    }

}

// MARK: - Top navigation view Delegate methods

extension LinkedAccountsVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
     self.navigationController?.popViewController(animated: true)
    }
    
    
}


//MARK:- Display Loading indicator on buttons

extension LinkedAccountsVC
{
    func displayIndicatorOnButtons(sender:UIButton,show:Bool,titleLabel:String,color:UIColor){
        let tag = 808455
        
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = sender.bounds.size.height
            let buttonWidth = sender.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = color
            indicator.tag = tag

            sender.setTitle(titleLabel, for: .normal)
            if let imageView = sender.imageView {
                sender.sendSubviewToBack(imageView)
            }

            sender.addSubview(indicator)
            indicator.startAnimating()

        } else {
            if let indicator = sender.viewWithTag(tag) as? UIActivityIndicatorView
            {
                sender.setTitle(titleLabel, for: .normal)

                if let imageView = sender.imageView {
                    sender.bringSubviewToFront(imageView)
                }

                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
