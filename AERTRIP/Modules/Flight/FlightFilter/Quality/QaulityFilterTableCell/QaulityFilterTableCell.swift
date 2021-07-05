//
//  QaulityFilterTableCell.swift
//  Aertrip
//
//  Created by Rishabh on 02/05/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class QaulityFilterTableCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var filterTitleLbl: UILabel!
    @IBOutlet weak var filterDescLbl: UILabel!
    @IBOutlet weak var selectDeselectImgView: UIImageView!
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: IBActions
    
    
    
    // MARK: Functions
    
    private func initialSetup() {
        
    }
    
    func configure(_ filter: QualityFilter) {
        
//        filterTitleLbl.font = UIFont(name: "SourceSansPro-Regular", size: 18)!
//        filterDescLbl.font = UIFont(name: "SourceSansPro-Regular", size: 14)!

        filterTitleLbl.font = AppFonts.Regular.withSize(18)
        filterDescLbl.font = AppFonts.Regular.withSize(14)

        filterTitleLbl.text = filter.name
        filterDescLbl.text = filter.getFilterDescription()
        
        if filter.isSelected {
            selectDeselectImgView.image = AppImages.CheckedGreenRadioButton
        }
        else {
            selectDeselectImgView.image = AppImages.UncheckedGreenRadioButton
        }
    }
}
