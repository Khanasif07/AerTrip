//
//  ViewProfileDetailVM.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ViewProfileDetailVMDelegate: class {
    func willGetDetail()
    func getSuccess(_ data: TravelDetailModel)
    func getFail(errors: ErrorCodes)
    func willLogOut()
    func didLogOutSuccess()
    func didLogOutFail(errors: ErrorCodes)
}

class ViewProfileDetailVM {
    weak var delegate: ViewProfileDetailVMDelegate?
    var travelData: TravelDetailModel?
    var paxId: String = UserInfo.loggedInUser?.userId ?? ""
    var isFromTravellerList: Bool = false
    
    func webserviceForGetTravelDetail() {
        var params = JSONDictionary()
        
        params[APIKeys.paxId.rawValue] = paxId
        
        self.delegate?.willGetDetail()
        
        APICaller.shared.getTravelDetail(params: params, completionBlock: { success, data, errorCode in
            
            if success, let trav = data {
                if let uId = UserInfo.loggedInUserId, uId == trav.id {
                    UserInfo.loggedInUser?.firstName = trav.firstName
                    UserInfo.loggedInUser?.lastName = trav.lastName
                    UserInfo.loggedInUser?.profileImage = trav.profileImage
                    
                    for email in trav.contact.email {
                        if email.label.lowercased() == "default".lowercased() {
                            UserInfo.loggedInUser?.email = email.value
                            break
                        }
                    }
                    
                    for mobile in trav.contact.mobile {
                        if mobile.label.lowercased() == "default".lowercased() {
                            UserInfo.loggedInUser?.mobile = mobile.value
                            break
                        }
                    }
                }
                self.delegate?.getSuccess(trav)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        })
    }
    
    func webserviceForLogOut() {
        var params = JSONDictionary()
        
        
        self.delegate?.willLogOut()
        APICaller.shared.callLogOutAPI(params: [:], completionBlock: { success, errors in
            if success {
                self.delegate?.didLogOutSuccess()
            }
            else {
                self.delegate?.didLogOutFail(errors: errors)
            }
        })
    }
    
    
}
