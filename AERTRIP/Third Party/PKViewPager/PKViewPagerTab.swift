//
//  ViewPagerTab.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 5/1/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

public enum PKViewPagerTabType {
    /// Tab contains text only.
    case basic
    /// Tab contains images only.
    case image
    /// Tab contains image with text. Text is shown at the bottom of the image
    case imageWithText
}

public struct PKViewPagerTab {
    
    public var title:String!
    public var image:UIImage?
    
    public init(title:String, image:UIImage?) {
        self.title = title
        self.image = image
    }
}
