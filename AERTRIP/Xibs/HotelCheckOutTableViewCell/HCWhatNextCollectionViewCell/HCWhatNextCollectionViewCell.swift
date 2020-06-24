//
//  HCWhatNextCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCWhatNextCollectionViewCell: UICollectionViewCell {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nextPlanLabel: UILabel!
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //UI
        self.shadowView.addShadow(cornerRadius: 13, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
        self.containerView.cornerRadius = 13.0
        self.containerView.clipsToBounds = true
        //Image
        self.flightImageView.image = #imageLiteral(resourceName: "flightIcon")
        //Font
        self.nextPlanLabel.font = AppFonts.SemiBold.withSize(22.0)
        //Text
        
        //Color
        self.nextPlanLabel.textColor = AppColors.textFieldTextColor51
       
    }
    
    ///COnfigure Cell
    internal func configCell() {
        
    }
}
