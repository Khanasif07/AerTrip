//
//  TravellerListHeaderView.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TravellerListHeaderViewDelegate : class {
    func headerViewTapped()
}

class TravellerListHeaderView: UIView {
    // MARK: - IB Outlet
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLbel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var importingContactView: UIView!
    @IBOutlet weak var importingContactLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var importingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundView: UIView!
    // MARK: - Variables
    weak var delegate : TravellerListHeaderViewDelegate?
    var isImportContactViewVisible = false {
        didSet {
            manageImportContactView()
        }
    }
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderWidth = 0.4
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        
        importingContactLabel.font = AppFonts.Regular.withSize(16)
        timeLabel.font = AppFonts.Regular.withSize(14)
        
        importingContactLabel.textColor = AppColors.themeBlack
        timeLabel.textColor = AppColors.themeGray40
        
        importingContactLabel.text = LocalizedString.ImportingContacts.localized
        timeLabel.text = LocalizedString.ThisMightTakeSomeTime.localized
        
        importingContactView.backgroundColor = AppColors.themeGray04
        isImportContactViewVisible = false
    
        userTypeLbel.textColor = AppColors.grayWhite
        backgroundView.backgroundColor = AppColors.themeWhite
    }
    
    private func manageImportContactView() {
        self.importingViewHeightConstraint.constant = isImportContactViewVisible ? 60 : 0
        self.layoutIfNeeded()
    }
    
    // MARK: - Helper methods
    
    class func instanceFromNib() -> TravellerListHeaderView {
        return UINib(nibName: "TravellerListHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TravellerListHeaderView
    }
    
    @IBAction func headerViewTapped(_ sender: Any) {
        printDebug("Header view tapped")
        delegate?.headerViewTapped()
    }
    
}
