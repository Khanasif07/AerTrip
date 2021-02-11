//
//  AccountDetailEvent.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum VoucherType: String {
    case none
    
    //with-out subtypes
    case receipt = "Receipt"
    case lockAmount = "Lock Amount"
    case debitNote = "Debit Note"
    case creditNote = "Credit Note"
    case payment = "Payment"
    
    //these have sub types
    case sales = "Sales"
    case journal = "Journal"
    
}

enum VoucherReceiptMethod: String {
    case none
    case netbanking = "netbanking"
    case card = "card"
    case upi = "upi"
    case offline = "offline"
    case wallet = "wallet"
}

enum VoucherProductType: String {
    case none
    case hotel = "hotel"
    case flight = "flight"
    case addOns = "addOns"
}

struct AccountDetailEvent {
    
    var id : String = ""
    var title : String = ""
    var attributedString:NSAttributedString?
    
    var _creationDate: Date?
    var creationDateStr: String? {
        return _creationDate?.toString(dateFormat: "YYYY-MM-dd")
    }
    
    private var _voucher : String = ""
    var voucher: VoucherType {
        get {
            return VoucherType(rawValue: self._voucher) ?? VoucherType.none
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
    var receiptMethod: VoucherReceiptMethod {
        get {
            return VoucherReceiptMethod(rawValue: self._receiptMethod) ?? VoucherReceiptMethod.none
        }
        
        set {
            self._receiptMethod = newValue.rawValue
        }
    }
    
    private var _productType : String = ""
    var productType: VoucherProductType {
        get {
            return VoucherProductType(rawValue: self._productType) ?? VoucherProductType.none
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
    var roomNamesArray = [String]()
    var inclusion: String = ""
    var confirmationId: String = ""
    var names: [AccountUser] = []
    
    var bookingId: String = ""
    var bookingNumber:String = ""
    
    var creditCardNo: String = ""
    
    //flight details related
    var billNumber: String = ""
    var totalAmount: Double = 0.0
    var pendingAmount: Double = 0.0
    var dueDate: Date?
    var overDueDays: Int = 0
    
    //description
    var description:String?
    
    var voucherDate: Date?
    
    var travelDate: Date?
    var airline: String = ""
    var sector: String = ""
    var pnr: String = ""
    var ticketNo: String = ""
    var hotelAddress = ""
    var flightNumber = ""
    var countryCode = ""

    //Added for ofline receipts:--
    var chequeNumber = ""
    var chequeDate = ""
    var offlineAccountName = ""
    var offlineBankName = ""
    var depositDate = ""
    var utrNumner = ""
    
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
            if amt != 0{
                self.balance = amt * -1
            }else{
                self.balance = 0
            }
        }
        
        if let obj = json["transaction_datetime"] {
            //"2019-04-08 16:17:28"
            self._creationDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
            
            if self._creationDate == nil {
                self._creationDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd")
            }
            
            self.date = self._creationDate
        }
        
        
        
        
        
        if let obj = json["voucher_number"] {
            self.voucherNo = "\(obj)"
        }
        
        if let obj = json["voucher"] {
            self._voucher = "\(obj)"
            self.fetchVoucherDetails(json: json)
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
//        printDebug(self.voucher.rawValue)
        switch self.voucher {
        case .lockAmount:
            self.iconImage = #imageLiteral(resourceName: "ic_acc_lockAmount")
            if let details = json["detail"] as? JSONDictionary, let partyName = details["party_name"] {
                self.title = "\(partyName)"
            }
            
        case .receipt:
            if let details = json["detail"] as? JSONDictionary, let info = details["info"] as? JSONDictionary {
                if !((info["method"] as? String) ?? "").isEmpty{
                    self._receiptMethod = (info["method"] as? String) ?? ""
                }else if !((info["type"] as? String) ?? "").isEmpty{
                    self._receiptMethod = (info["type"] as? String) ?? ""
                }
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
                    
                case .offline:
                    self.iconImage = #imageLiteral(resourceName: "ic_acc_receipt")
                    if (info["draft_cheque_number"] != nil) || (info["draft_cheque_date"] != nil) {
                        self.title = "Cheque / Demand Draft"
                        self.chequeNumber = info["draft_cheque_number"] as? String ?? ""
                        self.chequeDate = info["draft_cheque_date"] as? String ?? ""
                        self.offlineBankName = info["bank_name"] as? String ?? ""
                        self.offlineAccountName = info["account_name"] as? String ?? ""
                    }else if info["utr_number"] != nil{
                        self.title = "Fund Transfer"
                        self.utrNumner = info["utr_number"] as? String ?? ""
                        self.depositDate = info["deposit_date"] as? String ?? ""
                        self.offlineBankName = info["bank_name"] as? String ?? ""
                        self.offlineAccountName = info["account_name"] as? String ?? ""
                    }else{
                        self.title = "Cash deposit in Bank"
                    }
                    if let mode = details["mode"] as? String, let value = ADEventFilterVM.shared.paymentMethodArray[mode], !JSON(value).stringValue.isEmpty{
                        self.title = JSON(value).stringValue
                    }
//                    let bankName = (info["bank_name"] as? String) ?? ""
//                    self.title = self._receiptMethod.isEmpty ? bankName : "\(self._receiptMethod.capitalizedFirst()): \(bankName)"
                case .wallet:
                    self.iconImage = #imageLiteral(resourceName: "ic_acc_receipt")
//                    let walletName = (info["wallet_name"] as? String) ?? ""
                    let walletName :String
                    if let wName = (info["pg_wallet_alias"] as? String){
                        walletName = wName
                    }else{
                        walletName = (info["wallet_name"] as? String) ?? ""
                    }
                    if walletName.isEmpty{
                        self.title = "Wallet"
                    }else{
                        self.title = "Wallet: \(walletName)"
                    }
                    
                case .none:
                    printDebug("No need for other voucher types")
//                @unknown default:
//                    printDebug("No need for other voucher types")
                }
            }
            
        case .payment:
            if let details = json["detail"] as? JSONDictionary, let info = details["info"] as? JSONDictionary {
                self._receiptMethod = (info["method"] as? String) ?? ""
                self.iconImage = #imageLiteral(resourceName: "ic_acc_receipt")
                let bankName = (info["payment_method_value"] as? String) ?? ""
                self.title = self._receiptMethod.isEmpty ? bankName : "\(self._receiptMethod.capitalizedFirst()): \(bankName)"
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
            //self.title = "sales Test"
            if let details = json["detail"] as? JSONDictionary {
//                printDebug(json)
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
                    self.parseForOtherSales(details: details)
                @unknown default:
                    printDebug("No need for other voucher types")
                }
                
                if self.title.isEmpty, let partyName = details["party_name"] {
                    self.title = "\(partyName)"
                }
            }
            
        case .journal:
            //To-Do: need to find the types of the journal and then handel them same as sales
            //self.title = self.voucher.rawValue //temp work
            
            if let details = json["detail"] as? JSONDictionary {
//                printDebug(json)
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
//                    printDebug("No need for other voucher types")
                    self.parseForOtherSales(details: details)
//                @unknown default:
//                    printDebug("No need for other voucher types")
                }
                
                if self.title.isEmpty, let partyName = details["party_name"] {
                    self.title = "\(partyName)"
                }
            }
            
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
        if let obj = details["booking_id"] {
            self.bookingId = "\(obj)"
        }
        if let obj = details["booking_number"] {
            self.bookingNumber = "\(obj)"
        }
        
        //title
        self.title = ""
        if let journey = details["journey"] as? [[String]] {
            for obj in journey {
                self.title += ( (self.title.isEmpty ? "" : ", ") + obj.joined(separator: " → "))
            }
        }
        self.getAttributedText()
        if self.voucherNo.lowercased().contains("srjv") {
            self.title = "\(LocalizedString.CancellationFor.localized)\n\(self.title)"
            self.attributedString = self.setAttributedName(title: self.title, coloredText: LocalizedString.CancellationFor.localized, color: AppColors.themeRed)
            self.iconImage = #imageLiteral(resourceName: "flightCancellation")
        } else if self.voucherNo.lowercased().contains("rsrjv") {
            self.title = "\(LocalizedString.ReschedulingFor.localized)\n\(self.title)"
            self.attributedString = self.setAttributedName(title: self.title, coloredText: LocalizedString.ReschedulingFor.localized, color: AppColors.themeYellow)
            self.iconImage = #imageLiteral(resourceName: "ic_acc_flightReScheduling")
        }else if self.voucherNo.lowercased().contains("sa/") {
            self.title = "Add-ons"
            self.attributedString = nil
            self.iconImage = #imageLiteral(resourceName: "ic_acc_addOns")
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
            self.flightNumber = ""
            
            for row in rows {
                if let num = row["flight_no"] as? String{
                    self.flightNumber += (self.flightNumber.isEmpty) ? num : ",\(num)"
                }
                if let pnrs = row["pnrs"] as? [JSONDictionary], !pnrs.isEmpty {
                    if let first = pnrs.first {
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
                        if let paxs = pnr["pax"] as? [JSONDictionary], !paxs.isEmpty {
                            self.names = AccountUser.retunsAccountUserArray(jsonArr: paxs)
                            /*
                             for pax in paxs {
                             let salt = (pax["salutation"] as? String) ?? ""
                             let name = (pax["name"] as? String) ?? ""
                             
                             let final = salt.isEmpty ? name : "\(salt) \(name)"
                             self.names.append(final)
                             } */
                        }
                    }
                }
            }
        }
    }
    
    
    private  func setAttributedName( title: String, coloredText: String, color: UIColor) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : AppColors.themeBlack])
        let range = NSString(string: title).range(of: coloredText)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: range)
        return attributedString
        
    }
    
    private mutating func parseForOtherSales(details: JSONDictionary) {
        
        self.iconImage = (!(self._productType.lowercased() == "other")) ?  #imageLiteral(resourceName: "ic_acc_journalVoucher") :  #imageLiteral(resourceName: "others_hotels")
        
        //booking date
        if let obj = details["booking_date"] {
            //"2019-05-16 00:00:00",
            self.voucherDate = "\(obj)".toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
        }
        
        //booking id
        if let obj = details["booking_id"] {
            self.bookingId = "\(obj)"
        }
        if let obj = details["booking_number"] {
            self.bookingNumber = "\(obj)"
        }
        
        //title
        self.title = details["party_name"] as? String ?? ""
        
        if let rows = details["rows"] as? [JSONDictionary], !rows.isEmpty {
            self.names.append(contentsOf: AccountUser.retunsAccountUserArray(jsonArr: rows))
        }
        if let des = details["service_detail"] as? String, ((self._productType.lowercased() == "other")){
            self.title = des
        }
        self.description = details["service_detail"] as? String
    }

    
    private mutating func getAttributedText(){
        
        let ttls = self.title.components(separatedBy: " → ")
        guard ttls.count > 1 else {return}
        let attributedString = NSMutableAttributedString(string: "")
        for (index, element) in ttls.enumerated(){
            let text = NSAttributedString(string: element, attributes: [.font:AppFonts.Regular.withSize(18), .foregroundColor: AppColors.themeBlack])
            attributedString.append(text)
            if index != (ttls.count - 1){
                attributedString.append(AppGlobals.shared.getStringFromImage(name : "oneway"))
            }
            
        }
        self.attributedString = attributedString
        
    }
    
    private mutating func parseForHotelSales(details: JSONDictionary) {
        
        self.iconImage = #imageLiteral(resourceName: "ic_acc_hotels")
        
        //parse title as hotelName, hotelAdd
        var tStr = ""
        if let hotelName = details["hotel_name"] as? String, !hotelName.isEmpty {
            tStr = hotelName
        }
        if let hotelAddress = details["hotel_address"] as? String, !hotelAddress.isEmpty {
//            tStr = tStr.isEmpty ? hotelAddress : "\(tStr), \(hotelAddress)"
            self.hotelAddress = hotelAddress
        }
        
        if let countryCode = details["hotel_country_code"] as? String, !hotelAddress.isEmpty {
            tStr = tStr.isEmpty ? countryCode : "\(tStr), \(countryCode)"
            self.countryCode = countryCode
        }
        self.title = tStr
        
        if self.voucherNo.lowercased().contains("srjv") {
            self.title = "\(LocalizedString.CancellationFor.localized)\n\(tStr)"
            self.iconImage = #imageLiteral(resourceName: "ic_acc_hotelCancellation")
        } else if self.voucherNo.lowercased().contains("rsrjv") {
            self.title = "\(LocalizedString.ReschedulingFor.localized)\n\(tStr)"
        }else if self.voucherNo.lowercased().contains("sa/") {
            self.title = "Add-ons"
            self.iconImage = #imageLiteral(resourceName: "ic_acc_addOns")
        }
        
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
                self.roomNamesArray = rows.map({$0["room_name"] as? String ?? ""})
                
                //inclusion
                if let obj = first["inclusions"] as? [String] {
                    self.inclusion = obj.joined(separator: ", ")
                }
                
                //confirmation id
                self.confirmationId = ""//LocalizedString.dash.localized
                if let obj = first["voucher_id"] {
                    self.confirmationId = "\(obj)"
                }
                
                //guest names
                self.names = []
                for room in rows {
                    if let guests = room["guests"] as? [JSONDictionary], !rows.isEmpty {
                        self.names.append(contentsOf: AccountUser.retunsAccountUserArray(jsonArr: guests))
                        /*
                         for guest in guests {
                         let salt = (guest["salutation"] as? String) ?? ""
                         let name = (guest["name"] as? String) ?? ""
                         let final = salt.isEmpty ? name : "\(salt) \(name)"
                         names.append(final)
                         } */
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
        if let obj = details["booking_id"] {
            self.bookingId = "\(obj)"
        }
        if let obj = details["booking_number"] {
            self.bookingNumber = "\(obj)"
        }
    }
    
    static func modelsDict(data: [JSONDictionary]) -> (data: JSONDictionary, allVoucher: [String]) {
        
        var vchrType: [String] = []
        
        let temp = data.reduce(into: [String:[AccountDetailEvent]]()) {
            let obj = AccountDetailEvent(json: $1)
            if !vchrType.contains(obj.voucher.rawValue) {
                vchrType.append(obj.voucher.rawValue)
            }
            $0[obj.creationDateStr ?? "", default: [AccountDetailEvent]()].append(obj)
        }
        vchrType.sort()
        return (temp, vchrType)
        
        //        var temp = JSONDictionary()
        //        var vchrType: [String] = []
        //
        //        for dict in data {
        //            let obj = AccountDetailEvent(json: dict)
        //            if let cDate = obj.creationDateStr, !cDate.isEmpty {
        //                if var allOld = temp[cDate] as? [AccountDetailEvent] {
        //                    allOld.append(obj)
        //                    temp[cDate] = allOld
        //                }
        //                else {
        //                    temp[cDate] = [obj]
        //                }
        //                if !vchrType.contains(obj.voucher.rawValue) {
        //                    vchrType.append(obj.voucher.rawValue)
        //                }
        //            }
        //        }
        //
        //        return (temp, vchrType)
    }
}

struct AccountUser {
    
    var paxType: String = ""
    var paxId: String = ""
    var salutation: String = ""
    var name: String = ""
    var age: String = ""
    var dob: String = ""
    
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["pax_type"] {
            self.paxType = "\(obj)".removeNull
        }
        
        if let obj = json["pax_id"] {
            self.paxId = "\(obj)".removeNull
        }
        
        if let obj = json["salutation"] {
            self.salutation = "\(obj)".removeNull
        }
        
        if let obj = json["name"] {
            self.name = "\(obj)".removeNull
        }
        
        if let obj = json["age"] {
            self.age = "\(obj)".removeNull
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)".removeNull
        }
        
    }
    
    static func retunsAccountUserArray(jsonArr: [JSONDictionary]) -> [AccountUser] {
        var traveller = [AccountUser]()
        for element in jsonArr {
            traveller.append(AccountUser(json: element))
        }
        return traveller
    }
    
    
}
