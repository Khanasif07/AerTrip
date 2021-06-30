//
//  HotelBookingDetailsVC+TableCells.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension HotlelBookingsDetailsVC {
    func getNotesCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelInfoAddressCell.reusableIdentifier, for: indexPath) as? HotelInfoAddressCell else { return UITableViewCell() }
        cell.configureNotesCell(notes: self.viewModel.bookingDetail?.bookingDetail?.note ?? "", isHiddenDivider: (self.viewModel.bookingDetail?.cases ?? []).isEmpty)
        cell.containerViewBottomConstraint.constant = (self.viewModel.bookingDetail?.cases.isEmpty ?? true) ? 14 : 0
        cell.addressLblTopConst.constant = 16+3.5
        cell.clipsToBounds = true
        return cell
    }
    
    func getRequestsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingsRequestTitleTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingsRequestTitleTableViewCell else { return UITableViewCell() }
        if let note = self.viewModel.bookingDetail?.bookingDetail?.note, !note.isEmpty {
            cell.requestLabelTopConstraint.constant = 22+3.5
        }
        cell.clipsToBounds = true
        return cell
    }
    
    func getCancellationsRequestCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightBookingRequestsTableViewCell.reusableIdentifier, for: indexPath) as? FlightBookingRequestsTableViewCell else { return UITableViewCell() }
        let noOfCellAboveRequest = 2
        cell.configureCell(requestName: self.viewModel.bookingDetail?.cases[indexPath.row - (noOfCellAboveRequest - 1)].caseType ?? "", actionStatus: self.viewModel.bookingDetail?.cases[indexPath.row - (noOfCellAboveRequest - 1)].resolutionStatus ?? ResolutionStatus.aborted, isFirstCell: noOfCellAboveRequest - 1 == indexPath.row, isLastCell: indexPath.row == self.viewModel.bookingDetail?.cases.count, isStatusExpired: false)
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
    
    func getHotelBookingAddressDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelBookingAddressDetailsTableViewCell.reusableIdentifier, for: indexPath) as? HotelBookingAddressDetailsTableViewCell else { return UITableViewCell() }
        
        let booking = self.viewModel.bookingDetail?.bookingDetail
        cell.configCell(hotelName: booking?.hotelName ?? LocalizedString.na.localized, hotelAddress: booking?.hotelAddress ?? LocalizedString.na.localized, hotelStarRating: booking?.hotelStarRating ?? 0.0, tripAdvisorRating: booking?.taRating ?? 0.0, checkInDate: booking?.checkIn, checkOutDate: booking?.checkOut, totalNights: booking?.nights ?? 0)
        cell.clipsToBounds = true
        return cell
    }
    
    func getTitleWithSubTitleCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        
        let roomD = self.viewModel.bookingDetail?.bookingDetail?.roomDetails[indexPath.section - self.viewModel.noOfCellAboveHotelDetail]
        
        let above = self.viewModel.noOfCellAboveHotelDetail - 1
        let title =  ((self.viewModel.bookingDetail?.bookingDetail?.roomDetails.count ?? 1) > 1) ?  "\(LocalizedString.Room.localized) \(indexPath.section - above)" : LocalizedString.Room.localized
        cell.configHotelBookingDetailsCell(title: title, subTitle: roomD?.roomType ?? LocalizedString.na.localized)
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        return cell
    }
    
    func getTravellersDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellersDetailsTableViewCell.reusableIdentifier, for: indexPath) as? TravellersDetailsTableViewCell else { return UITableViewCell() }
        
        let currentRoomSection = indexPath.section - self.viewModel.noOfCellAboveHotelDetail
        let currentGuestIndex = indexPath.row - 1
        
        let allRooms = self.viewModel.bookingDetail?.bookingDetail?.roomDetails ?? []
        let allGuest = allRooms[currentRoomSection].guest
        
        let isLastRoom = (allRooms.count - 1) == currentRoomSection
        let isLastTarv = (allGuest.count - 1) == currentGuestIndex
        let guest = allGuest[currentGuestIndex]
        cell.configCell(travellersImage: guest.profileImage, travellerName: guest.name, firstName: guest.firstName, lastName: guest.lastname, isLastTravellerInRoom: isLastTarv, isLastTraveller: isLastRoom && isLastTarv, dob: guest.dob, salutation: guest.salutation, age: guest.age, congigureForHotelDetail: true)
        
        cell.clipsToBounds = true
        return cell
    }
    
    func getBookingDocumentsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDocumentsTableViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsTableViewCell else { return UITableViewCell() }
        cell.topdividerView.isHidden = false
        cell.delegate = self
        cell.documentsData = self.viewModel.bookingDetail?.documents ?? []
        cell.currentDocumentType = .hotels
        cell.clipsToBounds = true
        return cell
    }
    
    func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoTableViewCell.reusableIdentifier, for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell() }
        cell.paymentInfoLabel.text = LocalizedString.Vouchers.localized
        if (self.viewModel.bookingDetail?.documents ?? []).count != 0{
            cell.paymentInfoTopConstraint.constant = 26
        }else{
            cell.paymentInfoTopConstraint.constant = 10//5
        }
        cell.changeShadow()
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewBottomConstraint.constant = 0.0
        let amount = self.viewModel.bookingDetail?.bookingPrice ?? 0
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: false)
        
