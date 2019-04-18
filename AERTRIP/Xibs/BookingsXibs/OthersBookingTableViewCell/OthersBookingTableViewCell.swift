//
//  OthersBookingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OthersBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookingTypeImgView: UIImageView!
    @IBOutlet weak var plcaeNameLabel: UILabel!
    @IBOutlet weak var travellersNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func configUI() {
        self.bookingTypeImgView.image = #imageLiteral(resourceName: "others")
        self.plcaeNameLabel.textColor = AppColors.themeBlack
        self.travellersNameLabel.textColor = AppColors.themeGray40
        self.plcaeNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.travellersNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.screensBackground.color
    }
    
    internal func configCell(plcaeName: String , travellersName: String , bookingTypeImg: UIImage , isOnlyOneCell: Bool ) {
        self.plcaeNameLabel.text = plcaeName
        self.travellersNameLabel.text = travellersName
        self.bookingTypeImgView.image = bookingTypeImg
        if isOnlyOneCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize(width: 0.0, height: 2.0), opacity: 0.7, shadowRadius: 2.0)
        } else {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize(width: 0.0, height: 2.0), opacity: 0.7, shadowRadius: 2.0)
        }
    }
}
