//
//  EventAdddedTripTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EventAdddedTripTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    var changeBtnHandler: (()->Void)? = nil
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventAddedLabel: UILabel!
    @IBOutlet weak var eventDescLabel: UILabel!
    @IBOutlet weak var changeButtonLabel: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    //Mark:- Functions
    //================
    private func configUI() {
        self.eventImageView.image = AppImages.trips.withRenderingMode(.alwaysTemplate)
        self.eventImageView.tintColor = AppColors.brightViolet
        //Font
        self.eventAddedLabel.font = AppFonts.Regular.withSize(14.0)
        self.eventDescLabel.font = AppFonts.Regular.withSize(18.0)
        self.changeButtonLabel.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        //Color
        self.eventAddedLabel.textColor = AppColors.themeGray40
        self.eventDescLabel.textColor = AppColors.textFieldTextColor51
        self.changeButtonLabel.setTitleColor(AppColors.themeGreen, for: .normal)
        //Text
        self.changeButtonLabel.setTitle(LocalizedString.Change.localized, for: .normal)
    }

    internal func configCell(tripName: String) {
        self.eventDescLabel.text = tripName
    }
    
    //Mark:- IBActions
    //================
    @IBAction func changeButtonActin(_ sender: UIButton) {
        if let handler = self.changeBtnHandler {
            handler()
        }
    }
}
