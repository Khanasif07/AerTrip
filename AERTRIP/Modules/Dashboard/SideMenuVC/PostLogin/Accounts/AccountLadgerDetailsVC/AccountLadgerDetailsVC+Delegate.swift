//
//  AccountLadgerDetailsVC+Delegate.swift
//  AERTRIP
//
//  Created by Admin on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension AccountLadgerDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionArray.count + 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section > 0 else {
            //first section's first cell
            return 1
        }
        if section == self.viewModel.sectionArray.count + 1{
            return ((self.viewModel.ladgerEvent?.bookingId.isEmpty ?? false) && (self.viewModel.ladgerEvent?.transactionId.isEmpty ?? false)) ? 1: 3
        }
        return self.viewModel.sectionArray[section - 1].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getCellHeight(with: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section > 0 else {
            //first section's first cell
            let cell = UITableViewCell()
            cell.backgroundColor = AppColors.themeWhite
            return cell
        }
        
        
        if indexPath.section == self.viewModel.sectionArray.count + 1{
            
            switch indexPath.row {
            case 0,2:
                guard let emptyCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                    fatalError("EmptyTableViewCell not found")
                }
                emptyCell.clipsToBounds = true
                emptyCell.backgroundColor = AppColors.themeGray04
                emptyCell.contentView.backgroundColor = AppColors.themeGray04
                emptyCell.bottomDividerView.isHidden = true//(indexPath.row == 2)
                emptyCell.topDividerView.isHidden = (indexPath.row == 2)
                emptyCell.topDividerTopConstraint.constant = 0.0
                return emptyCell
            case 1:
                guard let downloadInvoiceCell = self.tableView.dequeueReusableCell(withIdentifier: "DownloadInvoiceTableViewCell") as? DownloadInvoiceTableViewCell else {
                    fatalError("DownloadInvoiceTableViewCell not found")
                }

                if self.viewModel.ladgerEvent?.voucher == .sales  {
                    downloadInvoiceCell.titleLabel.text = LocalizedString.DownloadInvoice.localized
                } else if self.viewModel.ladgerEvent?.voucher == .receipt {
                    downloadInvoiceCell.titleLabel.text = LocalizedString.DownloadReceipt.localized
                } else {
                    downloadInvoiceCell.titleLabel.text = LocalizedString.DownloadVoucher.localized
                }
                downloadInvoiceCell.showLoader = self.viewModel.isDownloadingRecipt
                return downloadInvoiceCell
            default: return UITableViewCell()
            }
            
        } else {
            let section = indexPath.section - 1
            let model = self.viewModel.sectionArray[section][indexPath.row]
            if model.isEmptyCell {
                //devider
                return self.getDeviderCell(indexPath: indexPath)
            } else {
                let key = model.title
                var value = model.value
                var descColor: UIColor? = nil
                let age = model.age
                if key.lowercased() == "Over Due by days".lowercased() {
                    descColor = AppColors.themeRed
                }
                value = value.isEmpty ? LocalizedString.dash.localized : value
                return self.getDetailCell(title: key, description: value, descriptionColor: descColor, age: age, at: indexPath)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == self.viewModel.sectionArray.count + 1) && (indexPath.row == 1){
          

            FirebaseEventLogs.shared.logAccountsEventsWithAccountType(with: .AccountsLedgerDetailsDownloadReciptSelected, AccountType: UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a")

            if let type = self.viewModel.ladgerEvent?.productType{
                switch type{
                case .hotel, .flight:
                    if let bID = self.viewModel.ladgerEvent?.bookingId, !bID.isEmpty {
                        self.viewModel.isDownloadingRecipt = true
                        if let cell = self.tableView.cellForRow(at: indexPath) as? DownloadInvoiceTableViewCell{
                            cell.showLoader = true
                        }
                        AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/booking-action?booking_id=\(bID)&doc=invoice&type=pdf", screenTitle: "Booking Invoice", showLoader: false, complition: { [weak self] (status) in
                            self?.viewModel.isDownloadingRecipt = false
                            self?.tableView.reloadRow(at: indexPath, with: .automatic)
                        })
                    }
                    
                default:
                    if let bID = self.viewModel.ladgerEvent?.transactionId, !bID.isEmpty {
                        self.viewModel.isDownloadingRecipt = true
                        if let cell = self.tableView.cellForRow(at: indexPath) as? DownloadInvoiceTableViewCell{
                            cell.showLoader = true
                        }
                        AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Receipt Voucher", showLoader: false, complition: { [weak self] (status) in
                            
                            self?.viewModel.isDownloadingRecipt = false
                            self?.tableView.reloadRow(at: indexPath, with: .automatic)
                        })
                    }
                }
            }else if let event = self.viewModel.onAccountEvent{
                
                let bID = event.transactionId
                if !bID.isEmpty{
                    self.viewModel.isDownloadingRecipt = true
                    if let cell = self.tableView.cellForRow(at: indexPath) as? DownloadInvoiceTableViewCell{
                        cell.showLoader = true
                    }
                    AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Receipt Voucher", showLoader: false, complition: { [weak self] (status) in
                        
                        self?.viewModel.isDownloadingRecipt = false
                        self?.tableView.reloadRow(at: indexPath, with: .automatic)
                    })
                }
                
                
            }
        }
        
    }
    
    func getDeviderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDividerell.reusableIdentifier) as? AccountLadgerDividerell else {
            return UITableViewCell()
        }
        let value:CGFloat = (self.numberOfSections(in: self.tableView) - 1 ) == indexPath.section ? 0 : 16
        cell.dividerLeadingConstraint.constant = value
        cell.dividerTrailingConstraint.constant = value
        
