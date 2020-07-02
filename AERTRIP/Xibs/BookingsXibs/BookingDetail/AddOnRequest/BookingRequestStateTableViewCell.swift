//
//  BookingRequestStateTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum CaseStatus {
    case inProcess
    case actionRequired
    case none
   
    
    var title: String {
        switch self {
        case .inProcess:
            return LocalizedString.InProcess.localized
        case .actionRequired:
            return LocalizedString.ActionRequired.localized
        case .none :
            return ""
        
        }
    }
}

class BookingRequestStateTableViewCell: ATTableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptorLabel: UILabel!
    
    
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomContraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        self.titleLabel.attributedText = nil
        self.titleLabel.text = ""
    }
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.descriptorLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
          self.titleLabel.textColor =  AppColors.themeBlack
          self.descriptorLabel.textColor = AppColors.textFieldTextColor51
    }
    
    
    func configureCell(title: String , descriptor: String, status: CaseStatus) {
        self.titleLabel.text = title
        self.descriptorLabel.textColor = AppColors.textFieldTextColor51
        switch status {
        case .inProcess:
            self.descriptorLabel.text = status.title
            self.descriptorLabel.textColor = AppColors.themeYellow
        case .actionRequired:
             self.descriptorLabel.text = status.title
             self.descriptorLabel.textColor = AppColors.themeRed
        case .none:
            self.descriptorLabel.text = descriptor
        }
        if title.contains("Agent") {
            self.descriptorLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: #imageLiteral(resourceName: "telex"), endText: "  \(descriptor)", font: AppFonts.Regular.withSize(16.0))
        }
    }
  
}
