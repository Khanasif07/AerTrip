//
//  HCDataSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCDataSelectionVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var hotelDetailsContainerView: UIView!
    @IBOutlet weak var continueContainerView: UIView!
    @IBOutlet weak var fareDetailContainerView: UIView!
    @IBOutlet weak var fareDetailBottomConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = HCDataSelectionVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        setupNavView()
        
        statusBarStyle = .default
        
        animateFareDetails(isHidden: true, animated: false)
        
        //setup continue button
        
        
        //setup hotelDetails
        
        //setup fare details
    }
    
    private func setupNavView() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.Guests.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "plusButton2"), selectedImage: #imageLiteral(resourceName: "plusButton2"))
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func toggleFareDetailView() {
        animateFareDetails(isHidden: fareDetailBottomConstraint.constant >= 0, animated: true)
    }
    private func animateFareDetails(isHidden: Bool, animated: Bool) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.fareDetailBottomConstraint.constant = isHidden ? -(sSelf.fareDetailContainerView.height) : 0.0
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self] (isDone) in
                
        })
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}


extension HCDataSelectionVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //plus button action
        toggleFareDetailView()
    }
}
