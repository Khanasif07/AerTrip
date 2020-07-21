//
//  FlightSectorHeaderCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 15/07/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightSectorHeaderCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var veticalSeparator: UIView!
    @IBOutlet weak var veticalSeparatorWidth: NSLayoutConstraint!
    @IBOutlet weak var veticalSeparatorTrailing: NSLayoutConstraint!


    var headerValue : MultiLegHeader?
    var textColor  = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUI(_ header : MultiLegHeader ) {
        self.headerValue = header

        if textColor == .black {
             self.title.attributedText = self.headerValue?.title
        }
        else {
             self.title.attributedText = self.headerValue?.redTitle
        }
        self.subtitle.text = header.subTitle
        self.subtitle.textColor = textColor
    }

    func setTitleColor(_ color : UIColor ) {
        self.title.textColor = color
        self.subtitle.textColor = color
    }
    
    
    func setRedColoredTitles() {
        textColor = .AERTRIP_RED_COLOR
        self.title.attributedText = self.headerValue?.redTitle
        self.subtitle.textColor = .AERTRIP_RED_COLOR
    }
    
    func setBlackColoredTitles(){
        textColor = .black        
        self.title.attributedText = self.headerValue?.title
        self.subtitle.textColor = .black
    }
}

