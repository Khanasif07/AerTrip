//
//  HotelShimmerView.swift
//  AERTRIP
//
//  Created by Admin on 27/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelShimmerView: UIView {

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: CustomView!
    @IBOutlet weak var shimmerView: FBShimmeringView!
    @IBOutlet weak var shimmerContainerView: UIView!
    
    //MARK:- View Life Cycle
    //MARK:-
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupShimmerView()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("HotelShimmerView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        shadowView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        shadowView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)

    }
    
    private func setupShimmerView() {
        //Optional ShimmeringView protocal values
        //All values show are the defaults
//        shimmerView.shimmeringPauseDuration = 0.4
//        shimmerView.shimmeringAnimationOpacity = 1
//        shimmerView.shimmeringOpacity = 0.0
        shimmerView.shimmeringSpeed = 180
//        shimmerView.shimmeringHighlightLength = 1.0
//        shimmerView.shimmeringDirection = .right
//        shimmerView.shimmeringBeginFadeDuration = 0.1
//        shimmerView.shimmeringEndFadeDuration = 0.3
        
        
        shimmerView.contentView = shimmerContainerView
        shimmerView.isShimmering = true
        
        printDebug("shimmerView.shimmeringFadeTime: \(shimmerView.shimmeringFadeTime)")
    }
}
/*
solShimmerView.setIntensity(0.0f);
solShimmerView.setBaseAlpha(0.3f);
solShimmerView.setTilt(30f);
solShimmerView.setDropoff(0.5f);
solShimmerView.setRepeatDelay(0);
solShimmerView.setDuration(1800);
solShimmerView.setRepeatCount(ValueAnimator.INFINITE);
solShimmerView.setRepeatMode(ValueAnimator.RESTART);
flShimmeRootView.add(solShimmerView);
*/
