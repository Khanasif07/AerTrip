//
//  CheckInCheckOutView.swift
//  AERTRIP
//
//  Created by RAJAN SINGH on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CheckInOutView: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDay: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDay: UILabel!
    
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
        let nib = UINib(nibName: "CheckInOutView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        let fontSize16 = AppFonts.Regular.withSize(16.0)
        let fontSize26 = AppFonts.Regular.withSize(26.0)
        self.checkInLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkInLabel.textColor = AppColors.themeGray40
        self.checkOutLabel.font = fontSize16
        self.checkOutLabel.textColor = AppColors.themeGray40
        self.checkInDay.font = fontSize16
        self.checkInDay.textColor = AppColors.textFieldTextColor51
        self.checkOutDay.font = fontSize16
        self.checkOutDay.textColor = AppColors.textFieldTextColor51
        self.checkInDateLabel.font = fontSize26
        self.checkInDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkOutDateLabel.font = fontSize26
        self.checkOutDateLabel.textColor = AppColors.textFieldTextColor51
        self.totalNightsLabel.font = UIFont(name: AppFonts.SemiBold.rawValue, size: 14.0)
        self.totalNightsLabel.textColor = AppColors.themeGray40
    }
}
