//
//  ApplyCouponTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ApplyCouponTableViewCellDelegate: class {
    func removeCouponTapped()
}

class ApplyCouponTableViewCell: UITableViewCell {
    
    // MARK: -  IBOutlet
    
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var appliedCouponLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    // MARK: - Properties
    weak var delegate : ApplyCouponTableViewCellDelegate?
    

    // MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.manageLoader()
        self.setupFonts()
        self.setUpColors()
        self.setUpText()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.couponLabel.attributedText = nil
        self.appliedCouponLabel.attributedText = nil
    }

    // MARK: - Helper methods
    
    private func setupFonts() {
        couponLabel.font = AppFonts.Regular.withSize(18.0)
        appliedCouponLabel.font = AppFonts.Regular.withSize(18.0)

    }
    
    private func setUpColors() {
       couponLabel.textColor = AppColors.themeBlack
       appliedCouponLabel.textColor = AppColors.themeGreen
    }
    
    private func setUpText() {
        couponLabel.text = LocalizedString.ApplyCoupon.localized
    }
    
    @IBAction func removeCouponTapped(_ sender: Any) {
        delegate?.removeCouponTapped()
    }
    
    
    private func manageLoader() {
        self.indicator.style = .gray
        self.indicator.tintColor = AppColors.themeGreen
        self.indicator.color = AppColors.themeGreen
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
            self.closeButton.isHidden = !isHidden
        }
    }
   
}
