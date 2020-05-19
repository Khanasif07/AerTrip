//
//  SmartIconCell.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 12/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class SmartIconCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var superScript: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        superScript.text = ""
        imageView.image = nil
    }

}
