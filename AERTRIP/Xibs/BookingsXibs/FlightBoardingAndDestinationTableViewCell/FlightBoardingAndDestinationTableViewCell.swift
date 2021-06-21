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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var boardAndDestStackView: UIStackView!
    @IBOutlet weak var boardingLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var boardingCodeLabel: UILabel!
    @IBOutlet weak var destinationCodeLabel: UILabel!
    @IBOutlet weak var greencircleContainerView: UIView!
    @IBOutlet weak var economyLabel: UILabel!
    @IBOutlet weak var noOfStoppageCollectionView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var boardingTimeLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var boardingDateLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.setupColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupColor()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Dotted View
        self.dottedView.makeDottedLine(dashLength:  2, gapLength: 2, dashColor: AppColors.themeGray40, isInCenter: true)
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
        self.boardingLabel.textColor = AppColors.themeGray153
        self.destinationLabel.textColor = AppColors.themeGray153
        self.boardingCodeLabel.textColor = AppColors.themeBlack
        self.destinationCodeLabel.textColor = AppColors.themeBlack
        self.economyLabel.textColor = AppColors.themeGray153
        self.timeLabel.textColor = AppColors.themeGray153
        self.boardingTimeLabel.textColor = AppColors.themeBlack
        self.destinationTimeLabel.textColor = AppColors.themeBlack
        self.boardingDateLabel.textColor = AppColors.themeGray153
        self.destinationDateLabel.textColor = AppColors.themeGray153
        
        // Text
        self.economyLabel.text = LocalizedString.Economy.localized
        self.noOfStoppageCollectionView.registerCell(nibName: FlightStopsCollectionViewCell.reusableIdentifier)
        self.noOfStoppageCollectionView.delegate = self
        self.noOfStoppageCollectionView.dataSource = self
        
        // Shadow
        //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties(self.isLightTheme())
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
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
    
    
    func configureCellWith(leg:IntLeg, airport:[String:IntAirportDetailsWS]){
        self.boardingLabel.text = airport[leg.originIATACode]?.c
        self.destinationLabel.text = airport[leg.destinationIATACode]?.c
        self.boardingCodeLabel.text = leg.originIATACode
        self.destinationCodeLabel.text = leg.destinationIATACode
        self.timeLabel.text = leg.durationTitle
        self.boardingTimeLabel.text = leg.dt
        self.destinationTimeLabel.text = leg.at
        self.boardingDateLabel.text = leg.dd.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "E, d MMM yyyy")
        self.destinationDateLabel.text = leg.ad.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "E, d MMM yyyy")
        self.economyLabel.text = leg.flightsWithDetails.first?.cc
        self.noOfStops = leg.stp.toInt ?? 0
        self.noOfStoppageCollectionView.reloadData()
    }
    
    
    func setupColor(){
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
        self.greencircleContainerView.backgroundColor = AppColors.themeWhiteDashboard
        self.dottedView.backgroundColor = AppColors.themeWhiteDashboard
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 23.0 * Double(self.noOfStops)
        let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: leftInset)
    }
}
