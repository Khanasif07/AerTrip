//
//  ViewProfileDetailTableViewSectionView.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileDetailTableViewSectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var topSeparatorView: ATDividerView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var topDividerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bottomSeparatorView: ATDividerView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
