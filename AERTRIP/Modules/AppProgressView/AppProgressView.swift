//
//  AppProgressView.swift
//  AERTRIP
//
//  Created by Rishabh on 27/07/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class AppProgressView: UIProgressView {
    
    var hideBottomHalf: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBar()
    }
    
    private func setupBar() {
        clipsToBounds = true
        progressViewStyle = .bar
        progressTintColor = AppColors.themeGreen
        trackTintColor = .clear
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !hideBottomHalf {
            if subviews.indices.contains(1), let _ = subviews[1] as? UIImageView {
                let originalFrame = subviews[1].frame
                subviews[1].frame = CGRect(x: originalFrame.origin.x, y: originalFrame.origin.y, width: originalFrame.width, height: originalFrame.height/2)
            }
        }
    }
}
