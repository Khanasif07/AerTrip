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
    
    
    // MARK: - Variables
    weak var delegate : TravellerListHeaderViewDelegate?
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderWidth = 0.4
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
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
