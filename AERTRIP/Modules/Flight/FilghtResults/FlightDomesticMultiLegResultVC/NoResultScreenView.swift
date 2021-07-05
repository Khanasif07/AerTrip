//
//  NoResultScreenView.swift
//  Aertrip
//
//  Created by  hrishikesh on 09/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

protocol NoResultScreenDelegate : AnyObject {
    func clearFilters()
    func restartFlightSearch()
    func resetPinnedFlight()
}


class NoResultScreenView : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var clearFilter: UIButton!
    @IBOutlet weak var TryAgain: UIButton!
    @IBOutlet weak var resetPinButton: UIButton!
    @IBOutlet weak var subTitleViewHeight: NSLayoutConstraint!
    weak var delegate : NoResultScreenDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoResultScreenView", owner: self, options: nil)
        addSubview(contentView)
        self.contentView.backgroundColor = AppColors.themeWhite
        contentView.frame = self.bounds
        clearFilter.setTitle("Clear Filters", for: .normal)
        clearFilter.setTitle("Clear Filters", for: .selected)
        TryAgain.setTitle("Try again!", for: .normal)
        TryAgain.setTitle("Try again!", for: .selected)
        resetPinButton.setTitle("View All Results", for: .normal)
        resetPinButton.setTitle("View All Results", for: .selected)
        subTitleViewHeight.constant = 84.0
        clearFilter.isHidden = false
        TryAgain.isHidden = true
        resetPinButton.isHidden = true
        
        
    }
    
    func showNoResultsMode(){
        
        headerLabel.text = "Flight Not Found"
        subTitle.text = "Try loading for other routes or dates."
        subTitleViewHeight.constant = 84.0
        TryAgain.isHidden = false
        clearFilter.isHidden = true
        resetPinButton.isHidden = true
        
    }
    
    @IBAction func clearFilterTapped(_ sender: Any) {
        delegate?.clearFilters()
    }
    
    
    func showNoFilteredResults(){
        
        headerLabel.text = "No results match your filters"
        subTitle.text = "Try different filters, or clear all."
        subTitleViewHeight.constant = 84.0
        clearFilter.isHidden = false
        TryAgain.isHidden = true
        resetPinButton.isHidden = true
    
    }
    
    
    func showResetPin(){
        
        headerLabel.text = "No Pinned Results"
        subTitle.text = ""
        subTitleViewHeight.constant = 0.0
        clearFilter.isHidden = true
        TryAgain.isHidden = true
        resetPinButton.isHidden = false
    
    }
    
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        delegate?.restartFlightSearch()
    }
    
    
    @IBAction func resetPinButtonTapped(_ sender: Any) {
        delegate?.resetPinnedFlight()
    }
    
}
