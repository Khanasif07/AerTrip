//
//  InternationalRetunFlightResultTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol InternationalRetunFlightResultTableViewCellDelegate: class {
    func showAllButtonTapped()
}

class InternationalRetunFlightResultTableViewCell: UITableViewCell {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var internationalCardCollectionView: UICollectionView!
    @IBOutlet weak var priceCollectionView: UICollectionView!
    @IBOutlet weak var pageControl:ISPageControl!
    
    weak var delegate: InternationalRetunFlightResultTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }

   
    @IBAction func showAllButtonTapped(_ sender: Any) {
        delegate?.showAllButtonTapped()
    }
}
