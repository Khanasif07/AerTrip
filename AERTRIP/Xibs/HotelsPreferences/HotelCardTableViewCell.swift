//
//  HotelCardTableViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 01/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCardTableViewCell: UITableViewCell {

    var hotels = [HotelsModel]()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var hotelCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Extension initialSetups
//MARK:-
extension HotelCardTableViewCell {
    
    func initialSetups() {
        
        self.registerXibs()
    }
    
    func registerXibs() {
        
        self.hotelCollectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.hotelCollectionView.dataSource = self
        self.hotelCollectionView.delegate     = self
    }
}

//MARK:- Extension initialSetups
//MARK:-
extension HotelCardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        cell.populateData(data: self.hotels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.hotels.count > 1 {
            
            return CGSize(width: (UIScreen.main.bounds.width - 26)/1.3, height: self.hotelCollectionView.height)
        } else {
            
            return CGSize(width: UIScreen.main.bounds.width - 16, height: self.hotelCollectionView.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.hotels.count > 1 {
            
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        } else {
            
            return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        
    }
}
