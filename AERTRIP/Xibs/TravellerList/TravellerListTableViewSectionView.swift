//
//  TravellerListTableViewSectionView.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerListTableViewSectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topSepratorView: ATDividerView!
    @IBOutlet weak var bottomSepratorView: ATDividerView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCell(_ title: String) {
        headerLabel.text = title.capitalizedFirst()
    }
}
