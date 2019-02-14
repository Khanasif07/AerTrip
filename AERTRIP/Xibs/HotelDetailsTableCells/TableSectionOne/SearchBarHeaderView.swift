//
//  SearchBarHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UITableViewHeaderFooterView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var breakfastButtonOutlet: UIButton!
    @IBOutlet weak var refundableButtonOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchBarHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        self.searchBarSetUp()
        self.breakfastButtonOutlet.layer.cornerRadius = 14.0
        self.breakfastButtonOutlet.layer.borderWidth = 1.0
        self.breakfastButtonOutlet.layer.masksToBounds = true
        self.refundableButtonOutlet.layer.cornerRadius = 14.0
        self.refundableButtonOutlet.layer.borderWidth = 1.0
        self.refundableButtonOutlet.layer.masksToBounds = true
        
        //Color
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.breakfastButtonOutlet.backgroundColor = AppColors.iceGreen
        self.breakfastButtonOutlet.layer.borderColor = AppColors.themeGreen.cgColor
        self.refundableButtonOutlet.backgroundColor = AppColors.greyO4
        self.refundableButtonOutlet.layer.borderColor = AppColors.themeGray40.cgColor
        self.breakfastButtonOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.refundableButtonOutlet.setTitleColor(AppColors.themeGray40, for: .normal)

        //Text
        self.breakfastButtonOutlet.setTitle(LocalizedString.Breakfast.localized, for: .normal)
        self.refundableButtonOutlet.setTitle(LocalizedString.Refundable.localized, for: .normal)
        
        //Font
        let semiBoldFont16 = AppFonts.SemiBold.withSize(16.0)
        self.breakfastButtonOutlet.titleLabel?.font = semiBoldFont16
        self.refundableButtonOutlet.titleLabel?.font = semiBoldFont16
    }
    
    ///Search Bar SetUp
    private func searchBarSetUp() {
        //UI
        self.searchBar.layer.cornerRadius = 10.0
        self.searchBar.layer.masksToBounds = true
        self.searchBar.backgroundColor = AppColors.themeGray10
        
        if let textField = self.searchBar.value(forKey: "_searchField") as? UITextField {
            //Color
            textField.borderStyle = .none
            textField.backgroundColor = .clear
            //Text
            textField.attributedPlaceholder = self.attributeLabelSetUp()
            //Font
            textField.font = AppFonts.Regular.withSize(18.0)
        }
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greyAttributedString = NSAttributedString(string: "  " + LocalizedString.hotelFilterSearchBar.localized, attributes: grayAttribute)
        attributedString.append(greyAttributedString)
        return attributedString
    }
    
    //Mark:- IBActions
    //================
    @IBAction func breakfastButtonAction(_ sender: UIButton) {
    }

    @IBAction func refundableButtonAction(_ sender: UIButton) {
    }
}
