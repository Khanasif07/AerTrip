//
//  PKAlertButton.swift
//
//
//  Created by Pramod Kumar on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

open class PKAlertButton {
    
    var title: String = ""
    var titleColor: UIColor = .black
    
    init(title: String = "", titleColor: UIColor = .black) {
        self.title = title
        self.titleColor = titleColor
    }
}
