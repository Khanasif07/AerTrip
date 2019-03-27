//
//  RangeVC.swift
//  AERTRIP
//
//  Created by apple on 01/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RangeVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var searchResultRangeLabel: UILabel!
    @IBOutlet var rangeView: UIView!
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet var stepSlider: StepSlider!
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doInitialSetup()
        self.setUpRangeView()
        self.addCurrentLocationView()
    }
    
    // MARK: - Override methods
    
    private func doInitialSetup() {
        self.rangeView.layer.cornerRadius = 15.5
      
    }
    
    override func setupTexts() {
        self.searchResultRangeLabel.text = LocalizedString.SearchResultsRange.localized
    }
    
    override func setupFonts() {
        self.searchResultRangeLabel.font = AppFonts.Regular.withSize(16.0)
        self.rangeLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.rangeView.backgroundColor = AppColors.themeGray10
        self.rangeLabel.textColor = AppColors.textFieldTextColor51
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
    
    private func setUpRangeView() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            return
        }
        let range = UserInfo.hotelFilter != nil ? filter.distanceRange : HotelFilterVM.shared.distanceRange
        self.stepSlider.index = UInt(range.toInt)
        self.rangeLabel.text = "Within " + "\((range.toInt))" + "Km"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let value = (sender as AnyObject).index ?? 0
        self.rangeLabel.text = value >= 20 ? "\(value)Km above " : "Within " + "\(value)" + "Km"
        HotelFilterVM.shared.distanceRange = Double((sender as AnyObject).index ?? 0)
    }
}
