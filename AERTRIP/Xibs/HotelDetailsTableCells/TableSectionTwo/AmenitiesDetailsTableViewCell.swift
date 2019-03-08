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
    let amenitiesItems: [UIImage] = [#imageLiteral(resourceName: "wifi_icon"),#imageLiteral(resourceName: "fitness_icon"),#imageLiteral(resourceName: "roomService_icon"),#imageLiteral(resourceName: "business_icon"),#imageLiteral(resourceName: "internet_icon"),#imageLiteral(resourceName: "pool_icon"),#imageLiteral(resourceName: "ac_icon"),#imageLiteral(resourceName: "breakfast_icon"),#imageLiteral(resourceName: "restaurant_icon"),#imageLiteral(resourceName: "spa_icon")]
    let amenitiesNames: [String] = [LocalizedString.Wi_Fi.localized,LocalizedString.Gym.localized,LocalizedString.RoomService.localized,LocalizedString.BusinessCenter.localized,LocalizedString.Internet.localized,LocalizedString.Pool.localized,LocalizedString.AirConditioner.localized,LocalizedString.Coffee_Shop.localized,LocalizedString.RestaurantBar.localized,LocalizedString.Spa.localized]
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView! {
        didSet {
            self.amenitiesCollectionView.delegate = self
            self.amenitiesCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var dividerView: ATDividerView!
    
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
        //Text Font
        //Text Color
//        self.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0)
        //Text SetUp
    }
    
    ///Register Nibs
    private func registerNibs() {
        let amenitiesNib = UINib(nibName: "AmenitiesDetailsCollectionCell", bundle: nil)
        self.amenitiesCollectionView.register(amenitiesNib, forCellWithReuseIdentifier: "AmenitiesDetailsCollectionCell")
    }
}

//Mark:- UICollectionView Delegate and DataSource
//===============================================
extension AmenitiesDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amenitiesItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesDetailsCollectionCell", for: indexPath) as? AmenitiesDetailsCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(amenitiesItem: self.amenitiesItems[indexPath.item], amenitiesName: self.amenitiesNames[indexPath.item])
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
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
