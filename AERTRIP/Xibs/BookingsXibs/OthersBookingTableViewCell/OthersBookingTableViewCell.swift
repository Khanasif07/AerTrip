//
//  OthersBookingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OthersBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookingTypeImgView: UIImageView!
    @IBOutlet weak var plcaeNameLabel: UILabel!
    @IBOutlet weak var travellersNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var allSteps: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner ,.layerMinXMaxYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
    }
    
    var bookingData: BookingData? {
        didSet {
            self.configCell()
        }
    }

    private func configUI() {
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
