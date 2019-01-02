//
//  GuestSideMenuHeaderCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class GuestSideMenuHeaderCell: UITableViewCell {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoTextImage: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var loginAndRegisterButton: ATButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var logoContainerView: UIView!
    
    
    //MARK:- TableViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
}

//MARK:- Extension Setup Text
//MARK:-
private extension GuestSideMenuHeaderCell {
    
    func initialSetups() {
        
        self.setupFontColorAndText()
    }
    
    func setupFontColorAndText() {
        
        self.loginAndRegisterButton.layer.cornerRadius = self.loginAndRegisterButton.height/2
        self.headerTitleLabel.font      = AppFonts.Regular.withSize(16)
        self.headerTitleLabel.textColor  = AppColors.themeBlack
        self.headerTitleLabel.text = LocalizedString.EnjoyAMorePersonalisedTravelExperience.localized
        self.loginAndRegisterButton.setTitle(LocalizedString.LoginOrRegister.localized, for: .normal)
    }
}
