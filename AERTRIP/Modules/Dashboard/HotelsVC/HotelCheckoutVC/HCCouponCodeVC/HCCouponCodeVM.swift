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
    func applyCouponCodeFailed(errors: ErrorCodes)
}

class HCCouponCodeVM {
    
    weak var delegate: HCCouponCodeVMDelegate?
    var couponsData: [HCCouponModel] = []
    var appliedCouponData: HCCouponAppliedModel?
    var itineraryId: String = ""
    var couponCode: String = ""
    var product = "hotels"
    
    func getCouponsDetailsApi() {
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryId , APIKeys.product.rawValue : self.product]
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
        APICaller.shared.applyCoupnCodeApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let sSelf = self else { return }
            if success {
                printDebug(appliedCouponData)
                sSelf.appliedCouponData = appliedCouponData
                sSelf.delegate?.applyCouponCodeSuccessful()
            } else {
                printDebug(errors)
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.applyCouponCodeFailed(errors: errors)
            }
        }
    }
    
}
