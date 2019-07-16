//
//  FlightBoardingAndDestinationTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightBoardingAndDestinationTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    internal var noOfStops: Int = 1
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var boardAndDestStackView: UIStackView!
    @IBOutlet var boardingLabel: UILabel!
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var boardingCodeLabel: UILabel!
    @IBOutlet var destinationCodeLabel: UILabel!
    @IBOutlet var greencircleContainerView: UIView!
    @IBOutlet var economyLabel: UILabel!
    @IBOutlet var noOfStoppageCollectionView: UICollectionView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var boardingTimeLabel: UILabel!
    @IBOutlet var destinationTimeLabel: UILabel!
    @IBOutlet var boardingDateLabel: UILabel!
    @IBOutlet var destinationDateLabel: UILabel!
    @IBOutlet var dottedView: UIView!
    @IBOutlet var dividerView: ATDividerView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Dotted View
        self.dottedView.makeDottedLine(isInCenter: true)
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configUI() {
        // Font
        self.boardingLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationLabel.font = AppFonts.Regular.withSize(14.0)
        self.boardingCodeLabel.font = AppFonts.Regular.withSize(40.0)
        self.destinationCodeLabel.font = AppFonts.Regular.withSize(40.0)
        self.economyLabel.font = AppFonts.Regular.withSize(14.0)
        self.timeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.boardingTimeLabel.font = AppFonts.Regular.withSize(22.0)
        self.destinationTimeLabel.font = AppFonts.Regular.withSize(22.0)
        self.boardingDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationDateLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Color
        self.boardingLabel.textColor = AppColors.themeGray40
        self.destinationLabel.textColor = AppColors.themeGray40
        self.boardingCodeLabel.textColor = AppColors.themeBlack
        self.destinationCodeLabel.textColor = AppColors.themeBlack
        self.economyLabel.textColor = AppColors.themeGray40
        self.timeLabel.textColor = AppColors.themeGray40
        self.boardingTimeLabel.textColor = AppColors.themeBlack
        self.destinationTimeLabel.textColor = AppColors.themeBlack
        self.boardingDateLabel.textColor = AppColors.themeGray40
        self.destinationDateLabel.textColor = AppColors.themeGray40
        
        // Text
        self.economyLabel.text = LocalizedString.Economy.localized
        self.noOfStoppageCollectionView.registerCell(nibName: FlightStopsCollectionViewCell.reusableIdentifier)
        self.noOfStoppageCollectionView.delegate = self
        self.noOfStoppageCollectionView.dataSource = self
        
        // Shadow
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(boardingCity: String, destinationCity: String, boardingCode: String, destinationCode: String, legDuration: String, boardingTime: String, destinationTime: String, boardingDate: String, destinationDate: String, economyClass: String) {
        self.boardingLabel.text = boardingCity
        self.destinationLabel.text = destinationCity
        self.boardingCodeLabel.text = boardingCode
        self.destinationCodeLabel.text = destinationCode
        self.timeLabel.text = legDuration
        self.boardingTimeLabel.text = boardingTime
        self.destinationTimeLabel.text = destinationTime
        self.boardingDateLabel.text = boardingDate
        self.destinationDateLabel.text = destinationDate
        self.economyLabel.text = economyClass
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============

extension FlightBoardingAndDestinationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.noOfStops
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightStopsCollectionViewCell.reusableIdentifier, for: indexPath) as? FlightStopsCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 23.0, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 23.0 * Double(self.noOfStops)
        let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: leftInset)
    }
}
