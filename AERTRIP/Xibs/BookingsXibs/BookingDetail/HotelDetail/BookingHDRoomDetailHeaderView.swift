//
//  BookingHDRoomDetailHeaderView.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
// Here HD stands for Hotel Detail
class BookingHDRoomDetailHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var roomDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        
    }
    
    // MARK: - Helper methods
    
    func setUpFont() {
        self.roomLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.roomTypeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.roomDetailLabel.font = AppFonts.Regular.withSize(14.0)
        
        
    }
    
    func setUpColor() {
        self.roomLabel.textColor = AppColors.themeBlack
        self.roomTypeLabel.textColor = AppColors.themeBlack
        self.roomDetailLabel.textColor = AppColors.themeBlack
        
    }
    
    
    func configureHeader(roomTitle: String,roomType: String,roomDescription: String) {
        self.roomLabel.text = roomTitle
        self.roomTypeLabel.text =  roomType
        self.roomDetailLabel.text = roomDescription
    }
    

}
