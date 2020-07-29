//
//  HotelDetailsCheckOutTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsCheckOutTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelFeesLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    //Mark:- PrivateFunctions
    //=======================
    
    private func manageLoader() {
        self.indicator.style = .gray
        self.indicator.tintColor = AppColors.themeWhite
        self.indicator.color = AppColors.themeWhite
        self.indicator.startAnimating()
        self.hideShowLoader(isHidden:true)
    }
    
    func hideShowLoader(isHidden:Bool){
        DispatchQueue.main.async {
            if isHidden{
                self.indicator.stopAnimating()
            }else{
                self.indicator.startAnimating()
            }
            self.bookLabel.isHidden = !isHidden
        }
    }
    
    ///ConfigureUI
    private func configureUI() {
        //Colors
        self.backgroundColor = .clear//AppColors.screensBackground.color
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
        self.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        self.containerView.backgroundColor = AppColors.themeGreen
        self.hotelFeesLabel.textColor = AppColors.themeWhite
        self.bookLabel.textColor = AppColors.themeWhite
        self.containerView.roundBottomCorners(cornerRadius: 10.0)
        //Size
        self.hotelFeesLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.bookLabel.font = AppFonts.SemiBold.withSize(20.0)
        
        //Text
        self.bookLabel.text = LocalizedString.Book.localized
        self.manageLoader()
    }
    
}
