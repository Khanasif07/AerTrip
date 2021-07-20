//
//  OtherBookingdDetailsVC+TableCells.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension OtherBookingsDetailsVC {
    func getInsurenceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: self.viewModel.bookingDetail?.bookingDetail?.title ?? "", subTitle: self.viewModel.bookingDetail?.bookingDetail?.otherPrductDetailStatus ?? "")
        cell.titleLabelTopConstraint.constant = 15.0
        cell.titleLabelBottomConstraint.constant = 0.0
        cell.dividerViewLeadingConstraint.constant = 16.0
        cell.dividerViewTrailingConstraint.constant = 16.0
        cell.dividerView.isHidden = false
        cell.containerView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getPolicyDetailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 0.0
        cell.configCell(title: self.viewModel.bookingDetail?.bookingDetail?.details ?? "", titleFont: AppFonts.SemiBold.withSize(16.0), titleColor: AppColors.themeBlack, subTitle: "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.dividerView.isHidden = true
        cell.containerView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getTravellersDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingTravellersDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingTravellersDetailsTableViewCell else { return UITableViewCell() }
            let traveller = self.viewModel.bookingDetail?.bookingDetail?.travellers[indexPath.row]
            
            if self.viewModel.bookingDetail?.bookingDetail?.travellers.count ?? 0 > 1{
                cell.travellersLabel.text = LocalizedString.Travellers.rawValue
            }else{
                cell.travellersLabel.text = LocalizedString.Traveller.rawValue
            }

            cell.configCell(travellersImage: traveller?.profileImage ?? "" , travellerName: traveller?.paxName ?? "", firstName: traveller?.firstName ?? "", lastName: traveller?.lastName ?? "", dob: traveller?.dob ?? "", salutation: traveller?.salutation ?? "")
            cell.travellerImageViewBottomConstraint.constant = 0
            // cell divider will not be use here as divider is in document Cell.
            cell.containerView.backgroundColor = AppColors.themeWhite
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellersDetailsTableViewCell.reusableIdentifier, for: indexPath) as? TravellersDetailsTableViewCell else { return UITableViewCell() }
             let traveller = self.viewModel.bookingDetail?.bookingDetail?.travellers[indexPath.row]

            
            cell.configCell(travellersImage: traveller?.profileImage ?? "", travellerName: traveller?.paxName ?? "", firstName: traveller?.firstName ?? "", lastName: traveller?.lastName ?? "", isLastTravellerInRoom: false, isLastTraveller: indexPath.row == self.viewModel.bookingDetail?.bookingDetail?.travellers.count ?? 0,isOtherBookingData: true, dob: traveller?.dob ?? "", salutation: traveller?.salutation ?? "", age: traveller?.age ?? "", congigureForHotelDetail: false)
            cell.dividerView.backgroundColor = .red
          // cell divider will not be use here as divider is in document Cell.
            cell.containerViewLeadingConstraint.constant = 0
            cell.containerViewBottomConstraint.constant = 0
            cell.containerViewTrailingConstraint.constant = 0
            cell.containerView.backgroundColor = AppColors.themeWhite
            return cell
        }
    }
    
    func getBookingDocumentsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDocumentsTableViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
//        cell.documentsData = self.viewModel.documentDownloadingData
        cell.documentsData = self.viewModel.bookingDetail?.documents ?? []
        cell.currentDocumentType = .others
        return cell
    }
    
    // get Payment Cell
    func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoTableViewCell.reusableIdentifier, for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell() }
        cell.clipsToBounds = true
        return cell
    }
    
    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewBottomConstraint.constant = 0.0
        
        var amount = 0.0
        if let totalTran = self.viewModel.bookingDetail?.receipt?.voucher.first?.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
            amount = totalTran.amount
        }
        
        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: false)
        
//        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: "\(amount)", isLastCell: false)
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewBottomConstraint.constant = 26.0
        
//        let amount = (self.viewModel.bookingDetail?.totalAmountPaid ?? 0)
//
//        let attAmount = self.getConvertedPrice(for: amount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
//
//        cell.configCellForAmount(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: amount, isLastCell: true)
        

        var transactionAmount = 0.0
        let count = self.viewModel.bookingDetail?.receipt?.voucher.count ?? 0
        for i in 0..<count{
            let basic = self.viewModel.bookingDetail?.receipt?.voucher[i].basic

            if basic?.type.lowercased() == "receipt"{
                transactionAmount = self.viewModel.bookingDetail?.receipt?.voucher[i].transactions.first?.amount ?? 0.0
            }
        }
        
        let attAmount = self.getConvertedPrice(for: transactionAmount, with: self.viewModel.bookingDetail?.bookingCurrencyRate, using: AppFonts.Regular.withSize(16.0), isForCancellation: false)
        
        cell.configCellForAmount(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0), titleColor: AppColors.themeBlack, isFirstCell: false, price: attAmount, priceInRupee: transactionAmount, isLastCell: true)
        
 
        cell.clipsToBounds = true
        cell.contentView.backgroundColor = AppColors.themeBlack26
        return cell
    }
    
    func getNameCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 18.0
        cell.configCell(title: LocalizedString.BillingName.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.billingName ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.dividerViewLeadingConstraint.constant = 0.0
        cell.dividerViewTrailingConstraint.constant = 0.0
        return cell
    }
    
    func getEmailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.Email.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.email ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.titleLabelBottomConstraint.constant = 2.0
        return cell
    }
    
    func getMobileCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.Mobile.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.communicationNumber ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        return cell
    }
    
    func getGstCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: LocalizedString.GSTIN.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.gst ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        return cell
    }
    
    func getBillingAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.configCell(title: LocalizedString.BillingAddress.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: self.viewModel.bookingDetail?.billingInfo?.address?.completeAddress ?? "", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.dividerView.isHidden = true
        cell.clipsToBounds = true
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        return cell
    }
}
