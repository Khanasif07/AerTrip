//
//  ReloadResultPopupVC.swift
//  AERTRIP
//
//  Created by Apple  on 22.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ReloadResultPopupVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-

    
    @IBOutlet weak var decreaseContainerView: UIView!
    @IBOutlet weak var decreaseLabel: UILabel!
    @IBOutlet weak var decreaseBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var reloadButtonTrailing: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var continueHandler: (()->Void)?
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.setupDecreasePopUp()
        self.decreaseContainerView.transform = CGAffineTransform(translationX: 0, y: (decreaseContainerView.height + 40.0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.decreaseContainerView.transform = CGAffineTransform.identity
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
   
    
    
    
    private func setupDecreasePopUp() {
        self.decreaseLabel.textColor = AppColors.themeWhite
        self.reloadButton.setTitleColor(AppColors.themeYellow, for: .normal)
        self.reloadButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        self.decreaseLabel.font = AppFonts.Regular.withSize(16)
        self.decreaseLabel.textColor = AppColors.themeWhite
        decreaseContainerView.cornerRadius = 10.0
        decreaseContainerView.backgroundColor = AppColors.themeGray60.withAlphaComponent(0.82)
    }

    private func setVisiblityForDecreasedPopUp(isHidden: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.decreaseContainerView.origin.y = UIScreen.height
        }) { [weak self]_ in
            self?.decreaseContainerView.isHidden = isHidden
           if isHidden {
            self?.removeMe()
           }
        }
    }
 
    
    private func hideDecreasedPopUp() {
        decreaseContainerView.isHidden = true
    }
    
    private func removeMe() {
        self.removeFromParentVC
    }
    
    //MARK:- Public
    
    
    
    
    func showToastWith(_ message: String, isButtonHidden:Bool, buttonTitle: String, reloadButtonAction: (()->Void)?) {
        view.backgroundColor = AppColors.clear
        if isButtonHidden{
            self.reloadButton.setTitle("", for: .normal)
            self.reloadButtonTrailing.constant = 0.0
        }else{
            self.reloadButton.setTitle(buttonTitle, for: .normal)
            self.reloadButtonTrailing.constant = 16.0
            continueHandler = reloadButtonAction
        }
        self.decreaseLabel.text = message
        setVisiblityForDecreasedPopUp(isHidden: false, animated: true)
        
//        delay(seconds: 2.0) {[weak self] in
//            self?.setVisiblityForDecreasedPopUp(isHidden: true, animated: true)
//        }
    }
    
    class func showPopUp(message: String, isButtonHidden:Bool, buttonTitle: String, reloadButtonAction: (()->Void)?){
        
        if let topVC = UIApplication.topViewController() {
            let obj = ReloadResultPopupVC.instantiate(fromAppStoryboard: .HotelResults)
            topVC.add(childViewController: obj)
            obj.showToastWith(message, isButtonHidden: isButtonHidden, buttonTitle: buttonTitle, reloadButtonAction: reloadButtonAction)
        }
    }
    
    
    //MARK:- Action
    @IBAction func reloadButtonAction(_ sender: UIButton) {
        setVisiblityForDecreasedPopUp(isHidden: true, animated: true)
        if let handler = continueHandler {
            handler()
        }
    }
    
}
