//
//  HotelSearchResultHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 27/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelSearchResultHeaderViewDelegate: class {
    func clearSearchView()
}

class HotelSearchResultHeaderView: UIView {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HotelSearchResultHeaderViewDelegate?
    
    //MARK:- View Life cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetUp()
        setupFontsAndText()
    }
    
    
    class func instanceFromNib() -> HotelSearchResultHeaderView {
        let parentView = UINib(nibName: "HotelSearchResultHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HotelSearchResultHeaderView
        
        return parentView
    }
    
    //MARK:- Private
    private func initialSetUp() {
    }
    
    private func setupFontsAndText() {
        ///Font
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.clearButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
        ///Colors
        self.titleLabel.textColor = AppColors.themeGray60
        self.clearButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        //Text
        self.clearButton.setTitle(LocalizedString.Clear.localized, for: .normal)
    }
    
    internal func configureView(searhText: String) {
        let highlightText = "“\(searhText)”"
        self.titleLabel.text = "\(LocalizedString.ShowingResultsFor.localized) \(highlightText)"
        self.titleLabel.AttributedFontForText(text: highlightText, textFont: AppFonts.SemiBold.withSize(16.0))
        if searhText.isEmpty {
            self.clearButton.setTitleColor(AppColors.themeGray40, for: .normal)
        } else {
            self.clearButton.setTitleColor(AppColors.themeGreen, for: .normal)
        }
    }
    
    internal func updateHeight(height: CGFloat){
        if heightConstraint.constant != height {
            heightConstraint.constant = height
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        self.delegate?.clearSearchView()
    }
    
}
