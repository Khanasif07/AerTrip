//
//  BookingRequestNoteTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestNoteTableViewCell: ATTableViewCell {

    
    //================
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    ///AttributeLabelSetup
    private func setInfoText(overview: String) {
        
        let totalLines = overview.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0)).height / AppFonts.Regular.withSize(18.0).pointSize
        
        infoLabel.text = overview
        self.moreBtnContainerView.isHidden = totalLines < 3.0
    }
    
    override func setupColors() {
    
        self.noteLabel.textColor = AppColors.themeGray40
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.infoLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.noteLabel.text = LocalizedString.NotesCapitalised.localized
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
        
    }
    
    override func setupFonts() {
        //Size
        self.noteLabel.font = AppFonts.Regular.withSize(14.0)
        self.moreBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.infoLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func doInitialSetup() {
        self.configureUI()
    }
    
    func configure(info: String) {
        
        if moreBtnOutlet.isSelected {
            self.moreBtnOutlet.isHidden = true
            self.infoLabel.numberOfLines = 0
        }
        else {
            self.moreBtnOutlet.isHidden = false
            self.infoLabel.numberOfLines = 3
            self.setInfoText(overview: info)
        }
    }
    
     func configureNoteCell(hotelData: HotelDetails) {
        if moreBtnOutlet.isSelected {
            self.moreBtnOutlet.isHidden = true
            self.infoLabel.numberOfLines = 0
        }
        else {
            self.moreBtnOutlet.isHidden = false
            self.infoLabel.numberOfLines = 3
            self.setInfoText(overview: hotelData.info)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        printDebug("More")
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            AppFlowManager.default.presentHotelDetailsOverViewVC(overViewInfo: parentVC.viewModel.hotelData?.info ?? "")
        }
        else if let parentVC = self.parentViewController as? BookingAddOnRequestVC {
            self.moreBtnOutlet.isSelected = true
            parentVC.requestTableView.reloadData()
        }
    }
    
    
    ///COnfigure UI
    private func configureUI() {
        //SetUps
        self.moreBtnContainerView.addGradientWithColor(color: AppColors.themeWhite)
        self.infoLabel.lineBreakMode = .byWordWrapping
    }
}
