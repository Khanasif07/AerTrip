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
        return self.viewModel.ladgerDetails.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard section > 0 else {
            //first section's first cell
            return 1
        }
        
        guard let dict = self.viewModel.ladgerDetails["\(section - 1)"] as? JSONDictionary else {
            return 0
        }
        
        if !dict.isEmpty {
            //extra 1 is for divider
            return dict.keys.count + 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.section > 0 else {
            //first section's first cell
            if let event = self.viewModel.ladgerEvent, event.voucher == .sales {
                if event.productType == .flight {
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
        
        guard let dict = self.viewModel.ladgerDetails["\(indexPath.section - 1)"] as? JSONDictionary else {
            return 0.0
        }
        
        if indexPath.row == dict.keys.count {
            //devider
            return 1
        }
        else {
            //details
            return 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section > 0 else {
            //first section's first cell
            let cell = UITableViewCell()
            cell.backgroundColor = AppColors.themeWhite
            return cell
        }
        
        let section = indexPath.section - 1
        guard let dict = self.viewModel.ladgerDetails["\(section)"] as? JSONDictionary else {
            return UITableViewCell()
        }
        if indexPath.row == dict.keys.count {
            //devider
            return self.getDeviderCell(indexPath: indexPath)
        }
        else {
            //details
            var key = "", value = ""
            var descColor: UIColor? = nil
            var age = ""
            
            if let event = self.viewModel.ladgerEvent {
                if event.voucher == .sales {
                    
                    if event.productType == .hotel {
                        switch section {
                        case 0:
                            key = self.viewModel.amountDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            
                        case 1:
                            key = self.viewModel.bookingDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            if let model = dict[key] as? AccountUser {
                                value = model.name
                                if !model.age.isEmpty, let userAge = Int(model.age)  {
                                    if (userAge > 0) && (userAge <= 12){
                                        age = "(\(userAge)y)"
                                    }
                                }
                            }
                            if key.contains("Names"), (key != "Names") {
                                key = ""
                            }
                            
                        default: key = ""
                        }
                    }
                    else if event.productType == .flight {
                        switch section {
                        case 0:
                            key = self.viewModel.flightAmountDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            
                            if key.lowercased() == "Over Due by days".lowercased() {
                                descColor = AppColors.themeRed
                            }
                            
                        case 1:
                            key = self.viewModel.voucherDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            
                        case 2:
                            key = self.viewModel.flightDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            if let model = dict[key] as? AccountUser {
                                value = model.name
                                if !model.dob.isEmpty {
                                    age = AppGlobals.shared.getAgeLastString(dob: model.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                                }
                            }
                            if key.contains("Names"), (key != "Names") {
                                key = ""
                            }
                            
                        default: key = ""
                        }
                    }
                }
                else {
                    switch section {
                    case 0:
                        key = self.viewModel.amountDetailKeys[indexPath.row]
                        value = (dict[key] as? String) ?? ""
                        
                    default: key = ""
                    }
                }
            }
            
            value = value.isEmpty ? LocalizedString.dash.localized : value
            return self.getDetailCell(title: key, description: value, descriptionColor: descColor, age: age)

        }
    }
    
    func getDeviderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDividerell.reusableIdentifier) as? AccountLadgerDividerell else {
            return UITableViewCell()
        }
        let value:CGFloat = (self.numberOfSections(in: self.tableView) - 1 ) == indexPath.section ? 0 : 16
        cell.dividerLeadingConstraint.constant = value
            cell.dividerTrailingConstraint.constant = value
        return cell
    }
    
    func getDetailCell(title: String, description: String, descriptionColor: UIColor? = nil, age: String) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDetailCell.reusableIdentifier) as? AccountLadgerDetailCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: title, description: description, age: age)
        if let color = descriptionColor {
            cell.descLabel.textColor = color
        }
        
        return cell
    }
}

//MARK:- Cell Classes
//MARK:-
class AccountLadgerDetailCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
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
        self.descLabel.textColor = AppColors.textFieldTextColor51
        self.descLabel.text = description
        if !age.isEmpty {
            self.descLabel.appendFixedText(text: description, fixedText: age)
            self.descLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
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
