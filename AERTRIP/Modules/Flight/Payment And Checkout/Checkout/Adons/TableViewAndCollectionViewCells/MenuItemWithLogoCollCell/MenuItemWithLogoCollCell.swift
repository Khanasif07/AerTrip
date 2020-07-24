//
//  MenuItemWithLogoCollCell.swift
//  AERTRIP
//
//  Created by Rishabh on 24/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

struct LogoMenuItem : PagingItem ,Hashable, Comparable {
    static func < (lhs: LogoMenuItem, rhs: LogoMenuItem) -> Bool {
         return lhs.index < rhs.index
    }
    
    static func ==(lhs: LogoMenuItem, rhs: LogoMenuItem) -> Bool {
        return lhs.attributedTitle == rhs.attributedTitle &&
            lhs.index == rhs.index
    }
    
    var index: Int
    var attributedTitle: NSAttributedString?
    var isSelected: Bool = true
    var logoUrl: String?
    
    init(index: Int,isSelected: Bool = true, attributedTitle: NSAttributedString? = nil, logoUrl: String? = nil){
        self.attributedTitle = attributedTitle
        self.index = index
        self.isSelected = isSelected
        self.logoUrl = logoUrl
    }
    
    var hashValue: Int {
      return attributedTitle.hashValue
    }
}
class MenuItemWithLogoCollCell: PagingCell {

    // MARK: Variables
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImgView.roundedCorners(cornerRadius: 2)
    }
    
    // MARK: Functions
    
    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        if let item = pagingItem as? LogoMenuItem {
            titleLbl.attributedText = item.attributedTitle
            self.titleLbl.font = selected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
            logoImgView.setImageWithUrl(item.logoUrl ?? "", placeholder: UIImage(), showIndicator: false)
        }
    }
    
}
