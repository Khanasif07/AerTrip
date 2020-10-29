//
//  ResultHeaderView.swift
//  Aertrip
//
//  Created by  hrishikesh on 27/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class ResultHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var grayView: UIView!
    @IBOutlet var yellowView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ResultHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
//        grayView.layer.cornerRadius = 10.0
        yellowView.layer.cornerRadius = 5.0
        setupGrayViewShadow()
    }
    
    fileprivate func setupGrayViewShadow() {
        backgroundColor = .clear // very important
        self.grayView.layer.masksToBounds = false
//        self.grayView.layer.shadowOpacity = 0.5
//        self.grayView.layer.shadowRadius = 4
//        self.grayView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.grayView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        self.grayView.layer.cornerRadius = 10
        
        self.grayView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 0.5, shadowRadius: 4.0)
    }
    
}
