//
//  SideMenuVC.swift
//  AERTRIP
//
//  Created by Admin on 10/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuVC: BaseVC {

    //MARK:- Properties
    //MARK:-
    let viewModel = SideMenuVM()
    let socialViewModel = SocialLoginVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.viewModel.isLogin.is
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.alpha = 1.0
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
             self.view.alpha = 0.5
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBAction
    
    // MARK: -

    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
       self.socialViewModel.fbLogin(vc: self, completionBlock: nil)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        self.socialViewModel.googleLogin()
    }
    
    @IBAction func linkedLoginButtonAction(_ sender: UIButton) {
        self.socialViewModel.linkedLogin()
    }
}


// MARK: - Extension SetupView

// MARK: -

private extension SideMenuVC {
    
    func initialSetups() {

        self.registerXibs()
    }
    
    func registerXibs() {
        
        self.sideMenuTableView.register(UINib(nibName: "SideMenuOptionsLabelCell", bundle: nil), forCellReuseIdentifier: "SideMenuOptionsLabelCell")
        self.sideMenuTableView.register(UINib(nibName: "SideMenuProfileImageCell", bundle: nil), forCellReuseIdentifier: "SideMenuProfileImageCell")
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.delegate   = self
    }
}


// MARK: - Extension Target Methods

// MARK: -

extension SideMenuVC {
    @objc func loginAndRegistrationButtonAction(_ sender: ATButton) {
        AppFlowManager.default.moveToSocialLoginVC()
    }
    
    @objc func viewProfileButtonAction(_ sender: ATButton) {
        
        AppFlowManager.default.moveToViewProfileVC()
    }
}


// MARK: - Extension SetupView

// MARK: -

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isLogin {
            return self.viewModel.cellForLoginUser.count + 1
            
        } else {
            return self.viewModel.displayCellsForGuest.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            
        case 0:
            
            if self.viewModel.isLogin {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuProfileImageCell", for: indexPath) as? SideMenuProfileImageCell else {
                    fatalError("SideMenuProfileImageCell not found")
                }
                
                cell.populateData(userData: self.viewModel.userData)
                cell.viewProfileButton.addTarget(self, action: #selector(self.viewProfileButtonAction(_:)), for: .touchUpInside)
                
                return cell
                
            } else {
                

                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestSideMenuHeaderCell", for: indexPath) as? GuestSideMenuHeaderCell else {
                    fatalError("GuestSideMenuHeaderCell not found")
                }
                
                cell.loginAndRegisterButton.addTarget(self, action: #selector(self.loginAndRegistrationButtonAction(_:)), for: .touchUpInside)
                
                return cell
            }

        case 1:
            
            if self.viewModel.isLogin {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewAccountCell", for: indexPath) as? SideMenuViewAccountCell else {
                    fatalError("SideMenuViewAccountCell not found")
                }
                
                cell.populateData(data: self.viewModel.userData)
                return cell

            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                    fatalError("SideMenuOptionsLabelCell not found")
                }
                
                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
                return cell
            }

        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                fatalError("SideMenuOptionsLabelCell not found")
            }
            
            if self.viewModel.isLogin {
                
                cell.populateData(text: self.viewModel.cellForLoginUser[indexPath.row - 2])
                
                if indexPath.row == 6 {
                    cell.sepratorView.isHidden = false
                }
                
            } else {
                

                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if indexPath.row == 6 && self.viewModel.isLogin {
            
            let action =   AKAlertController.actionSheet( nil, message: LocalizedString.DoYouWantToLogout.localized, sourceView: self.view, buttons: [LocalizedString.Logout.localized], tapBlock: {(alert,index) in
                
                AppUserDefaults.removeAllValues()
                AppFlowManager.default.goToDashboard()
                
            })
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
