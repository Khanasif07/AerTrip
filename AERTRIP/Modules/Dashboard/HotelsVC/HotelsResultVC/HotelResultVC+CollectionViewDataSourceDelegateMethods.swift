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
        self.collectionView.isHidden = self.viewModel.collectionViewLocArr.count == 0
        return self.viewModel.collectionViewLocArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.row]] as? [HotelSearched] else {
            return UICollectionViewCell()
        }
        
        //        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
        //        self.isFotterVisible = self.isAboveTwentyKm
        
        if hData.count > 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelGroupCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelGroupCardCollectionViewCell else {
                fatalError("HotelGroupCardCollectionViewCell not found")
            }
            
//            cell.contentView.backgroundColor = .green
//            cell.containerTopConstraint.constant = 29.0
//            cell.containerBottomConstraint.constant = -29.0
            cell.hotelListData = hData.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
//            cell.contentView.backgroundColor = .red
//            cell.containerTopConstraint.constant = 29.0
//            cell.containerBottomConstraint.constant = -29.0
            cell.hotelListData = hData.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let hData = (Array(self.viewModel.collectionViewList.values)[indexPath.row] as? [HotelSearched])
//        if hData?.count ?? 1 > 1 {
//            // grouped cell
//            return CGSize(width: UIDevice.screenWidth - 20.0, height: 230.0)
//        } else {
//            // single cell
//            return CGSize(width: UIDevice.screenWidth - 20.0, height: 200.0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? HotelGroupCardCollectionViewCell {
            self.expandGroup((self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[indexPath.row]] as? [HotelSearched]) ?? [])
        }
        else if let cell = collectionView.cellForItem(at: indexPath) as? HotelCardCollectionViewCell, let data = cell.hotelListData {
            self.selectedIndexPath = indexPath
            AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: data, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        printDebug("willDisplay")
//        let hData = (Array(self.viewModel.collectionViewList.values)[indexPath.row] as? [HotelSearched])?.first
//        let loc = CLLocationCoordinate2D(latitude: hData!.lat?.toDouble ?? 0.0, longitude: hData?.long?.toDouble ?? 0)
//        self.displayingHotelLocation = loc
//        updateMarker(coordinates: loc)
//    }
    
    
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        printDebug("willDisplay")
//        let hData = (Array(self.viewModel.collectionViewList.values)[indexPath.row] as? [HotelSearched])?.first
//        let loc = CLLocationCoordinate2D(latitude: hData!.lat?.toDouble ?? 0.0, longitude: hData?.long?.toDouble ?? 0)
//        self.displayingHotelLocation = loc
//        updateMarker(coordinates: loc)
//    }
}
