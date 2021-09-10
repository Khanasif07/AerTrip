//
//  NSAttributedStringExtension.swift
//  AERTRIP
//
//  Created by Admin on 20/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [ .usesFontLeading], context: nil)

        return ceil(boundingBox.width)
    }
}
