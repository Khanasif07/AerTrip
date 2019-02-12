//
//  BulkEnquirySuccessfulVC.swift
//  AERTRIP
//
//  Created by Admin on 07/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BulkEnquirySuccessfulVC: BaseVC {
    
    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bulkEnquiryLabel: UILabel!
    @IBOutlet weak var customerServiceLabel: UILabel!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        delay(seconds: 0.2) {
            self.setupViewForSuccessAnimation()
        }
    }
    
    override func setupFonts() {
        self.bulkEnquiryLabel.font = AppFonts.Bold.withSize(31.0)
        self.customerServiceLabel.font = AppFonts.Regular.withSize(15.0)
        self.doneBtnOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupColors() {
        self.bulkEnquiryLabel.textColor = AppColors.themeBlack
        self.customerServiceLabel.textColor = AppColors.themeBlack
        self.doneBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func setupTexts() {
        self.bulkEnquiryLabel.text = LocalizedString.BulkEnquirySent.localized
        self.customerServiceLabel.text = LocalizedString.CustomerServicesShallConnect.localized
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .normal)
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .selected)
        self.searchBtnOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
    }
    
    override func initialSetup() {
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        self.headerView.cornerRadius = 15.0
        self.headerView.layer.masksToBounds = true
    }
    //Mark:- Methods
    //==============
    //Private
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraint.constant = -(self.containerView.height + 100)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    ///SetUpViewForSuccess
    private func setupViewForSuccessAnimation() {
        self.searchBtnOutlet.setTitle(nil, for: .normal)
        self.searchBtnOutlet.setImage(#imageLiteral(resourceName: "Checkmark"), for: .normal)
        let reScaleFrame = CGRect(x: (self.containerView.width - 74.0) / 2.0, y: self.searchBtnOutlet.y, width: 74.0, height: 74.0)
        self.searchBtnOutlet.translatesAutoresizingMaskIntoConstraints = true
        
        let myLayer = CALayer()
        myLayer.backgroundColor = UIColor.clear.cgColor
        myLayer.frame = CGRect(x: (reScaleFrame.width - 20.0) / 2.0, y: (reScaleFrame.height - 20.0) / 2.0, width: 20.0, height: 20.0)
        self.searchBtnOutlet.layer.addSublayer(myLayer)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.searchBtnOutlet.frame = reScaleFrame
            self.searchBtnOutlet.myCornerRadius = reScaleFrame.height / 2.0
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            self.searchBtnOutlet.layer.cornerRadius = reScaleFrame.height / 2.0
            let yPerSafeArea = self.bulkEnquiryLabel.frame.origin.y + 26.0 + self.view.safeAreaInsets.bottom
            let tY = ((self.view.frame.height - reScaleFrame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y - yPerSafeArea
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.searchBtnOutlet.transform = t
                self.containerView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    private func finalTransFormation(reScaleFrame: CGRect) {
        
        let reScaleFrame = CGRect(x: (self.containerView.width - 62.0) / 2.0, y: reScaleFrame.origin.y, width: 62.0, height: 62.0)
        
        UIView.animateKeyframes(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), delay: 0.0, options: .calculationModeCubic, animations: {
            
            self.searchBtnOutlet.layer.cornerRadius = reScaleFrame.height / 2.0
            let yPerSafeArea = self.bulkEnquiryLabel.frame.origin.y + 26.0 + self.view.safeAreaInsets.bottom
            let tY = ((self.view.frame.height - reScaleFrame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y - yPerSafeArea
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.searchBtnOutlet.transform = t
                self.containerView.alpha = 1.0
            }, completion: nil)
            
        }, completion: nil)
    }
    
    //Mark:- IBActions
    //================
    
    @IBAction func doneBtnAction(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
    }
}
