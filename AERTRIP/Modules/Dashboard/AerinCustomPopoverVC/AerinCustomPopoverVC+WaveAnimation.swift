//
//  AerinCustomPopoverVC+WaveAnimation.swift
//  AERTRIP
//
//  Created by Rishabh on 23/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension AerinCustomPopoverVC {
    
    func addWaveAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.firstWaveView = HeartLoadingView(frame: self.waveAnimationContainerView.bounds)
            self.firstWaveView?.heartAmplitude = 50
            self.firstWaveView?.lightHeartColor = UIColor(displayP3Red: 204/255, green: 244/255, blue: 234/255, alpha: 0.7)
            self.firstWaveView?.heavyHeartColor = UIColor(displayP3Red: 177/255, green: 239/255, blue: 244/255, alpha: 1)
            self.firstWaveView?.isShowProgressText = false
            self.firstWaveView?.animationSpeed = 20
            self.waveAnimationContainerView.addSubview(self.firstWaveView!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.secondWaveView = HeartLoadingView(frame: self.waveAnimationContainerView.bounds)
            self.secondWaveView?.heartAmplitude = 50
            self.secondWaveView?.lightHeartColor = UIColor(displayP3Red: 142/255, green: 231/255, blue: 209/255, alpha: 0.5)
            self.secondWaveView?.heavyHeartColor = .clear//UIColor(r: 0, g: 105, b: 100, alpha: 0.5)
            self.secondWaveView?.isShowProgressText = false
            self.waveAnimationContainerView.addSubview(self.secondWaveView!)
            self.waveAnimationContainerView.bringSubviewToFront(self.waveAnimationContentView)
        }
    }
    
//    private func setWaveAnimationState(_ fast: Bool) {
//        firstWaveView?.heartAmplitude = fast ? 60 : 30
//        secondWaveView?.heartAmplitude = fast ? 60 : 30
//        firstWaveView?.animationSpeed = fast ? 30 : 20
//        secondWaveView?.animationSpeed = fast ? 20 : 10
//    }
    
}
