//
//  RangeExtension.swift
//  AERTRIP
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    func asNSRange(inString: String) -> NSRange {
//        let location = self.lowerBound.utf16Offset(in: inString)
//        let length = self.upperBound.utf16Offset(in: inString) - location
//        return NSRange(location: location, length: length)

        let lower = String.UTF16View.Index(self.lowerBound, within: inString.utf16) ?? inString.startIndex
        let upper = String.UTF16View.Index(self.upperBound, within: inString.utf16) ?? inString.endIndex
        
        return NSRange(location: inString.utf16.distance(from: inString.startIndex, to: lower), length: inString.utf16.distance(from: lower, to: upper))
    }
}
