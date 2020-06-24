//
//  WhetherInfoTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum WeatherCellUsingFor {
    case hotel
    case flight
}

class WeatherInfoTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    var usingFor: WeatherCellUsingFor = .flight
    var weatherData: WeatherInfo? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - Public
    
    var isLastCell: Bool = false
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var cityAndDateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var whetherLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        cityAndDateLabel.font = AppFonts.Regular.withSize(18.0)
        tempLabel.font = AppFonts.Regular.withSize(18.0)
        whetherLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func configureCell() {
        let cityNameCode: String = "\(weatherData?.city ?? ""), \(weatherData?.countryCode ?? "")"
        getCityNameWithDateLabel(cityName: usingFor == .hotel ? "" : cityNameCode, date: weatherData?.date?.toString(dateFormat: usingFor == .hotel ? "E, d MMM" : "d MMM") ?? "")
        if weatherData?.maxTemperature == 0 || weatherData?.minTemperature == 0 {
           tempLabel.text = "   -         "
        } else if (weatherData?.temperature ?? 0) != 0 {
            tempLabel.text = "\(weatherData?.temperature ?? 0)\u{00B0}C"
        } else {
            tempLabel.text = ""
        }
//        tempLabel.text = weatherData?.maxTemperature == 0 || weatherData?.minTemperature == 0 ? "   -         " : "\(weatherData?.temperature ?? 0)\u{00B0}C"
        let code: String = String(weatherData?.weatherIcon.split(separator: "-").first ?? "")
        
        let iconWithText = AppGlobals.shared.getTextWithImage(startText: "", image: ATWeatherType(rawValue: code)!.icon, endText: "  \(weatherData?.maxTemperature ?? 0) \u{00B0}/ \(weatherData?.minTemperature ?? 0)\u{00B0}", font: AppFonts.Regular.withSize(18.0), isEndTextBold: false)
        whetherLabel.attributedText = weatherData?.maxTemperature == 0 ||
            weatherData?.minTemperature == 0 ? NSAttributedString(string: "              -") : iconWithText
        
        self.containerViewBottomConstraint.constant = self.isLastCell ? 26.0 : 0.0
    }
    
    // get city name with date attributes
    private func getCityNameWithDateLabel(cityName: String, date: String) {
        let attributedString = NSMutableAttributedString()
        let nameAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key: Any]
        let dateAtrribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: cityName.isEmpty ? AppColors.themeBlack : AppColors.themeGray40]
        let nameAttributedString = NSAttributedString(string: cityName, attributes: nameAttribute)
        let dateAttributedString = NSAttributedString(string: usingFor == .hotel ? ""  + date : " " + date, attributes: dateAtrribute)
        attributedString.append(nameAttributedString)
        attributedString.append(dateAttributedString)
        cityAndDateLabel.attributedText = attributedString
    }
}
