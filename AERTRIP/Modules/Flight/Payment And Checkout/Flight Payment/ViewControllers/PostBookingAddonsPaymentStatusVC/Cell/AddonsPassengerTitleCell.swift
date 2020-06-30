//
//  AddonsPassengerTitleCell.swift
//  AERTRIP
//
//  Created by Apple  on 26.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AddonsPassengerTitleCell: UITableViewCell {
//    enum CellUseFor {
//        case title, passenger
//    }
    
    // MARK: - Variables
    
    // MARK: ===========
    
//    var pnrStatus: PNRStatus = .active
//    var useType  = CellUseFor.title
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var travellerNameLabel: UILabel!
    @IBOutlet weak var travellerPnrStatusLabel: UILabel!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!

    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.travellerNameLabel.attributedText = nil
    }
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configUI() {
        self.containerView.layoutIfNeeded()
        // Font
        self.travellerNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.travellerPnrStatusLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Color
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.travellerPnrStatusLabel.textColor = AppColors.themeGray40
        

    }
    
    internal func configCell(title: NSAttributedString, type:String) {
        
        self.travellerNameLabel.attributedText = title
        self.travellerPnrStatusLabel.text = type
        
    }
        
    // MARK: - IBActions
    
    // MARK: ===========
}
