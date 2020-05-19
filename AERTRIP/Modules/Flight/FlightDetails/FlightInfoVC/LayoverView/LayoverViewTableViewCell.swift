//
//  LayoverViewTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 17/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class LayoverViewTableViewCell: UITableViewCell
{
    @IBOutlet weak var layoverView: UIView!
    @IBOutlet weak var overNightLayoverImg: UIImageView!
    @IBOutlet weak var layoverLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layoverView.layer.borderWidth = 0.5
        layoverView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        layoverView.layer.cornerRadius = layoverView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
