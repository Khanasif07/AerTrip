//
//  WhetherInfoTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var cityAndDateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var whetherLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.cityAndDateLabel.font = AppFonts.Regular.withSize(18.0)
        self.tempLabel.font = AppFonts.Regular.withSize(18.0)
        self.whetherLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    internal func configureCell(cityName: String, date: String, temp: Int, upTemp: Int, downTemp: Int, isLastCell: Bool) {
        self.getCityNameWithDateLabel(cityName: cityName, date: date)
        self.tempLabel.text = temp == 0 ? "_" : "\(temp)\u{00B0}C"
        // \u{00B0}
        self.whetherLabel.text = upTemp == 0 || downTemp == 0 ? "_" : "☀️  \(upTemp)\u{00B0}/ \(downTemp)\u{00B0}"
        self.containerViewBottomConstraint.constant = isLastCell ? 17.0 : 0.0
    }
    
    private func getCityNameWithDateLabel(cityName: String, date: String) {
        let attributedString = NSMutableAttributedString()
        let nameAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key: Any]
        let dateAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: cityName.isEmpty ? AppColors.themeBlack : AppColors.themeGray40]
        let nameAttributedString = NSAttributedString(string: cityName, attributes: nameAttribute)
        let dateAttributedString = NSAttributedString(string: " " + date, attributes: dateAtrribute)
        attributedString.append(nameAttributedString)
        attributedString.append(dateAttributedString)
        self.cityAndDateLabel.attributedText = attributedString
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}