//        if indexPath.section == self.viewModel.ladgerDetails.count{
        cell.dividerView.isHidden = (indexPath.section == self.viewModel.sectionArray.count)
//        }
        return cell
    }
    
    func getDetailCell(title: String, description: String, descriptionColor: UIColor? = nil, age: String, at indexPath:IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDetailCell.reusableIdentifier) as? AccountLadgerDetailCell else {
            return UITableViewCell()
        }
        cell.descLabel.numberOfLines = 1
        cell.titleLabel.contentMode = .center
        if title == "Balance" || title == "Amount" || title == "Total Amount"  || title == "Pending Amount"{
            var desc = description
            var suffix: NSMutableAttributedString?
            if desc.contains(LocalizedString.DebitShort.localized) {
                desc = desc.replacingLastOccurrenceOfString(" \(LocalizedString.DebitShort.localized)", with: "")
                suffix = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
            }
            if desc.contains(LocalizedString.CreditShort.localized) {
                desc = desc.replacingLastOccurrenceOfString(" \(LocalizedString.CreditShort.localized)", with: "")
                suffix = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
            }
            let val = desc.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
            if let mutableString = suffix {
                val.append(mutableString)
            }
//            printDebug("\(title)...\(val.string)....\(suffix)....\(desc)")
            cell.configureCellWithAttributedText(title: title, description: val)
        }else{
            if title == "Room" || title == " " || title == "Guests" || title == "Passengers"{
                cell.descLabel.numberOfLines = 0
                cell.titleLabel.contentMode = .top
//                cell.descLabel.textAlignment = .right
            }
            cell.configure(title: title, description: description, age: age)
        }
        
        //Sector Attributed text For return and single journey
        
        if let sector =  self.viewModel.ladgerEvent?.attributedSector, title == "Sector"{
            cell.configureCellWithAttributedText(title: title, description: sector)
        }
        

        if let color = descriptionColor {
            cell.descLabel.textColor = color
        }
        let section = indexPath.section - 1
        var isForVouchre = false
        if let type = self.viewModel.ladgerEvent?.productType{
            switch type{
            case .hotel, .flight: isForVouchre = false
            default: isForVouchre = (self.viewModel.sectionArray.count < 2)
            }
        }
        if indexPath.row == 0 && section != 0{
            cell.stackTopConstraint.constant = 0
            cell.stackBottomConstraint.constant = 0
        }else if indexPath.row == 0 && isForVouchre{
            cell.stackTopConstraint.constant = 6
            cell.stackBottomConstraint.constant = 0
        }
