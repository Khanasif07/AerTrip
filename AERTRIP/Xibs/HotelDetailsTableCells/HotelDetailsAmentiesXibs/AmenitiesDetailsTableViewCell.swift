//
//  AmenitiesDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesDetailsTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    internal var amenitiesDetails: Amenities?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView! {
        didSet {
            self.amenitiesCollectionView.delegate = self
            self.amenitiesCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var dividerView: ATDividerView! {
        didSet {
            self.dividerView.backgroundColor = AppColors.themeBlack
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    ///Configure UI
    private func configureUI() {
        self.registerNibs()
    }
    
    ///Register Nibs
    private func registerNibs() {
        self.amenitiesCollectionView.registerCell(nibName: AmenitiesDetailsCollectionCell.reusableIdentifier)
    }
}

//Mark:- UICollectionView Delegate and DataSource
//===============================================
extension AmenitiesDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let safeAmenitiesData = self.amenitiesDetails?.main {
            return safeAmenitiesData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesDetailsCollectionCell", for: indexPath) as? AmenitiesDetailsCollectionCell else {
            return UICollectionViewCell()
        }
        if let safeAmenitiesData = self.amenitiesDetails?.main {
            cell.configureCell(amenitiesMainData: safeAmenitiesData[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: (collectionView.frame.width)/2 , height: (collectionView.frame.height)/5)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0//CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0//CGFloat.leastNonzeroMagnitude
    }
}
