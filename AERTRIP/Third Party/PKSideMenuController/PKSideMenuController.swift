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
    public static var sideDistanceForOpenMenu: CGFloat = 0.59 * UIScreen.main.bounds.width
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
        
        if let menu = menuContainer {
            return menu.frame.origin.x <= CGFloat(0.0)
        }
        return false
    }
    
    public weak var delegate: PKSideMenuControllerDelegate?
    
    private(set) var menuContainer : UIView?
    private(set) var menuViewController : UIViewController?

    //MARK:- Private
    private(set) var mainContainer : UIView?
    private(set) var mainViewController : UIViewController?
    private var shadowLayer: CAShapeLayer!
    private let animationTime: TimeInterval = 0.4
    
    private var distanceOpenMenu: CGFloat {
        return PKSideMenuOptions.currentOpeningSide == .left ? -(PKSideMenuOptions.sideDistanceForOpenMenu) : PKSideMenuOptions.sideDistanceForOpenMenu
    }
    
    var visibleSpace: CGFloat {
        let extra = PKSideMenuOptions.sideDistanceForOpenMenu - (PKSideMenuOptions.sideDistanceForOpenMenu * 0.85)
        return self.view.bounds.size.width - (PKSideMenuOptions.sideDistanceForOpenMenu + 10.0) + extra
    }
    
    private var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private var closeMenuGestureRecognizer: UIPanGestureRecognizer?
    private var lastPanLocation: CGFloat?
    
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
        self.view.addSubview(self.menuContainer!)
        
        self.mainContainer = UIView()
        self.mainContainer!.frame = self.view.bounds
        self.mainContainer!.backgroundColor = UIColor.clear
        self.view.addSubview(self.mainContainer!)
        
        self.addDropOffShadow()
        if PKSideMenuOptions.currentAnimation == .curve3D {
            self.setup3DShadowLayer(withCornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, shadowWidthFrom: 0.0, shadowWidthTo: PKSideMenuOptions.mainViewShadowWidth)
        }
        
        self.addEdgeSwipeGesture()
        self.addClosePanGesture()
    }
    
    private func addDropOffShadow() {
        let layerTemp = self.mainContainer!.layer
        layerTemp.masksToBounds = false
        layerTemp.shadowColor = PKSideMenuOptions.dropOffShadowColor.cgColor
        layerTemp.shadowOpacity = 0.0
        layerTemp.shadowOffset = CGSize(width: 25, height: 10)
        layerTemp.shadowRadius = 50

        layerTemp.shadowPath = UIBezierPath(roundedRect: self.mainContainer!.bounds, cornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode).cgPath
    }
    
    private func animateDropOffShadow(from: CGFloat, to: CGFloat, animated: Bool = true) {
        let layerTemp = self.mainContainer!.layer

        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? self.animationTime : 0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        layerTemp.add(animation, forKey: animation.keyPath)
        layerTemp.shadowOpacity = Float(to)
        
        CATransaction.commit()
    }
    
    private func animate3DShadow(from: CGFloat, to: CGFloat, animated: Bool = true) {
        
        guard let layerTemp = shadowLayer else {
            return
        }
        
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? self.animationTime : 0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        layerTemp.add(animation, forKey: animation.keyPath)
        layerTemp.shadowOpacity = Float(to)
        
        CATransaction.commit()
    }
    
    private func animateMainViewCorner(from: CGFloat, to: CGFloat, animated: Bool = true) {
        
        guard let layerTemp = self.mainViewController?.view.layer else {
            return
        }
        
        layerTemp.masksToBounds = true
        /* Do Animations */
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? self.animationTime : 0)
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
        edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        edgePanGestureRecognizer?.edges = (PKSideMenuOptions.currentOpeningSide == .left) ? .right : .left
        self.mainContainer?.addGestureRecognizer(edgePanGestureRecognizer!)
    }
    
    private func addClosePanGesture() {
        closeMenuGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        closeMenuGestureRecognizer?.delegate = self
        self.view?.addGestureRecognizer(closeMenuGestureRecognizer!)
        closeMenuGestureRecognizer?.isEnabled = false
    }
    
    private func animateToProgress(_ progressX: CGFloat) {
            let layerTemp : CALayer = (self.mainContainer?.layer)!

            var tRotate : CATransform3D = CATransform3DIdentity
            tRotate.m34 = 1.0 / (-700.0)
            
            let mainMultiplier = ((self.view.width - progressX) / self.view.width)*2
            
            let aXpos = self.degreesToRadians(-40) * mainMultiplier/2
            tRotate = CATransform3DRotate(tRotate, aXpos, 0.0, 1.0, 0.0)
            var tScale : CATransform3D = CATransform3DIdentity
            tScale.m34 = 1.0 / (-800.0)
            
            let xMultiplier = 0.75 * mainMultiplier/3
            let yMultiplier = 0.68 * mainMultiplier/3
            
            tScale = CATransform3DScale(tScale, 1 - xMultiplier, 1 - yMultiplier, 1.0)
            
            let scaleRotate = CATransform3DConcat(tScale, tRotate)
            
            let translationX = progressX - self.view.bounds.width
            
            let transformation = CATransform3DMakeTranslation(translationX, 0, 0)
            
            layerTemp.transform = CATransform3DConcat(scaleRotate, transformation)

            self.menuContainer?.transform = CGAffineTransform(translationX: (translationX * 1.72), y: 0)

    }
    
    private func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        degrees * (.pi/180)
    }
    
    //MARK:- Public
    func menuViewController(_ menuVC : UIViewController) {
        if (self.menuViewController != nil) {
            self.menuViewController?.willMove(toParent: nil)
            self.menuViewController?.removeFromParent()
            self.menuViewController?.view.removeFromSuperview()
        }
        
        self.menuViewController = menuVC
        let newFrame = CGRect(x: PKSideMenuOptions.sideDistanceForOpenMenu/2, y: 0.0, width: (view.width - PKSideMenuOptions.sideDistanceForOpenMenu/2), height: view.height)
        self.menuViewController!.view.frame = newFrame
        self.menuViewController!.view.layer.masksToBounds = true
        self.addChild(self.menuViewController!)
        self.menuContainer?.addSubview(menuVC.view)
        self.didMove(toParent: self.menuViewController)
    }
    
    func mainViewController(_ mainVC : UIViewController) {
//        closeMenu()

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
            DispatchQueue.main.async {
                self.addShadowsAndCornerRadius()
                UIView.animate(withDuration: self.animationTime, animations: {
                    self.animateToProgress(self.view.width - PKSideMenuOptions.sideDistanceForOpenMenu)
                }, completion: { _ in
                    self.edgePanGestureRecognizer?.isEnabled = false
                    self.closeMenuGestureRecognizer?.isEnabled = true
                    
                })
            }
            
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
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.animationTime, animations: {
                    self.animateToProgress(self.view.width)
                }, completion: { _ in
                    self.removeShadowsAndCornerRadius()
                    self.edgePanGestureRecognizer?.isEnabled = true
                    self.closeMenuGestureRecognizer?.isEnabled = false
                })
            }
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
        self.mainViewController!.view.isUserInteractionEnabled = true
    }
    
    @objc func tapMainAction(){
        closeMenu()
        removeGesture()
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
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: view)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer.require(toFail: gestureRecognizer)
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view {
            return touchedView.isDescendant(of: self.view)
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK:- Animation Funstions
//MARK:-
extension PKSideMenuController {
    
    //MARK:- Normal animation
    private func openWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer?.frame = mainFrame
            
            self.menuContainer?.transform = CGAffineTransform(translationX: PKSideMenuOptions.currentOpeningSide == .left ? -(self.view.bounds.width) : self.view.bounds.width, y: 0.0)

        }) { (finished: Bool) -> Void in
            
        }
    }
    
    private func closeWithCurveLinear(mainFrame: CGRect) {
        UIView.animate(withDuration: self.animationTime, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.mainContainer?.frame = mainFrame
            
            self.menuContainer?.transform = CGAffineTransform.identity

        }) { (finished: Bool) -> Void in
            self.mainViewController?.view.isUserInteractionEnabled = true
        }
    }
}

