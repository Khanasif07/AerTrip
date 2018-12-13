//
//  PKSideMenuController.swift
//
//  Created by Pramod Kumar on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

public enum PKSideMenuOpenSide {
    case left
    case right
}

public enum PKSideMenuAnimation {
    case curve3D
    case curveLinear
}

public struct PKSideMenuOptions {
    public static var mainViewCornerRadiusInOpenMode: CGFloat = 15.0
    public static var sideDistanceForOpenMenu: CGFloat = 220.0
    public static var opacityViewBackgroundColor: UIColor = UIColor.green
    public static var mainViewShadowColor: UIColor = UIColor.black
    public static var mainViewShadowWidth: Double = 5.0
    public static var panGesturesEnabled: Bool = true
    public static var tapGesturesEnabled: Bool = true
    public static var currentOpeningSide: PKSideMenuOpenSide = .left
    public static var currentAnimation: PKSideMenuAnimation = .curve3D
}

class PKSideMenuController: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var mainContainer : UIViewController?
    private var menuContainer : UIViewController?
    private var menuViewController : UIViewController?
    private var mainViewController : UIViewController?
    private var shadowLayer: CAShapeLayer!
    private let animationTime: TimeInterval = 0.4
    
    private var distanceOpenMenu: CGFloat {
        return PKSideMenuOptions.currentOpeningSide == .left ? -(PKSideMenuOptions.sideDistanceForOpenMenu) : PKSideMenuOptions.sideDistanceForOpenMenu
    }
    
    //MARK:- View Controller Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setUp(){
        self.view.backgroundColor = UIColor.white
        self.menuContainer = UIViewController()
        self.menuContainer!.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        var newFrame = self.view.bounds
        newFrame.origin.x = PKSideMenuOptions.currentOpeningSide == .right ? -(self.view.bounds.width) : self.view.bounds.width
        self.menuContainer!.view.frame = newFrame
        self.menuContainer!.view.backgroundColor = UIColor.clear
        self.addChild(self.menuContainer!)
        self.view.addSubview((self.menuContainer?.view)!)
        self.menuContainer?.didMove(toParent: self)
        
        self.mainContainer = UIViewController()
        self.mainContainer!.view.frame = self.view.bounds
        self.mainContainer!.view.backgroundColor = UIColor.clear
        self.addChild(self.mainContainer!)
        self.view.addSubview((self.mainContainer?.view)!)
        self.mainContainer?.didMove(toParent: self)
        
        self.addDropOffShadow()
        if PKSideMenuOptions.currentAnimation == .curve3D {
            self.setup3DShadowLayer(withCornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, shadowWidthFrom: 0.0, shadowWidthTo: PKSideMenuOptions.mainViewShadowWidth)
        }
    }
    
    private func addDropOffShadow() {
        let layerTemp = self.mainContainer!.view.layer
        layerTemp.masksToBounds = false
        layerTemp.shadowColor = AppColors.themeBlack.cgColor
        layerTemp.shadowOpacity = 0.0
        layerTemp.shadowOffset = CGSize(width: 0, height: 2)
        layerTemp.shadowRadius = 20.0

        layerTemp.shadowPath = UIBezierPath(roundedRect: self.mainContainer!.view.bounds, cornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode).cgPath
    }
    
    private func animateDropOffShadow(from: CGFloat, to: CGFloat) {
        let layerTemp = self.mainContainer!.view.layer

        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationTime)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        layerTemp.add(animation, forKey: animation.keyPath)
        layerTemp.shadowOpacity = Float(to)
        
        CATransaction.commit()
    }
    
    private func animate3DShadow(from: CGFloat, to: CGFloat) {
        
        guard let layerTemp = shadowLayer else {
            return
        }
        
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationTime)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        layerTemp.add(animation, forKey: animation.keyPath)
        layerTemp.shadowOpacity = Float(to)
        
        CATransaction.commit()
    }
    
    private func animateMainViewCorner(from: CGFloat, to: CGFloat) {
        
        guard let layerTemp = self.mainViewController?.view.layer else {
            return
        }
        
        layerTemp.masksToBounds = true
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationTime)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = from
        animation.toValue = to
        layerTemp.add(animation, forKey: animation.keyPath)
        layerTemp.cornerRadius = to
        
        CATransaction.commit()
    }
    
    private func setup3DShadowLayer(withCornerRadius: CGFloat, shadowWidthFrom: Double, shadowWidthTo: Double) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            self.mainContainer?.view.layer.insertSublayer(shadowLayer, at: 1)
        }

        shadowLayer.path = UIBezierPath(roundedRect: self.mainContainer?.view.bounds ?? .zero, cornerRadius: withCornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = PKSideMenuOptions.mainViewShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowWidthTo, height: 0.0)
        shadowLayer.shadowOpacity = 0.0
        shadowLayer.shadowRadius = 0.0
    }
    
    //MARK:- Public
    func menuViewController(_ menuVC : UIViewController) {
        if (self.menuViewController != nil) {
            self.menuViewController?.willMove(toParent: nil)
            self.menuViewController?.removeFromParent()
            self.menuViewController?.view.removeFromSuperview()
        }
        
        self.menuViewController = menuVC
        self.menuViewController!.view.frame = self.view.bounds
        self.menuViewController!.view.layer.masksToBounds = true
        self.menuContainer?.addChild(self.menuViewController!)
        self.menuContainer?.view.addSubview(menuVC.view)
        self.menuContainer?.didMove(toParent: self.menuViewController)
    }
    
    func mainViewController(_ mainVC : UIViewController) {
        closeMenu()

        if (self.mainViewController != nil) {
            self.mainViewController?.willMove(toParent: nil)
            self.mainViewController?.removeFromParent()
            self.mainViewController?.view.removeFromSuperview()
        }
        self.mainViewController = mainVC
        self.mainViewController!.view.frame = self.view.bounds
        self.mainContainer?.addChild(self.mainViewController!)
        self.mainContainer?.view.addSubview(self.mainViewController!.view)
        self.mainViewController?.didMove(toParent: self.mainContainer)
        
        if (self.mainContainer!.view.frame.minX == self.distanceOpenMenu) {
            closeMenu()
        }
    }
    
    func openMenu(){
       
        addTapGestures()
        var fMain : CGRect = self.mainContainer!.view.frame
        fMain.origin.x = self.distanceOpenMenu
        
        switch PKSideMenuOptions.currentAnimation {
        case .curve3D:
            self.openWith3DAnimation(mainFrame: fMain)
            
        case .curveLinear:
            self.openWithCurveLinear(mainFrame: fMain)
        }
    }
    
    func closeMenu(){
        var fMain : CGRect = self.mainContainer!.view.frame
        fMain.origin.x = 0
        
        switch PKSideMenuOptions.currentAnimation {
        case .curve3D:
            self.closeWith3DAnimation()
            
        case .curveLinear:
            self.closeWithCurveLinear(mainFrame: fMain)
        }
    }
    
    func addTapGestures(){
        self.mainViewController!.view.isUserInteractionEnabled = false
        
        let tapGestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMainAction))
        self.mainContainer!.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeGesture(){
        for recognizer in  self.mainContainer!.view.gestureRecognizers ?? [] {
            if (recognizer .isKind(of: UITapGestureRecognizer.self)){
                self.mainContainer!.view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc func tapMainAction(){
        closeMenu()
    }
    
    func toggleMenu(){
        let fMain : CGRect = self.mainContainer!.view.frame
        if (fMain.minX == self.distanceOpenMenu) {
            closeMenu()
        }else{
            openMenu()
        }
    }
}


//MARK:- Animation Funstions
//MARK:-
extension PKSideMenuController {

    //MARK:- 3D Animations
    private func openWith3DAnimation(mainFrame: CGRect) {
        self.animateDropOffShadow(from: 0.0, to: 0.8)
        self.animate3DShadow(from: 0.0, to: 1.0)
        self.animateMainViewCorner(from: 0.0, to: PKSideMenuOptions.mainViewCornerRadiusInOpenMode)
        
        UIView.animate(withDuration: self.animationTime, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () -> Void in
            let layerTemp : CALayer = (self.mainContainer?.view.layer)!
            layerTemp.zPosition = 1000
            
            var tRotate : CATransform3D = CATransform3DIdentity
            tRotate.m34 = 1.0 / (-500.0)
            
            let aXpos: CGFloat = CGFloat(-20.0 * (.pi / 180))
            tRotate = CATransform3DRotate(tRotate,aXpos, 0.0, 1.0, 0.0)
            
            var tScale : CATransform3D = CATransform3DIdentity
            tScale.m34 = 1.0 / (-500.0)
            tScale = CATransform3DScale(tScale, 0.8, 0.7, 1.0)
            layerTemp.transform = CATransform3DConcat(tScale, tRotate)
            
            self.mainContainer?.view.frame = mainFrame
            
            self.menuContainer?.view.transform = CGAffineTransform(translationX: PKSideMenuOptions.currentOpeningSide == .left ? -(self.view.bounds.width) : self.view.bounds.width, y: 0.0)
            
        }) { (finished: Bool) -> Void in
        }
    }
    
    private func closeWith3DAnimation() {
        self.animateDropOffShadow(from: 0.8, to: 0.0)
        self.animate3DShadow(from: 1.0, to: 0.0)
        self.animateMainViewCorner(from: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, to: 0.0)

        UIView.animate(withDuration: self.animationTime, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.mainContainer?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let layerTemp : CALayer = (self.mainContainer?.view.layer)!
            layerTemp.zPosition = 1000
            
            var tRotate : CATransform3D = CATransform3DIdentity
            tRotate.m34 = 1.0 / (-500.0)
            
            let aXpos: CGFloat = CGFloat(0.0 * (.pi / 180.0))
            tRotate = CATransform3DRotate(tRotate,aXpos, 0.0, 1.0, 0.0)
            layerTemp.transform = tRotate
            
            var tScale : CATransform3D = CATransform3DIdentity
            tScale.m34 = 1.0 / (-500.0)
            tScale = CATransform3DScale(tScale, 1.0, 1.0, 1.0)
            layerTemp.transform = tScale
            layerTemp.transform = CATransform3DConcat(tRotate, tScale)
            layerTemp.transform = CATransform3DConcat(tScale, tRotate)
            self.mainContainer!.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            self.menuContainer?.view.transform = CGAffineTransform.identity

        }) { (finished: Bool) -> Void in
            self.mainViewController!.view.isUserInteractionEnabled = true
            self.removeGesture()
        }
    }
    
    //MARK:- Normal animation
    private func openWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer!.view.frame = mainFrame
            
            self.menuContainer?.view.transform = CGAffineTransform(translationX: PKSideMenuOptions.currentOpeningSide == .left ? -(self.view.bounds.width) : self.view.bounds.width, y: 0.0)

        }) { (finished: Bool) -> Void in
            
        }
    }
    
    private func closeWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer!.view.frame = mainFrame
            
            self.menuContainer?.view.transform = CGAffineTransform.identity

        }) { (finished: Bool) -> Void in
            self.mainViewController!.view.isUserInteractionEnabled = true
        }
    }
}
