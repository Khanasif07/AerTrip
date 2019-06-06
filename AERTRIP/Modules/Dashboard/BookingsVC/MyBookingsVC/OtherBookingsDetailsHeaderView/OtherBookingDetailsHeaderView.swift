//
//  OtherBookingDetails.swift
//  AERTRIP
//
//  Created by Admin on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OtherBookingDetailsHeaderView: UIView {
    
    //MARK:- Variables
    //MARK:===========
    
    //MARK:- IBOutlets
    //MARK:===========
    
    @IBOutlet weak var bookingDataContainerView: UIView!
    @IBOutlet weak var bookingEventTypeImageView: UIImageView!
    @IBOutlet weak var bookingIdAndDateTitleLabel: UILabel!
    @IBOutlet weak var bookingIdAndDateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!

    //MARK:- LifeCycle
    //MARK:===========
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OtherBookingDetailsHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
//        self.configureUI()
    }
    
    internal func configureUI(bookingEventTypeImage: UIImage , bookingIdStr: String , bookingIdNumbers: String , date: String , isDividerView: Bool = true) {
        //Image
        self.bookingEventTypeImageView.image = bookingEventTypeImage
        
        //Text
        self.bookingIdAndDateTitleLabel.text = LocalizedString.BookingIDAndDate.localized
        self.attributeLabelSetUp(bookingIdStr: bookingIdStr, bookingIdNumbers: bookingIdNumbers, date: date)
        
        //Fonts
        self.bookingIdAndDateTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.bookingIdAndDateLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Colors
        self.bookingIdAndDateTitleLabel.textColor = AppColors.themeGray40
        self.bookingIdAndDateLabel.textColor = AppColors.themeBlack
        
        self.dividerView.isHidden = !isDividerView

    }
    
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(bookingIdStr: String , bookingIdNumbers: String , date: String) {
        let attributedString = NSMutableAttributedString()
        let stringAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let prefixAttributedString = NSAttributedString(string: bookingIdStr, attributes: stringAttribute)
        let numbersAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let postfixAttributedString = NSAttributedString(string: bookingIdNumbers, attributes: numbersAttribute)
        let dateAttributedString = NSAttributedString(string: " | " + date, attributes: stringAttribute)
        attributedString.append(prefixAttributedString)
        attributedString.append(postfixAttributedString)
        attributedString.append(dateAttributedString)
        self.bookingIdAndDateLabel.attributedText = attributedString
    }

    
    //MARK:- IBActions
    //MARK:===========
}
