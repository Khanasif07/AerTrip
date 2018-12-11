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
    
    //MARK:- IBOutlets
    //MARK:-
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func loginButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToLoginVC()
    }
}
