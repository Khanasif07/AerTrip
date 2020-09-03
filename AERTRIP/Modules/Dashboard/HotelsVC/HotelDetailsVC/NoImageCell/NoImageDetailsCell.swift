//
//  NoImageDetailsCell.swift
//  AERTRIP
//
//  Created by Apple  on 04.08.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NoImageDetailsCell: UITableViewCell {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var labelTopConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.noImageLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.initialSetup()
    }
    private func initialSetup() {
        self.selectionStyle = .none
        self.gradientView.backgroundColor = AppColors.clear
        self.gradientView.addGredientWithScreenWidth(isVertical: true, colors: [AppColors.themeBlack.withAlphaComponent(0.5),AppColors.themeBlack.withAlphaComponent(0.0)])
    }

    func configureCell(isTAImageAvailable:Bool){
        if !isTAImageAvailable{
            self.noImageLabel.textColor = AppColors.themeGray40
            self.noImageLabel.text = "No photos availble"
        }else{
            self.noImageLabel.textColor = AppColors.themeGreen
            self.noImageLabel.text = "Show photos on TripAdvisor"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
