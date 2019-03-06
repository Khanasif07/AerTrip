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
    
    var items: [ATClusterItem] = [] {
        didSet {
            self.configureUI()
        }
    }
    
    private(set) var isFavourite: Bool = false {
        didSet {
            self.updateFav()
        }
    }
    private let maxItemCount: Int = 99
    
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
        self.isFavourite = false
        
        countLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        if items.count > maxItemCount {
            countLabel.text = "\(maxItemCount)+"
        }
        else {
            countLabel.text = "\(items.count)"
        }
        
        for item in items {
            if let hotel = item.hotelDetails, (hotel.fav ?? "0") == "1" {
                self.isFavourite = true
                break
            }
        }
    }
    
    private func updateFav() {
        countLabel.cornerRadius = countLabel.height / 2.0
        if isFavourite {
            countLabel.textColor = AppColors.themeBlack
            countLabel.backgroundColor = AppColors.themeWhite
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
}
