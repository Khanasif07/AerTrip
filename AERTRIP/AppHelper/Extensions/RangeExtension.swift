//
//  RangeExtension.swift
//  AERTRIP
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    func asNSRange() -> NSRange {
        let location = self.lowerBound.encodedOffset
        let length = self.lowerBound.encodedOffset - self.upperBound.encodedOffset
        return NSRange(location: location, length: length)
    }
}
