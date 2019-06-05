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
//                AppFlowManager.default.moveToOtherBookingsDetailsVC()
        //                AppFlowManager.default.moveToRequestReschedulingVC()
//        AppFlowManager.default.moveToFlightBookingsDetailsVC()
        AppFlowManager.default.moveToHotelCancellationVC()
//        AppFlowManager.default.moveToHotlelBookingsDetailsVC()
        //        AppFlowManager.default.presentYouAreAllDoneVC(forItId: "", bookingIds: [], cid: [], originLat: "", originLong: "")
        
        //
        //        let params: JSONDictionary = [APIKeys.loginid.rawValue : "abc@gmail.com", APIKeys.password.rawValue : "" , APIKeys.isGuestUser.rawValue : "true"]
        //        printDebug(params)
        //        APICaller.shared.loginForPaymentAPI(params: params) { [weak self] (success, logInId, isGuestUser, errors) in
        //            if success {
        //                printDebug("\(logInId) , \(isGuestUser)")
        //            } else {
        //            }
        //        }
    }
}
