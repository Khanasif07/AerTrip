//
//  ToastView.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    internal var buttonAction: (()->Void)? = nil
    private var isSettingForDelete: Bool = false
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewRightButton: UIButton!
    
    class func instanceFromNib() -> ToastView {
        
        return UINib(nibName: "ToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToastView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTextColorAndFont()
    }
    
    func setupTextColorAndFont() {
        
        self.cornerRadius = 8
        self.clipsToBounds = true
        self.messageLabel.font    = AppFonts.Regular.withSize(16)
        self.messageLabel.textColor = AppColors.themeWhite
        self.backgroundColor = AppColors.themeGray60.withAlphaComponent(0.82)
        self.viewRightButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        self.viewRightButton.titleLabel?.textColor = AppColors.themeYellow
    }
    
    @IBAction func viewRightButtonTapped(_ sender: UIButton) {
        if let handel = self.buttonAction {
            handel()
        }
    }
}

extension ToastView {
    
    func setupToastForDelete(buttonAction: (()->Void)? = nil) {
        self.isSettingForDelete = true
        self.setupToastMessage(title: "", message: "", buttonTitle: LocalizedString.Undo.localized, buttonImage: nil, buttonAction: buttonAction)
        self.isSettingForDelete = false
    }
    
    func setupToastMessage(title: String = "", message: String, buttonTitle: String = "", buttonImage: UIImage? = nil, buttonAction: (()->Void)? = nil) {
        
        self.messageLabel.attributedText = self.getAttrText(title: title, message: message)
        
        self.buttonAction = buttonAction
        
        self.viewRightButton.setTitle(buttonTitle, for: .normal)
        self.viewRightButton.setTitle(buttonTitle, for: .selected)
        
        self.viewRightButton.setImage(buttonImage, for: .normal)
        self.viewRightButton.setImage(buttonImage, for: .selected)
        
        if buttonTitle.isEmpty, buttonImage == nil {
            //hide button
            self.viewRightButton.isHidden = true
        }
        else {
            //showButton
            self.viewRightButton.isHidden = false
        }
    }
    
    private func getAttrText(title: String, message: String) -> NSMutableAttributedString {
        if self.isSettingForDelete {
            return AppGlobals.shared.getTextWithImage(startText: "", image: #imageLiteral(resourceName: "ic_delete_toast"), endText: "  \(LocalizedString.Deleted.localized.lowercased())", font: AppFonts.Regular.withSize(16))
        }
        else {
            
            var finalText = title
            if !title.isEmpty {
                finalText += "\n"
            }
            finalText += "\(message)"
            
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: finalText, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(16)])
            
            attString.addAttributes([NSAttributedString.Key.font: AppFonts.SemiBold.withSize(14)], range: (finalText as NSString).range(of: title))
            
            return attString
        }
    }
}
