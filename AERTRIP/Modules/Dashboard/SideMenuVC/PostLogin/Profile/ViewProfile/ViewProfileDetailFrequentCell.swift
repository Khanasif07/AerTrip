//
//  ViewProfileDetailFrequentCell.swift
//  AERTRIP
//
//  Created by Admin on 02/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileDetailFrequentCell: UITableViewCell {
    
    
    
    @IBOutlet weak var frequentRightSubTitle: UILabel!
    @IBOutlet weak var frequentSubTitle: UILabel!
    @IBOutlet weak var frequentImage: UIImageView!
    @IBOutlet weak var frequentTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .red
        // Initialization code
    }
    func configureCellForFrequentFlyer(_ indexPath:IndexPath,_ logoUrl:String,_ flightName:String,_ flightNo:String,_ flightDetailCount: Int) {
        self.frequentImage.setImageWithUrl(logoUrl, placeholder: AppPlaceholderImage.frequentFlyer, showIndicator: true)
        self.frequentTitle.text = LocalizedString.FrequentFlyer.localized
        self.frequentRightSubTitle.text = flightNo
        self.frequentSubTitle.text = flightName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
