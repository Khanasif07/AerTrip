//
//  GSTINListVM.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
 
class GSTINListVM{
    
    var gSTList = [GSTINModel]()
    var returnGSTIN : ((_ gstIn: GSTINModel)->())?
    
    init() {
        for i in 0..<3{
            var gst = GSTINModel()
            gst.id = "\(i+1)"
            gst.billingName = "Aertrip India Ltd. West Zone"
            gst.companyName = "Aertrip India Ltd."
            gst.GSTInNo = "27AAPCA3454J1Z4"
            gSTList.append(gst)
        }
    }
    
}
