//
//  PriceVC.swift
//  AERTRIP
//
//  Created by apple on 04/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PriceVC: BaseVC {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var minimumPriceView: UIView!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    
    @IBOutlet weak var maximumPriceView: UIView!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    
    // MARK: - Variables
//    let minimum : CGFloat = CGFloat(HotelFilterVM.shared.minimumPrice)
//    let maximum : CGFloat = CGFloat(HotelFilterVM.shared.maximumPrice)
    let minimum : CGFloat = 1000
    let maximum : CGFloat = 10000
    let horizontalMultiSlider = MultiSlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetup()
        addSlider()
    }
    
    
   
 
    
    
    // MARK:- Override methods

    // MARK: - Helper methods
    func addSlider() {
      
         horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = minimum
        horizontalMultiSlider.maximumValue = maximum
      //  horizontalMultiSlider.value = [minimum,maximum]
       
        horizontalMultiSlider.thumbCount = 2
        horizontalMultiSlider.tintColor =  AppColors.themeGreen  // color of the track
        horizontalMultiSlider.outerTrackColor = AppColors.themeGray10
        horizontalMultiSlider.trackWidth = 3
        horizontalMultiSlider.showsThumbImageShadow = true
        horizontalMultiSlider.hasRoundTrackEnds = true
        horizontalMultiSlider.frame = CGRect(x: minimumPriceView.frame.origin.x + 16, y: minimumPriceView.frame.origin.y + 24, width: UIScreen.main.bounds.width - 66, height: 28.0)
        view.addSubview(horizontalMultiSlider)
    }
    
    func doInitialSetup(){
        minimumPriceView.layer.cornerRadius = 15.0
        maximumPriceView.layer.cornerRadius = 15.0
        minimumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(minimum)").asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        maximumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(maximum)").asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
       
    }
    
    
    override func setupColors() {
        titleLabel.textColor = AppColors.themeGray40
        //titleLabel.textColor = AppColors.themeRed

        minimumPriceLabel.textColor = AppColors.textFieldTextColor51
        maximumPriceLabel.textColor = AppColors.textFieldTextColor51
        minimumPriceView.backgroundColor = AppColors.themeGray10
        maximumPriceView.backgroundColor = AppColors.themeGray10
    }
    
    override func setupFonts() {
        titleLabel.font = AppFonts.Regular.withSize(16.0)
        minimumPriceLabel.font = AppFonts.Regular.withSize(14.0)
        maximumPriceLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        titleLabel.text = LocalizedString.PricePerNight.localized
    }
    
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("\(slider.value)")
        //"\u{20B9} " +
        minimumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + String(format: "%.2f", slider.value.first ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        HotelFilterVM.shared.minimumPrice = Double(slider.value.first ?? 0.0).roundTo(places: 2)
        HotelFilterVM.shared.maximumPrice = Double(slider.value.last ?? 0.0).roundTo(places: 2)
        maximumPriceLabel.attributedText =  (AppConstants.kRuppeeSymbol + String(format: "%.2f", slider.value.last ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
    }

}
