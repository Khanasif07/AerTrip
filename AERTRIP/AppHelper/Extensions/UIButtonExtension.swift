//
//  UIButtonExtension.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func addRequiredActionToShowAnimation() {
        self.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonTappedReleased(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @objc private func buttonTappedReleased(_ sender: UIButton) {
        self.transform = CGAffineTransform.identity
    }
}
