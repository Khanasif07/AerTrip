//
//  FlightBoardingAndDestinationTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightBoardingAndDestinationTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    internal var noOfStops: Int = 1
    
    //MARK:- IBOutlets
    //MARK:===========
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
    @IBOutlet weak var dividerView: ATDividerView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        //Font
        self.boardingLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationLabel.font = AppFonts.Regular.withSize(14.0)
        self.boardingCodeLabel.font = AppFonts.Regular.withSize(40.0)
        self.destinationCodeLabel.font = AppFonts.Regular.withSize(40.0)
        self.economyLabel.font = AppFonts.Regular.withSize(14.0)
        self.timeLabel.font = AppFonts.Regular.withSize(14.0)
        self.boardingTimeLabel.font = AppFonts.Regular.withSize(22.0)
        self.destinationTimeLabel.font = AppFonts.Regular.withSize(22.0)
        self.boardingDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationDateLabel.font = AppFonts.Regular.withSize(14.0)
        
        //Color
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
        
        //Text
        self.economyLabel.text = LocalizedString.Economy.localized
        self.noOfStoppageCollectionView.registerCell(nibName: FlightStopsCollectionViewCell.reusableIdentifier)
        self.noOfStoppageCollectionView.delegate = self
        self.noOfStoppageCollectionView.dataSource = self
        
        //Shadow
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(boarding: String , destination: String , boardingCode: String , destinationCode: String , totalTime: String , boardingTime: String , destinationTime: String , boardingDate: String , destinationDate: String) {
        self.boardingLabel.text = boarding
        self.destinationLabel.text = destination
        self.boardingCodeLabel.text = boardingCode
        self.destinationCodeLabel.text = destinationCode
        self.timeLabel.text = totalTime
        self.boardingTimeLabel.text = boardingTime
        self.destinationTimeLabel.text = destinationTime
        self.boardingDateLabel.text = boardingDate
        self.destinationDateLabel.text = destinationDate
    }
    
    //MARK:- IBActions
    //MARK:===========
    
}

//MARK:- Extensions
//MARK:============
extension FlightBoardingAndDestinationTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
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
