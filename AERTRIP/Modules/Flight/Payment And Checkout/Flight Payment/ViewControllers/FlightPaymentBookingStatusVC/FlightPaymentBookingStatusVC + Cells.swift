//
//  FlightPaymentBookingStatusVC + Cells.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension FlightPaymentBookingStatusVC{
    
    func getCellsForTtavellerSection(_ indexPath:IndexPath)-> UITableViewCell{
        switch indexPath.row{
        case 0:
            guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: FlightCarriersTableViewCell.reusableIdentifier) as? FlightCarriersTableViewCell else {return UITableViewCell()}
            cell.configureCellWith(self.viewModel.itinerary.details.legsWithDetail[indexPath.section], airLineDetail: self.viewModel.itinerary.details.aldet ?? [:])
            return cell
        case 1:
            guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: FlightBoardingAndDestinationTableViewCell.reusableIdentifier) as? FlightBoardingAndDestinationTableViewCell else {return UITableViewCell()}
            cell.configureCellWith(leg: self.viewModel.itinerary.details.legsWithDetail[indexPath.section], airport: self.viewModel.itinerary.details.apdet ?? [:])
            return cell
        case 2:
            guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier) as? BookingPaymentDetailsTableViewCell else {return UITableViewCell()}
            cell.titleTopConstraint.constant = 12.0
            cell.titleBottomConstraint.constant = 8.0
            let paxCount = 4//need to set according Passenger
            cell.configCell(title: paxCount > 1 ? LocalizedString.Travellers.localized : LocalizedString.Traveller.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, isFirstCell: false, price: "PNR/Status", isLastCell: false, cellHeight: 38.0)
            cell.clipsToBounds = true
            return cell
        default:
            guard let cell = self.statusTableView.dequeueReusableCell(withIdentifier: TravellersPnrStatusTableViewCell.reusableIdentifier) as? TravellersPnrStatusTableViewCell else {return UITableViewCell()}
            cell.configCell(travellersImage: "", travellerName: "Test User", travellerPnrStatus:"43543", firstName: "Test", lastName: "User", isLastTraveller: (indexPath.row == 6),paxType: "adult", dob: "1995-01-01", salutation: "Mr")
            cell.clipsToBounds = true
            return cell
        }
    }
    
}
