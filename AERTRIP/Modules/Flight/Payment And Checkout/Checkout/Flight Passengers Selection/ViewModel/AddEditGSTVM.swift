//
//  AddEditGSTVM.swift
//  Aertrip
//
//  Created by Apple  on 15.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
class AddEditGSTVM{
    var gst = GSTINModel()
    var isEditingGST = false
    var updateGst : ((_ gst:GSTINModel) -> ())?
    
    //Add Complete validation for gst form.
    func validateInfo()->Bool{
        return (!gst.billingName.isEmpty) && (!gst.companyName.isEmpty) && (!gst.GSTInNo.isEmpty)
    }
    
}
