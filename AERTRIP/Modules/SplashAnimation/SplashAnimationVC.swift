//
//  SplashAnimationVC.swift
//  AERTRIP
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Lottie

class SplashAnimationVC: UIViewController {
    
    // MARK:- IB Outlets
    @IBOutlet weak var animationContainer: UIView!
    
    // MARK: - Private
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
                            if finished {
                                printDebug("Animation Complete")
                                AppFlowManager.default.setupInitialFlow()
                            } else {
                                printDebug("Animation cancelled")
                            }
        })
        
    }
    
    // MARK: - Helper methods
    
    private func initialSetups() {
        
        let animation = Animation.named("aertripSplashAnimation")
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)
        animationView.backgroundBehavior = .pauseAndRestore
    }
    
    
}
