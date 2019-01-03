//
//  AddFavouriteHotels.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class AddFavouriteHotels: UITableViewCell {

    @IBOutlet weak var titleLabe: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addFavouriteButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToHotelSearchVC()
    }
    
    func setupText() {
        self.titleLabe.textColor = AppColors.themeBlack
        self.titleLabe.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabe.text = LocalizedString.FavouriteHotels.localized
    }
}
