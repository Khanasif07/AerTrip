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
    public static var mainViewCornerRadiusInOpenMode: CGFloat = 18.0
    public static var sideDistanceForOpenMenu: CGFloat = 220.0
    public static var opacityViewBackgroundColor: UIColor = UIColor.green
    public static var mainViewShadowColor: UIColor = UIColor.black
    public static var mainViewShadowWidth: Double = 5.0
    public static var dropOffShadowColor: UIColor = UIColor.black
    public static var panGesturesEnabled: Bool = true
    public static var tapGesturesEnabled: Bool = true
    public static var currentOpeningSide: PKSideMenuOpenSide = .left
    public static var currentAnimation: PKSideMenuAnimation = .curve3D
}

public protocol PKSideMenuControllerDelegate: class {
    func willOpenSideMenu()
    func willCloseSideMenu()
}

open class PKSideMenuController: UIViewController {
    
    //MARK:- Properties
    //MARK:- Public
    public var isOpen: Bool {
//        let fMain : CGRect = self.mainContainer!.frame
//        return (fMain.minX == self.distanceOpenMenu)
        
        if let menu = menuContainer {
            return menu.frame.origin.x <= CGFloat(0.0)
        }
        return false
    }
    
    public weak var delegate: PKSideMenuControllerDelegate?
    
    private(set) var menuContainer : UIView?
    private(set) var menuViewController : UIViewController?

    //MARK:- Private
    private var mainContainer : UIView?
    private var mainViewController : UIViewController?
    private var shadowLayer: CAShapeLayer!
    private let animationTime: TimeInterval = 0.4
    
    private var distanceOpenMenu: CGFloat {
        return PKSideMenuOptions.currentOpeningSide == .left ? -(PKSideMenuOptions.sideDistanceForOpenMenu) : PKSideMenuOptions.sideDistanceForOpenMenu
    }
    
    private var visibleSpace: CGFloat {
        let extra = PKSideMenuOptions.sideDistanceForOpenMenu - (PKSideMenuOptions.sideDistanceForOpenMenu * 0.85)
        return self.view.bounds.size.width - (PKSideMenuOptions.sideDistanceForOpenMenu + extra + 10.0)
    }
    
    //MARK:- View Controller Life Cycle
    //MARK:-
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        
        if self.menuViewController != nil {
             return .lightContent
        }
        
        if self.mainViewController != nil {
            return .default
        }
       
