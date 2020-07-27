//
//  FlightPaymentBookingStatusVC + Cells.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
//import FBSDKShareKit

extension FlightPaymentBookingStatusVC{
    
    func getAllDoneCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: YouAreAllDoneTableViewCell.reusableIdentifier, for: indexPath) as? YouAreAllDoneTableViewCell else { return UITableViewCell() }
        
        cell.configCell(forBookingId: self.viewModel.itinerary.bookingNumber, forCid: LocalizedString.na.localized, isBookingPending: (self.viewModel.itinerary.bookingStatus.status.lowercased() != "booked"))
        cell.delegate = self

        return cell
    }
    
    func getEventSharedCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: EventAdddedTripTableViewCell.reusableIdentifier, for: indexPath) as? EventAdddedTripTableViewCell else { return UITableViewCell() }
        
        cell.configCell(tripName: self.viewModel.itinerary.tripDetails.name)
        cell.changeBtnHandler = {[weak self] in
            guard let self = self else {return}
            AppFlowManager.default.selectTrip(self.viewModel.itinerary.tripDetails, tripType: .bookingTripChange) { [weak self] (tripModel, tripDetail) in
                guard let self = self else {return}
                printDebug(tripDetail)
                if let detail = tripDetail {
                    self.viewModel.itinerary.tripDetails = detail
                    self.statusTableView.reloadData()
                }
            }
        }
        return cell
    }
    
    func getCarriarTableCell(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: FlightCarriersTableViewCell.reusableIdentifier) as? FlightCarriersTableViewCell else {return UITableViewCell()}
        cell.configureCellWith(self.viewModel.itinerary.details.legsWithDetail[indexPath.section - 1], airLineDetail: self.viewModel.itinerary.details.aldet ?? [:])
        return cell
    }
    
    func getLegInfoCell(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: FlightBoardingAndDestinationTableViewCell.reusableIdentifier) as? FlightBoardingAndDestinationTableViewCell else {return UITableViewCell()}
        cell.configureCellWith(leg: self.viewModel.itinerary.details.legsWithDetail[indexPath.section - 1], airport: self.viewModel.itinerary.details.apdet ?? [:])
        return cell
    }
    
    func getTravellerStatusHeader(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier) as? BookingPaymentDetailsTableViewCell else {return UITableViewCell()}
        cell.titleTopConstraint.constant = 12.0
        cell.titleBottomConstraint.constant = 8.0
        
        cell.configCell(title: self.viewModel.itinerary.travellerDetails.t.count > 1 ? LocalizedString.Travellers.localized : LocalizedString.Traveller.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, isFirstCell: false, price: "PNR/Status", isLastCell: false, cellHeight: 38.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getTravellerCell(_ indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: TravellersPnrStatusTableViewCell.reusableIdentifier) as? TravellersPnrStatusTableViewCell else {return UITableViewCell()}
        let count = self.viewModel.itinerary.travellerDetails.t.count
        let traveller = self.viewModel.itinerary.travellerDetails.t[indexPath.row - 3]
        let pnr = self.viewModel.getPnrWith(indexPath)
        cell.configCell(travellersImage: traveller.profileImg, travellerName: "\(traveller.firstName) \(traveller.lastName)", travellerPnrStatus: pnr, firstName: (traveller.firstName), lastName: (traveller.lastName), isLastTraveller: (indexPath.row == (count + 2)),paxType: traveller.paxType, dob: traveller.dob, salutation: traveller.salutation)
        cell.clipsToBounds = true
        return cell
    }
    
    
    /* TotalCharge Section Cells */
    func getTotalChargeCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: HCTotalChargeTableViewCell.reusableIdentifier, for: indexPath) as? HCTotalChargeTableViewCell else { return UITableViewCell() }
        cell.dividerView.isHidden = self.viewModel.sectionData[indexPath.section].contains(.confirmationVoucherCell) ? false : true
        cell.configCell(mode: self.viewModel.itinerary.paymentDetails.mode, totalCharge: (self.viewModel.itinerary.paymentDetails.info?.payment_amount ?? 0.0).amountInDelimeterWithSymbol)
        return cell
    }
    
    func getConfirmationVoucherHealderCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: HCConfirmationVoucherTableViewCell.reusableIdentifier, for: indexPath) as? HCConfirmationVoucherTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 16.0
        cell.titleLabelBottomContraint.constant = 8.0
        cell.confirmationVoucherLabel.text = "View E-tickets"
        cell.viewButton.isHidden = true
        return cell
    }
    
     func getConfirmationVoucherCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: HCConfirmationVoucherTableViewCell.reusableIdentifier, for: indexPath) as? HCConfirmationVoucherTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 8.0
        cell.viewButton.isHidden = false
        let source = self.viewModel.itinerary.details.legsWithDetail[indexPath.row - 2].originIATACode
        let destination = self.viewModel.itinerary.details.legsWithDetail[indexPath.row - 2].destinationIATACode
        if (indexPath.row - 1)  == self.viewModel.itinerary.details.legsWithDetail.count{
            cell.titleLabelBottomContraint.constant = 16.0
        }else{
            cell.titleLabelBottomContraint.constant = 8.0
        }
        cell.viewButton.addTarget(self, action: #selector(tapViewTicketViewButton), for: .touchUpInside)
        cell.viewButton.tag = indexPath.row - 2
        cell.confirmationVoucherLabel.text = "\(source) - \(destination)"
        cell.configCell()
        return cell
    }
    
    internal func getWhatNextCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: HCWhatNextTableViewCell.reusableIdentifier, for: indexPath) as? HCWhatNextTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let whtNextNew = self.viewModel.itinerary.whatNext.map { whtNext -> String in
            if whtNext.productType == .flight{
                return "Book your return flight for\n\(whtNext.origin) to \(whtNext.destination)"
            }else if whtNext.productType == .hotel{
                return "Book your hotel in\n\(whtNext.city) & get the best deals!"
            }else{
                return "Book your hotel in\n\(whtNext.city) & get the best deals!"
            }
        }
        cell.suggetionImage = #imageLiteral(resourceName: "hotel_green_icon")
        if !whtNextNew.isEmpty {
            cell.configCell(whatNextString: whtNextNew)
            cell.whatNextStackView.isHidden = false
        } else {
            cell.whatNextStackView.isHidden = true
        }
        cell.selectedWhatNext = {[weak self] index in
            self?.tapOnSeletedWhatNext(index: index)
        }
        cell.whatNextCollectionView.reloadData()
        return cell
    }
    
    @objc func tapViewTicketViewButton(_ sender: UIButton){
        
        let index = sender.tag
        if self.viewModel.apiBookingIds.count > index{
            let id = self.viewModel.apiBookingIds[index]
            AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/booking-action?type=pdf&booking_id=\(id)&doc=voucher", screenTitle: "Booking Ticket")
        }else{
            let id = self.viewModel.apiBookingIds.first ?? ""
            AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/booking-action?type=pdf&booking_id=\(id)&doc=voucher", screenTitle: "Booking Ticket")
        }
    }
    
    private func tapOnSeletedWhatNext(index: Int){
        switch self.viewModel.itinerary.whatNext[index].productType{
        case .flight: self.bookFlightFor(self.viewModel.itinerary.whatNext[index])
        case .hotel: self.bookAnotherRoom(self.viewModel.itinerary.whatNext[index])
        default: break;
        }
    }
    
    
    func bookAnotherRoom(_ whatNext: WhatNext) {
        
        if let checkIn = whatNext.checkin.toDate(dateFormat: "E, dd MMM yy")?.toString(dateFormat: "yyyy-MM-dd"), let checkOut = whatNext.checkout.toDate(dateFormat: "E, dd MMM yy")?.toString(dateFormat: "yyyy-MM-dd"){
            var hotelData = HotelFormPreviosSearchData()
            hotelData.cityName = whatNext.city
            hotelData.adultsCount = whatNext.rooms.map{$0.adult}
            hotelData.childrenCounts = whatNext.rooms.map{$0.child}
            hotelData.destId = whatNext.destID
            hotelData.destType = whatNext.destType
            hotelData.destName = whatNext.destName
            hotelData.roomNumber =  whatNext.rooms.count
            hotelData.checkInDate = checkIn
            hotelData.checkOutDate = checkOut
            var splittedStringArray = whatNext.destName.components(separatedBy: ",")
            splittedStringArray.removeFirst()
            let stateName = splittedStringArray.joined(separator: ",")
            hotelData.stateName = stateName
            HotelsSearchVM.hotelFormData = hotelData
            AppFlowManager.default.goToDashboard(toBeSelect: .hotels)
        }
    }
    
    func bookFlightFor(_ whatNext:WhatNext){
        FlightWhatNextData.shared.isSettingForWhatNext = true
        FlightWhatNextData.shared.whatNext = whatNext
        AppFlowManager.default.goToDashboard(toBeSelect: .flight)
        
    }
    
}


