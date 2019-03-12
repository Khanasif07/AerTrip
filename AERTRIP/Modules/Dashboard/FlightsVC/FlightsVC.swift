//
//  FlightsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    @IBOutlet weak var myButton: UIButton!
    
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
    @IBAction func myButtonAction(_ sender: UIButton) {
//        AppFlowManager.default.presentSelectTripVC(delegate: self)
        AppFlowManager.default.moveToHCDataSelectionVC()
    }
}

//MARK:- SelectTripVC delegate methods
//MARK:-
extension FlightsVC: SelectTripVCDelegate {
    func selectTripVC(sender: SelectTripVC, didSelect trip: TripModel) {
        printDebug("Selected trip: \(trip.title)")
    }
}
