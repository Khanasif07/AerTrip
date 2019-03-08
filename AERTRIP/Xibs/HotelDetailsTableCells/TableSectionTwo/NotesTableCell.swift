//
//  NotesTableCell.swift
//  AERTRIP
//
//  Created by Admin on 27/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class NotesTableCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var blackDotLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var btnContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var moreBtnOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //UIColor
        self.backgroundColor = AppColors.screensBackground.color
//        self.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0)
        self.containerView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.btnContainerView.addGradientWithColor(color: AppColors.themeWhite)
        //Font
        self.notesTitle.font = AppFonts.Regular.withSize(14.0)
        //TextColo
        self.notesTitle.textColor = AppColors.themeGray40
        self.noteLabel.textColor = AppColors.textFieldTextColor51
        self.moreBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        //Text
        self.moreBtnOutlet.setTitle(LocalizedString.More.localized, for: .normal)
    }
    
//    internal func configCell(ratesData: Rates) {
//
//    }
    
    //Mark:- IBActions
    //================
    @IBAction func moreBtnAction(_ sender: UIButton) {
    }
}
