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
    }
    
    func setupFontColorAndText() {
        
        self.totalDueAmountLabel.font     = AppFonts.Regular.withSize(16)
        self.totalDueAmountLabel.textColor  = AppColors.themeBlack
        self.amountLabel.font          = AppFonts.Regular.withSize(22)
        self.amountLabel.textColor       = AppColors.themeBlack
        
        self.viewAccountButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.viewAccountButton.titleLabel?.textColor = AppColors.themeGreen
        self.viewAccountButton.setTitle(LocalizedString.ViewAccounts.localized, for: .normal)
        
        self.dateLabel.font = AppFonts.Regular.withSize(12)
        self.dateLabel.textColor = AppColors.themeRed
        
    }
    
    func populateData() {
        // FIXME:  Amount would be in double ,doing it for temporary as per QA
        let amount = (UserInfo.loggedInUser?.accountData?.statements.amountDue ?? 0)
        self.amountLabel.text = amount.amountInDelimeterWithSymbol
        
        self.dateLabel.text = "Before Fri, 12 May 2017"
    }
}
