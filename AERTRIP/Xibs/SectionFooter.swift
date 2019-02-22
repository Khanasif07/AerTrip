//
//  SectionFooter.swift
//  AERTRIP
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SectionFooterDelegate: class {
    func showHotelBeyond()
}

class SectionFooter: UICollectionReusableView {

    @IBOutlet weak var showHotelBeyondButton: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    weak var delegate : SectionFooterDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        self.doInitialSetup()
        
       
        
    }
    
    // MARK: - Helper methods
    func doInitialSetup() {
        self.backgroundColor = .white
        self.showHotelBeyondButton.setTitle(LocalizedString.ShowHotelsBeyond.localized
            , for: .normal)
        self.showHotelBeyondButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.showHotelBeyondButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.showHotelBeyondButton.layer.cornerRadius = 5.0
        self.firstView.layer.cornerRadius = 4.0
        self.secondView.layer.cornerRadius = 3.0
        self.showHotelBeyondButton.addCardShadow(withColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2))
        self.firstView.addCardShadow(withColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5))
        self.secondView.addCardShadow(withColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2))
       
        
    }
    
    @IBAction func showHotelBeyond(_ sender: Any) {
        delegate?.showHotelBeyond()
    }
}
