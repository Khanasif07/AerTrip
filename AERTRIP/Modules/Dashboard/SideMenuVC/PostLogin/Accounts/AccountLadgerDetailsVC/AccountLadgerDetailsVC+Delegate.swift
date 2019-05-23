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
        return self.viewModel.ladgerDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dict = self.viewModel.ladgerDetails["\(section)"] as? JSONDictionary else {
            return 0
        }
        if !dict.isEmpty {
            //extra 1 is for divider
            return dict.keys.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let dict = self.viewModel.ladgerDetails["\(indexPath.section)"] as? JSONDictionary else {
            return 0.0
        }
        if indexPath.row == dict.keys.count {
            //devider
            return 13.0
        }
        else {
            //details
            return 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dict = self.viewModel.ladgerDetails["\(indexPath.section)"] as? JSONDictionary else {
            return UITableViewCell()
        }
        if indexPath.row == dict.keys.count {
            //devider
            return self.getDeviderCell()
        }
        else {
            //details
            var key = "", value = ""
            var descColor: UIColor? = nil
            
            if let event = self.viewModel.ladgerEvent {
                if event.voucher == .sales {
                    
                    if event.productType == .hotel {
                        switch indexPath.section {
                        case 0:
                            key = self.viewModel.amountDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            
                        case 1:
                            key = self.viewModel.bookingDetailKeys[indexPath.row]
                            value = (dict[key] as? String) ?? ""
                            if key.contains("Names"), (key != "Names") {
                                key = ""
                            }
                            
                        default: key = ""
                        }
                    }
                    else if event.productType == .flight {
                        switch indexPath.section {
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
                            if key.contains("Names"), (key != "Names") {
                                key = ""
                            }
                            
                        default: key = ""
                        }
                    }
                }
                else {
                    switch indexPath.section {
                    case 0:
                        key = self.viewModel.amountDetailKeys[indexPath.row]
                        value = (dict[key] as? String) ?? ""
                        
                    default: key = ""
                    }
                }
            }
            
            value = value.isEmpty ? "--" : value
            return self.getDetailCell(title: key, description: value, descriptionColor: descColor)

        }
    }
    
    func getDeviderCell() -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDividerell.reusableIdentifier) as? AccountLadgerDividerell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func getDetailCell(title: String, description: String, descriptionColor: UIColor? = nil) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDetailCell.reusableIdentifier) as? AccountLadgerDetailCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: title, description: description)
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
    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    func configure(title: String, description: String) {
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.descLabel.isHidden = false
        self.descLabel.font = AppFonts.Regular.withSize(16.0)
        self.descLabel.textColor = AppColors.textFieldTextColor51
        self.descLabel.text = description
    }
}


class AccountLadgerDividerell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var dividerView: ATDividerView!
    
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
