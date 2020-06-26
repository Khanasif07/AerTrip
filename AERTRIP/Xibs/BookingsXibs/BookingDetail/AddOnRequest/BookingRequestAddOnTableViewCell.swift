//
//  BookingRequestAddOnTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestAddOnTableViewCell: ATTableViewCell {
    
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var devideLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var communicationData: BookingCaseHistory.Communication? {
        didSet {
            self.configureCell()
        }
    }
    
    var isDeviderForLast:Bool = false{
        didSet{
            self.updateLeadingConstraint()
        }
    }
    var showLoader: Bool = false {
        didSet {
            if showLoader {
                self.arrowImageView.isHidden = true
                loader.startAnimating()
            } else {
                loader.stopAnimating()
                self.arrowImageView.isHidden = false
            }
        }
    }
    
    override func doInitialSetup()  {
        loader.color = AppColors.themeGreen
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.timeStampLabel.font = AppFonts.Regular.withSize(16.0)
        self.messageLabel.font = AppFonts.Regular.withSize(16.0)
        
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.timeStampLabel.textColor = AppColors.themeGray140
       self.messageLabel.textColor = AppColors.themeGray140
    }
    
    private func configureCell() {
        self.messageImageView.image = #imageLiteral(resourceName: "bookingEmailIcon")
        self.dotImageView.image = nil// #imageLiteral(resourceName: "greenDot")
        self.titleLabel.text = communicationData?.subject ?? LocalizedString.dash.localized
        self.messageLabel.text = ""//LocalizedString.dash.localized
        self.timeStampLabel.text = "\(communicationData?.commDate?.toString(dateFormat: "hh:mm aa") ?? "") "
        //self.timeStampLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "\(communicationData?.commDate?.toString(dateFormat: "hh:mm aa") ?? "") ", image: #imageLiteral(resourceName: "hotelCheckoutForwardArrow"), endText: "", font: AppFonts.Regular.withSize(16.0))
        
        self.showLoader = communicationData?.isEmailLoading ?? false
    }
    
    func updateLeadingConstraint(){
        self.devideLeadingConstraint.constant = (self.isDeviderForLast) ? 0 : 37
    }
    
}
