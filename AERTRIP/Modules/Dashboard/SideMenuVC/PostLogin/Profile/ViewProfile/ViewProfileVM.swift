//
//  ViewProfileVM.swift
//  AERTRIP
//
//  Created by apple on 29/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ViewProfileVMDelegate: class {
    func willLogOut()
    func didLogOutSuccess()
    func didLogOutFail(errors: ErrorCodes)
}

class ViewProfileVM {
    weak var delegate: ViewProfileVMDelegate?
    
   
}
