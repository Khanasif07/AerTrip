//
//  BookingTravellerAddOnsTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 11/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerAddOnsTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var travellerCollectionView: UICollectionView!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var travellerAddonsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func registerXib() {
        self.travellerCollectionView.registerCell(nibName: BookingTravellerCollectionViewCell.reusableIdentifier)
        self.travellerCollectionView.registerCell(nibName: BookingTravellerAddOnsTableViewCell.reusableIdentifier)
        self.travellerCollectionView.dataSource = self
        self.travellerAddonsCollectionView.dataSource = self
        self.travellerCollectionView.delegate = self
        self.travellerAddonsCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewData Source and UICollectionViewDelegate methods

extension BookingTravellerAddOnsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
