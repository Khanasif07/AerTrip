//
//  OthersBookingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol OthersBookingTableViewCellDelegate: class {
    func didSelectRequest(index: Int, data: BookingData)
}
class OthersBookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookingTypeImgView: UIImageView!
    @IBOutlet weak var plcaeNameLabel: UILabel!
    @IBOutlet weak var travellersNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    private var allSteps: [String] = []
    
    weak var delegate: OthersBookingTableViewCellDelegate?
    var isLastCellInSection: Bool = false {
        didSet {
            updateBottomConstraint()
        }
    }
    var isFirstCellInSection: Bool = false {
        didSet {
            updateTopConstraint()
        }
    }
    
    var bookingData: BookingData? {
        didSet {
            self.configCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        //
//        self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
    }
    
    private func configUI() {
        //self.collectionView.isUserInteractionEnabled = false
        self.bookingTypeImgView.image = #imageLiteral(resourceName: "others")
        self.plcaeNameLabel.textColor = AppColors.themeBlack
        self.travellersNameLabel.textColor = AppColors.themeGray40
        self.plcaeNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.travellersNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.backgroundColor = AppColors.themeWhite
        self.collectionView.registerCell(nibName: QueryStatusCollectionCell.reusableIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = AppColors.clear
    }
    
    private func configCell() {
        
        self.plcaeNameLabel.text = nil
        self.plcaeNameLabel.attributedText = bookingData?.tripCitiesStr
        self.travellersNameLabel.text = bookingData?.paxStr ?? ""
        self.bookingTypeImgView.image = bookingData?.productType.icon
        self.allSteps = bookingData?.stepsArray ?? []
        self.collectionView.reloadData()
    }
    
    func updateTopConstraint() {
        let constant: CGFloat = self.isFirstCellInSection ? 16 : 8
        if self.containerTopConstraint.constant != constant {
            self.containerTopConstraint.constant = constant
            self.contentView.layoutIfNeeded()
        }
    }
    
    func updateBottomConstraint() {
        let constant: CGFloat = self.isLastCellInSection ? 16 : 8
        if self.containerBottomConstraint.constant != constant {
            self.containerBottomConstraint.constant = constant
            self.contentView.layoutIfNeeded()
        }
    }
}

extension OthersBookingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allSteps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QueryStatusCollectionCell.reusableIdentifier, for: indexPath) as? QueryStatusCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.statusText = self.allSteps[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = bookingData {
            delegate?.didSelectRequest(index: indexPath.item, data: data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
