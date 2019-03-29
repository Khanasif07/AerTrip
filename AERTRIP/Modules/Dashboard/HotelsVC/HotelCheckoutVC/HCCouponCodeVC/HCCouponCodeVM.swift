//
//  HCCouponCodeVM.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCCouponCodeVMDelegate: class {
    func getCouponsDataSuccessful()
    func getCouponsDataFailed()
    
    func applyCouponCodeSuccessful()
    func applyCouponCodeFailed()
}

class HCCouponCodeVM {
    
    weak var delegate: HCCouponCodeVMDelegate?
    var couponsData: [HCCouponModel] = []
    var itineraryId: String = ""
    var couponCode: String = ""
    
    func getCouponsDetailsApi() {
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryId , APIKeys.product.rawValue : "hotels"]
        APICaller.shared.getCouponDetailsApi(params: params, loader: true ) { [weak self] (success, errors, couponsDetails) in
            guard let sSelf = self else { return }
            if success {
                sSelf.couponsData = couponsDetails
                sSelf.delegate?.getCouponsDataSuccessful()
            } else {
                printDebug(errors)
//                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.getCouponsDataFailed()
            }
        }
    }
    
    func applyCouponCode() {
        let params: [String : Any] = [APIKeys.action.rawValue : "coupons" , APIKeys.coupon_code.rawValue : self.couponCode , APIKeys.it_id.rawValue : self.itineraryId ]
        APICaller.shared.applyCoupnCodeApi(params: params, loader: true) { [weak self] (success, errors, couponAppliedStatus) in
            guard let sSelf = self else { return }
            if success {
                printDebug(couponAppliedStatus)
                sSelf.delegate?.applyCouponCodeSuccessful()
            } else {
                printDebug(errors)
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.applyCouponCodeFailed()
            }
        }
    }
}
