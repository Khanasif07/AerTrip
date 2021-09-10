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

enum HotelResultsListPriceType {
    case perNight
    case total(Int)
}

class HotelSearchResultHeaderView: UIView {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var pricesInclusiveLbl: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HotelSearchResultHeaderViewDelegate?
    var resultListPriceType: HotelResultsListPriceType = .perNight {
        didSet {
            resetPriceTypeLbl()
        }
    }
    var numberOfRooms: Int = 0
    
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
        pricesInclusiveLbl.font = AppFonts.Regular.withSize(16)
        
        ///Colors
        self.titleLabel.textColor = AppColors.themeGray60
        self.clearButton.setTitleColor(AppColors.themeGreen, for: .normal)
        pricesInclusiveLbl.textColor = AppColors.themeGray60
        
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
        searchStackView.isHidden = height == 36
        if heightConstraint.constant != height {
            heightConstraint.constant = height
            self.layoutIfNeeded()
            if let tableView = self.superview as? UITableView {
                tableView.reloadData()
            }
        }
    }
    
    private func resetPriceTypeLbl() {
        switch resultListPriceType {
        case .perNight:
            pricesInclusiveLbl.text = LocalizedString.pricesArePerNight.localized + " \(numberOfRooms) " + (numberOfRooms > 1 ?  LocalizedString.Rooms.localized.lowercased() : LocalizedString.Room.localized.lowercased()) + ", " + (isSEDevice ? LocalizedString.allIncl.localized : LocalizedString.allInclusive.localized)
        case .total(let numberOfNights):
            pricesInclusiveLbl.text = LocalizedString.pricesAreFor.localized + " \(numberOfNights) " + (numberOfNights > 1 ?  LocalizedString.Nights.localized.lowercased() : LocalizedString.Night.localized.lowercased()) + " " + LocalizedString.For.localized.lowercased() + " \(numberOfRooms) " + (numberOfRooms > 1 ?  LocalizedString.Rooms.localized.lowercased() : LocalizedString.Room.localized.lowercased()) + ", " + (isSEDevice ? LocalizedString.allIncl.localized : LocalizedString.allInclusive.localized)
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        self.delegate?.clearSearchView()
    }
    
}
