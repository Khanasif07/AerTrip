//
//  MenuItemFilterCollCell.swift
//  AERTRIP
//
//  Created by Rishabh on 18/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Parchment
import UIKit

struct MenuItemForFilter : PagingItem ,Hashable, Comparable {
    static func < (lhs: MenuItemForFilter, rhs: MenuItemForFilter) -> Bool {
         return lhs.index < rhs.index
    }
    
    static func ==(lhs: MenuItemForFilter, rhs: MenuItemForFilter) -> Bool {
        return lhs.title == rhs.title &&
            lhs.index == rhs.index
    }
    
    var title: String
    var index: Int
    var isSelected: Bool = true
    var showSelectedFont = false
    
    init(title: String,index: Int,isSelected: Bool = true, showSelectedFont: Bool = false){
        self.title = title
        self.index = index
        self.isSelected = isSelected
        self.showSelectedFont = showSelectedFont
    }
    
    var hashValue: Int {
      return title.hashValue
    }
}

class MenuItemFilterCollCell: PagingCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dotView.layer.cornerRadius = 2.0
        self.dotView.backgroundColor = AppColors.themeGreen
    }
    
    open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
         if let item = pagingItem as? MenuItemForFilter {
            self.title.text = item.title
            self.dotView.isHidden = item.isSelected
            let showSelectedFont = item.showSelectedFont
            self.title.font = selected && showSelectedFont ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
        }
     }
}
