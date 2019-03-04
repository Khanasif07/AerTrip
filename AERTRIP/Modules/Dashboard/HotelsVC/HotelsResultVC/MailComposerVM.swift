//
//  MailComposerVM.swift
//  AERTRIP
//
//  Created by apple on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  MailComoserVMDelegate : class {
    func willSendEmail()
    func didSendEmailSuccess()
    func didSendemailFail()
}

class MailComposerVM: NSObject {
    
    // MARK:- Variables
    
    var favouriteHotels :[HotelSearched] = []
    weak var delegate : MailComoserVMDelegate?
    
    
    
    
    
}
