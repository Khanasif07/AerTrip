//
//  HCDataSelectionVC+Cells.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


class HCDataSelectionRoomDetailCell: UITableViewCell {
    
    //Mark:- IBOutlets
    //Mark:-
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var forIndex: IndexPath?
    private let hotelFormData = HotelsSearchVM.hotelFormData
    
    
    //Mark:- LifeCycles
    //Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.configUI()
    }
    
    //Mark:- Functions
    //Mark:-
    
    private func configUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        roomNumberLabel.font = AppFonts.SemiBold.withSize(16.0)
        roomNumberLabel.textColor = AppColors.themeBlack
    }
    
    func configData(forIndexPath idxPath: IndexPath) {
        forIndex = idxPath
        roomNumberLabel.text = LocalizedString.Room.localized + "\(idxPath.row + 1)"
        collectionView.reloadData()
    }
    
    //Mark:- IBActions
    //Mark:-
}

extension HCDataSelectionRoomDetailCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let forIdx = forIndex else {
            return 0
        }
        
        return hotelFormData.adultsCount[forIdx.row] + hotelFormData.childrenCounts[forIdx.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let forIdx = forIndex else {
            return CGSize.zero
        }
        
        // width = collectionView.width / <number of visible cell in row>
        let width = collectionView.width / 4.0
        let totalCount = hotelFormData.adultsCount[forIdx.row] + hotelFormData.childrenCounts[forIdx.row]
        
        let height = collectionView.height / ((totalCount <= 4) ? 1.0 : 2.0)
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let forIdx = forIndex, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDataSelectionRoomDetailsCollectionCell.reusableIdentifier, for: indexPath) as? HCDataSelectionRoomDetailsCollectionCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item >= hotelFormData.adultsCount[forIdx.row] {
            let age = hotelFormData.childrenAge[forIdx.row][indexPath.item-hotelFormData.adultsCount[forIdx.row]]
            cell.configData(isAdult: false, number: (indexPath.item + 1), age: age)
        }
        else {
            cell.configData(isAdult: true, number: (indexPath.item + 1), age: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let forIndex = forIndex {
            AppFlowManager.default.moveToGuestDetailScreen(IndexPath(row: indexPath.item, section: forIndex.row))
        }
        
    }
}


class HCDataSelectionPrefrencesCell: UITableViewCell {
    
    //Mark:- IBOutlets
    //Mark:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //Mark:- LifeCycles
    //Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.configUI()
    }
    
    //Mark:- Functions
    //Mark:-
    
    private func configUI() {
        titleLabel.font = AppFonts.Regular.withSize(18.0)
        titleLabel.textColor = AppColors.themeBlack
        titleLabel.text = LocalizedString.PreferencesSpecialRequests.localized
        
        descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        descriptionLabel.textColor = AppColors.themeGray40
        descriptionLabel.text = LocalizedString.Optional.localized
    }
    
    //Mark:- IBActions
    //Mark:-
}

class HCDataSelectionTextLabelCell: UITableViewCell {
    
    //Mark:- IBOutlets
    //Mark:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    //Mark:- LifeCycles
    //Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.configUI()
    }
    
    //Mark:- Functions
    //Mark:-
    
    func configUI() {
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        titleLabel.textColor = AppColors.themeGray40
        titleLabel.text = LocalizedString.EmailMobileCommunicationMessageForBooking.localized
    }
    
    //Mark:- IBActions
    //Mark:-
}

class HCDataSelectionRoomDetailsCollectionCell: UICollectionViewCell {
    
    //Mark:- IBOutlets
    //Mark:-
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private(set) var isForAdult: Bool = false
    
    //Mark:- LifeCycles
    //Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configUI()
    }
    
    //Mark:- Functions
    //Mark:-
    
    private func configUI() {
        iconImageView.image = nil
        
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        titleLabel.textColor = AppColors.themeBlack
    }
    
    func configData(isAdult: Bool, number: Int, age: Int?) {
        isForAdult = isAdult
        
        iconImageView.image = isAdult ? #imageLiteral(resourceName: "ic_add_adult") : #imageLiteral(resourceName: "ic_add_child")
        
        var finalText = "\(isAdult ? LocalizedString.Adult.localized : LocalizedString.Child.localized) \(number)"
        if let year = age {
            finalText += " (\(year))"
        }
        titleLabel.text = finalText
    }
    
    //Mark:- IBActions
    //Mark:-
}
