//
//  RangeTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 28/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class RangeTableViewCell: UITableViewCell {
    @IBOutlet weak var searchResultRangeLabel: UILabel!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var stepSlider: StepSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    
    private func initialSetup() {
        self.rangeView.layer.cornerRadius = 15.5
        setupTexts()
        setupColors()
        setupFonts()
        addCurrentLocationView()
    }
    
    func setupTexts() {
        self.searchResultRangeLabel.text = LocalizedString.SearchResultsRange.localized
    }
    
    func setupFonts() {
        self.searchResultRangeLabel.font = AppFonts.Regular.withSize(16.0)
        self.rangeLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    func setupColors() {
        self.rangeView.backgroundColor = AppColors.themeGray10
        self.rangeLabel.textColor = AppColors.themeBlack
        self.searchResultRangeLabel.textColor = AppColors.themeGray40

    }
    
    private func addCurrentLocationView() {
        let iconView = CityMarkerView(frame: CGRect(x: -4.0, y: (stepSlider.height - 30.0) / 2.0, width: 30.0, height: 30.0), shouldAddRippel: false)
        iconView.isUserInteractionEnabled = false
        stepSlider.addSubview(iconView)
        
        delay(seconds: 0.3) { [weak self] in
            guard let sSelf = self else {return}
            sSelf.stepSlider.bringSubviewToFront(iconView)
        }
    }
    
    func updateSliderValueOnLabel(range: Double) {
        if range > 20 {
           self.rangeLabel?.text = "All"
        } else {
        let rangeValue = "\((range))"
        self.rangeLabel?.text = "\((rangeValue.replacingOccurrences(of: ".0", with: "")))" + "km" //range.toInt >= 20 ? "Beyond \(range.toInt)km" : "Within " + "\((range.toInt))" + "km"
        }
    }
}
