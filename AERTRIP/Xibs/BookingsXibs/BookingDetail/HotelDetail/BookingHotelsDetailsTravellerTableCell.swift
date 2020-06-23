//
//  BookingHotelsDetailsTravellerTableCell.swift
//  AERTRIP
//
//  Created by Apple  on 16.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHotelsDetailsTravellerTableCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isToShowBottomView: Bool = true
    var guestDetails: [GuestDetail] = []
    
    var isForBooking: Bool = false {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = LocalizedString.TravellersAddOns.localized
        self.doInitialSetup()
        self.registerXib()
        
    }
    
    private func doInitialSetup() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    
    }
    
    private func registerXib() {
        self.collectionView.registerCell(nibName: BookingTravellerCollectionViewCell.reusableIdentifier)
    }
}

// MARK: - UICollectionViewDataSource UICollectionViewDataDelegate

extension BookingHotelsDetailsTravellerTableCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isForBooking ? self.guestDetails.count : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isForBooking {
            return  CGSize(width: collectionView.frame.width / 4 - 10, height: 122 )
        } else {
            return  CGSize(width: collectionView.frame.width / 4 - 10, height: 140 )
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isForBooking {
            guard let travellerCollectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookingTravellerCollectionViewCell", for: indexPath) as? BookingTravellerCollectionViewCell else {
                fatalError("BookingTravellerCollectionViewCell not found")
            }
            travellerCollectionCell.guestData = self.guestDetails[indexPath.item] //TODO:- pass the original data
            travellerCollectionCell.bottomSlideView.isHidden = !isToShowBottomView
            travellerCollectionCell.topConstraint.constant = 0.0
            return travellerCollectionCell
        } else {
            guard let travellerCollectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookingTravellerCollectionViewCell", for: indexPath) as? BookingTravellerCollectionViewCell else {
                fatalError("BookingTravellerCollectionViewCell not found")
            }
            travellerCollectionCell.paxData = nil //TODO:- pass the original data
            travellerCollectionCell.bottomSlideView.isHidden = !isToShowBottomView
            return travellerCollectionCell
        }
   
    }
    
    
}
