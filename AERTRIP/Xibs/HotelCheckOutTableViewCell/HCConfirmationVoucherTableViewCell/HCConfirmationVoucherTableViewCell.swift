//
//  HCConfirmationVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCConfirmationVoucherTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var confirmationVoucherLabel: UILabel!
    @IBOutlet weak var viewButton: ATButton!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
       
    var showLoader: Bool = false {
        didSet {
            if showLoader {
                loader.startAnimating()
            } else {
                loader.stopAnimating()
            }
            self.viewButton.isHidden = showLoader
        }
    }
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        loader.color = AppColors.themeGreen
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    
    override func prepareForReuse(){
        loader.color = AppColors.themeGreen
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        
        //view button
        self.viewButton.isShadowColorNeeded = true
        self.viewButton.shadowColor = AppColors.themeWhite
        self.viewButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.viewButton.setTitle(LocalizedString.View.localized, for: .normal)
        
        //Font
        self.confirmationVoucherLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.viewButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .normal)

        self.viewButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .selected)
        self.viewButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .highlighted)

        //Text
        self.confirmationVoucherLabel.text = LocalizedString.ConfirmationVoucher.localized
        self.viewButton.setTitle(LocalizedString.View.localized, for: .normal)
        
        //Color
        self.confirmationVoucherLabel.textColor = AppColors.themeBlack
        self.viewButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        self.dividerView.isHidden = true
    }
    
    ///COnfigure Cell
    internal func configCell() {
    }
}
