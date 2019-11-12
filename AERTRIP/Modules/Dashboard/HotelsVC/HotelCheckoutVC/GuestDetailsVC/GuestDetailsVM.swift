//
//  GuestDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GuestDetailsVMDelegate: class {}

class GuestDetailsVM {
    static let shared = GuestDetailsVM()
    weak var delegate: GuestDetailsVMDelegate?
    // Save Hotel Form Data
    var hotelFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var selectedIndexPath: IndexPath = IndexPath()
    var salutation = [String]()
    var canShowSalutationError = false
    
    // GuestModalArray for travellers
    var guests: [[ATContact]] = [[]]
    var travellerList: [TravellerModel] = []
    
    private init() {}
    
    func webserviceForGetSalutations() {
        APICaller.shared.callGetSalutationsApi(completionBlock: { success, data, errors in
            
            if success {
                self.salutation = data
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
            }
        })
    }
}
