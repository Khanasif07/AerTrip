//
//  PKSideMenuController.swift
//
//  Created by Pramod Kumar on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

public struct PKSideMenuOptions {
    public static var mainViewCornerRadiusInOpenMode: CGFloat = 30.0
    public static var rightViewWidth: CGFloat = 220.0
    public static var opacityViewBackgroundColor: UIColor = UIColor.green
    public static var mainViewShadowColor: UIColor = UIColor.black
    public static var panGesturesEnabled: Bool = true
    public static var tapGesturesEnabled: Bool = true
}

class PKSideMenuController: UIViewController {
    //MARK:- Properties
    //MARK:- Public
    open var opacityView = UIView()
    open var mainContainerView = UIView()
    open var rightContainerView =  UIView()
    
    open var isRightOpen: Bool {
        return mainContainerView.frame.origin.x < 0
    }
    
    open var isRightHidden: Bool {
        return rightContainerView.frame.origin.x >= view.bounds.width
    }
    
    //MARK:- Private
    private var mainViewController: UIViewController?
    private var rightMenuViewController: UIViewController?
    private var rightPanGesture: UIPanGestureRecognizer?
    private var rightTapGesture: UITapGestureRecognizer?
    private var shadowLayer: CAShapeLayer!
    
    
    private var rightMinOrigin: CGFloat {
        return view.frame.size.width - 20.0
    }
    
    //MARK:- Intializer
    //MARK:-
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(mainViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.rightMenuViewController = rightMenuViewController
        initView()
    }
    
    open override func awakeFromNib() {
        initView()
    }
    
    deinit { }
    
    //MARK:- View Controller Life Cycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initView() {
        
        self.view.backgroundColor = .white
        setupOpacity()
        setupMainViewController()
        setupRightViewController()
    }
    
    private func setupMainViewController() {
        guard let vc = self.mainViewController else {
            fatalError("mainViewController not provided")
        }
        
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.backgroundColor = UIColor.clear
        mainContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        vc.view.frame = mainContainerView.bounds
        vc.view.layer.masksToBounds = true
        mainContainerView.addSubview(vc.view)
        view.insertSubview(mainContainerView, at: 2)
    }
    
    private func setupRightViewController() {
        guard let vc = self.rightMenuViewController else {
            fatalError("rightMenuViewController not provided")
        }
        
        var rightFrame: CGRect = view.bounds
        rightFrame.size.width = PKSideMenuOptions.rightViewWidth
        rightFrame.origin.x = rightMinOrigin
        let rightOffset: CGFloat = 0
        rightFrame.origin.y = rightFrame.origin.y + rightOffset
        rightFrame.size.height = rightFrame.size.height - rightOffset
        rightContainerView = UIView(frame: rightFrame)
        rightContainerView.backgroundColor = UIColor.clear
        rightContainerView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        vc.view.frame = rightContainerView.bounds
        rightContainerView.addSubview(vc.view)
        view.insertSubview(rightContainerView, at: 0)
    }
    
    private func setupOpacity() {
        var opacityframe: CGRect = view.bounds
        let opacityOffset: CGFloat = 0
        opacityframe.origin.y = opacityframe.origin.y + opacityOffset
        opacityframe.size.height = opacityframe.size.height - opacityOffset
        opacityView = UIView(frame: opacityframe)
        opacityView.backgroundColor = PKSideMenuOptions.opacityViewBackgroundColor
        opacityView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        opacityView.alpha = 0.5
        view.insertSubview(opacityView, at: 1)
    }
    
    private func setupShadowLayer(withCornerRadius: CGFloat, shadowWidth: Double) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            self.mainContainerView.layer.insertSublayer(shadowLayer, at: 0)
//            self.mainViewController?.view.layer.insertSublayer(shadowLayer, at: 0)
//            self.mainContainerView.layer.addSublayer(shadowLayer)
        }
        
        self.mainViewController?.view.layer.cornerRadius = withCornerRadius
        shadowLayer.path = UIBezierPath(roundedRect: self.mainContainerView.bounds, cornerRadius: withCornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = PKSideMenuOptions.mainViewShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowWidth, height: 0.0)
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowRadius = 0.0
    }
    
    @objc private func handleRightPanGesture(_ panGesture: UIPanGestureRecognizer) {
    }
    
    //MARK:- Public
    open func addRightGestures() {
        if rightMenuViewController != nil {
            if PKSideMenuOptions.panGesturesEnabled {
                if rightPanGesture == nil {
                    rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleRightPanGesture(_:)))
//                    rightPanGesture!.delegate = self
                    view.addGestureRecognizer(rightPanGesture!)
                }
            }
            
            if PKSideMenuOptions.tapGesturesEnabled {
                if rightTapGesture == nil {
                    rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleRight))
//                    rightTapGesture!.delegate = self
                    view.addGestureRecognizer(rightTapGesture!)
                }
            }
        }
    }
    
    @objc open func toggleRight() {
        if isRightOpen {
            //close right
            self.hideRightMenu()
        }
        else {
            //open right
            self.showRightMenu()
        }
    }
    
    open func showRightMenu() {
        
//        var rotationAndPerspectiveTransform: CATransform3D = CATransform3DIdentity
//        rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (.pi * 0.9), 0.0, 5.0, 0.0)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setupShadowLayer(withCornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, shadowWidth: 8.0)

            let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.85)
            let translateTransform = CGAffineTransform(translationX: -(PKSideMenuOptions.rightViewWidth), y: 0.0)

            let animationTransform = translateTransform.concatenating(scaleTransform)
            self.mainContainerView.transform = animationTransform
            
//            self.mainContainerView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
//            self.mainContainerView.layer.transform = rotationAndPerspectiveTransform
            
            self.opacityView.alpha = 0.0
            
        }) { (isCompleted) in
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.rightContainerView.transform = CGAffineTransform(translationX: -(self.view.frame.size.width - PKSideMenuOptions.rightViewWidth), y: 0.0)
            
        }) { (isCompleted) in
            
        }
    }
    
    open func hideRightMenu() {

        UIView.animate(withDuration: 0.3, animations: {
            self.mainContainerView.transform = CGAffineTransform.identity
            self.setupShadowLayer(withCornerRadius: PKSideMenuOptions.mainViewCornerRadiusInOpenMode, shadowWidth: 0.0)
            
            self.opacityView.alpha = 0.5

        }) { (isCompleted) in
            self.mainViewController?.view.layer.cornerRadius = 0.0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.rightContainerView.transform = CGAffineTransform(translationX: (self.view.frame.size.width - PKSideMenuOptions.rightViewWidth), y: 0.0)

        }) { (isCompleted) in
            
        }
    }
}


extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
