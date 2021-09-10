//
//  PanDirectionGestureRecognizer.swift
//  AERTRIP
//
//  Created by Apple  on 27.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

enum CustomPanDirection {
    case vertical
    case horizontal
}

class PanDirectionGestureRecognizer: UIPanGestureRecognizer {

    let customDirection: CustomPanDirection

    init(direction: CustomPanDirection, target: AnyObject, action: Selector) {
        self.customDirection = direction
        super.init(target: target, action: action)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let vel = velocity(in: view)
            switch customDirection {
            case .horizontal where abs(vel.y) > abs(vel.x):
                state = .cancelled
            case .vertical where abs(vel.x) > abs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
    
}
