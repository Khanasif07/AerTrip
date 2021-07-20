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
        seatLabel.attributedText = nil
        seatLabel.font = AppFonts.Regular.withSize(14)
        seatLabel.textColor = AppColors.themeGray153
        selectionImageView.backgroundColor = AppColors.themeGreen.withAlphaComponent(0.6)
        contentView.backgroundColor = AppColors.themeWhiteDashboard
        nameLabel.textColor = AppColors.themeBlack
        nameLabel.backgroundColor = AppColors.clear
        seatLabel.backgroundColor = AppColors.clear
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
    }
    
    
    func populateData(data : ATContact) {
        self.nameLabel.text = "\(data.firstName) \(data.lastName)"
        
        let placeHolder = data.flImage ?? AppImages.ic_deselected_hotel_guest_adult
        self.passengerImageView.image = placeHolder
        
        if  !data.profilePicture.isEmpty {
            self.passengerImageView.setImageWithUrl(data.profilePicture, placeholder: placeHolder, showIndicator: false)
        }
        else {
            self.passengerImageView.image = AppGlobals.shared.getImageFor(firstName: data.firstName, lastName: data.lastName, font: AppFonts.Light.withSize(36.0),textColor: AppColors.grayWhite, offSet: CGPoint(x: 0, y: 12), backGroundColor: AppColors.imageBackGroundColor)
        }
        
    }
    
    func setupCellFor(_ passengerData: ATContact,_ selectedSeatData: SeatMapModel.SeatMapRow,_ seatDataArr: [SeatMapModel.SeatMapRow]) {
        populateData(data: passengerData)
        if passengerData.id == selectedSeatData.columnData.passenger?.id {
            selectionImageView.isHidden = false
            let attString = NSMutableAttributedString(string: selectedSeatData.columnData.ssrCode.replacingOccurrences(of: "-", with: "") + "・")
            attString.append(Double(selectedSeatData.columnData.amount).getConvertedAmount(using: AppFonts.Regular.withSize(14)))
//            seatLabel.text = selectedSeatData.columnData.ssrCode.replacingOccurrences(of: "-", with: "") + "・" + "₹ \(selectedSeatData.columnData.amount.formattedWithCommaSeparator)"
            
            seatLabel.attributedText = attString
        } else {
            selectionImageView.isHidden = true
            if let seat = seatDataArr.first(where: { $0.columnData.passenger?.id == passengerData.id }) {
                if seat.columnData.ssrCode != selectedSeatData.columnData.ssrCode {
                    
                    let attString = NSMutableAttributedString(string: seat.columnData.ssrCode.replacingOccurrences(of: "-", with: "") + "・")
                    attString.append(Double(seat.columnData.amount).getConvertedAmount(using: AppFonts.Regular.withSize(14)))
                    
                    seatLabel.attributedText = attString
                    
//                    seatLabel.text = seat.columnData.ssrCode.replacingOccurrences(of: "-", with: "") + "・" + "₹ \(seat.columnData.amount.formattedWithCommaSeparator)"
                } else {
                    seatLabel.attributedText = nil
                }
            } else {
                seatLabel.attributedText = nil
            }
        }
    }

}
