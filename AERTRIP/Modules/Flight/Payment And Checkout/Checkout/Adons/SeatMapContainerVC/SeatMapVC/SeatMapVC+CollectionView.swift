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
        return viewModel.deckColumnsCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.deckRowsCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeueSeatCell(collectionView, indexPath)
    }
    
    private func dequeueSeatCell(_ collectionView: UICollectionView,_ indexPath: IndexPath) -> SeatCollCell {
        
        guard let seatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollCell", for: indexPath) as? SeatCollCell else { return SeatCollCell() }
        
        let seatRelatedData = getSeatDataFor(indexPath)
        let rowStr = seatRelatedData.rowStr, columnStr = seatRelatedData.columnStr, seatData = seatRelatedData.seatData
        seatCell.setupViewModel(seatData, viewModel.flightFares, viewModel.setupFor)
        seatCell.setupCellFor(indexPath, rowStr, columnStr)
        return seatCell
    }
    
    private func getSeatDataFor(_ indexPath: IndexPath) -> seatRelatedInfo {
        var rowStr = ""
        if viewModel.deckData.rowsArr.indices.contains(indexPath.item - 1) {
            rowStr = viewModel.deckData.rowsArr[indexPath.item - 1]
        }
        var columnStr = ""
        if viewModel.deckData.columns.indices.contains(indexPath.section - 1) {
            columnStr = viewModel.deckData.columns[indexPath.section - 1]
        }
        var seatData = SeatMapModel.SeatMapRow()
        if let curRowIntValue = Int(rowStr), let curRow = viewModel.deckData.rows[curRowIntValue] {
            if let curSeatData = curRow[columnStr] {
                seatData = curSeatData
            }
        }
        return (rowStr, columnStr, seatData)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let seatRelatedData = getSeatDataFor(indexPath)
        if seatRelatedData.columnStr == "aisle" {
            return CGSize(width: 40, height: 30)
        }
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let curCell = collectionView.cellForItem(at: indexPath) as? SeatCollCell, curCell.viewModel.seatData.columnData.availability == .available else { return }
//        guard !checkIfSinglePassenger(curCell.viewModel.seatData) else { return }
        if presentedViewController == nil {
            let seatData = curCell.viewModel.seatData
            if seatData.columnData.postBooking {
                openPostSelectionSeatPopup(indexPath, seatData)
            } else {
                openPassengerSelectionVC(indexPath, seatData)
            }
        }
    }
    
//    private func checkIfSinglePassenger(_ seatData: SeatMapModel.SeatMapRow) -> Bool {
//        guard let passengersArr = GuestDetailsVM.shared.guests.first else { return false }
//        let adultPassengersArr = passengersArr.filter { $0.passengerType != .infant }
//        if adultPassengersArr.count == 1 {
//            if let passenger = adultPassengersArr.first {
//                setPassengerOnSeat(passenger, seatData)
//            }
//            return true
//        } else if adultPassengersArr.count > 1 {
//            return false
//        }
//        return false
//    }
    
    private func setPassengerOnSeat(_ passenger: ATContact,_ seatData: SeatMapModel.SeatMapRow) {
        viewModel.resetFlightData(passenger, seatData)
        self.seatMapCollView.reloadData()
        self.onReloadPlaneLayoutCall?(viewModel.flightData)
    }
    
    private func openPassengerSelectionVC(_ indexPath: IndexPath,_ seatData: SeatMapModel.SeatMapRow) {
        guard let curCell = seatMapCollView.cellForItem(at: indexPath) as? SeatCollCell else { return }
        var changesMade = false
        let originalFlightData = viewModel.flightData
        curCell.seatView.backgroundColor = AppColors.themeGreen
        let passengerVC = SelectPassengerVC.instantiate(fromAppStoryboard: .Adons)
        passengerVC.onDismissCompletion = { [weak self] in
            guard let self = self else { return }
            if changesMade && seatData.columnData.characteristic.contains("Exitrow"){
                self.openEmergencySeatPopup {[weak self] (agree) in
                    guard let self = self else { return }
                    if !agree {
                        self.viewModel.flightData = originalFlightData
                        self.seatMapCollView.reloadData()
                        self.onReloadPlaneLayoutCall?(originalFlightData)
                    }
                }
            }
            self.seatMapCollView.reloadItems(at: [indexPath])
        }
        passengerVC.selectPassengersVM.selectedSeatData = seatData
        passengerVC.selectPassengersVM.flightData = originalFlightData
        passengerVC.selectPassengersVM.setupFor = .seatSelection
        passengerVC.modalPresentationStyle = .overFullScreen
        passengerVC.updatedFlightData = { [weak self] flightData in
            guard let self = self else { return }
            self.viewModel.flightData = flightData
            self.seatMapCollView.reloadData()
            self.onReloadPlaneLayoutCall?(flightData)
            changesMade = true
        }
        present(passengerVC, animated: false, completion: nil)
    }
    
    private func openEmergencySeatPopup(agreed: @escaping ((Bool) -> ())) {
        let baggageTermsVC = BaggageTermsVC.instantiate(fromAppStoryboard: AppStoryboard.Adons)
        baggageTermsVC.baggageTermsVM.setupFor = .seats
        baggageTermsVC.modalPresentationStyle = .overFullScreen
        baggageTermsVC.baggageTermsVM.agreeCompletion = agreed
//        DispatchQueue.delay(0.5) {
            self.present(baggageTermsVC, animated: true, completion: nil)
//        }
    }
    
    private func openPostSelectionSeatPopup(_ indexPath: IndexPath,_ seatData: SeatMapModel.SeatMapRow) {
        guard let curCell = seatMapCollView.cellForItem(at: indexPath) as? SeatCollCell else { return }
        curCell.seatView.backgroundColor = AppColors.themeGreen
        let postSeatSelectionPopupVC = PostSelectionSeatPopupVC.instantiate(fromAppStoryboard: AppStoryboard.Rishabh_Dev)
        postSeatSelectionPopupVC.onDismissTap = { [weak self] in
            self?.seatMapCollView.reloadItems(at: [indexPath])
        }
        let seatTitle = seatData.columnData.seatNumber + " • ₹\(seatData.columnData.amount)"
        postSeatSelectionPopupVC.setTexts(seatTitle, seatData.columnData.getCharactericstic())
        postSeatSelectionPopupVC.modalPresentationStyle = .overFullScreen
        present(postSeatSelectionPopupVC, animated: false, completion: nil)
    }
}

extension SeatMapVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === seatMapCollView {
            let xMul = scrollView.contentOffset.x / scrollView.contentSize.width
            let yMul = scrollView.contentOffset.y / scrollView.contentSize.height
            let widthMul = scrollView.size.width / scrollView.contentSize.width
            let heightMul = scrollView.size.height / scrollView.contentSize.height
            let multipliers = visibleRectMultipliers(xMul, yMul, widthMul, heightMul)
            onScrollViewScroll?(multipliers)
        }
    }
}
