//
//  LoginVC.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-

    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    var viewModel = LoginVM()
    
    //MARK:- View Controller Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initialSetup()
    }
    
    override func bindViewModel() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Methods
    //MARK:- Private
    override func initialSetup() {
        
    }

    //MARK:- Public
    
    
    //MARK:- Action

}

