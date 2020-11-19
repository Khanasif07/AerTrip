//
//  OnAccountDetailVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension OnAccountDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.viewModel.allDates.count
        tableView.backgroundView?.isHidden = (count > 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.topSeparatorView.isHidden = false
        
        var dateStr = ""
        if let event = self.getEvent(forIndexPath: IndexPath(row: 0, section: section), forTableView: tableView).event {
            dateStr = event.onAccountDate?.toString(dateFormat: "dd MMM YYYY") ?? ""
        }
        headerView.headerLabel.text = dateStr.uppercased()
        headerView.headerLabel.textColor = AppColors.themeGray60
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [OnAccountLedgerEvent] {
            return allEvent.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (currentEvent, allCount) = self.getEvent(forIndexPath: indexPath, forTableView: tableView)

        guard let event = currentEvent, let cell = self.tableView.dequeueReusableCell(withIdentifier: OnAccountEventCell.reusableIdentifier) as? OnAccountEventCell else {
            return UITableViewCell()
        }
        
        cell.event = event
        
        if (indexPath.section == (self.viewModel.allDates.count - 1)), (indexPath.row >= (allCount - 1)) {
            cell.dividerView.isHidden = false
            cell.dividerViewLeadingConstraint.constant = 0
        }
        else {
            cell.dividerView.isHidden = (indexPath.row >= (allCount - 1))
            cell.dividerViewLeadingConstraint.constant = 16.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (currentEvent, _) = self.getEvent(forIndexPath: indexPath, forTableView: tableView)

        if let bID = currentEvent?.transactionId, !bID.isEmpty {
            
            AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)dashboard/download-voucher?id=\(bID)", screenTitle: "Receipt Voucher", showLoader: true, complition: { [weak self] (status) in
                
//                self?.tableView.reloadRow(at: indexPath, with: .automatic)
            })
        }
    }
    
    func getEvent(forIndexPath indexPath: IndexPath, forTableView: UITableView) -> (event: OnAccountLedgerEvent?, allCount: Int){
        
        guard !self.viewModel.accountDetails.isEmpty else {
            return (nil, 0)
        }
        
        let allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [OnAccountLedgerEvent]) ?? []
        
        guard !allEvent.isEmpty else {
            return (nil, 0)
        }
        
        return (allEvent[indexPath.row], allEvent.count)
    }
}


//MARK:- Cell Class
//MARK:-
class OnAccountEventCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    
    var event: OnAccountLedgerEvent? {
        didSet {
            self.setData()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.titleLabel.textColor = AppColors.themeBlack//themeTextColor
        self.descriptionLabel.textColor = AppColors.themeGray40
        self.amountLabel.textColor = AppColors.themeBlack//themeTextColor
    }
    
    private func resetAllText() {
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.amountLabel.text = ""
        self.amountLabel.attributedText = nil
    }
    
    private func setData() {
        guard let event = self.event else {
            self.resetAllText()
            return
        }
        self.titleLabel.text = event.voucherName
        self.descriptionLabel.text = event.voucherNo
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])

        let amount = event.amount
        
        let amountStr = abs(event.amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        amountStr.append((amount > 0) ? drAttr : crAttr)
        self.amountLabel.attributedText = amountStr
    }
}
