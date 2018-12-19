//
//  ToastView.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ToastDelegate: NSObjectProtocol {
    func toastRightButtoAction()
}

class ToastView: UIView {

    weak var delegate: ToastDelegate?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewRightButton: UIButton!
    @IBOutlet weak var rightViewButtonWidth: NSLayoutConstraint!
    
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
        
        self.delegate?.toastRightButtoAction()
        printDebug("Tapped")
    }
}

extension ToastView {
    
    func showToastMessage(message: String) {
        
        self.rightViewButtonWidth.constant = 0
        self.messageLabel.text = message
    }
    
    func showToastMessageWithRightButtonTitle(message: String, buttonTitle: String) {
        
        self.rightViewButtonWidth.constant = 45
        self.viewRightButton.setTitle(buttonTitle, for: .normal)
        self.messageLabel.text = message
    }
    
    func showToastMessageWithRightButtonImage(message: String) {
        
        self.rightViewButtonWidth.constant = 25
        self.viewRightButton.setImage(UIImage(named: "cancelButton"), for: .normal)
        self.messageLabel.text = message
    }
}
