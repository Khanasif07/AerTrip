//
//  AccountDepositAmountCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountDepositAmountCellDelegate: class {
    func amountDidChanged(amount: Double, amountString: String)
    func amountValueChanged(amount: Double, amountString: String)
}

extension AccountDepositAmountCellDelegate{
    func amountValueChanged(amount: Double, amountString: String){}
}


class AccountDepositAmountCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var topDividerView: ATDividerView!
    
    
    weak var delegate: AccountDepositAmountCellDelegate?
    
    var amount: Double = 0.0 {
        didSet {
            self.setData()
        }
    }
    var amountTextSetOnce = false
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.amountTextField.keyboardType = .numberPad

        self.setFontAndColor()
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingDidEnd)
        self.amountTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.topDividerView.isHidden = true

    }
    deinit {
        printDebug("deinit AccountDepositAmountCell")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.topDividerView.isHidden = true
        self.amountTextField.attributedText = nil
        self.amountTextField.font = AppFonts.SemiBold.withSize(40.0)
        self.amountTextField.keyboardType = .numberPad
    }
    
    @objc private func textFieldDidEndEditing(_ sender: UITextField) {
        if let txt = sender.text  {
            let value = txt.isEmpty ? "0" : txt
            if let amt = value.replacingOccurrences(of: ",", with: "").toDouble {
            self.amountTextField.text = amt.delimiterWithoutSymbol
            self.delegate?.amountDidChanged(amount: amt, amountString: txt)
            }
        }
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        self.amountTextField.backgroundColor = .clear
        if let txt = sender.text  {
            self.amountTextField.AttributedBackgroundColorForText(text: txt, textColor: AppColors.clear)
            let value = txt.isEmpty ? "0" : txt
            if let amt = value.replacingOccurrences(of: ",", with: "").toDouble {
                self.delegate?.amountValueChanged(amount: amt, amountString: txt)
            }
        }
        
    }
    
    private func setData() {
        let value = amount.delimiterWithoutSymbol
        self.amountTextField.text = value
//        if !amountTextSetOnce {
//            amountTextSetOnce = true
//        self.amountTextField.AttributedBackgroundColorForText(text: value, textColor: AppColors.themeBlue.withAlphaComponent(0.26))
//        }
        
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.currencyLabel.font = AppFonts.Regular.withSize(18.0)
        self.amountTextField.font = AppFonts.SemiBold.withSize(40.0)
        
        self.titleLabel.textColor = AppColors.themeGreen
        self.currencyLabel.textColor = AppColors.themeTextColor
        self.amountTextField.textColor = AppColors.themeBlack
        self.amountTextField.backgroundColor = AppColors.themeWhite//AppColors.themeBlue.withAlphaComponent(0.26)
        
        self.titleLabel.text = LocalizedString.DepositAmount.localized
        self.currencyLabel.text = AppConstants.kRuppeeSymbol
        self.amountTextField.text = "0"
    }
    
}
