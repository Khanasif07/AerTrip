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
    @IBOutlet weak var noRoomsAvailable: UILabel!
    
    
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
//        self.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: AppConstants.appthemeGradientColors)
//        self.containerView.backgroundColor = AppColors.themeGreen
        self.fromLabel.textColor =  AppColors.unicolorWhite
        self.hotelFeesLabel.textColor =  AppColors.unicolorWhite
        self.selectRoomLabel.textColor =  AppColors.unicolorWhite
        self.noRoomsAvailable.textColor =  AppColors.unicolorWhite
        
        //Size
        let semiboldFontSize20 = AppFonts.SemiBold.withSize(20.0)
        self.fromLabel.font = AppFonts.Regular.withSize(14.0)
        self.hotelFeesLabel.font = semiboldFontSize20
        self.selectRoomLabel.font = semiboldFontSize20
        self.noRoomsAvailable.font = semiboldFontSize20
        
        //Text
        self.fromLabel.text = LocalizedString.From.localized
        self.selectRoomLabel.text = LocalizedString.SelectRoom.localized
        self.noRoomsAvailable.text = LocalizedString.NoRoomsAvailable.localized
    }
    
    func addSelectRoomTarget(target: Any?, action: Selector?) {
        self.selectRoomLabel.isUserInteractionEnabled = true
        let tapGeature = UITapGestureRecognizer(target: target, action: action)
        tapGeature.numberOfTapsRequired = 1
        self.selectRoomLabel.addGestureRecognizer(tapGeature)
    }
}
