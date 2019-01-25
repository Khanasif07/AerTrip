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
    
    @IBOutlet var searchImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchCodeLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ imageUrl: String, _ title: String, _ code: String) {
        let result = title.replacingOccurrences(of: "(\(code))", with: "",
                                              options: NSString.CompareOptions.literal, range: nil)
        self.searchImageView.kf.setImage(with: URL(string: imageUrl))
        titleLabel.text = result
        searchCodeLabel.text = code
    }
}
