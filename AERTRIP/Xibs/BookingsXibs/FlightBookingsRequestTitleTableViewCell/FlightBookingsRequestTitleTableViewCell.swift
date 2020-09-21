//
//  FlightBookingsRequestTitleTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightBookingsRequestTitleTableViewCell: UITableViewCell {
    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var requestTitleLabel: UILabel!
    @IBOutlet weak var requestLabelTopConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.requestTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.requestTitleLabel.textColor = AppColors.themeGray40
        self.requestTitleLabel.text = LocalizedString.Requests.localized
    }

    
    //MARK:- IBActions
    //MARK:===========
    
}
