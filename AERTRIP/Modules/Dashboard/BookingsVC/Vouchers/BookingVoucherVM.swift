//
//  BookingVoucherVM.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


class BookingVoucherVM {
    
    
    var vouchers: [VoucherEvent] = []
    
    func getVouherData() {
        let jsonData: [JSONDictionary] = [
            [
                "id"   : "1",
                "title":  "Booking",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 12,545",
                "type" : "data"
               
            ],
            [
                 "id"   : "2",
                "title":  "Add-ons",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 5,800",
                "type" : "data"
            ],
            [
                 "id"   : "3",
                "title":  "xxxx  xxxx  xxxx  3424s",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 5,800",
                "type" : "card"
               
            ],
            [
                "id" : "4",
                "title":  "xxxx  xxxx  xxxx  3424s",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 5,800",
                "type" : "card"
            ],
            [
                "id"   : "1",
                "title":  "xxxx  xxxx  xxxx  3424",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 12,545",
                "type" : "card"
                
                ],
            [
                "id"   : "2",
                "title":  "Add-ons",
                "date" : "Fri, 12 Oct 2014",
                "price": "₹ 5,800",
            ],
            [
                "id"   : "3",
                "title":  "Amount to be paid",
                "date" : "",
                "price": "₹ 5,800",
                "type" : "payment"
            ]
            
        ]
        
                self.vouchers = VoucherEvent.getVoucherData(jsonDictArray: jsonData)
        
    }
}
