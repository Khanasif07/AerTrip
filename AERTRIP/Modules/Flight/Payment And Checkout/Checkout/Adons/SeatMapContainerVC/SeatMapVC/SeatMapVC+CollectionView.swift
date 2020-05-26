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
        return viewModel.flightData.md.columns.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flightData.md.rowsArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeueSeatCell(collectionView, indexPath)
    }
    
    private func dequeueSeatCell(_ collectionView: UICollectionView,_ indexPath: IndexPath) -> SeatCollCell {
        guard let seatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollCell", for: indexPath) as? SeatCollCell else { return SeatCollCell() }
        var rowStr = ""
        if viewModel.flightData.md.rowsArr.indices.contains(indexPath.item - 1) {
            rowStr = viewModel.flightData.md.rowsArr[indexPath.item - 1]
        }
        var columnStr = ""
        if viewModel.flightData.md.columns.indices.contains(indexPath.section - 1) {
            columnStr = viewModel.flightData.md.columns[indexPath.section - 1]
        }
        var seatData = SeatMapModel.SeatMapRow()
        if let curRowIntValue = Int(rowStr), let curRow = viewModel.flightData.md.rows[curRowIntValue] {
            if let curSeatData = curRow[columnStr] {
                seatData = curSeatData
            }
        }
        seatCell.setupCellFor(indexPath, rowStr, columnStr, seatData)
        return seatCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40, height: 40)
    }
}
