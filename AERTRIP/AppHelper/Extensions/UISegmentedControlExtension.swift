//
//  UISegmentedControlExtension.swift
//  AERTRIP
//
//  Created by Admin on 13/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func setBacgroundColor() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: tintColor), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}
