//
//  selectPassengerCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectPassengerCell: UICollectionViewCell {

    
    @IBOutlet weak var selectionImageView: UIView!
    @IBOutlet weak var passengerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passengerImageView.roundedCorners(cornerRadius: selectionImageView.frame.height/2)
        selectionImageView.roundedCorners(cornerRadius: selectionImageView.frame.height/2)
        seatLabel.text = ""
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
    }
    
    
    func populateData(data : ATContact) {
        self.nameLabel.text = "\(data.firstName) \(data.lastName)"
        
        let placeHolder = data.flImage ?? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
        self.passengerImageView.image = placeHolder
        
        if  !data.profilePicture.isEmpty {
            self.passengerImageView.setImageWithUrl(data.profilePicture, placeholder: placeHolder, showIndicator: false)
        }
        else {
            self.passengerImageView.image = AppGlobals.shared.getImageFor(firstName: data.firstName, lastName: data.lastName, font: AppFonts.Light.withSize(36.0),textColor: AppColors.themeGray60, offSet: CGPoint(x: 0, y: 12), backGroundColor: AppColors.imageBackGroundColor)
        }
        
    }
    
    func setupCellFor(_ passengerData: ATContact,_ seatData: SeatMapModel.SeatMapRow) {
        if passengerData.id == seatData.columnData.passenger?.id {
            selectionImageView.isHidden = false
            seatLabel.text = seatData.columnData.ssrCode + " . " + "\(seatData.columnData.amount)"
        } else {
            selectionImageView.isHidden = true
            seatLabel.text?.removeAll()
            
        }
    }

}