//        else if indexPath.row == self.viewModel.sectionArray[section].count-2{
//            cell.stackTopConstraint.constant = 0
//            cell.stackBottomConstraint.constant = 6
//            printDebug("indexPath: \(indexPath)")
//        }
        else if title == "Room"{
            cell.stackTopConstraint.constant = 6
            cell.stackBottomConstraint.constant = 6.0
        }else{
            cell.stackTopConstraint.constant = 0
            cell.stackBottomConstraint.constant = 0
        }
        if title == "Guests" || title == "Passengers"{
            cell.stackTopConstraint.constant = 4
            cell.stackBottomConstraint.constant = 8.0
        }
        if self.getCellHeight(with: indexPath) == -1{
//            let section = indexPath.section - 1
//            let model = self.viewModel.sectionArray[section][indexPath.row]
//            if (model.title == "Room" || model.title == " "){
//                cell.titleLabelHeightConstraint.constant = cell.descLabel.frame.height
//            }else{
                cell.titleLabelHeightConstraint.constant = 20.0
//            }
            
        }else{
            cell.titleLabelHeightConstraint.constant = (self.getCellHeight(with: indexPath) - cell.stackBottomConstraint.constant)
        }
        cell.titleLabelWidthConstraints.constant = self.viewModel.cellTitleLabelWidth
        return cell
    }
    
    func getCellHeight(with indexPath:IndexPath)->CGFloat{
        
        guard indexPath.section > 0 else {
            //first section's first cell
            if let event = self.viewModel.ladgerEvent, event.voucher == .sales || event.voucher == .journal  || self.viewModel.sectionArray.count > 2 {
                if event.productType == .flight{
                    return 7.0
                }
                else {
                    return 5.0
                }
            }
            else {
                return 2.0
            }
        }
        
        if indexPath.section == self.viewModel.sectionArray.count + 1{
            if ((self.viewModel.ladgerEvent?.bookingId.isEmpty ?? false) && (self.viewModel.ladgerEvent?.transactionId.isEmpty ?? false)){
                switch indexPath.row {
                case 0: return 27
                default: return CGFloat.leastNonzeroMagnitude
                }
            }else{
                switch indexPath.row {
                case 0: return 27
                case 1: return 44
                case 2: return 35
                default: return 0
                }
            }
            
        }
        if indexPath.row == self.viewModel.sectionArray[indexPath.section - 1].count - 1 {
            //devider
            return 1
        }
        else {
            //details
            var isForVouchre = false
            if let type = self.viewModel.ladgerEvent?.productType{
                switch type{
                case .hotel, .flight: isForVouchre = false
                default: isForVouchre = (self.viewModel.sectionArray.count < 2)
                }
            }
            
            if indexPath.row == 0 && (indexPath.section - 1) != 0{
                return 36.0
            }else if indexPath.row == 0 && isForVouchre{
                return 36.0
            }else if indexPath.row == self.viewModel.sectionArray[indexPath.section - 1].count-2{
                let section = indexPath.section - 1
                let model = self.viewModel.sectionArray[section][indexPath.row]
                if (model.title == "Passengers" || model.title == "   " || model.title == "Guests"){
                    return UITableView.automaticDimension
                }else{
                    return 36.0
                }
                
            }else{
                let section = indexPath.section - 1
                let model = self.viewModel.sectionArray[section][indexPath.row]
                if (model.title == "Room" || model.title == " "){
                    return UITableView.automaticDimension
                }else if (model.title == "Passengers" || model.title == "   " || model.title == "Guests"){//passenger, guest
                    return UITableView.automaticDimension
                }else{
                    return 30.0
                }
            }
            
        }
    }
        
    
    
    
}

//MARK:- Cell Classes
//MARK:-
class AccountLadgerDetailCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabelWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    
    
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.descLabel.attributedText = nil
    }
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    func configure(title: String, description: String, age: String) {
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.descLabel.isHidden = false
        self.descLabel.font = AppFonts.Regular.withSize(16.0)
        self.descLabel.textColor = AppColors.themeBlack//textFieldTextColor51
        self.descLabel.text = description
        if !age.isEmpty {
            self.descLabel.appendFixedText(text: description, fixedText: age)
            self.descLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
    }
    
    
    func configureCellWithAttributedText(title: String, description: NSAttributedString){
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.descLabel.isHidden = false
        self.descLabel.font = AppFonts.Regular.withSize(16.0)
        self.descLabel.textColor = AppColors.themeBlack//textFieldTextColor51
        self.descLabel.attributedText = description
    }
    
    func setTitleFor(key: String, value: String){
        
//        attributedText = (self.event?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
    }
    
}


class AccountLadgerDividerell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerTrailingConstraint: NSLayoutConstraint!
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
}
