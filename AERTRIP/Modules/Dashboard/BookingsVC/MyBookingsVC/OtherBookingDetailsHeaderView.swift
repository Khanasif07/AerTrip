//
//  OtherBookingDetails.swift
//  AERTRIP
//
//  Created by Admin on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol OtherBookingDetailsHeaderViewDelegate: class {
    func backButtonAction()
    func optionButtonAction()
}

class OtherBookingDetailsHeaderView: UIView {
    
    //MARK:- Variables
    //MARK:-
    var delegate: OtherBookingDetailsHeaderViewDelegate?
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var bookingDataContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var bookingEventTypeImageView: UIImageView!
    @IBOutlet weak var bookingIdAndDateTitleLabel: UILabel!
    @IBOutlet weak var bookingIdAndDateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!

    //MARK:- LifeCycle
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //MARK:- Functions
    //MARK:-
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OtherBookingDetailsHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    private func configureUI() {
        //Text
        self.bookingIdAndDateTitleLabel.text = LocalizedString.BookingIDAndDate.localized
        
        //Fonts
        self.bookingIdAndDateTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.bookingIdAndDateLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Colors
        self.bookingIdAndDateTitleLabel.textColor = AppColors.themeGray40
        self.bookingIdAndDateLabel.textColor = AppColors.themeBlack

    }
    
    //MARK:- IBActions
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.backButtonAction()
    }
    
    @IBAction func optionButtonAction(_ sender: UIButton) {
        self.delegate?.optionButtonAction()
    }

}
