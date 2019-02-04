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
    
    
    
    
    
    // MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.doInitialSetup()
    }
    
    
    // MARK: - Override methods
    
     func doInitialSetup() {
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
    
    
    
    

 

}
