//
//  ATTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATTableViewCell: UITableViewCell {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.intitalSetup()
     
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupFonts()
        self.setupTexts()
        self.setupColors()
        self.doInitialSetup()
        
    }
    
    
    private func intitalSetup() {
        self.selectionStyle = .none
       
    }
    
    /// Setup Fonts
    @objc func setupFonts() {
        
    }
    
    /// Setup Colors
    @objc func setupColors() {
        
    }
    
    /// Setup Texts
    @objc func setupTexts() {
        
    }
    
    /// Do Inital setup
    
    @objc func doInitialSetup()  {
        
    }
    
    
}


class ATTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