extension PKSideMenuController {
    
    @objc
    func panGestureRecognized(_ recognizer: UIGestureRecognizer) {
        
        if let gestRecog =  recognizer as? UIScreenEdgePanGestureRecognizer {
            actionForEdgePanGesture(gestRecog)
        } else {
            guard let gestRecog = recognizer as? UIPanGestureRecognizer else { return }
            actionForPanGesture(gestRecog)
        }
    }
    
    private func actionForEdgePanGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if !self.isOpen {
            let progress = recognizer.location(in: view)
            let progressX = progress.x
            if recognizer.state == .began {
                addShadowsAndCornerRadius(false)
                
            } else if recognizer.state == .ended {
                if progressX < (view.width * (2/3)) {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.animateToProgress(self.view.width - PKSideMenuOptions.sideDistanceForOpenMenu)
                        }) { _ in
                            self.edgePanGestureRecognizer?.isEnabled = false
                            self.closeMenuGestureRecognizer?.isEnabled = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.animateToProgress(self.view.width)
                        }) { (_) in
                            self.removeShadowsAndCornerRadius()
                            self.removeGesture()
                            self.edgePanGestureRecognizer?.isEnabled = true
                            self.closeMenuGestureRecognizer?.isEnabled = false
                        }
                    }
                }
                addTapGestures()
            }  else {
                if progressX < (view.width - PKSideMenuOptions.sideDistanceForOpenMenu) + 20 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.animateToProgress(self.view.width - PKSideMenuOptions.sideDistanceForOpenMenu)
                        }) { _ in
                            self.edgePanGestureRecognizer?.isEnabled = false
                            self.closeMenuGestureRecognizer?.isEnabled = true
                        }
                    }
                    addTapGestures()
                } else {
                    animateToProgress(progressX)
                }
            }
        }
    }
    
    private func actionForPanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translationX = recognizer.translation(in: view).x
        let totalTranslation = (view.width - PKSideMenuOptions.sideDistanceForOpenMenu) + translationX
        guard translationX >= 0, totalTranslation <= view.width else {
            applyEndedGesture(totalTranslation)
            return
        }
        if recognizer.state == .ended {
            applyEndedGesture(totalTranslation)
        } else {
            if totalTranslation < (view.width - PKSideMenuOptions.sideDistanceForOpenMenu) + 10 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.animateToProgress(self.view.width - PKSideMenuOptions.sideDistanceForOpenMenu)
                    }) { _ in
                        self.edgePanGestureRecognizer?.isEnabled = false
                        self.closeMenuGestureRecognizer?.isEnabled = true
                    }
                }
                addTapGestures()
            } else if totalTranslation >= (view.width - 20) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.animateToProgress(self.view.width)
                    }) { (_) in
                        self.removeShadowsAndCornerRadius()
                        self.removeGesture()
                        self.edgePanGestureRecognizer?.isEnabled = true
                        self.closeMenuGestureRecognizer?.isEnabled = false
                    }
                }
            } else {
                animateToProgress(totalTranslation)
            }
        }
        lastPanLocation = totalTranslation
    }
    
    private func applyEndedGesture(_ totalTranslation: CGFloat) {
        if (totalTranslation) < (view.width * (2/3)) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.animateToProgress(self.view.width - PKSideMenuOptions.sideDistanceForOpenMenu)
                }) { _ in
                    self.edgePanGestureRecognizer?.isEnabled = false
                    self.closeMenuGestureRecognizer?.isEnabled = true
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.animateToProgress(self.view.width)
                }) { (_) in
                    self.removeShadowsAndCornerRadius()
                    self.removeGesture()
                    self.edgePanGestureRecognizer?.isEnabled = true
                    self.closeMenuGestureRecognizer?.isEnabled = false
                }
            }
        }
        addTapGestures()
    }
    
    private func addShadowsAndCornerRadius(_ animated: Bool = true) {
        self.animateDropOffShadow(from: 0.0, to: 1, animated: animated)
        self.animate3DShadow(from: 0.0, to: 1.0, animated: animated)
        self.animateMainViewCorner(from: 0.0, to: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, animated: animated)
        self.delegate?.willOpenSideMenu()
    }
    
    private func removeShadowsAndCornerRadius(_ animated: Bool = true) {
        self.animateDropOffShadow(from: 1, to: 0.0, animated: animated)
        self.animate3DShadow(from: 1.0, to: 0.0, animated: animated)
        self.animateMainViewCorner(from: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, to: 0.0, animated: animated)
        self.delegate?.willCloseSideMenu()
    }
    
}
