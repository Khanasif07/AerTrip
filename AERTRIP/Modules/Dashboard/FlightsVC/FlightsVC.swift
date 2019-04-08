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
    var subView = HotelCheckOutDetailsVIew()
    // MARK: -
    
    @IBOutlet var myButton: UIButton!
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {}
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func myButtonAction(_ sender: UIButton) {
//        AppFlowManager.default.presentHCEmailItinerariesVC()
//        AppFlowManager.default.presentYouAreAllDoneVC(forItId: "23423", bookingIds: ["1323"], originLat: "", originLong: "")
    }
}
