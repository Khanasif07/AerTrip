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
    @IBOutlet weak var resetFilterButtonOutlet: UIButton!
    
    //Mark:- LifeCycles
    //=================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    ///Config UI
    private func configUI() {
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.emptyStateImageView.image = AppImages.HotelDetailsEmptyState
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateDescriptionLabel.font = AppFonts.Regular.withSize(18.0)
        self.resetFilterButtonOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.emptyStateTitleLabel.textColor = AppColors.textFieldTextColor51
        self.emptyStateDescriptionLabel.textColor = AppColors.themeGray60
        self.resetFilterButtonOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.emptyStateTitleLabel.text = LocalizedString.Whoops.localized
        self.emptyStateDescriptionLabel.text = LocalizedString.HotelDetailsEmptyState.localized
        self.resetFilterButtonOutlet.setTitle(LocalizedString.ResetFilter.localized, for: .normal)
    }

    //Mark:- IBActions
    //================
    @IBAction func resetFilterButtonAction(_ sender: UIButton) {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
//            parentVC.viewModel.permanentTagsForFilteration.removeAll()
            parentVC.viewModel.roomMealDataCopy.removeAll()
            parentVC.viewModel.roomCancellationDataCopy.removeAll()
            parentVC.viewModel.roomOtherDataCopy.removeAll()
            parentVC.viewModel.selectedTags.removeAll()
            parentVC.getSavedFilter()
            parentVC.viewModel.selectedTags.removeAll()
//            parentVC.permanentTagsForFilteration()
            parentVC.filterdHotelData(tagList: [])
            parentVC.viewModel.logEvents(with: .ResetRoomFilters)
            parentVC.hotelTableView.reloadData()
        }
    }
}
