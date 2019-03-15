//
//  HCEmailItinerariesTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SendToEmailIDDelegate: class {
    func sendToEmailId(indexPath: IndexPath)
    func sendEmailText(emailId: String)
}

class HCEmailItinerariesTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    weak var delegate: SendToEmailIDDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.delegate = self
            self.emailTextField.rightViewMode = .whileEditing
//            self.emailTextField
            self.emailTextField.adjustsFontSizeToFitWidth = true
            self.emailTextField.textFieldClearBtnSetUp()

        }
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //UI
        self.profileImageView.makeCircular()
        self.sendButton.layer.cornerRadius = 14.0
        self.sendButton.layer.masksToBounds = true
        //Color
        self.sendButton.backgroundColor = AppColors.screensBackground.color
        self.sendButton.setTitleColor(AppColors.themeGray20, for: .normal)
        self.nameLabel.textColor = AppColors.themeGray60
        self.emailTextField.textColor = AppColors.textFieldTextColor51
        //Font
        self.emailTextField.font = AppFonts.Regular.withSize(18.0)
        self.nameLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.sendButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        //Text
        self.sendButton.setTitle(LocalizedString.Send.localized, for: .normal)
        self.emailTextField.setAttributedPlaceHolder(placeHolderText: LocalizedString.Email_ID.localized)
    }
    
    private func sendButtonSetUp(isMailSended: Bool) {
        if isMailSended {
            self.sendButton.setTitle(nil, for: .normal)
            self.sendButton.setImage(#imageLiteral(resourceName: "buttonCheckIcon"), for: .normal)
            self.sendButton.backgroundColor = UIColor.clear
        } else {
            self.sendButton.setTitle(LocalizedString.Send.localized, for: .normal)
            self.sendButton.setImage(nil, for: .normal)
            self.sendButton.backgroundColor = AppColors.screensBackground.color
        }
    }
    
    internal func configCell(isMailSended: Bool, name: String) {
        self.sendButtonSetUp(isMailSended: isMailSended)
        self.profileImageView.image = #imageLiteral(resourceName: "linkFacebook")
        self.nameLabel.text = name
    }
    
    //Mark:- IBOActions
    //================
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if let superView = self.superview as? UITableView, let indexPath = superView.indexPath(forItem: sender), let safeDelegate = self.delegate {
            safeDelegate.sendToEmailId(indexPath: indexPath)
        }
    }
}

extension HCEmailItinerariesTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalText.isEmpty {
            self.delegate?.sendEmailText(emailId: finalText)
        }
        return true
    }
}
