//
//  ViewProfileDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileDetailTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var sepratorLeadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }

    
    func configureCell(_ title:String,_ content:String) {
        headerTitleLabel.text = title.capitalizedFirst()
        contentLabel.text = content
    }
}