extension FlightPaymentBookingStatusVC : HCWhatNextTableViewCellDelegate{
    func shareOnInstagram() {
        
    }
    
    func shareOnFaceBook() {
        printDebug("Share On FaceBook")
    }
    
    func shareOnTwitter() {
        printDebug("Share On Twitter")
        let tweetText = "\(AppConstants.kAppName) Appstore Link: "
        let tweetUrl = AppConstants.kAppStoreLink
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        if let url = URL(string: escapedShareString) {
            if UIApplication.shared.canOpenURL(url ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                AppFlowManager.default.showURLOnATWebView(url, screenTitle:  "")
            }
        }
    }

    
    func shareOnLinkdIn() {
        
    }
}

extension FlightPaymentBookingStatusVC : YouAreAllDoneTableViewCellDelegate{
    
    func addToAppleWalletTapped() {
        
    }
    
    func addToCallendarTapped() {
        
        for legs in self.viewModel.itinerary.details.legsWithDetail{
            guard let start = "\(legs.dd) \(legs.dt)".toDate(dateFormat: "yyyy-MM-dd HH:MM"),
                let end = "\(legs.ad) \(legs.at)".toDate(dateFormat: "yyyy-MM-dd HH:MM") else {
                    return
            }
            let bid = self.viewModel.itinerary.bookingNumber
            let title = "Flight: \(legs.originIATACode) → \(legs.destinationIATACode)"
            let location = self.viewModel.itinerary.details.apdet?[legs.originIATACode]?.c ?? ""
            let bookingId = "Booking Id: \(self.viewModel.itinerary.bookingNumber)"
            let notes = bookingId //+ "\n \(confirmationCode)"
            AppGlobals.shared.addEventToCalender(title: title, startDate: start, endDate: end, location: location,  notes: notes, uniqueId: bid)
        }
    }
}


extension FlightPaymentBookingStatusVC : HCBookingDetailsTableViewHeaderFooterViewDelegate{
    
    func emailIternaryButtonTapped(){
        let obj = HCEmailItinerariesVC.instantiate(fromAppStoryboard: .HotelCheckout)
        obj.viewModel.isForFlight = true
        obj.viewModel.bookingId = self.viewModel.apiBookingIds.first ?? ""
        obj.viewModel.flightTraveller = self.viewModel.itinerary.travellerDetails.t
        self.present(obj, animated: true, completion: nil)
    }
    
}