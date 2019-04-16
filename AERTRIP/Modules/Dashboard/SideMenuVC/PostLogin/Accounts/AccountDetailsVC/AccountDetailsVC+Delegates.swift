//
//  AccountDetailsVC+Delegates.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//MARK:- tableView datasource and delegate methods
//MARK:-
extension AccountDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.allDates.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = self.viewModel.allDates[section]
        label.font = AppFonts.SemiBold.withSize(16.0)
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
            
            return (allEvent.reduce(0) { $0 + $1.numOfRows})
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent] else {
            return UITableViewCell()
        }
        
        let allCount = (allEvent.count > 1) ? allEvent.count : 2
        if (indexPath.row % allCount) == 0 {
            //event header cell
            return self.getEventHeaderCell(forData: allEvent[0])
        }
        else if (indexPath.row % allCount) == 1 {
            //event description cell
            return self.getEventDescriptionCell(forData: allEvent[0])
        }
        
        return UITableViewCell()
    }
    
    func getEventHeaderCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountDetailEventHeaderCell.reusableIdentifier) as? AccountDetailEventHeaderCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        return cell
    }
    
    func getEventDescriptionCell(forData: AccountDetailEvent) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountDetailEventDescriptionCell.reusableIdentifier) as? AccountDetailEventDescriptionCell else {
            return UITableViewCell()
        }
        
        cell.event = forData
        
        return cell
    }
}


//MARK:- Cell Classes
//MARK:-
class AccountDetailEventHeaderCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    var event: AccountDetailEvent? {
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
        self.dividerView.defaultHeight = 1.0
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
    }
    
    private func setData() {
        self.iconImageView.image = self.event?.voucher.image
        self.titleLabel.text = self.event?.title
    }
}

class AccountDetailEventDescriptionCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    
    var event: AccountDetailEvent? {
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
        self.voucherTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.amountTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.voucherTitleLabel.textColor = AppColors.themeGray40
        self.amountTitleLabel.textColor = AppColors.themeGray40
        self.balanceTitleLabel.textColor = AppColors.themeGray40
        
        self.voucherTitleLabel.text = LocalizedString.Voucher.localized
        self.amountTitleLabel.text = LocalizedString.Amount.localized
        self.balanceTitleLabel.text = LocalizedString.Balance.localized
    }
    
    private func setData() {
        self.voucherValueLabel.text = "Sales"
        self.amountValueLabel.text = "\(AppConstants.kRuppeeSymbol)\((self.event?.amount ?? 0.0).delimiter)"
        self.balanceValueLabel.text = "\(AppConstants.kRuppeeSymbol)\((self.event?.balance ?? 0.0).delimiter)"
    }
}
