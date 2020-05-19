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
    
    private(set) var forIndex = IndexPath()
//    private let hotelFormData = HotelsSearchVM.hotelFormData
    private var lineSpacing: CGFloat = 5
    var totalPassenger:Int = 0
    var passengers = [Passenger]()
    weak var delegate: PassengerGridSelectionDelegate?
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
    
    func configData(forIndexPath indexPath: IndexPath, passengers:[Passenger]) {
        forIndex = indexPath
        self.passengers = passengers
//        roomNumberLabel.text = LocalizedString.Room.localized + " \(idxPath.row + 1)"
//        let totalCount = hotelFormData.adultsCount[idxPath.row] + hotelFormData.childrenCounts[idxPath.row]
//        var isEmptyText = true
//        for i in stride(from: 0, to: 3, by: 1) {
//            if GuestDetailsVM.shared.guests.count > idxPath.row, GuestDetailsVM.shared.guests[idxPath.row].count > i {
//                let object = GuestDetailsVM.shared.guests[idxPath.row][i]
//                if (!object.firstName.isEmpty || !object.lastName.isEmpty) {
//                    isEmptyText = false
//                }
//            }
//        }
//        lineSpacing = isEmptyText ? 12 : 5
        collectionView.reloadData()
    }
    
    
    // Mark:- IBActions
    // Mark:-
}

extension PassengerGridCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return passengers.count
        
//        guard let forIdx = forIndex else {
//            return 0
//        }
//
//        return  0//hotelFormData.adultsCount[forIdx.row] + hotelFormData.childrenCounts[forIdx.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let forIdx = forIndex else {
//            return CGSize.zero
//        }
  
        guard collectionView.frame.height != 0.0 else {
            return CGSize.zero
        }
        
        // width = collectionView.width / <number of visible cell in row>
        let width = collectionView.frame.width / 4.0
        let height = collectionView.frame.height
        var cellHeight : CGFloat = 0
        if (self.totalPassenger)%4 == 0{
            let count = ((self.passengers.count)/4 == 0) ? 1 : (self.passengers.count)/4
            cellHeight = CGFloat(height / CGFloat(count))
        }else{
            cellHeight = CGFloat(height / CGFloat((self.passengers.count)/4 + 1))
        }
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let forIdx = forIndex,
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PassengerDetailsCell", for: indexPath) as? PassengerDetailsCell else {
            return UICollectionViewCell()
        }
        cell.firstNameLabel.text = passengers[indexPath.row].title
//
//        if GuestDetailsVM.shared.guests.count > forIdx.row, GuestDetailsVM.shared.guests[forIdx.row].count > indexPath.item {
//            cell.contact = GuestDetailsVM.shared.guests[forIdx.row][indexPath.item]
//        }
//        else {
//            var contact = ATContact(json: [:])
//
//            if indexPath.item >= hotelFormData.adultsCount[forIdx.row] {
//                let age = hotelFormData.childrenAge[forIdx.row][indexPath.item - hotelFormData.adultsCount[forIdx.row]]
//
//                contact.passengerType = .child
//                contact.numberInRoom = ((indexPath.item - hotelFormData.adultsCount[forIdx.row]) + 1)
//                contact.age = age
//            }
//            else {
//
//                contact.passengerType = .Adult
//                contact.numberInRoom = (indexPath.item + 1)
//                contact.age = -1
//            }
//            cell.contact = contact
//
//        }
//
        return cell
//        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelected(at: indexPath)
    }
}
