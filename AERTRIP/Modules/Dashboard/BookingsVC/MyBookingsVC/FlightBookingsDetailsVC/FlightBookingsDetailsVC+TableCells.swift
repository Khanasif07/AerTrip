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
        cell.configureNotesCell(notes: "A massive collection of core components and over 60 (x2) selected screens found in the public release of iOS 11 made over 60 (x2)")
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
        cell.configureCell(requestName: "Cancellations Request", actionStatus: "In Progress", actionStatusColor: AppColors.themeYellow, isFirstCell: true, isLastCell: false, isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddOnRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        cell.configureCell(requestName: "Add-On Request", actionStatus: "In Progress", actionStatusColor: AppColors.themeRed, isFirstCell: false, isLastCell: false, isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }

    func getReschedulingRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        cell.configureCell(requestName: "Rescheduling Request", actionStatus: "In Progress", actionStatusColor: AppColors.themeGreen, isFirstCell: false, isLastCell: (indexPath.row == 3), isStatusExpired: false)
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightCarriersCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightCarriersTableViewCell.reusableIdentifier, for: indexPath) as? FlightCarriersTableViewCell else { return UITableViewCell() }
        cell.configCell(totalNumberOfCarriers: 4, flightNo: "W888", flightName: "Jet Airways")
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightBoardingAndDestinationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBoardingAndDestinationTableViewCell.reusableIdentifier, for: indexPath) as? FlightBoardingAndDestinationTableViewCell else { return UITableViewCell() }
        cell.configCell(boarding: "Mumbai", destination: "Bangkok", boardingCode: "BOM", destinationCode: "BKK", totalTime: "24h 20m", boardingTime: "06:05", destinationTime: "06:05", boardingDate: "Sat, 26 Jan 2018", destinationDate: "Sat, 26 Jan 2018")
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
        cell.configCell(travellersImage: "https://lh6.googleusercontent.com/-oXpHDt3qMTY/AAAAAAAAAAI/AAAAAAAAAAA/ACevoQNgVkoVZ-CLi_hSD8oP8oA-6WnytA/s200/photo.jpg", travellerName: "Rajan Singh", travellerPnrStatus: "FW737K", isLastTraveller: (indexPath.row == 6))
        cell.clipsToBounds = true
        return cell
    }
    
    func getBookingDocumentsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDocumentsTableViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsTableViewCell else { return UITableViewCell() }
        cell.topdividerView.isHidden = false
        cell.delegate = self
        cell.documentsData = self.viewModel.documentDownloadingData
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
        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "₹ 10,000", isLastCell: false, cellHeight: 36.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddOnsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 5.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.AddOns.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "₹ 5,000", isLastCell: false, cellHeight: 30.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getCancellationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 12.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Cancellation.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "- ₹ 2,000", isLastCell: false, cellHeight: 37.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 12.0
        cell.titleBottomConstraint.constant = 5.0
        cell.configCell(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "₹ 4,000", isLastCell: false, cellHeight: 37.0)
        cell.dividerView.isHidden = false
        cell.clipsToBounds = true
        return cell
    }
    
    func getRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 13.0
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Refund.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "- ₹ 4,000", isLastCell: false, cellHeight: 38.0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaymentPendingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentPendingTableViewCell.reusableIdentifier, for: indexPath) as? PaymentPendingTableViewCell else { return UITableViewCell() }
        cell.configCell(price: " ₹ 5,000")
        cell.clipsToBounds = true
        return cell
    }
    
    func getFlightsOptionsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightsOptionsTableViewCell.reusableIdentifier, for: indexPath) as? FlightsOptionsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell()
        cell.clipsToBounds = true
        return cell
    }
    
    func getWeatherHeaderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHeaderTableViewCell.reusableIdentifier, for: indexPath) as? WeatherHeaderTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        cell.delegate = self
        return cell
    }
    
    func getWeatherInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.reusableIdentifier, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
        cell.configureCell(cityName: self.viewModel.cityName[indexPath.row], date: "23 Jun", temp: "15", upTemp: "8", downTemp: "10", isLastCell: indexPath.row == self.viewModel.cityName.count-1)
        cell.clipsToBounds = true
        return cell
    }
    
    func getNameCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 18.0
        cell.dividerView.isHidden = false
        cell.configCell(title: "Billing Name", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "Rosa Luettgen", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getEmailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Email", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "rosa.luettgen@gmail.com", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getMobileCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Mobile", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "+91 12345 67890", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getGstCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "GSTIN", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "-", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
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
        cell.configCell(title: "Billing Address", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "21/22, Y.A Chunawala Industrial Estate, Kondivita Lane, Andheri East, Mumbai - 400059, Maharashtra, IN", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.clipsToBounds = true
        return cell
    }

}
