//
//  WhetherInfoTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var cityAndDateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var whetherLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.cityAndDateLabel.font = AppFonts.Regular.withSize(18.0)
        self.tempLabel.font = AppFonts.Regular.withSize(18.0)
        self.whetherLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    internal func configureCell(cityName: String , date: String , temp: String, upTemp: String , downTemp: String , isLastCell: Bool) {
        self.getCityNameWithDateLabel(cityName: cityName, date: date)
        self.tempLabel.text = "\(temp)\u{00B0}C"
        //\u{00B0}
        self.whetherLabel.text = "☀️  \(upTemp)\u{00B0}/ \(downTemp)\u{00B0}"
        self.containerViewBottomConstraint.constant = isLastCell ? 17.0 : 0.0
    }
    
    private func getCityNameWithDateLabel(cityName: String , date: String) {
        let attributedString = NSMutableAttributedString()
        let nameAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let dateAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
        let nameAttributedString = NSAttributedString(string: cityName, attributes: nameAttribute)
        let dateAttributedString = NSAttributedString(string: " " + date, attributes: dateAtrribute)
        attributedString.append(nameAttributedString)
        attributedString.append(dateAttributedString)
        self.cityAndDateLabel.attributedText = attributedString
    }
    
    
    //MARK:- IBActions
    //MARK:===========
    
}
