//
//  SearchBarHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesDescriptionHeaderView: UITableViewHeaderFooterView {
    
    //Mark:- Variables
    //===============

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        let nib = UINib(nibName: "AmenitiesDescriptionHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configUI()
    }
    
    ///ConfigureUI
    private func configUI() {
        self.containerView.backgroundColor = AppColors.themeWhite
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    internal func configureView(title: String, image: UIImage) {
        self.imgView.image = image
        self.titleLabel.text = title
    }
}

