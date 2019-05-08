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
        guard let _ = self.viewModel.ladgerEvent else {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            //booking details (5) + bottom divider + total names
            return 6 + (self.viewModel.ladgerEvent?.names.count ?? 0)
        }
        else {
            //amount details (5) + top and bottom divider
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            //booking details (5) + bottom divider + total names
            switch indexPath.row {
            case (6 + (self.viewModel.ladgerEvent?.names.count ?? 0) - 1) :
                //bottom devider
                return 43.0
            default:
                return 60.0
            }
        }
        else {
            //amount details (5) + top and bottom divider
            switch indexPath.row {
            case 0, 6 :
                //top and bottom devider
                return 33.0
            default:
                return 60.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            //booking details (5) + bottom divider + total names
            switch indexPath.row {
            case (6 + (self.viewModel.ladgerEvent?.names.count ?? 0) - 1) :
                //bottom devider
                return self.getDeviderCell()
                
            case 0:
                //cehck in
                return self.getDetailCell(title: "Check-in", description: self.viewModel.ladgerEvent?.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? "")
                
            case 1:
                //check out
                return self.getDetailCell(title: "Check-out", description: self.viewModel.ladgerEvent?.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? "")
                
            case 2:
                //room
                return self.getDetailCell(title: "Room", description: self.viewModel.ladgerEvent?.room ?? "")
                
            case 3:
                //inclusion
                return self.getDetailCell(title: "Inclusion", description: self.viewModel.ladgerEvent?.inclusion ?? "")
                
            case 4:
                //confrm Id
                return self.getDetailCell(title: "Confirmation ID", description: self.viewModel.ladgerEvent?.confirmationId ?? "")
                
            default:
                let idx = indexPath.row - 5
                let title = (idx == 0) ? "Names" : ""
                let name = self.viewModel.ladgerEvent?.names[idx] ?? ""
                return self.getDetailCell(title: title, description: name)
            }
        }
        else {
            //amount details (5) + top and bottom divider
            switch indexPath.row {
            case 0, 6 :
                //top and bottom devider
                return self.getDeviderCell()
                
            case 1:
                //Date
                return self.getDetailCell(title: "Date", description: self.viewModel.ladgerEvent?.date?.toString(dateFormat: "dd-MM-YYYY") ?? "")
                
            case 2:
                //Voucher
                return self.getDetailCell(title: "Voucher", description: "Sales")
                
            case 3:
                //Voucher No.
                return self.getDetailCell(title: "Voucher No.", description: self.viewModel.ladgerEvent?.voucherNo ?? "")
                
            case 4:
                //Amount
                return self.getDetailCell(title: "Amount", description: (self.viewModel.ladgerEvent?.amount ?? 0.0).amountInDelimeterWithSymbol)
                
            case 5:
                //Balance
                return self.getDetailCell(title: "Balance", description: (self.viewModel.ladgerEvent?.balance ?? 0.0).amountInDelimeterWithSymbol)
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func getDeviderCell() -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDividerell.reusableIdentifier) as? AccountLadgerDividerell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func getDetailCell(title: String, description: String) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountLadgerDetailCell.reusableIdentifier) as? AccountLadgerDetailCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: title, description: description)
        
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
