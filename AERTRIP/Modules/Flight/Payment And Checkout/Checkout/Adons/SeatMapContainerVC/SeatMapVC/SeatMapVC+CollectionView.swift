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
        seatCell.setupViewModel(seatData, viewModel.flightFares)
        seatCell.setupCellFor(indexPath, rowStr, columnStr)
        return seatCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let curCell = collectionView.cellForItem(at: indexPath) as? SeatCollCell, curCell.viewModel.seatData.columnData.availability == .available && !curCell.viewModel.seatData.columnData.postBooking else { return }
        if presentedViewController == nil {
            openPassengerSelectionVC(indexPath, curCell.viewModel.seatData)
        }
    }
    
    private func openPassengerSelectionVC(_ indexPath: IndexPath,_ seatData: SeatMapModel.SeatMapRow) {
        let passengerVC = SelectPassengerVC.instantiate(fromAppStoryboard: .Adons)
        passengerVC.selectPassengersVM.seatModel = seatData
        passengerVC.selectPassengersVM.setupFor = .seatSelection
        passengerVC.modalPresentationStyle = .overFullScreen
        passengerVC.selectedPassengerForSeat = { [weak self] passenger in
            self?.savePassengerForSeat(indexPath, seatData, passenger)
        }
        present(passengerVC, animated: true, completion: nil)
    }
    
    private func savePassengerForSeat(_ indexPath: IndexPath,_ seatData: SeatMapModel.SeatMapRow,_ passenger: ATContact?) {
        
        var indexPaths = [IndexPath]()
        
        indexPaths.append(indexPath)
        
        seatMapCollView.visibleCells.forEach { (cell) in
            if let seatCell = cell as? SeatCollCell, let seatPassenger = seatCell.viewModel.seatData.columnData.passenger {
                if seatPassenger.id == passenger?.id {
                    if let index = seatCell.indexPath {
                        indexPaths.append(index)
                    }
                }
            }
        }
        
        viewModel.flightData.md.rows.forEach { (rowKey, row) in
            var newRow = row
            newRow.forEach { (columnKey, column) in
                var newColumn = column
                if newColumn.columnData.ssrCode == seatData.columnData.ssrCode {
                    newColumn.columnData.passenger = passenger
                } else {
                    if newColumn.columnData.passenger?.id == passenger?.id {
                        newColumn.columnData.passenger = nil
                        
                    }
                }
                
                newRow.updateValue(newColumn, forKey: columnKey)
            }
            
            viewModel.flightData.md.rows.updateValue(newRow, forKey: rowKey)
        }
        
        DispatchQueue.main.async {
            self.seatMapCollView.reloadData()
//            self.seatMapCollView.reloadItems(at: indexPaths)


        }
        
    }
}
