//
//  FareBreakupTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FareBreakupTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var greenTickImgView: UIImageView!
    @IBOutlet weak var passangersView: UIView!
    @IBOutlet weak var adultCountDisplayView: UIView!
    @IBOutlet weak var adultCountDisplayViewWidth: NSLayoutConstraint!
    @IBOutlet weak var adultCountLabel: UILabel!
    
    @IBOutlet weak var childrenCountDisplayView: UIView!
    @IBOutlet weak var childrenCountDisplayViewWidth: NSLayoutConstraint!
    @IBOutlet weak var childrenCountLabel: UILabel!
    
    @IBOutlet weak var infantCountDisplayView: UIView!
    @IBOutlet weak var infantCountDisplayViewWidth: NSLayoutConstraint!
    @IBOutlet weak var infantCountLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setColors()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setColors()
    }
    
    private func setColors(){
        backView.backgroundColor = AppColors.themeBlack26
        titleLabel.textColor = AppColors.themeBlack
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
