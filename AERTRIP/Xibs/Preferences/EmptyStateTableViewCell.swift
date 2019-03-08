//
//  EmptyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EmptyStateTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UIImageView!
    @IBOutlet weak var emptyStateDescriptionLabel: UIImageView!
    @IBOutlet weak var empty: UIImageView!
    
    //Mark:- LifeCycles
    //=================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    
    private func configUI() {
        
    }
    
    internal func configCell() {
        
    }
}
