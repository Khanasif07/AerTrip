//
//  SearchTagTableCell.swift
//  AERTRIP
//
//  Created by Admin on 04/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SearchTagTableCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    
    @IBOutlet weak var hotelTagName: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var dividerViewTrailingConstraints: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.hotelTagName.font = AppFonts.Regular.withSize(18.0)
        self.hotelTagName.textColor = AppColors.textFieldTextColor51
    }
}
