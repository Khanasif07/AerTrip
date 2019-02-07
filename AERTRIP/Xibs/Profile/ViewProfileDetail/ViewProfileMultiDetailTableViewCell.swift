//
//  ViewProfileMultiDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import Kingfisher

class ViewProfileMultiDetailTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstTitleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstSubtTitleLabel: UILabel!
   
    @IBOutlet weak var secondTitleLabel: UILabel!
    
    @IBOutlet weak var secondSubTitleLabel: UILabel!
    
    @IBOutlet weak var frequentFlyerView: UIView!
    @IBOutlet weak var frequentFlyerImageView: UIImageView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    @IBOutlet weak var separatorView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cofigureCell(_ issueDate:String,_ expiryDate:String) {
        self.firstSubtTitleLabel.text = issueDate
        self.secondSubTitleLabel.text = expiryDate
    }
    
    
    func configureCellForFrequentFlyer(_ indexPath:IndexPath,_ logoUrl:String,_ flightName:String,_ flightNo:String) {
      //  self.frequentFlyerImageView.kf.setImage(with: URL(string: logoUrl))
        self.frequentFlyerImageView.setImageWithUrl(logoUrl, placeholder: AppPlaceholderImage.frequentFlyer, showIndicator: false)
            self.frequentFlyerLabel.text = flightName
        
            self.secondSubTitleLabel.text = flightNo
        
        if indexPath.row == 2 {
            firstTitleLabel.isHidden = false
             self.firstTitleLabel.text = "Frequent Flyer"
        } else {
            firstTitleLabel.isHidden = true
            firstTitleLabelHeightConstraint.constant = 0
        }
        
        
    }
    
    
    
}
