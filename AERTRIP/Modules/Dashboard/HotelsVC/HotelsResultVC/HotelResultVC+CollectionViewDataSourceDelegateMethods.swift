//
//  HotelResultVC+CollectionViewDataSourceDelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        guard let sections = self.fetchedResultsController.sections else {
        //            printDebug("No sections in fetchedResultsController")
        //            return 0
        //        }
        //        let sectionInfo = sections[section]
        //        if sectionInfo.numberOfObjects > 0 {
        //            self.shimmerView.removeFromSuperview()
        //        }
        return self.getHotelsForMapView().keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])
        
        //        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
        //        self.isFotterVisible = self.isAboveTwentyKm
        
        if hData?.count ?? 1 > 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelGroupCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelGroupCardCollectionViewCell else {
                fatalError("HotelGroupCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData?.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData?.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])
        
        if hData?.count ?? 1 > 1 {
            // grouped cell
            return CGSize(width: UIDevice.screenWidth, height: 230.0)
        } else {
            // single cell
            return CGSize(width: UIDevice.screenWidth, height: 200.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? HotelGroupCardCollectionViewCell {
            self.expandGroup((Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched] ?? []))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        printDebug("willDisplay")
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])?.first
        let loc = CLLocationCoordinate2D(latitude: hData!.lat?.toDouble ?? 0.0, longitude: hData?.long?.toDouble ?? 0)
        self.displayingHotelLocation = loc
        updateMarker(coordinates: loc)
    }
}
