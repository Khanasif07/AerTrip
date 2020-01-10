//
//  WormTabStripButton.swift
//  AERTRIP
//
//  Created by Admin on 09/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
class WormTabStripButton: UILabel{
    
    
    var index:Int?
    var paddingToEachSide:CGFloat = 10
    var tabText:NSString?{
        didSet{
            let textSize:CGSize = tabText!.size(withAttributes: [NSAttributedString.Key.font: font])
            self.frame.size.width = textSize.width + paddingToEachSide + paddingToEachSide
            
            self.text = String(tabText!)
        }
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = AppFonts.Regular.withSize(17.0)
        
    }
    convenience required init(key:String) {
        self.init(frame:CGRect.zero)
        self.font  = AppFonts.Regular.withSize(17.0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
