//
//  RouteFareInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RouteFareInfoTableViewCellDelegate: class {
    func viewDetailsButtonTapped()
}

class RouteFareInfoTableViewCell: UITableViewCell {
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var viewDetailButton: UIButton!
    
    // MARK: - Variables
    weak var delegate: RouteFareInfoTableViewCellDelegate?
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
        
    }

    
    
    private func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
        self.viewDetailButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    private func setUpTextColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.viewDetailButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.viewDetailButton.setTitle(LocalizedString.ViewDetails.localized, for: .normal)
    }
    
    func configureCell() {
        self.routeLabel.text = "Amsterdam → Czechslovakia"
        self.infoLabel.text = "18 Jul 2018 • Economy Super Saver (AGS024)"
    }
    
    @IBAction func viewDetailButtonTapped(_ sender: Any) {
        delegate?.viewDetailsButtonTapped()
    }
    
    
    
}
