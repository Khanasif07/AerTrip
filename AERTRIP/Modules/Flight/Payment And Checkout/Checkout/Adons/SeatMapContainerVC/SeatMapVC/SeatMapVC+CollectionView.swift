//
//  SeatMapVC+CollectionView.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension SeatMapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.seatLayout.getSeatSectionArr().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeueSeatCell(collectionView, indexPath)
    }
    
    private func dequeueSeatCell(_ collectionView: UICollectionView,_ indexPath: IndexPath) -> SeatCollCell {
        guard let seatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollCell", for: indexPath) as? SeatCollCell else { return SeatCollCell() }
        seatCell.seatLayout = viewModel.seatLayout
        seatCell.setupCellFor(indexPath)
        return seatCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40, height: 40)
    }
}
