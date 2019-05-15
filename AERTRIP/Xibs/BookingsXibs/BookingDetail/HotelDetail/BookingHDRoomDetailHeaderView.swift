//
//  BookingHDRoomDetailHeaderView.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHDRoomDetailHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var roomDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
    
    
    func configureCell() {
        self.roomLabel.text = "Room 1 - WWWWWWWWWW"
        self.roomTypeLabel.text = "Premier King Bed Ocean View"
        self.roomDetailLabel.text = "2 Twin Beds, Business Lounge Access, City View Business Lounge Access, City View"
    }
    

}
