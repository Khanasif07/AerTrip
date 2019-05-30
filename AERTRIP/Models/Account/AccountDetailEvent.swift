//
//  AccountDetailEvent.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct AccountDetailEvent {
    
    enum Voucher: String {
        case none
        
        //with-out subtypes
        case receipt = "Receipt"
        case lockAmount = "Lock Amount"
        case debitNote = "Debit Note"
        case creditNote = "Credit Note"
        
        //these have sub types
        case sales = "Sales"
        case journal = "Journal"

    }
    
    enum ReceiptMethod: String {
        case none
        case netbanking = "netbanking"
        case card = "card"
        case upi = "upi"
    }
    
    enum ProductType: String {
        case none
        case hotel = "hotel"
        case flight = "flight"
        case addOns = "addOns"
    }

    var id : String = ""
    var title : String = ""
    
    private var _creationDate: Date?
    var creationDateStr: String? {
        return _creationDate?.toString(dateFormat: "EEE, dd MMM")
    }
    
    private var _voucher : String = ""
    var voucher: Voucher {
        get {
            return Voucher(rawValue: self._voucher) ?? Voucher.none
        }
        
        set {
            self._voucher = newValue.rawValue
        }
    }
    var voucherNo: String = ""
    
    var voucherName: String {
        return self.voucher.rawValue
    }
    
    private var _receiptMethod : String = ""
    var receiptMethod: ReceiptMethod {
        get {
            return ReceiptMethod(rawValue: self._receiptMethod) ?? ReceiptMethod.none
        }
        
        set {
            self._receiptMethod = newValue.rawValue
        }
    }
    
    private var _productType : String = ""
    var productType: ProductType {
        get {
            return ProductType(rawValue: self._productType) ?? ProductType.none
        }
        
        set {
            self._productType = newValue.rawValue
        }
    }
    
    var transactionId: String = ""
    
    var amount: Double = 0.0
    var balance: Double = 0.0
    
    var iconImage: UIImage? = nil
    
    var date: Date?
    var checkIn: Date?
    var checkOut: Date?
    var room: String = ""
    var inclusion: String = ""
    var confirmationId: String = ""
    var names: [String] = []
    
    var bookingId: String = ""
    
    var creditCardNo: String = ""
    
    //flight details related
    var billNumber: String = ""
    var totalAmount: Double = 0.0
    var pendingAmount: Double = 0.0
    var dueDate: Date?
    var overDueDays: Int = 0
    
    var voucherDate: Date?
    
    var travelDate: Date?
    var airline: String = ""
    var sector: String = ""
    var pnr: String = ""
    var ticketNo: String = ""

    var numOfRows: Int {
        return 2
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        else {
            self.id = UIApplication.shared.uniqueID
        }
        
        if let obj = json["amount"] {
            let amt = "\(obj)".toDouble ?? 0.0
            self.amount = amt * -1
        }
        
        if let obj = json["transaction_id"] {
            self.transactionId = "\(obj)"
        }
        
        if let obj = json["balance"] {
            let amt = "\(obj)".toDouble ?? 0.0
            self.balance = amt * -1
        }
        
        if let obj = json["transaction_datetime"] {
            //"2019-04-08 16:17:28"
            self._creationDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
            
            if self._creationDate == nil {
                self._creationDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
            }
            
            self.date = self._creationDate
        }
        
        
        if let obj = json["voucher"] {
            self._voucher = "\(obj)"
            self.fetchVoucherDetails(json: json)
        }
        
        
        if let obj = json["voucher_number"] {
            self.voucherNo = "\(obj)"
        }
        
        if let obj = json["overdue_days"] {
            self.overDueDays = "\(obj)".toInt ?? 0
        }
        
        if let obj = json["due_date"] {
            //2019-04-06
            self.dueDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
        }
        
        if let obj = json["pending"] {
            self.pendingAmount = "\(obj)".toDouble ?? 0.0
        }
    }
    
    mutating private func fetchVoucherDetails(json: JSONDictionary) {
        
        switch self.voucher {
        case .lockAmount:
            self.iconImage = #imageLiteral(resourceName: "ic_acc_lockAmount")
            if let details = json["detail"] as? JSONDictionary, let partyName = details["party_name"] {
                self.title = "\(partyName)"
            }
            
        case .receipt:
            if let details = json["detail"] as? JSONDictionary, let info = details["info"] as? JSONDictionary {
                self._receiptMethod = (info["method"] as? String) ?? ""
                switch self.receiptMethod {
                case .netbanking:
                    self.iconImage = #imageLiteral(resourceName: "ic_acc_receipt")
                    let bankName = (info["bank_name"] as? String) ?? ""
                    self.title = self._receiptMethod.isEmpty ? bankName : "\(self._receiptMethod.capitalizedFirst()): \(bankName)"
                    
                case .upi:
                    self.iconImage = #imageLiteral(resourceName: "ic_acc_receipt")
                    let upi_id = (info["upi_id"] as? String) ?? ""
                    self.title = self._receiptMethod.isEmpty ? upi_id : "\(self._receiptMethod.uppercased()): \(upi_id)"
                    
                case .card:
                    self.iconImage = #imageLiteral(resourceName: "ic_acc_card")
                    let cardType = (info["card_type"] as? String) ?? ""
                    self.title = cardType.isEmpty ? self._receiptMethod : "\(cardType.capitalizedFirst()) \(self._receiptMethod.capitalizedFirst())"
                    
                    let cardNum = (info["card_number"] as? String) ?? "XXXX"
                    self.creditCardNo = "XXXX - XXXX - XXXX - \(cardNum)"
                    
                case .none:
                    printDebug("No need for other voucher types")
                @unknown default:
                    printDebug("No need for other voucher types")
                }
            }
            
        case .debitNote:
            self.iconImage = #imageLiteral(resourceName: "ic_acc_debitNote")
            if let details = json["detail"] as? JSONDictionary, let partyName = details["party_name"] {
                self.title = "\(partyName)"
            }
            
        case .creditNote:
            self.iconImage = #imageLiteral(resourceName: "ic_acc_creditNote")
            if let details = json["detail"] as? JSONDictionary, let partyName = details["party_name"] {
                self.title = "\(partyName)"
            }
            
        case .sales:
            if let details = json["detail"] as? JSONDictionary {
                if let obj = details["product_type"] {
                    self._productType = "\(obj)"
                }
                
                switch self.productType {
                case .hotel:
                    self.parseForHotelSales(details: details)
                    
                case .flight:
                    self.parseForFlightSales(details: details)
                    
                case .addOns:
                    self.parseForAddOnsSales(details: details)
                    
                case .none:
                    printDebug("No need for other voucher types")
                @unknown default:
                    printDebug("No need for other voucher types")
                }
            }

        case .journal:
            //To-Do: need to find the types of the journal and then handel them same as sales
            self.title = self.voucher.rawValue //temp work
            
        case .none:
            printDebug("No need for other voucher types")
        @unknown default:
            printDebug("No need for other voucher types")
        }
    }
    
    private mutating func parseForAddOnsSales(details: JSONDictionary) {
        
        self.iconImage = #imageLiteral(resourceName: "ic_acc_addOns")
        self.title = "Add-ons"
        
    }
    private mutating func parseForFlightSales(details: JSONDictionary) {
        
        self.iconImage = #imageLiteral(resourceName: "ic_acc_flight")
        
        //booking date
        if let obj = details["booking_date"] {
            //"2019-05-16 00:00:00",
            self.voucherDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        //booking id
        if let obj = details["booking_number"] {
            self.bookingId = "\(obj)"
        }
        
        //title
        self.title = ""
        if let journey = details["journey"] as? [[String]] {
            for obj in journey {
                self.title += ( (self.title.isEmpty ? "" : " → ") + obj.joined(separator: " → "))
            }
        }
        
        if let rows = details["rows"] as? [JSONDictionary], !rows.isEmpty {
            if let first = rows.first {
                if let obj = first["travel_date"] {
                    //travelDate : "2019-05-20"
                    self.travelDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
                }
                
                if let obj = first["al"] {
                    //airline
                    self.airline = "\(obj)"
                }
                
                if let obj = first["sector"] as? [String] {
                    //sector
                    self.sector = obj.joined(separator: " → ")
                }
            }
            
            for row in rows {
                if let pnrs = row["pnrs"] as? [JSONDictionary], !pnrs.isEmpty {
                    if let first = rows.first {
                        if let obj = first["pnr"] {
                            //pnr
                            self.pnr = "\(obj)"
                        }
                        
                        if let obj = first["ticket_no"] {
                            //ticketNo
                            self.ticketNo = "\(obj)"
                        }
                    }
                    
                    //names for paxs
                    for pnr in pnrs {
                        if let paxs = pnr[""] as? [JSONDictionary], !paxs.isEmpty {
                            for pax in paxs {
                                let salt = (pax["salutation"] as? String) ?? ""
                                let name = (pax["name"] as? String) ?? ""
                                
                                let final = salt.isEmpty ? name : "\(salt) \(name)"
                                self.names.append(final)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private mutating func parseForHotelSales(details: JSONDictionary) {
        
        self.iconImage = #imageLiteral(resourceName: "ic_acc_hotels")
        
        //parse title as hotelName, hotelAdd
        var tStr = ""
        if let hotelName = details["hotel_name"] as? String, !hotelName.isEmpty {
            tStr = hotelName
        }
        if let hotelAddress = details["hotel_address"] as? String, !hotelAddress.isEmpty {
            tStr = tStr.isEmpty ? hotelAddress : "\(tStr), \(hotelAddress)"
        }
        self.title = tStr
        
        //check-in
        if let obj = details["check_in"] {
            //"2019-05-16 00:00:00",
            self.checkIn = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        //check-out
        if let obj = details["check_out"] {
            //"2019-05-16 00:00:00",
            self.checkOut = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        if let rows = details["rows"] as? [JSONDictionary], !rows.isEmpty {
            if let first = rows.first {
                
                //room
                if let obj = first["room_name"] {
                    self.room = "\(obj)"
                }
                
                //inclusion
                if let obj = first["inclusions"] as? [String] {
                    self.inclusion = obj.joined(separator: ", ")
                }
                
                //confirmation id
                self.confirmationId = "--"
                
                //guest names
                for room in rows {
                    if let guests = room["guests"] as? [JSONDictionary], !rows.isEmpty {
                        
                        for guest in guests {
                            let salt = (guest["salutation"] as? String) ?? ""
                            let name = (guest["name"] as? String) ?? ""
                            
                            let final = salt.isEmpty ? name : "\(salt) \(name)"
                            self.names.append(final)
                        }
                    }
                }
            }
        }
        
        
        //booking date
        if let obj = details["booking_date"] {
            //"2019-05-16 00:00:00",
            self.date = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        //booking id
        if let obj = details["booking_number"] {
            self.bookingId = "\(obj)"
        }
    }
    
    static func modelsDict(data: [JSONDictionary]) -> (data: JSONDictionary, allVoucher: [String]) {
        var temp = JSONDictionary()
        var vchrType: [String] = []
        
        for dict in data {
            let obj = AccountDetailEvent(json: dict)
            if let cDate = obj.creationDateStr, !cDate.isEmpty {
                if var allOld = temp[cDate] as? [AccountDetailEvent] {
                    allOld.append(obj)
                    temp[cDate] = allOld
                }
                else {
                    temp[cDate] = [obj]
                }
                if !vchrType.contains(obj.voucher.rawValue) {
                    vchrType.append(obj.voucher.rawValue)
                }
            }
        }
        
        return (temp, vchrType)
    }
}
