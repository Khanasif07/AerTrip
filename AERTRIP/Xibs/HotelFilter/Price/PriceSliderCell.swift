//
//  PriceSliderCell.swift
//  AERTRIP
//
//  Created by Admin on 28/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PriceSliderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minimumPriceView: UIView!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var maximumPriceView: UIView!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let horizontalMultiSlider = MultiSlider()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }
    
    
    private func initialSetup() {
        setupTexts()
        setupColors()
        setupFonts()
        addSlider()
        setFilterValues()
    }
    
    func setupColors() {
        titleLabel.textColor = AppColors.themeGray40
        minimumPriceLabel.textColor = AppColors.themeBlack
        maximumPriceLabel.textColor = AppColors.themeBlack
        minimumPriceView.backgroundColor = AppColors.themeGray10
        maximumPriceView.backgroundColor = AppColors.themeGray10
    }
    
    func setupFonts() {
        titleLabel.font = AppFonts.Regular.withSize(16.0)
        minimumPriceLabel.font = AppFonts.Regular.withSize(14.0)
        maximumPriceLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func setupTexts() {
        titleLabel.text = LocalizedString.PricePerNight.localized
    }
    
    
    private func addSlider() {
        //horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        horizontalMultiSlider.orientation = .horizontal
        
        horizontalMultiSlider.isSettingValue = true
        horizontalMultiSlider.thumbCount = 2
        horizontalMultiSlider.snapStepSize = 1
        horizontalMultiSlider.tintColor = AppColors.themeGreen // color of the track
        horizontalMultiSlider.outerTrackColor = AppColors.themeGray10
        horizontalMultiSlider.trackWidth = 3
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.hasRoundTrackEnds = true
        horizontalMultiSlider.frame = CGRect(x: minimumPriceView.frame.origin.x + 16, y: minimumPriceView.frame.origin.y + minimumPriceView.height + 14, width: UIScreen.main.bounds.width - 66, height: 28.0)
        containerView.addSubview(horizontalMultiSlider)
        
    }
    
    func setFilterValues() {
        minimumPriceView?.layer.cornerRadius = 15.0
        maximumPriceView?.layer.cornerRadius = 15.0
        horizontalMultiSlider.minimumValue = CGFloat(HotelFilterVM.shared.minimumPrice)
        horizontalMultiSlider.maximumValue = CGFloat(HotelFilterVM.shared.maximumPrice)
        self.setPriceOnLabels()
    }
    
    func setPriceOnLabels() {
        minimumPriceLabel?.attributedText = Double(horizontalMultiSlider.value.first ?? 0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0)) //(AppConstants.kRuppeeSymbol + String(format: "%.0f", horizontalMultiSlider.value.first ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        maximumPriceLabel?.attributedText = Double(horizontalMultiSlider.value.last ?? 0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0)) //(AppConstants.kRuppeeSymbol + String(format: "%.0f", horizontalMultiSlider.value.last ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
    }
}