//        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(self.viewModel.bookingDetail?.bookingPrice ?? 0)", isLastCell: false)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        var isCellLast = (self.viewModel.bookingDetail?.totalOutStanding == 0)
        if self.viewModel.bookingDetail?.refundAmount ?? 0.0 != 0.0 {
            isCellLast = false
        }
        
//        let amount = (self.viewModel.bookingDetail?.paid ?? 0)
//        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
//        
//        cell.configCellForAmount(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: isCellLast)
        
        var transactionAmount = 0.0
        let count = self.viewModel.bookingDetail?.receipt?.voucher.count ?? 0
        for i in 0..<count{
            let basic = self.viewModel.bookingDetail?.receipt?.voucher[i].basic

            if basic?.type.lowercased() == "receipt"{
                transactionAmount = self.viewModel.bookingDetail?.receipt?.voucher[i].transactions.first?.amount ?? 0.0
            }
        }
        let attAmount = self.getConvertedPrice(for: transactionAmount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: transactionAmount, isLastCell: isCellLast)

        cell.containerViewBottomConstraint.constant = (isCellLast) ? 21.0 : 0.0
        cell.clipsToBounds = isCellLast
        cell.dividerView.isHidden = false
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
//    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
//        cell.titleTopConstraint.constant = 11.0
//        cell.titleBottomConstraint.constant = 5.0
//        cell.containerViewBottomConstraint.constant = 0.0
//        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.bookingPrice.delimiterWithSymbol, isLastCell: false, cellHeight: 36.0)
//        cell.clipsToBounds = true
//        return cell
//    }
    
    func getAddOnsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 5.0
        cell.containerViewBottomConstraint.constant = 0.0
        
        let amount = self.viewModel.bookingDetail?.addOnAmount ?? 0
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.AddOns.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: false, cellHeight: 30.0)
        
//
//        cell.configCell(title: LocalizedString.AddOns.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(self.viewModel.bookingDetail?.addOnAmount ?? 0)", isLastCell: false, cellHeight: 30.0)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getCancellationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 12.0
        cell.containerViewBottomConstraint.constant = 0.0
        
        let amount = self.viewModel.bookingDetail?.cancellationAmount ?? 0
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Cancellation.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: false, cellHeight: 37.0)
        
        
//        cell.configCell(title: LocalizedString.Cancellation.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(self.viewModel.bookingDetail?.cancellationAmount ?? 0)", isLastCell: false, cellHeight: 37.0)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getReschedulingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 12.0
        cell.containerViewBottomConstraint.constant = 0.0
        
        let amount = self.viewModel.bookingDetail?.rescheduleAmount ?? 0
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Rescheduling.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: false, cellHeight: 37.0)
        
        
//        cell.configCell(title: LocalizedString.Cancellation.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(self.viewModel.bookingDetail?.cancellationAmount ?? 0)", isLastCell: false, cellHeight: 37.0)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
//    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
//        cell.titleTopConstraint.constant = 12.0
//        cell.titleBottomConstraint.constant = 5.0
//        cell.containerViewBottomConstraint.constant = 26
//        cell.configCell(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: self.viewModel.bookingDetail?.paid.delimiterWithSymbol, isLastCell: true, cellHeight: 37.0)
//        cell.dividerView.isHidden = false
//        cell.clipsToBounds = true
//        return cell
//    }
    
    func getRefundCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        let amount = self.viewModel.bookingDetail?.refundAmount ?? 0.0
        let outstading = self.viewModel.bookingDetail?.totalOutStanding ?? 0
        let isCellLast = (amount != 0 && outstading == 0)
        cell.titleTopConstraint.constant = 5.0
        cell.titleBottomConstraint.constant = 13.0
        cell.containerViewBottomConstraint.constant = 0.0
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Refund.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: isCellLast, cellHeight: 38.0)
        
//        cell.configCell(title: LocalizedString.Refund.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(self.viewModel.bookingDetail?.refundAmount ?? 0)", isLastCell: isCellLast, cellHeight: 38.0)
        
        cell.containerViewBottomConstraint.constant = (isCellLast) ? 21.0 : 0.0
        cell.clipsToBounds = isCellLast
        cell.dividerView.isHidden = false
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getPaymentPendingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentPendingTableViewCell.reusableIdentifier, for: indexPath) as? PaymentPendingTableViewCell else { return UITableViewCell() }
        
        let price = self.viewModel.bookingDetail?.totalOutStanding ?? 0.0
        let attPrice = self.getConvertedPrice(for: price, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.SemiBold.withSize(20.0), isForCancellation: false)
            
        cell.configCurrencyChange(price: price, attPrice: attPrice)
        
