//
//  AccountChargeInfoVC+Delegate.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

import UIKit

extension AccountChargeInfoVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountChargeInfoCell.reusableIdentifier) as? AccountChargeInfoCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: self.viewModel.titles[indexPath.row], description: self.viewModel.description[indexPath.row], usingFor: self.viewModel.currentUsingFor)
        cell.contentView.backgroundColor = AppColors.themeBlack26
        return cell
    }
}


//MARK:- Cell Classes
//MARK:-
class AccountChargeInfoCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var discriptionLabelTopConstraint: NSLayoutConstraint!
    
    
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
    func configure(title: String, description: String, usingFor: AccountChargeInfoVM.UsingFor) {
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.descLabel.isHidden = false
        
        if usingFor == .chargeInfo {
            self.descLabel.font = AppFonts.Regular.withSize(16.0)
            self.discriptionLabelTopConstraint.constant = 6.0
        }
        else {
            self.descLabel.font = AppFonts.Regular.withSize(18.0)
            self.discriptionLabelTopConstraint.constant = 9.0
        }
        self.descLabel.textColor = AppColors.themeBlack
        self.descLabel.text = description
    }
}
