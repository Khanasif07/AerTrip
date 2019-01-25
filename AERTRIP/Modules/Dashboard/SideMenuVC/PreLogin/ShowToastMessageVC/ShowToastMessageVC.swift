//
//  ShowToastMessageVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ShowToastMessageVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    var message            = ""
    var rightButtonTitle   = ""
    var isRightButtonImage = false
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rightViewButton: UIButton!
    @IBOutlet weak var rightViewButtonWidth: NSLayoutConstraint!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.rightViewButtonWidth.constant = 0
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            
            self.toastView.transform  = CGAffineTransform(translationX: 0, y: -(self.toastView.y + 64))
        }
        
    
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {

            UIView.animate(withDuration: AppConstants.kAnimationDuration) {

                self.toastView.transform  = CGAffineTransform(translationX: 0, y: self.toastView.y + 64)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.toastView.transform  = CGAffineTransform(translationX: 0, y: self.toastView.y + 64)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.toastView.cornerRadius = 10
    }
    
    override func setupColors() {
        
        self.toastView.backgroundColor = AppColors.toastBackgroundBlur
        self.messageLabel.textColor   = AppColors.themeWhite
        self.rightViewButton.titleLabel?.textColor = AppColors.themeYellow
    }
    
    override func setupFonts() {
        
        self.messageLabel.font = AppFonts.Regular.withSize(16)
        self.rightViewButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func setupTexts() {
        
        self.messageLabel.text = message
        if self.isRightButtonImage {
            
            self.rightViewButtonWidth.constant = 25
            let image = UIImage(named: "cancelButton")
            self.rightViewButton.setImage(image, for: .normal)
            
        } else if !self.rightButtonTitle.isEmpty {
            
            self.rightViewButtonWidth.constant = 50
            self.rightViewButton.setTitle(self.rightButtonTitle, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {

            self.toastView.transform  = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            self.view.removeFromSuperview()
        }
    }
    
    //MARK:- IBActions
    //MARK:-
}