//        cell.configCell(price: self.viewModel.bookingDetail?.totalOutStanding ?? 0.0)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getFlightsOptionsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightsOptionsTableViewCell.reusableIdentifier, for: indexPath) as? FlightsOptionsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.additionalInformation = self.viewModel.bookingDetail?.additionalInformation
        let optionImages: [UIImage] = [AppImages.bookingsDirections, AppImages.bookingsCall, AppImages.bookingsCalendar, AppImages.shareBooking, AppImages.bookingsHotel]
        let optionNames: [String] = [LocalizedString.Directions.localized, LocalizedString.Call.localized, LocalizedString.AddToCalender.localized, LocalizedString.Share.localized, LocalizedString.BookAnotherRoom.localized]
//        if self.viewModel.bookingDetail?.tripInfo == nil {
//            optionImages.append(#imageLiteral(resourceName: "addToTrips"))
//            optionNames.append(LocalizedString.AddToTrips.localized)
//        }
        cell.optionImages = optionImages
        cell.optionNames = optionNames
        cell.usingFor = .hotel
        cell.configureCell()
        cell.clipsToBounds = true
        return cell
    }
    
    func getAddToCalenderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .addToCalender
        cell.configureCell(buttonImage: AppImages.greenCalenderIcon, buttonTitle: LocalizedString.AddToCalender.localized)
        return cell
    }
    
    func getBookAnotherRoomCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .bookSameFlight
        cell.configureCell(buttonImage: AppImages.BookAnotherRoom, buttonTitle: LocalizedString.BookAnotherRoom.localized)
        return cell
    }
    
    func getAddToWalletCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingCommonActionTableViewCell.reusableIdentifier, for: indexPath) as? BookingCommonActionTableViewCell else { return UITableViewCell() }
        cell.usingFor = .addToAppleWallet
        cell.configureCell(buttonImage: AppImages.AddToAppleWallet, buttonTitle: LocalizedString.AddToAppleWallet.localized)
        cell.actionButton.isLoading = self.viewModel.showWaletLoader
        cell.backgroundViewTopConstraint.constant = 16
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
        tripChangeCell.hideBottomSpace = self.viewModel.bookingDetail?.tripWeatherData.isEmpty ?? true

        return tripChangeCell
    }
    
    func getWeatherHeaderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHeaderTableViewCell.reusableIdentifier, for: indexPath) as? WeatherHeaderTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        cell.seeAllBtnOutlet.isHidden = self.viewModel.isSeeAllWeatherButtonTapped || self.viewModel.bookingDetail?.tripWeatherData.count ?? 0 <= 5
        cell.delegate = self
        return cell
    }
    
    func getWeatherInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTableViewCell.reusableIdentifier, for: indexPath) as? WeatherInfoTableViewCell else { return UITableViewCell() }
        
        // For getting maximum label widths and setting - start
        cell.cityAndDateLblWidth.constant = viewModel.weatherLabelWidths.dateLblWidth
        cell.tempLblWidth.constant = viewModel.weatherLabelWidths.curTempLblWidth
        cell.weatherIconLbl.isHidden = !viewModel.weatherLabelWidths.showWeatherIcons
        cell.weatherLblWidth.constant = viewModel.weatherLabelWidths.highLowLblWidth
        // For getting maximum label widths and setting - end
        
        cell.usingFor = .hotel
        if self.viewModel.isSeeAllWeatherButtonTapped || (self.viewModel.bookingDetail?.tripWeatherData.count ?? 0) < 5  {
            cell.isLastCell = (self.viewModel.bookingDetail?.weatherDisplayedWithin16Info ?? false ) ? false : indexPath.row == ((self.viewModel.bookingDetail?.tripWeatherData.count ?? 0))
        } else {
            cell.isLastCell = (self.viewModel.bookingDetail?.weatherDisplayedWithin16Info ?? false ) ? false : (indexPath.row == 5)
        }
        cell.weatherData = self.viewModel.bookingDetail?.tripWeatherData[indexPath.row - 1]
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
        cell.dividerView.isHidden = self.viewModel.bookingDetail?.tripWeatherData.isEmpty ?? true
        cell.configCell(title: "Billing Name", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.billingName ?? LocalizedString.na.localized, subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.dividerViewLeadingConstraint.constant = 0.0
        cell.dividerViewTrailingConstraint.constant = 0.0
        cell.clipsToBounds = true
        return cell
    }
    
    func getEmailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Email", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.email ?? LocalizedString.na.localized, subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.clipsToBounds = true
         cell.dividerView.isHidden = true
        return cell
    }
    
    func getMobileCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        if let contactNumber = self.viewModel.bookingDetail?.billingInfo?.communicationNumber {
            cell.configCell(title: "Mobile", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: contactNumber.prefix(9) + " " + contactNumber.suffix(5) , subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        } else {
            let contactNumber = LocalizedString.na.localized
            cell.configCell(title: "Mobile", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: contactNumber, subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        }
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.clipsToBounds = true
        cell.dividerView.isHidden = true
        return cell
    }
    
    func getGstCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "GSTIN", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.gst ?? LocalizedString.na.localized, subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.clipsToBounds = true
        cell.dividerView.isHidden = true
        return cell
    }
    
    func getBillingAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 18.0
        cell.configCell(title: "Billing Address", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.address?.completeAddress ?? LocalizedString.na.localized, subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.clipsToBounds = true
        cell.dividerView.isHidden = true
        return cell
    }
}

