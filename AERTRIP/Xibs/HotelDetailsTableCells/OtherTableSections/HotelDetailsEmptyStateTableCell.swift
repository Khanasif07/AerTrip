//
//  HotelDetailsEmptyStateTableCell.swift
//  AERTRIP
//
//  Created by Admin on 05/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsEmptyStateTableCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateDescriptionLabel: UILabel!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    
    //Mark:- LifeCycles
    //=================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    
    private func configUI() {
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.emptyStateImageView.image = #imageLiteral(resourceName: "HotelDetailsEmptyState")
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateDescriptionLabel.font = AppFonts.Regular.withSize(18.0)
        self.resetButtonOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.emptyStateTitleLabel.textColor = AppColors.textFieldTextColor51
        self.emptyStateDescriptionLabel.textColor = AppColors.themeGray60
        self.resetButtonOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.emptyStateTitleLabel.text = LocalizedString.Whoops.localized
        self.emptyStateDescriptionLabel.text = LocalizedString.HotelDetailsEmptyState.localized
        self.resetButtonOutlet.setTitle(LocalizedString.ResetFilter.localized, for: .normal)
    }

    //Mark:- IBActions
    //================
    @IBAction func resetButtonAction(_ sender: UIButton) {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            parentVC.viewModel.permanentTagsForFilteration.removeAll()
            parentVC.viewModel.roomMealData.removeAll()
            parentVC.viewModel.roomCancellationData.removeAll()
            parentVC.viewModel.roomOtherData.removeAll()
            parentVC.viewModel.selectedTags.removeAll()
            parentVC.getSavedFilter()
            parentVC.permanentTagsForFilteration()
            parentVC.filterdHotelData(tagList: [])
            parentVC.hotelTableView.reloadData()
        }
    }
    
}
