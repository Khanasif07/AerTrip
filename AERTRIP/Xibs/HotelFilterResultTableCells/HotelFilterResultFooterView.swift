//
//  HotelFilterResultFooterView.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelFilterResultFooterView: UITableViewHeaderFooterView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var hotelFeesLabel: UILabel!
    @IBOutlet weak var selectRoomLabel: UILabel!
    
    
    //Mark:- LifeCycle
    //================
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        let nib = UINib(nibName: "HotelFilterResultFooterView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        //Colors
        let whiteColor = AppColors.themeWhite
        self.containerView.backgroundColor = AppColors.themeGreen
        self.fromLabel.textColor = whiteColor
        self.hotelFeesLabel.textColor = whiteColor
        self.selectRoomLabel.textColor = whiteColor
        
        //Size
        let semiboldFontSize20 = AppFonts.SemiBold.withSize(20.0)
        self.fromLabel.font = AppFonts.Regular.withSize(14.0)
        self.hotelFeesLabel.font = semiboldFontSize20
        self.selectRoomLabel.font = semiboldFontSize20
        
        //Text
        self.fromLabel.text = LocalizedString.From.localized
        self.hotelFeesLabel.text = "₹ 35,500"
        self.selectRoomLabel.text = LocalizedString.SelectRoom.localized
    }
}