         return .default
     }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup(){
        self.view.backgroundColor = UIColor.white
        self.menuContainer = UIView()
        
        var newFrame = self.view.bounds
        newFrame.origin.x = PKSideMenuOptions.currentOpeningSide == .right ? -(self.view.bounds.width) : self.view.bounds.width
        self.menuContainer!.frame = newFrame
        self.menuContainer!.backgroundColor = UIColor.clear
        self.view.addSubview((self.menuContainer!))
        
        self.mainContainer = UIView()
        self.mainContainer!.frame = self.view.bounds
        self.mainContainer!.backgroundColor = UIColor.clear
        self.view.addSubview((self.mainContainer!))
        
        self.addDropOffShadow()
        if PKSideMenuOptions.currentAnimation == .curve3D {
            self.setup3DShadowLayer(withCornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, shadowWidthFrom: 0.0, shadowWidthTo: PKSideMenuOptions.mainViewShadowWidth)
        }
        
        self.addEdgeSwipeGesture()
    }
    
    private func addDropOffShadow() {
        let layerTemp = self.mainContainer!.layer
        layerTemp.masksToBounds = false
        layerTemp.shadowColor = PKSideMenuOptions.dropOffShadowColor.cgColor
        layerTemp.shadowOpacity = 0.0
        layerTemp.shadowOffset = CGSize(width: 0, height: 2)
        layerTemp.shadowRadius = 15.0

        layerTemp.shadowPath = UIBezierPath(roundedRect: self.mainContainer!.bounds, cornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode).cgPath
    }
    
    private func animateDropOffShadow(from: CGFloat, to: CGFloat) {
        let layerTemp = self.mainContainer!.layer

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
            self.mainContainer?.layer.insertSublayer(shadowLayer, at: 1)
        }

        shadowLayer.path = UIBezierPath(roundedRect: self.mainContainer?.bounds ?? .zero, cornerRadius: withCornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = PKSideMenuOptions.mainViewShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowWidthTo, height: 0.0)
        shadowLayer.shadowOpacity = 0.0
        shadowLayer.shadowRadius = 0.0
    }
    
    private func addEdgeSwipeGesture() {
        let openGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeSwipeOpenAction(_:)))
        openGesture.edges = (PKSideMenuOptions.currentOpeningSide == .left) ? .right : .left
        openGesture.delegate = self
        
        self.view.addGestureRecognizer(openGesture)
        
        let closeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeSwipeCloseAction(_:)))
        closeGesture.edges = (PKSideMenuOptions.currentOpeningSide == .right) ? .right : .left
        closeGesture.delegate = self
        
        self.view.addGestureRecognizer(closeGesture)
    }
    
    @objc private func edgeSwipeOpenAction(_ sender: UIGestureRecognizer) {
        if sender.state == .began, !self.isOpen {
            self.openMenu()
        }
    }
    
    @objc private func edgeSwipeCloseAction(_ sender: UIGestureRecognizer) {
        if sender.state == .began, self.isOpen {
            self.closeMenu()
        }
    }
    
    //MARK:- Public
    func menuViewController(_ menuVC : UIViewController) {
        if (self.menuViewController != nil) {
            self.menuViewController?.willMove(toParent: nil)
            self.menuViewController?.removeFromParent()
            self.menuViewController?.view.removeFromSuperview()
        }
        
        self.menuViewController = menuVC
        let newFrame = CGRect(x: self.visibleSpace, y: 0.0, width: (self.view.bounds.size.width - self.visibleSpace), height: self.view.bounds.size.height)
        self.menuViewController!.view.frame = newFrame
        self.menuViewController!.view.layer.masksToBounds = true
        self.addChild(self.menuViewController!)
        self.menuContainer?.addSubview(menuVC.view)
        self.didMove(toParent: self.menuViewController)
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
        self.addChild(self.mainViewController!)
        self.mainContainer?.addSubview(self.mainViewController!.view)
        self.didMove(toParent: self.mainViewController)
        
        if (self.mainContainer!.frame.minX == self.distanceOpenMenu) {
            closeMenu()
        }
    }
    
    func openMenu(){
       
        addTapGestures()
        var fMain : CGRect = self.mainContainer!.frame
        fMain.origin.x = self.distanceOpenMenu
        
        self.delegate?.willOpenSideMenu()
        switch PKSideMenuOptions.currentAnimation {
        case .curve3D:
            self.openWith3DAnimation(mainFrame: fMain)
            
        case .curveLinear:
            self.openWithCurveLinear(mainFrame: fMain)
        }
    }
    
    func closeMenu(){
        var fMain : CGRect = self.mainContainer!.frame
        fMain.origin.x = 0
        
        self.delegate?.willCloseSideMenu()
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
        self.mainContainer!.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func removeGesture(){
        for recognizer in  self.mainContainer!.gestureRecognizers ?? [] {
            if (recognizer .isKind(of: UITapGestureRecognizer.self)){
                self.mainContainer!.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc func tapMainAction(){
        closeMenu()
    }
    
    func toggleMenu(){
        if self.isOpen {
            closeMenu()
        }else{
            openMenu()
        }
    }
}


extension PKSideMenuController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer.require(toFail: gestureRecognizer)
        return true
    }
    private func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: self.view) {
            return false
        }
        return true
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
            let layerTemp : CALayer = (self.mainContainer?.layer)!
            layerTemp.zPosition = 1000

            var tRotate : CATransform3D = CATransform3DIdentity
            tRotate.m34 = 1.0 / (-800.0)
            tRotate.m44 = 1.0

            let aXpos: CGFloat = CGFloat(-40.0 * (.pi / 180))
            tRotate = CATransform3DRotate(tRotate,aXpos, 0.0, 1.0, 0.0)

            var tScale : CATransform3D = CATransform3DIdentity
            tScale.m34 = 1.0 / (-800.0)
            tScale = CATransform3DScale(tScale, 0.85, 0.75, 1.0)
            layerTemp.transform = CATransform3DConcat(tScale, tRotate)

            self.mainContainer?.frame = mainFrame
            
            var finalX = PKSideMenuOptions.currentOpeningSide == .left ? -(self.view.bounds.width) : self.view.bounds.width
            if UIDevice.isPlusDevice {
                finalX += 78.0
            }
            self.menuContainer?.transform = CGAffineTransform(translationX: finalX, y: 0.0)

        }) { (finished: Bool) -> Void in
        }
    }
    
    private func closeWith3DAnimation() {
        self.animateDropOffShadow(from: 0.8, to: 0.0)
        self.animate3DShadow(from: 1.0, to: 0.0)
        self.animateMainViewCorner(from: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, to: 0.0)

        UIView.animate(withDuration: self.animationTime, delay: 0.0, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.mainContainer?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            let layerTemp : CALayer = (self.mainContainer?.layer)!
            layerTemp.zPosition = 1000
            
            var tRotate : CATransform3D = CATransform3DIdentity
            tRotate.m34 = 1.0 / (-800.0)
            
            let aXpos: CGFloat = CGFloat(0.0 * (.pi / 180.0))
            tRotate = CATransform3DRotate(tRotate,aXpos, 0.0, 1.0, 0.0)
            layerTemp.transform = tRotate
            
            var tScale : CATransform3D = CATransform3DIdentity
            tScale.m34 = 1.0 / (-800.0)
            tScale = CATransform3DScale(tScale, 1.0, 1.0, 1.0)
            layerTemp.transform = tScale
            layerTemp.transform = CATransform3DConcat(tRotate, tScale)
            layerTemp.transform = CATransform3DConcat(tScale, tRotate)
            self.mainContainer!.frame = CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: UIScreen.main.bounds.height)
            
            self.menuContainer?.transform = CGAffineTransform.identity

        }) { (finished: Bool) -> Void in
            self.mainViewController!.view.isUserInteractionEnabled = true
            self.removeGesture()
        }
    }
    
    //MARK:- Normal animation
    private func openWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer!.frame = mainFrame
            
            self.menuContainer?.transform = CGAffineTransform(translationX: PKSideMenuOptions.currentOpeningSide == .left ? -(self.view.bounds.width) : self.view.bounds.width, y: 0.0)

        }) { (finished: Bool) -> Void in
            
        }
    }
    
    private func closeWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer!.frame = mainFrame
            
            self.menuContainer?.transform = CGAffineTransform.identity

        }) { (finished: Bool) -> Void in
            self.mainViewController!.view.isUserInteractionEnabled = true
        }
    }
}
