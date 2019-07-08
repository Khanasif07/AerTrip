//
//  AerinInfoSectionHeader.swift
//  ActiveLabel
//
//  Created by apple on 07/05/19.
//

import UIKit

class AerinInfoSectionHeader: UITableViewHeaderFooterView {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var sectionImageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.sectionTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.sectionTitleLabel.textColor = AppColors.themeTextColor
    }
    
    

  

}
