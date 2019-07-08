//
//  PKWaveView.swift
//  PKWaveView
//
//  Created by apple on 06/05/19.
//  Copyright © 2019 pawanLine. All rights reserved.
//

import UIKit

open class PKWaterWaveView: UIView {

    /// wave curvature (default :1.5)
    open var waveCurvature: CGFloat = 1.5
    
    /// wave speed (default: 1.6)
    open var waveSpeed: CGFloat = 0.5
    
    /// wave height (default: 15.0)
    open var  waveHeight: CGFloat = 15
    
    /// real wave color
    open var realWaveColor: UIColor = UIColor.red {
        didSet {
            self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        }
    }
    
    /// mask wave color
    open var maskWaveColor: UIColor = UIColor.red {
        didSet {
            self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        }
    }
    
    /// third wave color
    open var thirdWaveColor: UIColor = UIColor.red {
        didSet {
            self.thirdWaveLayer.fillColor = self.thirdWaveColor.cgColor
        }
    }
    
  
    
    
    /// real wave
    fileprivate var realWaveLayer :CAShapeLayer = CAShapeLayer()
    /// mask wave
    fileprivate var maskWaveLayer :CAShapeLayer = CAShapeLayer()
    
    // third Wave
    fileprivate var thirdWaveLayer: CAShapeLayer = CAShapeLayer()
    
    /// wave timmer
    fileprivate var timer: CADisplayLink?
    
    
    /// offset
    fileprivate var offset :CGFloat = 0
    
    fileprivate var _waveCurvature: CGFloat = 0
    fileprivate var _waveSpeed: CGFloat = 0
    fileprivate var _waveHeight: CGFloat = 0
    fileprivate var _starting: Bool = false
    fileprivate var _stoping: Bool = false
    
    
    /**
    Init View
 
 - parameter frame: view frame
 
    **/
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        var frame = self.bounds
        var thirdFrame = self.bounds
        frame.origin.y = (frame.size.height)
        frame.size.height = 0
        thirdFrame.origin.y = (thirdFrame.size.height + 50)
        thirdFrame.size.height = 0
        maskWaveLayer.frame = frame
        realWaveLayer.frame = frame
        thirdWaveLayer.frame = thirdFrame
        self.backgroundColor = UIColor.clear
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
 
   Init View with wave Color
 - parameter frame : view frame
 - parmaeter color : real wave color
 - return view
 
 **/
    
    public convenience  init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        
        self.realWaveColor = color
        self.maskWaveColor = color.withAlphaComponent(0.4)
        self.thirdWaveColor = AppColors.themeGreen.withAlphaComponent(0.20)
        
//        self.realWaveColor = UIColor.red
//        self.maskWaveColor = UIColor.blue
       // self.thirdWaveColor = UIColor.black
        
        realWaveLayer.fillColor = self.realWaveColor.cgColor
        maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        thirdWaveLayer.fillColor = self.thirdWaveColor.cgColor
        
        
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(self.maskWaveLayer)
        self.layer.addSublayer(self.thirdWaveLayer)
    }
    
    /** Star Wave
    */
    
    /**
     Start wave
     */
    open func start() {
        if !_starting {
            _stop()
            _starting = true
            _stoping = false
            _waveHeight = 0
            _waveCurvature = 0
            _waveSpeed = 0
            
            timer = CADisplayLink(target: self, selector: #selector(wave))
            timer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    
        }
    }
    
    
    /** Stop Wave
    */
    open func _stop() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    open func stop() {
        if !_stoping {
            _starting = false
            _stoping = true
        }
    }
    
    
    /** wave animation
     **/
 
    @objc func wave() {
        if _starting {
            if _waveHeight < waveHeight {
                _waveHeight = _waveHeight + waveHeight/100.0
                var frame = self.bounds
                var thirdFrame = self.bounds
                thirdFrame.origin.y = (thirdFrame.size.height - _waveHeight)
                frame.origin.y = (frame.size.height-_waveHeight)
                frame.size.height = _waveHeight
                thirdFrame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                thirdWaveLayer.frame = thirdFrame
                _waveCurvature = _waveCurvature + waveCurvature / 100.0
                _waveSpeed = _waveSpeed + waveSpeed / 50.0
            } else {
                _starting = false
            }
        }
        
        if _stoping {
            if _waveHeight > 0 {
                _waveHeight = _waveHeight - waveHeight/50.0
                var frame = self.bounds
                frame.origin.y = frame.size.height
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                thirdWaveLayer.frame = frame
                _waveCurvature = _waveCurvature - waveCurvature / 50.0
                _waveSpeed = _waveSpeed - waveSpeed / 50.0
            } else {
//                _stoping = false
//                 _stop()
            }
        }
        
        offset += _waveSpeed
        
        let width = frame.width
        let height = CGFloat(_waveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        var y: CGFloat = 0
        
        let maskpath = CGMutablePath()
        maskpath.move(to: CGPoint(x: 0, y: height))
        
        // third Wave path
        let thirdWavePath = CGMutablePath()
        thirdWavePath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveCurvature_f = Float(0.01 * _waveCurvature)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf( waveCurvature_f * Float(x) + offset_f))
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskpath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
            thirdWavePath.addLine(to: CGPoint(x: CGFloat(x), y: -(2 * y) / 3 ))
        }
        
        
        
        // real Wave layer
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.closeSubpath()
        self.realWaveLayer.path = path
        
        // mask Path
        maskpath.addLine(to: CGPoint(x: width, y: height))
        maskpath.addLine(to: CGPoint(x: 0, y: height))
        
        maskpath.closeSubpath()
        self.maskWaveLayer.path = maskpath
        
        // third wave path
        thirdWavePath.addLine(to: CGPoint(x: width, y: height))
        thirdWavePath.addLine(to: CGPoint(x: 0, y: height))
        
        thirdWavePath.closeSubpath()
        self.thirdWaveLayer.path = thirdWavePath
        

        
    }
}
