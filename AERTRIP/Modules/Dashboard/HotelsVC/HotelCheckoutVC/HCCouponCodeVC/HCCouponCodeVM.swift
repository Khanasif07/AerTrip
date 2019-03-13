//
//  HCCouponCodeVM.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol CouponsDataDelegate: class {
    func getCouponsDataSuccessful()
    func getCouponsDataFailed()
}

class HCCouponCodeVM {
    
    weak var delegate: CouponsDataDelegate?
    var couponsData: HCCouponModel?
    
    func getCouponsData() {
        
    }
    
}
