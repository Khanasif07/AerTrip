//
//  FlightsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsVC: BaseVC {
    // MARK: - Properties
    private var homeFlightsVC: UIViewController!

    // MARK: -
        
    // MARK: - IBOutlets
    
    // MARK: -
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeFlightsVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        addFlightsModuleView()
    }
    
    private func addFlightsModuleView() {
        let homeFlightStoryBoard = UIStoryboard(name: "FlightForm", bundle: nil)
        homeFlightsVC = homeFlightStoryBoard.instantiateViewController(withIdentifier: "FlightFormViewController")
        
        homeFlightsVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.addChild(homeFlightsVC)
        view.addSubview(homeFlightsVC.view)
        homeFlightsVC.didMove(toParent: self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
}
