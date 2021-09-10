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
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //    var flightDetail: BookingFlightDetail? {
    //        didSet {
    //            self.collectionView.reloadData()
    //        }
    //    }
    
    var amenities = [String]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let numberOfItemInRow: Double = 3.0
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.registerXib()
        self.setColors()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setColors()
    }
    
    private func setColors(){
        self.contentView.backgroundColor = AppColors.themeBlack26
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
        return amenities.count //self.flightDetail?.amenities.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newW: CGFloat = collectionView.width / CGFloat(numberOfItemInRow) - 10.0
        let newH: CGFloat = 64//collectionView.height / CGFloat(self.flightDetail?.totalRowsForAmenities ?? 1)
        return  CGSize(width: newW, height: newH)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookingAmenityCollectionViewCell", for: indexPath) as? BookingAmenityCollectionViewCell else {
            fatalError("BookingAmenityCollectionViewCell not found ")
        }
        
        // cell.amenity = self.flightDetail?.amenities[indexPath.item]
        cell.amenityTitle.text = amenities[indexPath.item]
        if amenities[indexPath.row].contains(find: "Cabbin"){
            cell.amenityImageView.image = AppImages.cabinBaggage
        }else if amenities[indexPath.row].contains(find: "Check-in"){
            cell.amenityImageView.image = AppImages.checkingBaggageKg
        }else{
            cell.amenityImageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
