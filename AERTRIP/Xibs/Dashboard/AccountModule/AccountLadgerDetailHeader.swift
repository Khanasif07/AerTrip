//
//  AccountLadgerDetailHeader.swift
//  AERTRIP
//
//  Created by apple on 17/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountLadgerDetailHeader: UIView {
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookingIdKeyLabel: UILabel!
    @IBOutlet weak var bookingIdValueLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var bottomDetailContainer: UIView!
    @IBOutlet weak var bottomDetailContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerBottomConstraint: NSLayoutConstraint!
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    var ladgerEvent: AccountDetailEvent? {
        didSet {
            self.configureData()
        }
    }

    //MARK:- Life Cycle
    //MARK:-
    class func instanceFromNib(isFamily: Bool = false) -> AccountLadgerDetailHeader {
        let parentView = UINib(nibName: "AccountLadgerDetailHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AccountLadgerDetailHeader
        return parentView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupSubView()
        self.configureData()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupSubView() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.bookingIdKeyLabel.font = AppFonts.Regular.withSize(14.0)
        self.bookingIdKeyLabel.textColor = AppColors.themeGray40
        
        self.bookingIdValueLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.bookingIdValueLabel.textColor = AppColors.themeBlack
    }
    
    private func resetAllSubviews() {
        self.imageView.image = nil
        self.titleLabel.text = ""
        self.bookingIdKeyLabel.text = ""
        self.bookingIdValueLabel.text = ""
    }
    
    private func configureData() {
        guard let event = self.ladgerEvent else {
            self.resetAllSubviews()
            return
        }
        
        self.imageView.image = event.iconImage
        if event.voucher == .debitNote {
            self.titleLabel.text = event.title + "\n" + event.creditCardNo
            self.bookingIdKeyLabel.text = ""
            self.bookingIdValueLabel.text = ""
            self.bottomDetailContainer.isHidden = true
            self.bottomDetailContainerHeightConstraint.constant = 0.0
            self.bottomContainerBottomConstraint.constant = 0.0
        }
        else {
            self.titleLabel.text = event.title
            self.bookingIdKeyLabel.text = LocalizedString.BookingID.localized
            self.bookingIdValueLabel.text = event.bookingId
            self.bottomDetailContainer.isHidden = false
            self.bottomDetailContainerHeightConstraint.constant = 38.0
            self.bottomContainerBottomConstraint.constant = 22.0
        }
    }
    
    //MARK:- Public
}
