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

    func configureCell(_ title: String) {
        headerLabel.text = title.capitalizedFirst()
    }
}
