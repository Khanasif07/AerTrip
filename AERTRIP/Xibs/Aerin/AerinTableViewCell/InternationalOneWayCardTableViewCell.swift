//
//  InternationalOneWayCardTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class InternationalOneWayCardTableViewCell: UITableViewCell {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var internationCardCollectionView: UICollectionView!
    @IBOutlet weak var priceCollectionView: UICollectionView!
    @IBOutlet weak var showAllLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.doIntialSetup()
        
    }

   
    private func doIntialSetup() {
        self.showAllLabel.font = AppFonts.Regular.withSize(16.0)
        self.showAllLabel.textColor = AppColors.themeGray40
    }
    
    @IBAction func showAllButtonTapped(_ sender: Any) {
        
    }
    
    
}
