//
//  PinedFlightOptionView.swift
//  Aertrip
//
//  Created by  hrishikesh on 27/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PinedFlightOptionView: UIView {

    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
         commonInit()
    }
    
    func commonInit() {
        
        Bundle.main.loadNibNamed("PinedFlightOptionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
