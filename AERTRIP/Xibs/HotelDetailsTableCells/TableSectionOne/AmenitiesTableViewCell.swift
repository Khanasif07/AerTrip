//
//  AmenitiesTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    let amenitiesItems: [UIImage] = [#imageLiteral(resourceName: "wifi_icon"),#imageLiteral(resourceName: "roomService_icon"),#imageLiteral(resourceName: "fitness_icon"),#imageLiteral(resourceName: "breakfast_icon"),#imageLiteral(resourceName: "business_icon"),#imageLiteral(resourceName: "internet_icon"),#imageLiteral(resourceName: "pool_icon"),#imageLiteral(resourceName: "restaurant_icon"),#imageLiteral(resourceName: "ac_icon"),#imageLiteral(resourceName: "spa_icon")]
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amenitiesCollectionView: UICollectionView! {
        didSet {
            self.amenitiesCollectionView.delegate = self
            self.amenitiesCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var viewAllButtonOutlet: UIButton!
    @IBOutlet weak var dividerView: UIView! {
        didSet {
            self.dividerView.backgroundColor = AppColors.divider.color
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
        //Text Font
        self.amenitiesLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.viewAllButtonOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        //Text Color
        self.amenitiesLabel.textColor = AppColors.themeBlack
        self.viewAllButtonOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        //Text SetUp
        self.amenitiesLabel.text = LocalizedString.Amenities.localized
        self.viewAllButtonOutlet.setTitle(LocalizedString.ViewAll.localized, for: .normal)
    }
    
    ///Register Nibs
    private func registerNibs() {
        let amenitiesNib = UINib(nibName: "AmenitiesCollectionCell", bundle: nil)
        self.amenitiesCollectionView.register(amenitiesNib, forCellWithReuseIdentifier: "AmenitiesCollectionCell")
    }
    
    
    @IBAction func viewAllBtnAction(_ sender: UIButton) {
    }
}

//Mark:- UICollectionView Delegate and DataSource
//===============================================
extension AmenitiesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amenitiesItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesCollectionCell", for: indexPath) as? AmenitiesCollectionCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        cell.configureCell(amenitiesItem: self.amenitiesItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: (collectionView.frame.width)/5 , height: (collectionView.frame.height)/2.308)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
