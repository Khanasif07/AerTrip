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
}


class NoResultScreenView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var clearFilter: UIButton!
    @IBOutlet weak var TryAgain: UIButton!
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
        contentView.frame = self.bounds
        clearFilter.setTitle("Clear Filters", for: .normal)
        clearFilter.setTitle("Clear Filters", for: .selected)
        TryAgain.setTitle("Try again!", for: .normal)
        TryAgain.setTitle("Try again!", for: .selected)

        clearFilter.isHidden = false
        TryAgain.isHidden = true

    }
    
    func showNoResultsMode(){
        
        headerLabel.text = "Flight Not Found"
        subTitle.text = "Kindly re check your search or try looking for other routes or dates."
        
        TryAgain.isHidden = false
        clearFilter.isHidden = true
        
    }
    
    @IBAction func clearFilterTapped(_ sender: Any) {
        delegate?.clearFilters()
    }
    
    
    func showNoFilteredResults(){
        
        headerLabel.text = "No Results Available"
        subTitle.text = "We couldn’t find flights to match your filters. Try changing the filters, or reset them."
        clearFilter.isHidden = false
        TryAgain.isHidden = true
        
    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        delegate?.restartFlightSearch()
    }
}
