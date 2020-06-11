//
//  HCEmailItinerariesTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

//class EmailItinerariesTextField: UITextField {
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(copy(_:)) || action == #selector(paste(_:)){
//            return true
//        }
//        return false
//    }
//}

protocol HCEmailItinerariesTableViewCellDelegate: class {
    func sendToEmailId(indexPath: IndexPath, emailId: String)
    func updateEmailId(indexPath: IndexPath, emailId: String)
}

class HCEmailItinerariesTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    weak var delegate: HCEmailItinerariesTableViewCellDelegate?
    let sendBtnImage = #imageLiteral(resourceName: "checkIcon").withRenderingMode(.alwaysTemplate)
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.delegate = self
            self.emailTextField.rightViewMode = .whileEditing
            self.emailTextField.keyboardType = .emailAddress
            self.emailTextField.autocorrectionType = .no
            self.emailTextField.adjustsFontSizeToFitWidth = true
            self.emailTextField.delegate = self

        }
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
//        self.profileImageView.backgroundColor = AppColors.themeGray60
        self.sendButton.layer.cornerRadius = 14.0
        self.sendButton.layer.masksToBounds = true
        self.activityIndicator.isHidden = true
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
        self.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    internal func configCell(isMailSended: Bool, name: String) {
        self.profileImageView.image = #imageLiteral(resourceName: "linkFacebook")
        self.nameLabel.text = name
        if isMailSended {
            self.sendButton.setTitle(nil, for: .normal)
            self.sendButton.backgroundColor = UIColor.clear
            self.sendButton.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
            self.emailTextField.textColor = AppColors.themeGray40
        } else {
            self.sendButton.setImage(nil, for: .normal)
            self.sendButton.setTitle(LocalizedString.Send.localized, for: .normal)
            self.sendButton.backgroundColor = AppColors.screensBackground.color
            self.emailTextField.textColor = AppColors.textFieldTextColor51
        }
    }
    
    internal func configureCell(emailInfo: HCEmailItinerariesModel, name: String, firstName: String , lastName: String , profileImage: String) {
        self.nameLabel.text = name
        let placeholderImage = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName , font: AppFonts.Regular.withSize(36.0), textColor: AppColors.themeGray60 , backGroundColor: AppColors.imageBackGroundColor)
        self.profileImageView.setImageWithUrl(profileImage, placeholder: placeholderImage, showIndicator: true)
        self.emailTextField.text = emailInfo.emailId
        self.emailTextField.isUserInteractionEnabled = true
        switch emailInfo.emailStatus {
        case .toBeSend:
            self.activityIndicator.isHidden = true
            self.sendButton.isHidden = false
            self.sendButton.setImage(nil, for: .normal)
            self.sendButton.setTitle(LocalizedString.Send.localized, for: .normal)
            self.sendButton.backgroundColor = AppColors.screensBackground.color
            self.sendButton.isUserInteractionEnabled = true
            if emailInfo.emailId.isEmail {
                self.sendButton.setTitleColor(AppColors.themeGreen, for: .normal)
                self.emailTextField.textColor = AppColors.textFieldTextColor51
            } else {
                self.sendButton.setTitleColor(AppColors.themeGray20, for: .normal)
                self.emailTextField.textColor = AppColors.themeRed
            }
        case .sending:
            self.sendButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.emailTextField.textColor = AppColors.textFieldTextColor51
        case .sent:
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.sendButton.isHidden = false
            self.sendButton.setTitle(nil, for: .normal)
            self.sendButton.backgroundColor = UIColor.clear
            self.sendButton.setImage(self.sendBtnImage, for: .normal)
            self.sendButton.imageView?.tintColor = AppColors.themeGreen
            self.sendButton.isUserInteractionEnabled = false
            self.emailTextField.isUserInteractionEnabled = false
            self.emailTextField.textColor = AppColors.themeGray40
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let superView = self.superview as? UITableView, let indexPath = superView.indexPath(forItem: textField), let safeDelegate = self.delegate, let emailId =  textField.text{
            safeDelegate.updateEmailId(indexPath: indexPath, emailId: emailId)
        }
    }
    
    
    //Mark:- IBOActions
    //================
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if let superView = self.superview as? UITableView, let indexPath = superView.indexPath(forItem: sender), let safeDelegate = self.delegate, let emailId =  self.emailTextField.text{
            safeDelegate.sendToEmailId(indexPath: indexPath, emailId: emailId.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}

extension HCEmailItinerariesTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.emailTextField.textColor = AppColors.textFieldTextColor51
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailId =  textField.text {
            let finalText = emailId.trimmingCharacters(in: .whitespacesAndNewlines)
            if finalText.isEmail {
                self.sendButton.setTitleColor(AppColors.themeGreen, for: .normal)
                self.emailTextField.textColor = AppColors.textFieldTextColor51
            } else {
                self.sendButton.setTitleColor(AppColors.themeGray20, for: .normal)
                self.emailTextField.textColor = AppColors.themeRed
            }
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
//        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !finalText.isEmpty {
//            self.delegate?.sendEmailText(emailId: finalText)
//        }
//        return true
//    }
}
