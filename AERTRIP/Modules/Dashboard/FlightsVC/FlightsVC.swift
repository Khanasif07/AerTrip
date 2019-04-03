//
//  FlightsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import Razorpay

class FlightsVC: BaseVC {
    // MARK: - Properties
    var subView = HotelCheckOutDetailsVIew()
    // MARK: -
    
    private var razorpay : Razorpay!
    
    @IBOutlet var myButton: UIButton!
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        
        razorpay = Razorpay.initWithKey(AppConstants.kRazorpayPublicKey, andDelegateWithData: self)
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {}
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func myButtonAction(_ sender: UIButton) {
        self.initializePayment(forAmount: 1.0)
    }
}


extension FlightsVC: RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(forAmount amount: Double) {
        let options = [
            "amount" : "\(amount)"
        ]
        razorpay.open(options)
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        printDebug("code: \(code) \ndescription \(str) \nresponse \(response) ")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        printDebug("payment_id: \(payment_id) \nresponse \(response) ")
    }
}
