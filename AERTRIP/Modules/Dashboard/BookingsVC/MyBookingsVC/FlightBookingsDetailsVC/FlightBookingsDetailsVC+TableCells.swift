//
//  FlightBookingsDetailsVC+TableCells.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension FlightBookingsDetailsVC {
    func getNotesCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelInfoAddressCell.reusableIdentifier, for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
        cell.configureNotesCell(notes: self.viewModel.bookingDetail?.bookingDetail?.note ?? "")
        cell.clipsToBounds = true
        return cell
    }
    
    func getRequestsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingsRequestTitleTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingsRequestTitleTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        return cell
    }
    
    func getCancellationsRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        let noOfCellAboveRequest = 2
        let noOfCases = self.viewModel.bookingDetail?.cases.count ?? 1
        cell.configureCell(requestName: self.viewModel.bookingDetail?.cases[indexPath.row - (noOfCellAboveRequest - 1)].caseType ?? "", actionStatus: self.viewModel.bookingDetail?.cases[indexPath.row - (noOfCellAboveRequest - 1)].resolutionStatus ?? ResolutionStatus.aborted, isFirstCell: noOfCellAboveRequest - 1 == indexPath.row, isLastCell: indexPath.row == noOfCases, isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddOnRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        cell.configureCell(requestName: "Add-On Request", actionStatus: ResolutionStatus.inProgress, actionStatusColor: AppColors.themeRed, isFirstCell: false, isLastCell: false, isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }
    
    func getReschedulingRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        cell.configureCell(requestName: "Rescheduling Request", actionStatus: ResolutionStatus.inProgress, actionStatusColor: AppColors.themeGreen, isFirstCell: false, isLastCell: indexPath.row == 3, isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightCarriersCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightCarriersTableViewCell.reusableIdentifier, for: indexPath) as? FlightCarriersTableViewCell else { return UITableViewCell() }
//        let count = (self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false) ? 0 : 1
        let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section - self.viewModel.noOfLegCellAboveLeg]
