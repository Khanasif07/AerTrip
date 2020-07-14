//
//  OfflineDepositeTextImageCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

class OfflineDepositeTextImageCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var titleLabel: ActiveLabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingWithButton: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    var isHiddenButton: Bool = false {
        didSet {
            self.manageButton()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.valueLabel.text = ""
        self.valueLabel.isHidden = true
        
        self.manageButton()
    }
    
    private func manageButton() {
        selectionButton.isUserInteractionEnabled = false
        titleLeadingWithButton.constant = isHiddenButton ? 0.0 : 10.0
        buttonHeightConstraint.constant = isHiddenButton ? 0.0 : 22.0
    }
}
