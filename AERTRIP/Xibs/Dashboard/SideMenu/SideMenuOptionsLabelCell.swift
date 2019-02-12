//
//  SideMenuOptionsLabelCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuOptionsLabelCell: UITableViewCell {

    @IBOutlet weak var displayTextLabel: UILabel!
    @IBOutlet weak var sepratorView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Extension Setup Text
//MARK:-
extension SideMenuOptionsLabelCell {
    
    private func initialSetups() {
        
        self.sepratorView.isHidden = true
        self.displayTextLabel.font      = AppFonts.Regular.withSize(20)
        self.displayTextLabel.textColor = AppColors.themeBlack
    }
    
    func populateData(text: String) {
        
        self.displayTextLabel.text = text
    }
}
