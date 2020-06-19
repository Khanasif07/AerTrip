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
            return allChildVCs[viewModel.currentIndex].viewModel.deckColumnsCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allChildVCs[viewModel.currentIndex].viewModel.deckRowsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let seatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutSeatCollCell", for: indexPath) as? LayoutSeatCollCell else {
            fatalError("Unable to dequeue LayoutSeatCollCell")
        }
        let seatRelatedInfo = getSeatDataFor(indexPath)
        let columnStr = seatRelatedInfo.columnStr, seatData = seatRelatedInfo.seatData
        seatCell.populateCell(seatData, columnStr)
        return seatCell
    }
    
    private func getSeatDataFor(_ indexPath: IndexPath) -> SeatMapVC.seatRelatedInfo {
        let curDeckData = allChildVCs[viewModel.currentIndex].viewModel.deckData
        var rowStr = ""
        if curDeckData.rowsArr.indices.contains(indexPath.item) {
            rowStr = curDeckData.rowsArr[indexPath.item]
        }
        var columnStr = ""
        if curDeckData.columns.indices.contains(indexPath.section) {
            columnStr = curDeckData.columns[indexPath.section]
        }
        var seatData = SeatMapModel.SeatMapRow()
        if let curRowIntValue = Int(rowStr), let curRow = curDeckData.rows[curRowIntValue] {
            if let curSeatData = curRow[columnStr] {
                seatData = curSeatData
            }
        }
        return (rowStr, columnStr, seatData)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let seatRelatedInfo = getSeatDataFor(indexPath)
        if seatRelatedInfo.columnStr == "aisle" {
            let numberForSections = CGFloat(allChildVCs[viewModel.currentIndex].viewModel.deckData.columns.count)
            let maxHeight = collectionView.height/numberForSections
            let aisleHeight = maxHeight - (0.6 * maxHeight)
            return CGSize(width: maxHeight + (maxHeight * 0.27), height: aisleHeight)
        }
        
        let numberOfSections = CGFloat(allChildVCs[viewModel.currentIndex].viewModel.deckData.columns.count)
        let numberOfAisles = CGFloat(allChildVCs[viewModel.currentIndex].viewModel.deckData.columns.filter { $0.contains("aisle") }.count)
        let maxHeight = collectionView.height/numberOfSections
        let extraHeight = numberOfAisles * (maxHeight - (0.4 * maxHeight))
        let extraHeightForCell = extraHeight/(numberOfSections - numberOfAisles)
        return CGSize(width: maxHeight + (maxHeight * 0.27), height: maxHeight + extraHeightForCell)
    }
    
}

extension SeatMapContainerVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === planeLayoutScrollView {
            showPlaneLayoutView(!didBeginDraggingPlaneLayout)
        }
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView === planeLayoutScrollView {
            showPlaneLayoutView()
            didBeginDraggingPlaneLayout = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView === planeLayoutScrollView {
            didBeginDraggingPlaneLayout = true
        }
    }
}
