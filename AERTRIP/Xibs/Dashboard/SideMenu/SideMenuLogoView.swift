//
//  SideMenuLogoView.swift
//  AERTRIP
//
//  Created by Admin on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuLogoView: UIView {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTextView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    class func instanceFromNib() -> SideMenuLogoView {
        
        return UINib(nibName: "SideMenuLogoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SideMenuLogoView
        
//        Bundle.main.loadNibNamed("SideMenuLogoView", owner: self, options: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }
    
    private func initialSetup() {
        
    }
}
