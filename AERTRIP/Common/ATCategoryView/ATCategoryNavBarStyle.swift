//
//  ATNotificationLabel.swift
//
//
//  Created by Pramod Kumar on 06/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

public enum ATCategoryNavBarAlignment {
    case left
    case center
}

public struct ATCategoryNavBarStyle {
    public var height: CGFloat = 44.0
    
    public var contentInset: UIEdgeInsets = .zero
    
    /// The paddings inserted before/after a AHCategoryItem's content.
    /// Note: this padding attribute is included into the touch area for each categoryItem.
    public var itemPadding: CGFloat = 8.0
    
    /// Laying out category items from left to right, or from center to both sides.
    /// Note: This attribute only works when isScrollabel = false.
    public var layoutAlignment: ATCategoryNavBarAlignment = .left
    
    public var isScrollable = false
    
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 17.0)
    public var showTransitionAnimation = true
    public var showBarSelectionAnimation = true
    
    
    /// AHCategoryItem normal color. Use RGB channels!!!
    public var normalColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    /// AHCategoryItem selected color. Use RGB channels!!!
    public var selectedColor = UIColor(red: 244.0/255.0, green: 173.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    
    /// The space between each AHCategoryItem
    public var interItemSpace: CGFloat = 20.0
    

    public var showBottomSeparator = true
    public var bottomSeparatorColor = UIColor.lightGray
    
    /// The 'underscore' indicator following AHCategoryItems.
    public var showIndicator = true
    
    public var indicatorHeight:CGFloat = 2.0
    public var indicatorCornerRadius:CGFloat = 1.0
    public var indicatorColor:UIColor = UIColor(red: 244.0/255.0, green: 173.0/255.0, blue: 98.0/255.0, alpha: 1.0)
    
    
    //###### AHCategoryItems Background Mask Related
    
    /// The default bgMaskView's background color.
    /// It doesn't have to use RGB channels.
    public var bgMaskViewColor = UIColor.darkGray
    
    // a custom bgMaskView
    public var bgMaskView: UIView? = nil
    
    public var showBgMaskView = false
    
    //##################
    
    
    /// Should the navBar be embedded into categoryView. If not, you should position it manually somewhere. You can embedded it into a native narBar's titleView if you want.
    public var isEmbeddedToView = true
    
    public init() {}
    
}


public struct ATCategoryItem {
    public var title: String?
    public var normalImage: UIImage?
    public var selectedImage: UIImage?
    public init() {}
}











