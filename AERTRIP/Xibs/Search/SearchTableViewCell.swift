//
//  SearchTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchCodeLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ imageUrl: String, _ title: String, _ code: String) {
        let result = title.replacingOccurrences(of: "(\(code))", with: "",
                                              options: NSString.CompareOptions.literal, range: nil)
        self.searchImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.frequentFlyer, showIndicator: false)
        titleLabel.text = result
        searchCodeLabel.text = code
    }
}
