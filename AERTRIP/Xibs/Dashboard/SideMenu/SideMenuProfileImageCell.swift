//
//  SideMenuProfileImageCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuProfileImageCell: UITableViewCell {


    @IBOutlet weak var profileSuperView: UIView!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var sepratorView: ATDividerView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Extension Setup Text
//MARK:-
extension SideMenuProfileImageCell {
    
    private func initialSetups() {
        self.viewProfileButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.viewProfileButton.titleLabel?.textColor = AppColors.themeGreen
        self.viewProfileButton.setTitle(LocalizedString.ViewProfile.localized, for: .normal)
    }
}
