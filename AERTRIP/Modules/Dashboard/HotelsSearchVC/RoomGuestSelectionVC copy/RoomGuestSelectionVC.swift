//
//  RoomGuestSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RoomGuestSelectionVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = RoomGuestSelectionVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    override func setupTexts() {
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.selected)
    }
    
    override func setupColors() {
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }

    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        //background view
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        
        self.mainContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func show(animated: Bool) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraints.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {

        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraints.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func tappedOnBackgroundView(_ sender: UIGestureRecognizer) {
        self.hide(animated: true, shouldRemove: true)
    }
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.hide(animated: true, shouldRemove: true)
    }
}
