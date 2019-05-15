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
        headerView.headerLabel.text = self.viewModel.allDates[section]
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
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
    
    func getEvent(forIndexPath indexPath: IndexPath, forTableView: UITableView) -> (event: AccountDetailEvent?, allCount: Int){
        
        guard !self.viewModel.accountDetails.isEmpty else {
            return (nil, 0)
        }
        
        let allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
        
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
        
        self.backgroundColor = AppColors.themeWhite
        
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.titleLabel.textColor = AppColors.themeTextColor
        self.descriptionLabel.textColor = AppColors.themeGray40
        self.amountLabel.textColor = AppColors.themeTextColor
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
        self.descriptionLabel.text = event.billNumber
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let amount = event.amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        amount.append(drAttr)
        self.amountLabel.attributedText = amount
    }
}
