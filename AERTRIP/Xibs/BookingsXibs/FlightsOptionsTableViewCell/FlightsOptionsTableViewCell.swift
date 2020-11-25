//
//  FlightsOptionsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum UsingFor {
    case flight
    case hotel
}

protocol FlightsOptionsTableViewCellDelegate: class {
    func openWebCheckin()
    func openDirections()
    func openCallDetail()
    func addToCalendar()
    func share()
    func bookSameFlight()
    func addToTrips()
}

extension FlightsOptionsTableViewCellDelegate {
    func addToCalendar() {}
    func share() {}
    func bookSameFlight() {}
}

class FlightsOptionsTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    weak var delegate: FlightsOptionsTableViewCellDelegate?
    
    var optionImages = [#imageLiteral(resourceName: "bookingsWebCheckin"), #imageLiteral(resourceName: "bookingsCalendar"), #imageLiteral(resourceName: "directions"), #imageLiteral(resourceName: "shareBooking"), #imageLiteral(resourceName: "bookingsCall"), #imageLiteral(resourceName: "bookSameFlight")]
    
    var optionNames = [LocalizedString.WebCheckin.localized, LocalizedString.AddToCalender.localized, LocalizedString.Directions.localized, LocalizedString.Share.localized, LocalizedString.Call.localized, LocalizedString.BookSameFlight.localized]
        
    var additionalInformation: AdditionalInformation?
    var webCheckinUrl: String = ""
    var usingFor: UsingFor = .flight
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionsCollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var flightsOptionCollectionView: UICollectionView! {
        didSet {
            self.flightsOptionCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 0.0, right: 1.0)
        }
    }
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.flightsOptionCollectionView.delegate = self
        self.flightsOptionCollectionView.dataSource = self
        self.flightsOptionCollectionView.registerCell(nibName: FlightsOptionCollectionViewCell.reusableIdentifier)
    }
    
    internal func configureCell() {}
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============

extension FlightsOptionsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.optionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightsOptionCollectionViewCell.reusableIdentifier, for: indexPath) as? FlightsOptionCollectionViewCell else { return UICollectionViewCell() }
        
        if self.usingFor == .flight {
            cell.configureCell(optionImage: self.optionImages[indexPath.item], optionName: self.optionNames[indexPath.item], isLastCell: indexPath.row == 2)
            if indexPath.item == 0, self.webCheckinUrl.isEmpty {
                cell.optionImageView.image = #imageLiteral(resourceName: "webCheckinGray")
                cell.optionNameLabel.textColor = AppColors.themeGray40
            } else if indexPath.item == 2, self.additionalInformation?.directions.isEmpty ?? false {
                cell.optionImageView.image = #imageLiteral(resourceName: "dircetionGray")
                cell.optionNameLabel.textColor = AppColors.themeGray40
                
            } else if indexPath.item == 4, self.additionalInformation?.contactInfo == nil {
                printDebug("inside contact cell")
                cell.optionImageView.image = #imageLiteral(resourceName: "callGray")
                cell.optionNameLabel.textColor = AppColors.themeGray40
            }
        } else {
            cell.configureCell(optionImage: self.optionImages[indexPath.item], optionName: self.optionNames[indexPath.item], isLastCell: indexPath.row == 1)
            if indexPath.item == 0, self.additionalInformation?.directions.isEmpty ?? false {
                cell.optionImageView.image = #imageLiteral(resourceName: "dircetionGray")
                cell.optionNameLabel.textColor = AppColors.themeGray40
                
            } else if indexPath.item == 1, self.additionalInformation?.contactInfo == nil {
                printDebug("inside contact cell")
                cell.optionImageView.image = #imageLiteral(resourceName: "callGray")
                cell.optionNameLabel.textColor = AppColors.themeGray40
            }
            if self.optionNames.count == 2 {
                if indexPath.item == 0 {
                    cell.setupForTwoViews(leadingConstant: 16, trailingConstant: 0)
                } else {
                    cell.setupForTwoViews(leadingConstant: 0, trailingConstant: 16)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.usingFor == .flight {
            switch indexPath.item {
            case 0:
                if !self.webCheckinUrl.isEmpty {
                    self.delegate?.openWebCheckin()
                }
            case 1:
                delegate?.addToCalendar()
            case 2:
                if !(self.additionalInformation?.directions.isEmpty ?? false) {
                    self.delegate?.openDirections()
                }
            case 4:
                if self.additionalInformation?.contactInfo != nil {
                    self.delegate?.openCallDetail()
                }
            case 5:
                delegate?.bookSameFlight()
            default:
                return
            }
        } else {
            switch indexPath.item {
            case 0:
                if !(self.additionalInformation?.directions.isEmpty ?? false) {
                    self.delegate?.openDirections()
                }
                
            case 2:
                if self.additionalInformation?.contactInfo != nil {
                    self.delegate?.openCallDetail()
                }
                
            case 2:
//                self.delegate?.addToTrips()
            break
            default:
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if self.usingFor == .flight {
//            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
//        } else {
//            if self.optionNames.count == 2 {
//                return CGSize(width: 187.5, height: collectionView.frame.height)
//            } else {
//                return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
//            }
//        }
        
        switch usingFor {
        case .flight:
            let width = collectionView.width/3//CGFloat(self.optionImages.count)
            return CGSize(width: width, height: collectionView.height/2)
        default:
            var width = collectionView.width/3 - 5
            if indexPath.item == 0 || indexPath.item == 1 {
                width = collectionView.width/2 - 5
            }
            return CGSize(width: width, height: collectionView.height/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
