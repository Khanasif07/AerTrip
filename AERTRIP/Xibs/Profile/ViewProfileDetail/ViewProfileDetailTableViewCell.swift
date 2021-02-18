//
//  ViewProfileDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import PhoneNumberKit

class ViewProfileDetailTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var sepratorLeadingConstraint: NSLayoutConstraint!
    
    enum CellType {
        case mobile
        case other
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }

    
    func configureCell(_ title:String,_ content:String, _ type: CellType = .other) {
        headerTitleLabel.text = title.capitalizedFirst()
        contentLabel.text = content
        
        if type == .mobile {
            do {
                let mobileNum = content
                let phoneNumber = try PhoneNumberKit().parse(mobileNum)
                print(phoneNumber)
                let formattedNumber = PhoneNumberKit().format(phoneNumber, toType: .international)
                contentLabel.text = formattedNumber
            } catch {
                
            }
        }
    }
}
