//
//  IntHeaderCollectionCell.swift
//  Aertrip
//
//  Created by Apple  on 27.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit
//Onward
//Return
class IntHeaderCollectionCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var veticalSeparator: UIView!
    @IBOutlet weak var titleLeadingContraint: NSLayoutConstraint!
    
    var headerValue : MultiLegHeader?
    var textColor  = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUI(_ header : MultiLegHeader ) {
        self.headerValue = header

        if header.isInCompatable {
            self.title.attributedText = self.headerValue?.redTitle
            self.subtitle.textColor = .AERTRIP_RED_COLOR
        } else {
            self.title.attributedText = self.headerValue?.title
            self.subtitle.textColor = .black

        }
        if header.subTitle == "Onward" || header.subTitle == "Return"{
            titleLeadingContraint.constant = 15
        }else{
            titleLeadingContraint.constant = 18
        }
        self.subtitle.text = header.subTitle
        self.subtitle.textColor = textColor
    }

    func setTitleColor2(_ color : UIColor ) {
        self.title.textColor = color
        self.subtitle.textColor = color
    }
    
    
    func setRedColoredTitles2() {
        textColor = .AERTRIP_RED_COLOR
        self.title.attributedText = self.headerValue?.redTitle
        self.subtitle.textColor = .AERTRIP_RED_COLOR
    }
    
    func setBlackColoredTitles2(){
        textColor = .black
        self.title.attributedText = self.headerValue?.title
        self.subtitle.textColor = .black
    }
}
