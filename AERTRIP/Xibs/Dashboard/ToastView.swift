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
        self.addPanGesture()
    }
    
    func setupTextColorAndFont() {
        
        self.cornerradius = 8
//        self.clipsToBounds = true
        self.messageLabel.font    = AppFonts.Regular.withSize(16)
        self.messageLabel.textColor = AppColors.themeWhite
        self.addBlurEffect()
        self.viewRightButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        self.viewRightButton.titleLabel?.textColor = AppColors.themeYellow
    }
    
    private func addBlurEffect() {
        if let backClr = self.backgroundColor, backClr != AppColors.clear {
            self.insertSubview(getBlurView(forView: self), at: 0)
            self.backgroundColor = AppColors.clear
        }
        
        self.insertSubview(getBlurView(forView: self), at: 0)
        self.backgroundColor = AppColors.clear
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)

    }
    
    private func getBlurView(forView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = forView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.7
        return blurEffectView
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer?) {
        if recognizer?.state.rawValue == 1 {
            AppToast.default.hideToast(nil, animated: true)
        }
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
            return AppGlobals.shared.getTextWithImage(startText: "", image: AppImages.ic_delete_toast, endText: "  \(LocalizedString.Deleted.localized.lowercased())", font: AppFonts.Regular.withSize(16))
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
