//
//  MenuItemzCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 31/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

struct MenuItem : PagingItem ,Hashable, Comparable {
    static func < (lhs: MenuItem, rhs: MenuItem) -> Bool {
         return lhs.index < rhs.index
    }
    
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.title == rhs.title &&
            lhs.index == rhs.index
    }
    
    var title: String
    var index: Int
    var isSelected: Bool = true
    
    init(title: String,index: Int,isSelected: Bool = true){
        self.title = title
        self.index = index
        self.isSelected = isSelected
    }
    
    var hashValue: Int {
      return title.hashValue
    }
}

class MenuItemCollectionCell: PagingCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dotView.layer.cornerRadius = 2.0
        self.dotView.backgroundColor = AppColors.themeGreen
    }
    
    open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
         if let item = pagingItem as? MenuItem {
            self.title.text = item.title
            self.dotView.isHidden = item.isSelected
            self.title.font = selected ? AppFonts.SemiBold.withSize(16.0) : AppFonts.Regular.withSize(16.0)
        }
     }
}