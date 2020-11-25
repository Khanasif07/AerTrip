//
//  AccountLadgerDetailHeader.swift
//  AERTRIP
//
//  Created by apple on 17/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountLadgerDetailHeaderDelegate:NSObjectProtocol{
    func tapBookingButton()
}

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
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bookingIdButton: UIButton!
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    var ladgerEvent: AccountDetailEvent? {
        didSet {
            self.configureData()
        }
    }
    
    var onAccountEvent:OnAccountLedgerEvent?{
        didSet {
            self.configureForOnAccount()
        }
        
    }
    
    weak var delegate:AccountLadgerDetailHeaderDelegate?
    //MARK:- Life Cycle
    //MARK:-
    class func instanceFromNib(isFamily: Bool = false) -> AccountLadgerDetailHeader {
        let parentView = UINib(nibName: "AccountLadgerDetailHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AccountLadgerDetailHeader
        return parentView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bookingIdButton.isHidden = true
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
    
    @IBAction func tapBookingIdButton(_ sender: UIButton) {
        self.delegate?.tapBookingButton()
    }
    private func configureData() {
        self.layoutIfNeeded()
        guard let event = self.ladgerEvent else {
            self.resetAllSubviews()
            return
        }
        
        self.imageView.image = event.iconImage
        if event.voucher == .receipt {
            var ttlStr = event.title
            
            if !event.creditCardNo.isEmpty {
                ttlStr += "\n\(event.creditCardNo)"
            }
            self.titleLabel.text = ttlStr
            self.bookingIdKeyLabel.text = ""
            self.bookingIdValueLabel.text = ""
            self.bottomDetailContainer.isHidden = true
            self.bottomDetailContainerHeightConstraint.constant = 0.0
            self.bottomContainerBottomConstraint.constant = 0.0
        }
        else {
            if let atbTxt = event.attributedString{
                self.titleLabel.text = nil
                self.titleLabel.attributedText = atbTxt
            }else{
                self.titleLabel.attributedText = nil
                self.titleLabel.text = event.title
            }
//            self.titleLabel.text = event.title
            self.bookingIdKeyLabel.text = LocalizedString.BookingID.localized
            self.bookingIdValueLabel.text = event.bookingNumber
            self.bottomDetailContainer.isHidden = false
            self.bottomDetailContainerHeightConstraint.constant = 38.0
            self.bottomContainerBottomConstraint.constant = 22.0
        }
    }
    
    
    func configureForOnAccount(){
        
        self.layoutIfNeeded()
        guard let event = self.onAccountEvent else {
            self.resetAllSubviews()
            return
        }
        
        self.imageView.image = #imageLiteral(resourceName: "ic_acc_receipt")
        self.titleLabel.text = event.voucher.rawValue
        self.bookingIdKeyLabel.text = ""
        self.bookingIdValueLabel.text = ""
        self.bottomDetailContainer.isHidden = true
        self.bottomDetailContainerHeightConstraint.constant = 0.0
        self.bottomContainerBottomConstraint.constant = 0.0
    }
    
    //MARK:- Public
}
