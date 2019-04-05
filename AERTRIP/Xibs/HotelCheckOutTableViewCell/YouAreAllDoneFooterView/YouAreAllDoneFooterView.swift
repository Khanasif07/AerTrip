//
//  YouAreAllDoneFooterView.swift
//  AERTRIP
//
//  Created by Admin on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class YouAreAllDoneFooterView: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var returnHomeButton: UIButton!
    
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "YouAreAllDoneFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        //UI
        self.returnHomeButton.backgroundColor = AppColors.themeGreen
        self.returnHomeButton.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        //Text
        self.returnHomeButton.setTitle(LocalizedString.ReturnHome.localized, for: .normal)
        //Font
        self.returnHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        //Color
        self.returnHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    //Mark:- IBActions
    //================
    @IBAction func returnHomeButtonAction(_ sender: UIButton) {
        GuestDetailsVM.shared.guests.removeAll()
        AppFlowManager.default.popToRootViewController(animated: true)
    }
}