//        var tempCarrier : [String] = []
//        if let carrier = leg?.carriers {
//            tempCarrier.append(contentsOf: carrier)
//            tempCarrier.append(contentsOf: carrier)
//             tempCarrier.append(contentsOf: carrier)
//              tempCarrier.append(contentsOf: carrier)
//        }
//
//          var carrierCodes : [String] = []
//        if let carrierCode = leg?.carrierCodes {
//            carrierCodes.append(contentsOf: carrierCode)
//            carrierCodes.append(contentsOf: carrierCode)
//            carrierCodes.append(contentsOf: carrierCode)
//            carrierCodes.append(contentsOf: carrierCode)
//        }
//        var flightNumbers: [String] = []
//
//
//
//        if let flightnumber = leg?.flightNumbers {
//            flightNumbers.append(contentsOf: flightnumber)
//            flightNumbers.append(contentsOf: flightnumber)
//            flightNumbers.append(contentsOf: flightnumber)
//           flightNumbers.append(contentsOf: flightnumber)
//        }
//
        cell.configCell(carriers: leg?.carriers ?? [], carrierCode: leg?.carrierCodes ?? [], flightNumbers: leg?.flightNumbers ?? [])
        // cell.configCell(carriers: tempCarrier, carrierCode: carrierCodes, flightNumbers: flightNumbers)
        
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightBoardingAndDestinationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBoardingAndDestinationTableViewCell.reusableIdentifier, for: indexPath) as? FlightBoardingAndDestinationTableViewCell else { return UITableViewCell() }
//        let count = (self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false) ? 0 : 1
        
        let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section - self.viewModel.noOfLegCellAboveLeg]
        cell.configCell(boardingCity: leg?.flight.last?.departCity ?? "", destinationCity: leg?.flight.last?.departCity ?? "", boardingCode: leg?.flight.first?.departure ?? "", destinationCode: leg?.flight.last?.departure ?? "", legDuration: leg?.legDuration.asString(units: [.hour, .minute], style: .abbreviated) ?? LocalizedString.na.localized, boardingTime: leg?.flight.first?.departureTime ?? "", destinationTime: leg?.flight.last?.departureTime ?? "", boardingDate: leg?.flight.first?.departDate?.toString(dateFormat: "E, d MMM yyyy") ?? "", destinationDate: leg?.flight.last?.departDate?.toString(dateFormat: "E, d MMM yyyy") ?? "", economyClass: leg?.cabinClass ?? "-")
        
        cell.noOfStops = leg?.numberOfStop ?? 0
        cell.clipsToBounds = true
        return cell
    }
    
    func getTravellersPnrStatusTitleCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 12.0
        cell.titleBottomConstraint.constant = 8.0
        cell.configCell(title: "Travellers", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, isFirstCell: false, price: "PNR/Status", isLastCell: false, cellHeight: 38.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getTravellersPnrStatusCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellersPnrStatusTableViewCell.reusableIdentifier, for: indexPath) as? TravellersPnrStatusTableViewCell else { return UITableViewCell() }
        //   let count = (self.viewModel.bookingDetail?.bookingDetail?.note.isEmpty ?? false) ? 0 : 1
        let leg = self.viewModel.bookingDetail?.bookingDetail?.leg[indexPath.section - self.viewModel.noOfLegCellAboveLeg]
        let traveller = leg?.pax[indexPath.row - 3]
        if traveller?.status.lowercased() == "booked" {
            cell.pnrStatus = .active
        } else if traveller?.status.lowercased() == "cancelled" {
            cell.pnrStatus = .cancelled
        } else if traveller?.status.lowercased() == "rescheduled" {
            cell.pnrStatus = .rescheduled
        } else if traveller?.status.lowercased() == "pending" {
            cell.pnrStatus = .pending
        }
        cell.configCell(travellersImage: "", travellerName: traveller?.paxName ?? "", travellerPnrStatus: traveller?.status == "booked" ? traveller?.pnr ?? "" : traveller?.status.capitalizedFirst() ?? "", firstName: traveller?.firstName ?? "", lastName: traveller?.lastName ?? "", isLastTraveller: indexPath.row - 2 == leg?.pax.count)
        cell.clipsToBounds = true
        return cell
    }
    
    func getBookingDocumentsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDocumentsTableViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsTableViewCell else { return UITableViewCell() }
        cell.topdividerView.isHidden = false
        cell.delegate = self
        cell.documentsData = self.viewModel.bookingDetail?.documents ?? []
        cell.currentDocumentType = .flights
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoTableViewCell.reusableIdentifier, for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        return cell
    }
    
    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 11.0
        cell.titleBottomConstraint.constant = 5.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.bookingPrice.delimiterWithSymbol, isLastCell: false, cellHeight: 36.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddOnsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 5.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.AddOns.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.addOnAmount.delimiterWithSymbol, isLastCell: false, cellHeight: 30.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getCancellationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 12.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Cancellation.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.cancellationAmount.delimiterWithSymbol, isLastCell: false, cellHeight: 37.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 12.0
        cell.titleBottomConstraint.constant = 5.0
        cell.configCell(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.paid.delimiterWithSymbol, isLastCell: self.viewModel.bookingDetail?.totalOutStanding == 0.0 ? true : false, cellHeight: 37.0)
        cell.dividerView.isHidden = false
        cell.clipsToBounds = true
        return cell
    }
    
    func getRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 13.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Refund.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.refundAmount.delimiterWithSymbol, isLastCell: false, cellHeight: 38.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaymentPendingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentPendingTableViewCell.reusableIdentifier, for: indexPath) as? PaymentPendingTableViewCell else { return UITableViewCell() }
        
        cell.configCell(price: self.viewModel.bookingDetail?.totalOutStanding ?? 0.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightsOptionsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightsOptionsTableViewCell.reusableIdentifier, for: indexPath) as? FlightsOptionsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.webCheckinUrl = self.viewModel.bookingDetail?.webCheckinUrl ?? ""
        cell.additionalInformation = self.viewModel.bookingDetail?.additionalInformation
        cell.configureCell()
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddToCalenderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .addToCalender
        cell.configureCell(buttonImage: #imageLiteral(resourceName: "greenCalenderIcon"), buttonTitle: LocalizedString.AddToCalender.localized)
        return cell
    }
    
    func getAddToTripsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .addToTrips
        cell.configureCell(buttonImage: #imageLiteral(resourceName: "greenAddToTripIcon"), buttonTitle: LocalizedString.AddToTrips.localized)
        return cell
    }
    
    func getBookSameFlightCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .bookSameFlight
        cell.configureCell(buttonImage: #imageLiteral(resourceName: "greenFlightIcon"), buttonTitle: LocalizedString.BookSameFlight.localized)
        return cell
    }
    
    func getAddToWalletCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .addToAppleWallet
        cell.configureCell(buttonImage: #imageLiteral(resourceName: "AddToAppleWallet"), buttonTitle: LocalizedString.AddToAppleWallet.localized)
        return cell
    }
    
    func getTripChangeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let tripChangeCell = tableView.dequeueReusableCell(withIdentifier: TripChangeTableViewCell.reusableIdentifier, for: indexPath) as? TripChangeTableViewCell else {
            return UITableViewCell()
        }
        if let _ = self.tripChangeIndexPath, updatedTripDetail != nil {
            tripChangeCell.configureCell(tripName: self.updatedTripDetail?.name ?? "")
        } else {
            tripChangeCell.configureCell(tripName: self.viewModel.bookingDetail?.tripInfo?.name ?? "")
        }
        
        return tripChangeCell
    }
    
    func getWeatherHeaderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHeaderTableViewCell.reusableIdentifier, for: indexPath) as? WeatherHeaderTableViewCell else { return UITableViewCell() }
        cell.seeAllBtnOutlet.isHidden = self.viewModel.bookingDetail?.tripWeatherData.count ?? 0 < 6
        cell.clipsToBounds = true
        cell.delegate = self
        return cell
    }
    
    func getWeatherInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.reusableIdentifier, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
        cell.usingFor = .flight
        cell.weatherData = self.viewModel.bookingDetail?.tripWeatherData[indexPath.row - 1]
        
        cell.isLastCell = indexPath.row == (self.viewModel.bookingDetail?.tripWeatherData.count ?? 0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getWeatherFooterCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFooterTableViewCell.reusableIdentifier, for: indexPath) as? WeatherFooterTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        return cell
    }
    
    func getNameCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 18.0
        cell.dividerView.isHidden = false
        cell.configCell(title: LocalizedString.BillingName.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.billingName ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getEmailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.Email.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.email ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getMobileCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.Mobile.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.communicationNumber ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getGstCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.GSTIN.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.gst.isEmpty ?? false ? LocalizedString.dash.localized : self.viewModel.bookingDetail?.billingInfo?.gst ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.clipsToBounds = true
        return cell
    }
    
    func getBillingAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 18.0
        cell.configCell(title: LocalizedString.BillingAddress.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.address?.completeAddress ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.clipsToBounds = true
        return cell
    }
}
