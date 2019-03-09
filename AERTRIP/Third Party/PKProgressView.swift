//
//  PKProgressView.swift
//  PKProgressView
//
//  Created by Pramod Kumar on 29/08/16.
//  Copyright © 2016 Pramod Kumar . All rights reserved.
//

import UIKit

@IBDesignable
class PKProgressView: UIView {
    
    
    //MARK:- Private Properties
    //MARK:-
    fileprivate var progressViewAlpha : CGFloat = 1.0
//    private var trackView : UIView!
    fileprivate var progressView : UIView!
    
    //MARK:- Internal Properties
    //MARK:-
    override var alpha : CGFloat {
        didSet {
            self.progressViewAlpha = self.alpha
            super.alpha = 1.0
        }
    }
    
    //MARK:- IBInspectable Properties
    //MARK:-
    @IBInspectable var trackTint : UIColor = UIColor.lightGray {
        didSet {
            self.backgroundColor = self.trackTint
        }
    }
    
    @IBInspectable var progressTint : UIColor = AppColors.themeGreen {
        didSet {
            if let prgrsVw = self.progressView  {
                prgrsVw.backgroundColor = self.progressTint
            }
        }
    }
    
    @IBInspectable var trackBorderWidth : CGFloat = 0.0 {
        didSet {
            self.draw(self.frame)
        }
    }
    
    @IBInspectable var progressBorderWidth : CGFloat = 0.0 {
        didSet {
            self.draw(self.frame)
        }
    }
    
    @IBInspectable var trackBorderColor : UIColor = UIColor.lightGray {
        didSet {
            self.draw(self.frame)
        }
    }
    
    @IBInspectable var progressBorderColor : UIColor = AppColors.themeGreen {
        didSet {
            self.draw(self.frame)
        }
    }
    
    @IBInspectable var minValue : CGFloat = 0.0
    @IBInspectable var maxValue : CGFloat = 1.0
    
    @IBInspectable var progress : CGFloat = 0.0 {
        //between minValue to maxValue
        didSet {
            self.progress = self.progress > self.maxValue ? self.maxValue : self.progress
            self.progress = self.progress < self.minValue ? self.minValue : self.progress
            self.draw(self.frame)
        }
    }
    
    //MARK:- View Life Cycle
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addTrackView()
    }
    
    
    //MARK:- Private Methods
    //MARK:-
    fileprivate func addTrackView() {
        DispatchQueue.delay(0.1, closure: { [weak self] in
            guard let wSelf = self else {
                return
            }
            
            if let prgrsVW = wSelf.progressView {
                prgrsVW.frame = CGRect(x: 0.0, y: 0.0, width: wSelf.getTrackingWidth(), height: wSelf.frame.size.height)
            }
            else {
                wSelf.progressView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: wSelf.getTrackingWidth(), height: wSelf.frame.size.height))
                wSelf.addSubview(wSelf.progressView)
            }
            
            //wSelf.layer.cornerRadius = wSelf.frame.size.height / 2
            wSelf.layer.borderWidth = wSelf.trackBorderWidth
            wSelf.layer.borderColor = wSelf.trackBorderColor.cgColor
            wSelf.layer.masksToBounds = true
            
            wSelf.progressView.backgroundColor = wSelf.progressTint
            //wSelf.progressView.layer.cornerRadius = wSelf.progressView.frame.size.height / 2
            wSelf.progressView.layer.borderWidth = wSelf.progressBorderWidth
            wSelf.progressView.layer.borderColor = wSelf.progressBorderColor.cgColor
            wSelf.progressView.layer.masksToBounds = true
        })
    }
    
    fileprivate func getTrackingWidth() -> CGFloat {
        return self.frame.size.width * self.progress
    }
}
