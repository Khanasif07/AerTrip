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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ imageUrl:String,_ title:String, _ code : String) {
        self.searchImageView.kf.setImage(with: URL(string: imageUrl))
        titleLabel.text = title
        searchCodeLabel.text = code
    }
    
}
