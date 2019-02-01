//
//  HotelsSearchVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsSearchVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    @IBOutlet weak var tapMeButton: UIButton!
    
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
        self.tapMeButton.isHidden = AppConstants.isReleasingToClient
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func tapOnMeAction(_ sender: UIButton) {
//        AppFlowManager.default.showRoomGuestSelectionVC(selectedAdults: 2, selectedChildren: 3, selectedAges: [2, 3, 10], delegate: self)
        
//        AppFlowManager.default.showSelectDestinationVC(delegate: self)
        
        AppFlowManager.default.moveToHotelsResultVc()
    }
}

//MARK:- RoomGuestSelectionVCDelegate
//MARK:-
extension HotelsSearchVC: RoomGuestSelectionVCDelegate {
    func didSelectedRoomGuest(adults: Int, children: Int, childrenAges: [Int]) {
        printDebug("adults: \(adults), children: \(children), ages: \(childrenAges)")
    }
}

//MARK:- SelectDestinationVCDelegate
//MARK:-
extension HotelsSearchVC: SelectDestinationVCDelegate {
    func didSelectedDestination(hotel: SearchedDestination) {
        printDebug("selected: \(hotel)")
    }
}
