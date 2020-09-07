//
//  CheckInCheckOutView.swift
//  AERTRIP
//
//  Created by RAJAN SINGH on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ClusterMarkerView: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var countLabel: UILabel!
    
    var items: [ATClusterItem]? {
        didSet {
            self.configureUI()
        }
    }
    
    deinit {
        printDebug("deinit ClusterMarkerView")
    }
    
    var hotelTtems: [HotelSearched]? {
        didSet {
            self.isForHotel = true
            self.configureUIForHotelItems()
        }
    }
    
    private(set) var isFavourite: Bool = false {
        didSet {
            self.updateFav()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            self.updateSelection()
        }
    }
    
    private let maxItemCount: Int = 99
    private var isForHotel = false
    
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        let nib = UINib(nibName: "ClusterMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)

        configureUI()
    }

    ///ConfigureUI
    private func configureUI() {
        self.layoutIfNeeded()
        guard let value = items else {return}
        self.isFavourite = false
        
        countLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        if value.count > maxItemCount {
            countLabel.text = "\(maxItemCount)+"
        }
        else {
            countLabel.text = "\(value.count)"
        }
        
        for item in value {
            if let hotel = item.hotelDetails, (hotel.fav ?? "0") == "1" {
                self.isFavourite = true
                break
            }
        }
    }
    
    private func configureUIForHotelItems() {
        self.layoutIfNeeded()
        guard let value = hotelTtems else {return}
        self.isFavourite = false
        
        countLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        if value.count > maxItemCount {
            countLabel.text = "\(maxItemCount)+"
        }
        else {
            countLabel.text = "\(value.count)"
        }
        
        for hotel in value {
            if (hotel.fav ?? "0") == "1" {
                self.isFavourite = true
                break
            }
        }
    }
    
    private func updateFav() {
        countLabel.cornerradius = countLabel.height / 2.0
        if isFavourite {
            countLabel.textColor = isForHotel ? AppColors.themeWhite : AppColors.themeBlack
            countLabel.backgroundColor = isForHotel ? AppColors.themeRed : AppColors.themeWhite
            countLabel.layer.borderColor = AppColors.themeRed.cgColor
            countLabel.layer.borderWidth = 1.0
        }
        else {
            countLabel.textColor = AppColors.themeWhite
            countLabel.backgroundColor = AppColors.themeGreen
            countLabel.layer.borderColor = AppColors.clear.cgColor
            countLabel.layer.borderWidth = 0.0
        }
    }
    
    private func updateSelection() {
        guard !isFavourite else {
            self.updateFav()
            return
        }
        
        countLabel.backgroundColor = isSelected ? (isFavourite ? AppColors.themeRed : AppColors.themeGreen) : AppColors.themeWhite
        
        countLabel.layer.borderColor = isSelected ? AppColors.clear.cgColor : AppColors.themeGreen.cgColor
        countLabel.layer.borderWidth = isSelected ? 0.0 : 1.0
        
        countLabel.textColor = isSelected ? AppColors.themeWhite : AppColors.themeGreen
    }
}
