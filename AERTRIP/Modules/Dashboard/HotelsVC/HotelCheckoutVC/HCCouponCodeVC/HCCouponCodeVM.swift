//
//  HCCouponCodeVM.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum CouponFor:String{
    case hotels
    case flights
}

protocol HCCouponCodeVMDelegate: class {
    func getCouponsDataSuccessful()
    func getCouponsDataFailed()
    
    func applyCouponCodeSuccessful()
    func applyCouponCodeFailed(errors: ErrorCodes)
    
    func searchedCouponsDataSuccessful()
}

class HCCouponCodeVM {
    
    weak var delegate: HCCouponCodeVMDelegate?
    var couponsData: [HCCouponModel] = [] {
        didSet{
            searcedCouponsData = couponsData
        }
    }
    var searcedCouponsData: [HCCouponModel] = []
    var appliedCouponData: HCCouponAppliedModel?
    var appliedDataForFlight:FlightItineraryData?
    var itineraryId: String = ""
    var couponCode: String = ""
    var product = CouponFor.hotels
    var isCouponApplied = false
    
    func searchCoupons(searchText: String) {
        if searchText.isEmpty {
            searcedCouponsData = couponsData
        }else {
            searcedCouponsData = couponsData.filter({ (model) -> Bool in
                model.couponCode.lowercased().contains(searchText.lowercased())
            })
        }
        self.delegate?.searchedCouponsDataSuccessful()
    }
    
    
//    func getCouponsDetailsApi() {
//        delay(seconds: 0.2) {
//            AppGlobals.shared.startLoading()
//        }
//        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryId , APIKeys.product.rawValue : self.product.rawValue]
//        APICaller.shared.getCouponDetailsApi(params: params, loader: true ) { [weak self] (success, errors, couponsDetails) in
//            AppGlobals.shared.stopLoading()
//            guard let sSelf = self else { return }
//            if success {
//                sSelf.couponsData = couponsDetails
//                sSelf.delegate?.getCouponsDataSuccessful()
//            } else {
//                printDebug(errors)
//                sSelf.delegate?.getCouponsDataFailed()
//            }
//        }
//    }
    
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
                sSelf.delegate?.applyCouponCodeFailed(errors: errors)
            }
        }
    }
    
    func applyFlightCouponCode() {
        let params: [String : Any] = [APIKeys.action.rawValue : "coupons" , APIKeys.coupon_code.rawValue : self.couponCode , APIKeys.it_id.rawValue : self.itineraryId ]
        APICaller.shared.applyFlightCoupnCodeApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let sSelf = self else { return }
            if success {
                sSelf.appliedDataForFlight = appliedCouponData
                sSelf.delegate?.applyCouponCodeSuccessful()
            } else {
                printDebug(errors)
                sSelf.delegate?.applyCouponCodeFailed(errors: errors)
            }
        }
    }
    
    func removeFlightCouponCode() {
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryId]
        APICaller.shared.removeFlightCouponApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let sSelf = self else { return }
            if success {
                sSelf.appliedDataForFlight = appliedCouponData
                sSelf.delegate?.applyCouponCodeSuccessful()
                
            } else {
                sSelf.delegate?.applyCouponCodeFailed(errors: errors)
            }
        }
    }
}
