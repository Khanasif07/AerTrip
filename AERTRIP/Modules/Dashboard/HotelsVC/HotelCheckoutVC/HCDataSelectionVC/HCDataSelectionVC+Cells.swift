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
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    private(set) var forIndex: IndexPath?
    private let hotelFormData = HotelsSearchVM.hotelFormData
    private var lineSpacing: CGFloat = 5
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
        
        roomNumberLabel.font = AppFonts.SemiBold.withSize(16.0)
        roomNumberLabel.textColor = AppColors.themeBlack
    }
    
    func configData(forIndexPath idxPath: IndexPath) {
        forIndex = idxPath
        roomNumberLabel.text = LocalizedString.Room.localized + " \(idxPath.row + 1)"
        let totalCount = hotelFormData.adultsCount[idxPath.row] + hotelFormData.childrenCounts[idxPath.row]
        var isEmptyText = true
        for i in stride(from: 0, to: 3, by: 1) {
        if GuestDetailsVM.shared.guests.count > idxPath.row, GuestDetailsVM.shared.guests[idxPath.row].count > i {
            let object = GuestDetailsVM.shared.guests[idxPath.row][i]
            if (!object.firstName.isEmpty || !object.lastName.isEmpty) {
               isEmptyText = false
            }
        }
        }
        lineSpacing = isEmptyText ? 12 : 5
        collectionView.reloadData()
        self.dividerView.isHidden = idxPath.row != 0
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
        return lineSpacing
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let forIdx = forIndex, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCDataSelectionRoomDetailsCollectionCell.reusableIdentifier, for: indexPath) as? HCDataSelectionRoomDetailsCollectionCell else {
            return UICollectionViewCell()
        }
        cell.isContinueButtonTapped = self.isContinueButtonTapped
        if GuestDetailsVM.shared.guests.count > forIdx.row, GuestDetailsVM.shared.guests[forIdx.row].count > indexPath.item {
            cell.contact = GuestDetailsVM.shared.guests[forIdx.row][indexPath.item]
        }
        else {
            var contact = ATContact(json: [:])
            
            if indexPath.item >= hotelFormData.adultsCount[forIdx.row] {
                let age = hotelFormData.childrenAge[forIdx.row][indexPath.item - hotelFormData.adultsCount[forIdx.row]]
                
                contact.passengerType = .Child
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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    
    func configureData(prefrenceNames: [String], request: String, other: String) {
        if prefrenceNames.isEmpty && request.isEmpty && other.isEmpty {
            descriptionLabel.text = LocalizedString.Optional.localized
        } else {
            var prefreence = [String]()
            if !prefrenceNames.isEmpty {
                prefreence.append(prefrenceNames.joined(separator: ", "))
            }
            if !other.isEmpty {
                prefreence.append(other)
            }
            if !request.isEmpty {
                prefreence.append(request)
            }
            
            descriptionLabel.text = prefreence.joined(separator: ", ")
        }
    }
}

class HCDataSelectionTextLabelCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
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
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameAgeContainer: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    
    var isContinueButtonTapped = false
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    // Mark:- Functions
    // Mark:-
    
    private func configUI() {
        self.layoutIfNeeded()
        iconImageView.image = nil
        
        firstNameLabel.font = AppFonts.Regular.withSize(14.0)
        firstNameLabel.textColor = AppColors.themeBlack
        
        lastNameLabel.font = AppFonts.Regular.withSize(14.0)
        lastNameLabel.textColor = AppColors.themeBlack
        
        ageLabel.font = AppFonts.Regular.withSize(14.0)
        ageLabel.textColor = AppColors.themeGray40
        
        resetView()
    }
    
    private func resetView() {
        lastNameLabel.isHidden = true
        ageLabel.isHidden = true
        lastNameAgeContainer.isHidden = true
        lastNameLabel.text = ""
        ageLabel.text = ""
    }
    
    private func configData() {
        
        func setupForAdd() {
            infoImageView.image = (!self.isContinueButtonTapped) ? #imageLiteral(resourceName: "greenFilledAdd") : #imageLiteral(resourceName: "ic_info_incomplete")
            var finalText = ""
            if let type = self.contact?.passengerType {
                iconImageView.image = (type == .Adult) ? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") : #imageLiteral(resourceName: "ic_deselected_hotel_guest_child")
                
                finalText = "\((type == .Adult) ? LocalizedString.Adult.localized : LocalizedString.Child.localized) \(self.contact?.numberInRoom ?? 0)"
            }
            var ageText = ""
            if let year = self.contact?.age, year > 0 {
                //ageLabel.text = "(\(year)y)"
                finalText += " (\(year)y)"
                ageText = "(\(year)y)"
            }
            ageLabel.isHidden = false
            lastNameAgeContainer.isHidden = false
            firstNameLabel.attributedText = self.atributedtedString(text: finalText, ageText: ageText)
        }
        
        self.iconImageView.cornerradius = self.iconImageView.height / 2.0
        if let fName = self.contact?.firstName, let lName = self.contact?.lastName, let saltn = self.contact?.salutation {
            infoImageView.image = #imageLiteral(resourceName: "ic_info_incomplete")
            infoImageView.isHidden = true
            
            let placeHolder = self.contact?.flImage ?? #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult")
            self.iconImageView.image = placeHolder

            if (fName.isEmpty && lName.isEmpty) {
                infoImageView.isHidden = false
                setupForAdd()
            }
            else {
                infoImageView.isHidden = !((fName.isEmpty || fName.count < 1) || (lName.isEmpty || lName.count < 1) || saltn.isEmpty)
                firstNameLabel.text = fName
                lastNameLabel.text = lName
                if !lName.isEmpty {
                    lastNameLabel.isHidden = false
                    lastNameAgeContainer.isHidden = false
                }
                
                if let img = self.contact?.profilePicture, !img.isEmpty {
                    self.iconImageView.setImageWithUrl(img, placeholder: placeHolder, showIndicator: false)
//                    self.iconImageView.layer.borderColor = AppColors.themeGray40.cgColor
//                    self.iconImageView.layer.borderWidth = 1.0
                }
                else {
                    self.iconImageView.image = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, font: AppFonts.Light.withSize(36.0),textColor: AppColors.themeGray60, offSet: CGPoint(x: 0, y: 12), backGroundColor: AppColors.imageBackGroundColor)
//                    self.iconImageView.layer.borderColor = AppColors.themeGray40.cgColor
//                    self.iconImageView.layer.borderWidth = 1.0
                }
                
                if let year = self.contact?.age, year > 0 {
                    ageLabel.text = "(\(year)y)"
                    ageLabel.isHidden = false
                    lastNameAgeContainer.isHidden = false
                }
            }
            
        }
        else {
            setupForAdd()
        }
    }
    
    // Mark:- IBActions
    // Mark:-
    
    func atributedtedString(text: String, ageText: String)-> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: AppFonts.Regular.withSize(14),
            .foregroundColor: AppColors.themeBlack
        ])
        attributedString.addAttribute(.foregroundColor, value: AppColors.themeGray40, range: (text as NSString).range(of: ageText))
        return attributedString
    }
}
//Travel Safety Guidelines
class HCDataSelectionTravelSafetyCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet weak var titleLabel: UILabel!
    
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
        titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        titleLabel.textColor = AppColors.themeBlack
        titleLabel.text = LocalizedString.TravelSafetyGuidelines.localized
        
        
    }
    
    
}




