//
//  PassengerGridCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol PassengerGridSelectionDelegate: NSObjectProtocol {
    func didSelected(at indexPath: IndexPath)
}

class PassengerGridCell: UITableViewCell{
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var forIdx = IndexPath()
    private var lineSpacing: CGFloat = 5
    var totalPassenger:Int = 0
    var journeyType:JourneyType = .domestic
    var lastJourneyDate = Date()
    var isAllPaxInfoRequired = false
    weak var delegate: PassengerGridSelectionDelegate?
    var minMNS = 10
    var maxMNS = 10
    var isContinueButtonTapped = false
    // Mark:- LifeCycles
    // Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configUI()
    }
    
    // Mark:- Functions
    // Mark:-
    
    private func configUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configData(forIndexPath indexPath: IndexPath) {
        forIdx = indexPath
        self.contentView.backgroundColor = AppColors.themeBlack26
        collectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        self.collectionView.reloadData()
    }
    
    // Mark:- IBActions
    // Mark:-
}

extension PassengerGridCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard GuestDetailsVM.shared.guests.count != 0 else { return 0}
        return GuestDetailsVM.shared.guests[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView.frame.height != 0.0 else {
            return CGSize.zero
        }
        let width = collectionView.frame.width / 4.0
        let height = collectionView.frame.height
        var cellHeight : CGFloat = 0
        if (GuestDetailsVM.shared.guests[0].count)%4 == 0{
            let count = (GuestDetailsVM.shared.guests[0].count/4 == 0) ? 1 : (GuestDetailsVM.shared.guests[0].count)/4
            cellHeight = CGFloat(height / CGFloat(count))
        }else{
            cellHeight = CGFloat(height / CGFloat((GuestDetailsVM.shared.guests[0].count)/4 + 1))
        }
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassengerDetailsCell", for: indexPath) as? PassengerDetailsCell else {
            return UICollectionViewCell()
        }
        cell.isContinueButtonTapped = self.isContinueButtonTapped
        cell.journeyType = self.journeyType
        if GuestDetailsVM.shared.guests.count > forIdx.row, GuestDetailsVM.shared.guests[forIdx.row].count > indexPath.item {
            cell.innerCellIndex = indexPath
            cell.contact = GuestDetailsVM.shared.guests[forIdx.row][indexPath.item]
        }
        cell.lastJourneyDate = self.lastJourneyDate
        cell.isAllPaxInfoRequired = self.isAllPaxInfoRequired
        cell.minMNS = self.minMNS
        cell.maxMNS = self.maxMNS
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelected(at: indexPath)
    }
}
