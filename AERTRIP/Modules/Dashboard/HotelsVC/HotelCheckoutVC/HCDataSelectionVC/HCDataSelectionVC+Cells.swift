//
//  HCDataSelectionVC+Cells.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCDataSelectionRoomDetailCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet var roomNumberLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private(set) var forIndex: IndexPath?
    private let hotelFormData = HotelsSearchVM.hotelFormData
    
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
        
        roomNumberLabel.font = AppFonts.SemiBold.withSize(16.0)
        roomNumberLabel.textColor = AppColors.themeBlack
    }
    
    func configData(forIndexPath idxPath: IndexPath) {
        forIndex = idxPath
        roomNumberLabel.text = LocalizedString.Room.localized + " \(idxPath.row + 1)"
        collectionView.reloadData()
    }
    
    // Mark:- IBActions
    // Mark:-
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
        
        let height = (collectionView.height / ((totalCount <= 4) ? 1.0 : 2.0)) - 5.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let forIdx = forIndex, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDataSelectionRoomDetailsCollectionCell.reusableIdentifier, for: indexPath) as? HCDataSelectionRoomDetailsCollectionCell else {
            return UICollectionViewCell()
        }
        
        if GuestDetailsVM.shared.guests.count > forIdx.row, GuestDetailsVM.shared.guests[forIdx.row].count > indexPath.item {
            cell.contact = GuestDetailsVM.shared.guests[forIdx.row][indexPath.item]
        }
        else {
            var contact = ATContact(json: [:])
            
            if indexPath.item >= hotelFormData.adultsCount[forIdx.row] {
                let age = hotelFormData.childrenAge[forIdx.row][indexPath.item - hotelFormData.adultsCount[forIdx.row]]
                
                contact.passengerType = .child
                contact.numberInRoom = ((indexPath.item - hotelFormData.adultsCount[forIdx.row]) + 1)
                contact.age = age
            }
            else {
                
                contact.passengerType = .Adult
                contact.numberInRoom = (indexPath.item + 1)
                contact.age = -1
            }
            cell.contact = contact
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let forIndex = forIndex {
            if let controller = UIApplication.topViewController() as? HCDataSelectionVC {
                AppFlowManager.default.moveToGuestDetailScreen(delegate:controller,IndexPath(row: indexPath.item, section: forIndex.row))
            }
        }
    }
}

class HCDataSelectionPrefrencesCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
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
        titleLabel.font = AppFonts.Regular.withSize(18.0)
        titleLabel.textColor = AppColors.themeBlack
        titleLabel.text = LocalizedString.PreferencesSpecialRequests.localized
        
        descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        descriptionLabel.textColor = AppColors.themeGray40
        descriptionLabel.text = LocalizedString.Optional.localized
    }
    
    // Mark:- IBActions
    // Mark:-
}

class HCDataSelectionTextLabelCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    // Mark:- LifeCycles
    // Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        configUI()
    }
    
    // Mark:- Functions
    // Mark:-
    
    func configUI() {
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        titleLabel.textColor = AppColors.themeGray40
        titleLabel.text = LocalizedString.EmailMobileCommunicationMessageForBooking.localized
    }
    
    // Mark:- IBActions
    // Mark:-
}

class HCDataSelectionRoomDetailsCollectionCell: UICollectionViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    private(set) var isForAdult: Bool = false
    
    var contact: ATContact? {
        didSet {
            self.configData()
        }
    }
    
    // Mark:- LifeCycles
    // Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
    
    // Mark:- Functions
    // Mark:-
    
    private func configUI() {
        iconImageView.image = nil
        
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        titleLabel.textColor = AppColors.themeBlack
    }
    
    
    private func configData() {
        
        func setupForAdd() {
            infoImageView.image = #imageLiteral(resourceName: "add_icon")
            var finalText = ""
            if let type = self.contact?.passengerType {
                iconImageView.image = (type == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                
                finalText = "\((type == .Adult) ? LocalizedString.Adult.localized : LocalizedString.Child.localized) \(self.contact?.numberInRoom ?? 0)"
            }
            
            
            if let year = self.contact?.age, year >= 0 {
                finalText += " (\(year))"
            }
            titleLabel.text = finalText
        }
        
        self.iconImageView.cornerRadius = self.iconImageView.height / 2.0
        if let fName = self.contact?.firstName, let lName = self.contact?.lastName, let saltn = self.contact?.salutation {
            infoImageView.image = #imageLiteral(resourceName: "ic_info_incomplete")
            infoImageView.isHidden = true
            
            let placeHolder = self.contact?.flImage ?? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            self.iconImageView.image = placeHolder

            if (fName.isEmpty && lName.isEmpty && saltn.isEmpty) {
                infoImageView.isHidden = false
                setupForAdd()
            }
            else {
                infoImageView.isHidden = !(fName.isEmpty || lName.isEmpty || saltn.isEmpty)
                titleLabel.text = self.contact?.fullName
                if let img = self.contact?.profilePicture, !img.isEmpty {
                    self.iconImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
                    self.iconImageView.layer.borderColor = AppColors.themeGray40.cgColor
                    self.iconImageView.layer.borderWidth = 1.0
                }
                else {
                    self.iconImageView.image = self.contact?.flImage
                    self.iconImageView.layer.borderColor = AppColors.themeGray40.cgColor
                    self.iconImageView.layer.borderWidth = 1.0
                }
            }
        }
        else {
            setupForAdd()
        }
    }
    
    // Mark:- IBActions
    // Mark:-
}
