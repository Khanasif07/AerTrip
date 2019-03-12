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
    
    private func setUpRangeView() {
        guard let filter = UserInfo.loggedInUser?.hotelFilter else {
            printDebug("filter not found")
            return
        }
        let range = UserInfo.loggedInUser?.hotelFilter != nil ? filter.distanceRange : HotelFilterVM.shared.distanceRange
        self.stepSlider.index = UInt(range.toInt)
        self.rangeLabel.text = "Within " + "\((range.toInt))" + "Km"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        self.rangeLabel.text = "Within " + "\((sender as AnyObject).index ?? 0)" + "Km"
        HotelFilterVM.shared.distanceRange = Double((sender as AnyObject).index ?? 0)
    }
}
