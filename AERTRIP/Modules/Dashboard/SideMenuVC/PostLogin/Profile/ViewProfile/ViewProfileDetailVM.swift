//
//  ViewProfileDetailVM.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ViewProfileDetailVMDelegate: class {
    func willGetDetail(_ isShowLoader: Bool)
    func getSuccess(_ data: TravelDetailModel)
    func getFail(errors: ErrorCodes)
    func willLogOut()
    func didLogOutSuccess()
    func didLogOutFail(errors: ErrorCodes)
}

class ViewProfileDetailVM {
    
    weak var delegate: ViewProfileDetailVMDelegate?
    var travelData: TravelDetailModel? {
        didSet {
            if currentlyUsingFor == .viewProfile {
                checkAndUpdateDefaults()
            }
        }
    }
    var currentlyUsingFor: EditProfileVM.UsingFor = .viewProfile
    var isComingFromDeepLink = false
    
    func webserviceForGetTravelDetail(isShowLoader: Bool = false) {
        var params = JSONDictionary()
        
        params[APIKeys.paxId.rawValue] = self.travelData?.id ?? ""
        if isShowLoader {
            DispatchQueue.mainAsync {
                self.delegate?.willGetDetail(isShowLoader)
            }
        }
        
        APICaller.shared.getTravelDetail(params: params, completionBlock: { [weak self] (success, data, errorCode) in
            guard let strongSelf = self else {return}
            if success, let trav = data {
                if let uId = UserInfo.loggedInUserId, uId == trav.id {
                    UserInfo.loggedInUser?.firstName = trav.firstName
                    UserInfo.loggedInUser?.lastName = trav.lastName
                    UserInfo.loggedInUser?.profileImage = trav.profileImage
                    UserInfo.loggedInUser?.hasPassword = trav.has_password

                    for email in trav.contact.email {
                        if email.label.lowercased() == LocalizedString.Default.localized.lowercased() {
                            UserInfo.loggedInUser?.email = email.value
                            break
                        }
                    }
                    
                    for mobile in trav.contact.mobile {
                        if mobile.label.lowercased() == LocalizedString.Default.localized.lowercased() {
                            UserInfo.loggedInUser?.mobile = mobile.value
                            break
                        }
                    }
                }
                
                if let _ = strongSelf.travelData {
                    
                    // nitin changes
                    // comenting because old values are showing
                    /*
                    if let obj = oldTrav.contact.email.first {
                        trav.contact.add(email: obj)
                    }
                    
                    if let obj = oldTrav.contact.mobile.first {
                        trav.contact.add(mobile: obj)
                    }
                    
                    if let obj = oldTrav.contact.social.first {
                        trav.contact.add(social: obj)
                    }
                    */
                    strongSelf.travelData = trav
                }
                DispatchQueue.mainAsync {
                    strongSelf.delegate?.getSuccess(trav)
                }
            } else {
                DispatchQueue.mainAsync {
                strongSelf.delegate?.getFail(errors: errorCode)
                }
                printDebug(errorCode)
            }
        })
    }
    
    func webserviceForLogOut() {
        
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
    
    
    func webserviceForGetPreferenceList() {
        
        APICaller.shared.callGetPreferencesListApi { success, seatPreferences, mealPreferences, errorCode in
            if success {
//                self.delegate?.getPreferenceListSuccess(seatPreferences, mealPreferences)
            } else {
//                self.delegate?.getFail(errors: errorCode)
//                printDebug(errorCode)
            }
        }
    }
    
    private func checkAndUpdateDefaults() {
        
    }
}


///Logs Firebase  ViewProfileDetailVC events
extension ViewProfileDetailVM {
    func logEventsForFirebase(with event: FirebaseEventLogs.EventsTypeName){
        FirebaseEventLogs.shared.logViewTravellerEvents(with: event)
    }
}

///Logs Firebase  ViewProfileVC events
extension ViewProfileDetailVM {
    func logEventsWithoutParam(with event: AnalyticsEvents){
        FirebaseEventLogs.shared.logEventsWithOutParam(with: event)
    }
     
    func logEvents(with event: FirebaseEventLogs.EventsTypeName){
        FirebaseEventLogs.shared.logProfileEvents(with: event)
    }
}
