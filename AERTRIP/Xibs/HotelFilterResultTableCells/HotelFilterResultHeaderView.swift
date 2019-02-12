//
//  HotelFilterResultHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelFilterResultHeaderView: UITableViewHeaderFooterView {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonLabel: UIButton!
    
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
        let nib = UINib(nibName: "HotelFilterResultHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        //self.containerView.layer.cornerRadius = 10.0
        //self.containerView.layer.masksToBounds = true
        self.containerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.hotelNameLabel.textColor = AppColors.textFieldTextColor51
    }
}
