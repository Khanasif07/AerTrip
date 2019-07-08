//
//  AbortRequestVM.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol AbortRequestVMDelegate: class {
    func willMakeRequestAbort()
    func makeRequestAbortSuccess()
    func makeRequestAbortFail()
}

class AbortRequestVM {
    
    var caseToAbort: Case?
    var comment: String = ""
    weak var delegate: AbortRequestVMDelegate?
    
    func makeRequestAbort() {
        
        guard let caseData = caseToAbort else {
            fatalError("Please pass the case to be aborted in \(#file) at line numer \(#line)")
        }
        
        let param = ["case_id": caseData.id, "booking_id": caseData.bookingId, "reason": comment]
        
        self.delegate?.willMakeRequestAbort()
        APICaller.shared.abortRequestAPI(params: param) { [weak self] (success, errors) in
            guard let sSelf = self else {return}
            
            if success {
                sSelf.delegate?.makeRequestAbortSuccess()
            }
            else {
                sSelf.delegate?.makeRequestAbortFail()
            }
        }
    }
}
