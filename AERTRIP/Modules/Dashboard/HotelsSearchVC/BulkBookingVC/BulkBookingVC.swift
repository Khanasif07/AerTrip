//
//  BulkBookingVC.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BulkBookingVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = BulkBookingVM()
    
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        
        cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        
        titleLabel.text = LocalizedString.BulkBooking.localized
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
    }
    
    override func setupColors() {
        
        titleLabel.textColor = AppColors.themeBlack
        
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
    }
    
    override func bindViewModel() {
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        
        self.mainContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func show(animated: Bool) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}
