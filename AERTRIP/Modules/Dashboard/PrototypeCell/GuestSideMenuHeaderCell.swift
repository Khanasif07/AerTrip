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
      
        self.loginAndRegisterButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.loginAndRegisterButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.loginAndRegisterButton.layer.cornerRadius = self.loginAndRegisterButton.height/2
        self.loginAndRegisterButton.setTitle(LocalizedString.LoginOrRegister.localized, for: .normal)
        self.loginAndRegisterButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.loginAndRegisterButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.loginAndRegisterButton.setTitle(LocalizedString.LoginOrRegister.localized, for: .selected)
        self.loginAndRegisterButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
}
