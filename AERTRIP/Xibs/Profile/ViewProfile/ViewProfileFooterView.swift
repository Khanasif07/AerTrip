//
//  ViewProfileFooterView.swift
//  AERTRIP
//
//  Created by Admin on 17/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileFooterView: UITableViewHeaderFooterView {

    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }
}
