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
        grayView.layer.cornerRadius = 10.0
        yellowView.layer.cornerRadius = 5.0
    }
    
}
