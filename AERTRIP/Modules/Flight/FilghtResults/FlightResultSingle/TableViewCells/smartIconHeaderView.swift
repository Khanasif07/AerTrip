//
//  smartIconHeaderView.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 13/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class smartIconHeaderView: UICollectionReusableView {

    @IBOutlet weak var lineView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = UIColor.blue
        lineView.backgroundColor = UIColor(displayP3Red: ( 204.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 204 / 255.0), alpha: 1.0)
    }
    
}
