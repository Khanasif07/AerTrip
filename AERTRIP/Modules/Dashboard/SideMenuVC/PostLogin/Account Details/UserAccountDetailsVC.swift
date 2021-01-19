//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class UserAccountDetailsVC : BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var accountDetailsTableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
   
    
    let viewModel = UserAccountDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.viewModel.getProfilData()
    }
    
    override func setupFonts() {

    }
    
    override func setupColors() {
       
    }

    override func setupTexts() {
    
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
        
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Account_Details.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : true)
        configureTableView()
        self.accountDetailsTableView.backgroundColor = AppColors.themeGray04
        self.accountDetailsTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: 0, right: 0)
        self.progressView.progressTintColor = UIColor.AertripColor
        self.progressView.trackTintColor = .clear
    
    }
    
    private func configureTableView(){
        self.accountDetailsTableView.register(UINib(nibName: "UserAccountDetailsCell", bundle: nil), forCellReuseIdentifier: "UserAccountDetailsCell")
        self.accountDetailsTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        self.accountDetailsTableView.separatorStyle = .none
        self.accountDetailsTableView.rowHeight = UITableView.automaticDimension
        self.accountDetailsTableView.estimatedRowHeight = 44
        self.accountDetailsTableView.dataSource = self
        self.accountDetailsTableView.delegate = self
    }
    
    func showProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
            guard let self = self else {return}
            self.progressView.isHidden = false
            self.progressViewHeight.constant = 1
        }
    }
    
    func hideProgressView(){
        UIView.animate(withDuration: 2) {[weak self] in
        guard let self = self else {return}
            self.progressViewHeight.constant = 0
            self.progressView.isHidden = true
        }
    }
    
}


extension UserAccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}


extension UserAccountDetailsVC : GetAccountDetailsDelegate  {
    
    
    func willGetDetails() {
        self.progressView.setProgress(0, animated: false)
        self.accountDetailsTableView.isHidden = true
        self.showProgressView()
        delay(seconds: 0.5){[weak self] in
        guard let self = self else {return}
         UIView.animate(withDuration: 2){[weak self] in
         guard let self = self else {return}
             self.progressView.setProgress(0.25, animated: true)
         }
            
            UIView.animate(withDuration: 2) {
                self.progressView.setProgress(0.25, animated: true)

            } completion: { (success) in
                
                UIView.animate(withDuration: 2) {
                    self.progressView.setProgress(0.50, animated: true)
                } completion: { (success) in
                    
                }
            }
        }
    }
    
    func getAccountDetailsSuccess() {

        UIView.animate(withDuration: 2) {
            self.progressView.setProgress(1, animated: true)
        } completion: { (success) in
                self.accountDetailsTableView.isHidden = false
                self.hideProgressView()
                self.accountDetailsTableView.reloadData()
        }
    }
    
    func failedToGetAccountDetails() {
        self.hideProgressView()
    }
    
}

extension UserAccountDetailsVC : GetUpdatedAccountDetailsBack {
    
    func updatedDetails(details : UserAccountDetail) {
        self.viewModel.details = details
        self.accountDetailsTableView.reloadData()
    }
    
}
