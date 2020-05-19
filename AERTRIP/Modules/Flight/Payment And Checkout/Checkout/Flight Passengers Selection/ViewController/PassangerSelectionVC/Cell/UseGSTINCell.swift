//
//  UseGSTINCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol UseGSTINCellDelegate:NSObjectProtocol {
    func changeSwitchValue(isOn:Bool)
    func tapOnSelectGST()
}

class UseGSTINCell: UITableViewCell {

    @IBOutlet weak var useGSTTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var gstSwitch: UISwitch!
    @IBOutlet weak var subTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var useGSTTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGSTDetailView: UIView!
    @IBOutlet weak var selectGSTTextField: PKFloatLabelTextField!
    @IBOutlet weak var selectGSTFieldSeparatorView: UIView!
    @IBOutlet weak var gSTDetailsLabel: UILabel!
    @IBOutlet weak var enterGSTView: UIView!
    @IBOutlet weak var companyNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var companyNameSeparatorView: UIView!
    @IBOutlet weak var gSTNumberTextField: PKFloatLabelTextField!
    
    var delegate:UseGSTINCellDelegate?
    var gstModel = GSTINModel(){
        didSet{
            self.selectGSTTextField.text = self.gstModel.billingName
            if !self.gstModel.companyName.isEmpty{
                self.gSTDetailsLabel.text = "\(self.gstModel.companyName)\nGSTIN - \(self.gstModel.GSTInNo)"
            }else{
                self.gSTDetailsLabel.text = ""
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        self.selectionStyle = .none
        self.selectGSTDetailView.isHidden = true
        self.enterGSTView.isHidden = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectGSTDetailView.isHidden = true
        self.enterGSTView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        self.delegate?.changeSwitchValue(isOn: sender.isOn)
    }
    
    @IBAction func tapSelectGSTBtn(_ sender: Any) {
        self.delegate?.tapOnSelectGST()
    }
    
    func setupFont(){
        useGSTTitleLabel.font = AppFonts.Regular.withSize(18.0)
        subTitleLabel.font = AppFonts.Regular.withSize(14.0)
        useGSTTitleLabel.textColor = AppColors.themeBlack
        subTitleLabel.textColor = AppColors.themeGray40
        gSTDetailsLabel.font = AppFonts.Regular.withSize(14)
        gSTDetailsLabel.textColor = AppColors.themeGray40
        selectGSTTextField.setUpAttributedPlaceholder(placeholderString: "Billing Company",with: "")
        companyNameTextField.setUpAttributedPlaceholder(placeholderString: "Company Name",with: "")
        gSTNumberTextField.setUpAttributedPlaceholder(placeholderString: "GSTIN Registration Number",with: "")
        selectGSTTextField.lineColor = AppColors.clear
        selectGSTTextField.selectedLineColor = AppColors.clear
        selectGSTTextField.hintYPadding = -6
        selectGSTTextField.titleYPadding = 1.5
        [selectGSTTextField, companyNameTextField, gSTNumberTextField].forEach{ txt in
            txt?.titleActiveTextColour = AppColors.themeGreen
            txt?.textColor =  AppColors.textFieldTextColor51
            txt?.font = AppFonts.Regular.withSize(18.0)
            txt?.titleFont = AppFonts.Regular.withSize(14.0)
        }
        self.useGSTTopConstraint.constant = 10
    }
    
    func setupForNewGST(){
        self.enterGSTView.isHidden = !(self.gstSwitch.isOn)
        self.selectGSTDetailView.isHidden = true
    }
    
    func setupForSelectGST(){
        self.selectGSTDetailView.isHidden = !(self.gstSwitch.isOn)
        self.enterGSTView.isHidden = true
    }
    
}
