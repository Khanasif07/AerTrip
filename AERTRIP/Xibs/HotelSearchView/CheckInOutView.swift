//
//  CheckInCheckOutView.swift
//  AERTRIP
//
//  Created by RAJAN SINGH on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol CheckInOutViewDelegate: class {
    func selectCheckInDate(_ sender: UIButton)
    func selectCheckOutDate(_ sender: UIButton)
}

class CheckInOutView: UIView {
    
    //MARK:- Variables
    //MARK:===========
    weak var delegate: CheckInOutViewDelegate?
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDay: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDay: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    
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
    
    //MARK:- PrivateFunctions
    //MARK:==================
    ///InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CheckInOutView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        let fontSize16 = AppFonts.Regular.withSize(16.0)
        let fontSize26 = AppFonts.Regular.withSize(26.0)
        self.checkInLabel.font = fontSize16
        self.checkInLabel.textColor = AppColors.themeGray40
        self.checkOutLabel.font = fontSize16
        self.checkOutLabel.textColor = AppColors.themeGray40
        self.checkInDay.font = fontSize16
        self.checkInDay.textColor = AppColors.textFieldTextColor51
        self.checkOutDay.font = fontSize16
        self.checkOutDay.textColor = AppColors.textFieldTextColor51
        self.checkInDateLabel.font = fontSize26
        self.checkInDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkOutDateLabel.font = fontSize26
        self.checkOutDateLabel.textColor = AppColors.textFieldTextColor51
        self.totalNightsLabel.font = UIFont(name: AppFonts.SemiBold.rawValue, size: 14.0)
        self.totalNightsLabel.textColor = AppColors.themeGray40
        self.checkInLabel.text = LocalizedString.CheckIn.localized
        self.checkOutLabel.text = LocalizedString.CheckOut.localized
        self.totalNightsLabel.text = "20 \(LocalizedString.Nights.localized)"
    }
    
    //yyyy-MM-dd
    internal func setDates(fromData searchData: HotelFormPreviosSearchData) {
        let checkInDate = Date.getDateFromString(stringDate: searchData.checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "d MMM")
        self.checkInDateLabel.text = checkInDate
        let checkOutDate = Date.getDateFromString(stringDate: searchData.checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "d MMM")
        self.checkOutDateLabel.text = checkOutDate
        
        var totalNights = 0, checkOutDayStr = ""
        if !searchData.checkOutDate.isEmpty && !searchData.checkInDate.isEmpty {
            totalNights = searchData.checkOutDate.toDate(dateFormat: "yyyy-MM-dd")!.daysFrom(searchData.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date())
            checkOutDayStr = Date.getDateFromString(stringDate: searchData.checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE") ?? ""
        }
        self.totalNightsLabel.text = ""
        if totalNights != 0 {
          self.totalNightsLabel.text = (totalNights == 1) ? "\(totalNights) \(LocalizedString.Night.localized)" : "\(totalNights) \(LocalizedString.Nights.localized)"
        }
        self.checkInDay.text = Date.getDateFromString(stringDate: searchData.checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE")
        
        self.checkOutDay.text = checkOutDayStr
    }
    
    @IBAction func checkInDateButtonAction(_ sender: UIButton) {
        self.delegate?.selectCheckInDate(sender)
    }
    
    @IBAction func checkOutDateButtonAction(_ sender: UIButton) {
        self.delegate?.selectCheckOutDate(sender)
    }
}
