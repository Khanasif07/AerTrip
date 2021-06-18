//
//  CommunicationTextCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class CommunicationTextCell: UITableViewCell {

    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setColors()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setColors(){
        self.contentView.backgroundColor = AppColors.themeBlack26
    }
    
    func setupForTitlte(){
         self.selectionStyle = .none
        self.titleTextLabel.font = AppFonts.SemiBold.withSize(16)
        self.titleTextLabel.textColor = AppColors.themeBlack
        self.titleTextLabel.text = "Contact Details"
        self.labelTopConstraint.constant = 20
        self.labelBottomConstraint.constant = 8
        
    }
    
    func setupForCommunicationMsg(){
         self.selectionStyle = .none
        self.titleTextLabel.font = AppFonts.Regular.withSize(14)
        self.titleTextLabel.textColor = AppColors.themeGray40
        self.titleTextLabel.text = "This mobile number and email address will be used for all communication related to this booking."
        self.labelTopConstraint.constant = 6
        self.labelBottomConstraint.constant = 8
    }
    
}
