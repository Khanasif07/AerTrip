//
//  AmentityTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmentityTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flightDetail: BookingFlightDetail? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private let numberOfItemInRow: Double = 4.0
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.registerXib()
    }
    
    
    //MARK: - private helper methods
    
    
    func doInitialSetup() {
        self.collectionView.isScrollEnabled = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func registerXib()  {
        self.collectionView.registerCell(nibName: BookingAmenityCollectionViewCell.reusableIdentifier)
    }
}


// MARK:- UICollectionViewCell Datasource and Delegate methods

extension AmentityTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flightDetail?.amenities.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newW: CGFloat = collectionView.width / CGFloat(numberOfItemInRow) - 10.0
        let newH: CGFloat = collectionView.height / CGFloat(self.flightDetail?.totalRowsForAmenities ?? 1)
        return  CGSize(width: newW, height: newH)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookingAmenityCollectionViewCell", for: indexPath) as? BookingAmenityCollectionViewCell else {
            fatalError("BookingAmenityCollectionViewCell not found ")
        }
        
        cell.amenity = self.flightDetail?.amenities[indexPath.item]
        
        return cell
    }
    
}
