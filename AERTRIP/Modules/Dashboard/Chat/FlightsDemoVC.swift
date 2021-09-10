//
//  FlightsDemoVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsDemoVC : BaseVC {
  
    @IBOutlet weak var topNavView: TopNavigationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetups()
    }
    
    //MARK:- Methods
          //MARK:- Private
          private func initialSetups() {
              self.topNavView.delegate = self
              self.topNavView.configureNavBar(title: LocalizedString.flights.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : false)
    }

}

extension FlightsDemoVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popToRootViewController(animated: true)
    }
}
