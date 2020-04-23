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
    
    @IBOutlet weak var searchResultRangeLabel: UILabel!
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var stepSlider: StepSlider!
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialSetup()
        //self.setFilterValues()
        self.addCurrentLocationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFilterValues()
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
    
    func setFilterValues() {
        let filter = UserInfo.hotelFilter
        let range = filter?.distanceRange ?? HotelFilterVM.shared.distanceRange
        self.stepSlider?.index = UInt(range.toInt)
        self.rangeLabel?.text = range.toInt >= 20 ? "Beyond \(range.toInt)km" : "Within " + "\((range.toInt))" + "km"
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let value = (sender as AnyObject).index ?? 0
        self.rangeLabel.text = value >= 20 ? "Beyond \(value)km" : "Within " + "\(value)" + "km"
        HotelFilterVM.shared.distanceRange =  Double((sender as AnyObject).index ?? 0)
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
    }
}
