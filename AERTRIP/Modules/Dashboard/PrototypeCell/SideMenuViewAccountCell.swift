//
//  SideMenuViewAccountCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuViewAccountCell: UITableViewCell {

    @IBOutlet weak var totalDueAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var viewAccountButton: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK:- Extension Setup Text
//MARK:-
extension SideMenuViewAccountCell {
    
    func initialSetups() {
        
        self.setupFontColorAndText()
        self.viewAccountButton.isUserInteractionEnabled = false
    }
    
    func setupFontColorAndText() {
        
        self.totalDueAmountLabel.font     = AppFonts.Regular.withSize(16)
        self.totalDueAmountLabel.textColor  = AppColors.themeBlack
        self.amountLabel.font          = AppFonts.Regular.withSize(22)
        self.amountLabel.textColor       = AppColors.themeBlack
        
        self.viewAccountButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.viewAccountButton.setTitle(LocalizedString.ViewAccounts.localized, for: .normal)
        viewAccountButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        self.dateLabel.font = AppFonts.Regular.withSize(12)
        self.dateLabel.textColor = AppColors.themeRed
        
    }
    
    func populateData() {
        // FIXME:  Amount would be in double ,doing it for temporary as per QA
        var amount: Double = 0.0
        var date: Date? = nil
        
        if let usr = UserInfo.loggedInUser {
            
            switch usr.userCreditType {
            case .billwise:
                amount = UserInfo.loggedInUser?.accountData?.billwise?.totalOutstanding ?? 0.0

            case .topup:
                amount = UserInfo.loggedInUser?.accountData?.topup?.beforeAmountDue?.amount ?? 0.0
                date = UserInfo.loggedInUser?.accountData?.topup?.beforeAmountDue?.dates.first
                
            case .statement:
                amount = UserInfo.loggedInUser?.accountData?.statements?.beforeAmountDue?.amount ?? 0.0
                date = UserInfo.loggedInUser?.accountData?.statements?.beforeAmountDue?.dates.first
                
            default:
                amount = UserInfo.loggedInUser?.accountData?.walletAmount ?? 0.0
                if amount != 0{
                    amount *= -1
                }
            }
        }
        
        self.amountLabel.attributedText = (amount * (UserInfo.preferredCurrencyDetails?.rate ?? 1.0)).amountInDelimeterWithoutSymbol.asStylizedPriceWithSymbol(using: AppFonts.Regular.withSize(22.0))
        
        self.dateLabel.text = ""
        self.dateLabel.isHidden = true
        if let dt = date {
            let str = dt.toString(dateFormat: "EE, dd MMM YYYY")
            if !str.isEmpty {
                self.dateLabel.isHidden = false
                self.dateLabel.text = "Before \(str)"
            }
        }
    }
}
