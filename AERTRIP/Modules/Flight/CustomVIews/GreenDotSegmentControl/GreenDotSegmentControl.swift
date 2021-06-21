//
//  GreenDotSegmentControl.swift
//  AERTRIP
//
//  Created by Rishabh on 18/05/21.
//  Copyright © 2021 Rishabh Nautiyal. All rights reserved.
//

import UIKit

class GreenDotSegmentControl: UISegmentedControl {
    
    override func setTitle(_ title: String?, forSegmentAt segment: Int) {
        let image = getImgFromAttString(segmentTitle: title ?? "")
        setImage(image, forSegmentAt: segment)
    }
    
    override func insertSegment(withTitle title: String?, at segment: Int, animated: Bool) {
        let image = getImgFromAttString(segmentTitle: title ?? "")
        insertSegment(with: image, at: segment, animated: animated)
    }
    
    func getImgFromAttString(segmentTitle: String) -> UIImage {
        
        let mutableStr = NSMutableAttributedString(string: segmentTitle, attributes: [.font: AppFonts.Regular.withSize(16), .foregroundColor: AppColors.themeBlack])
        let rangeOfDot = (mutableStr.string as NSString).range(of: "•")
        mutableStr.setAttributes([.font: AppFonts.Regular.withSize(16), .foregroundColor: AppColors.themeGreen], range: rangeOfDot)
        
        UIGraphicsBeginImageContext(mutableStr.size())
        mutableStr.draw(at: .zero)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return resultImage!
    }
}
