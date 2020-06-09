//
//  SeatMapContainerVC+Collection.swift
//  AERTRIP
//
//  Created by Rishabh on 09/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension SeatMapContainerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if allChildVCs.indices.contains(viewModel.currentIndex) {
            return allChildVCs[viewModel.currentIndex].viewModel.flightData.md.columns.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allChildVCs[viewModel.currentIndex].viewModel.flightData.md.rowsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let seatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutSeatCollCell", for: indexPath) as? LayoutSeatCollCell else {
            fatalError("Unable to dequeue LayoutSeatCollCell")
        }
        return seatCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightForSection = CGFloat(allChildVCs[viewModel.currentIndex].viewModel.flightData.md.columns.count)
        let maxHeight = collectionView.height/heightForSection
        return CGSize(width: maxHeight - 1, height: maxHeight - 1)
    }
    
}
