//
//  AerinHotelResultCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AerinHotelResultCardCollectionViewCellDelegate: class {
    func showAllButtonTapped()
}

class AerinHotelResultCardCollectionViewCell: UITableViewCell {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var hotelCardCollectionView: UICollectionView!
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
