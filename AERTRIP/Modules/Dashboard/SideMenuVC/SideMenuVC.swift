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
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    
    //MARK:- IBAction
    //MARK:-
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
        self.socialViewModel.fbLogin(vc: self)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        self.socialViewModel.googleLogin()
    }
    
    @IBAction func linkedLoginButtonAction(_ sender: UIButton) {
        self.socialViewModel.linkedLogin()
    }
}

//MARK:- Extension SetupView
//MARK:-
private extension SideMenuVC {
    
    func initialSetups() {
        
        self.registerXibs()
    }
    
    func registerXibs() {
        
        self.sideMenuTableView.register(UINib(nibName: "SideMenuOptionsLabelCell", bundle: nil), forCellReuseIdentifier: "SideMenuOptionsLabelCell")
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.delegate  = self
    }
}

//MARK:- Extension Target Methods
//MARK:-
extension SideMenuVC {
    
    @objc func loginAndRegistrationButtonAction(_ sender: ATButton) {
        AppFlowManager.default.moveToSocialLoginVC()
    }
}

//MARK:- Extension SetupView
//MARK:-
extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.displayCells.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestSideMenuHeaderCell", for: indexPath) as? GuestSideMenuHeaderCell else {
                fatalError("GuestSideMenuHeaderCell not found")
            }
            
            cell.loginAndRegisterButton.addTarget(self, action: #selector(self.loginAndRegistrationButtonAction(_:)), for: .touchUpInside)
            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                fatalError("SideMenuOptionsLabelCell not found")
            }
            
            cell.populateData(text: self.viewModel.displayCells[indexPath.row - 1])
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
