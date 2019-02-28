//
//  PKBottomSheet.swift
//  AERTRIP
//
//  Created by Admin on 26/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PKBottomSheetDelegate: class {
    func willHide(_ sheet: PKBottomSheet)
}

class PKBottomSheet: UIView {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet private weak var mainContainerView: UIView!
    @IBOutlet private weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerContainerView: UIView!
    @IBOutlet private weak var dataContainerView: UIView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: PKBottomSheetDelegate?
    
    /* gapFromTop
     * - used to give the gap from top of screen.
     */
    var gapFromTop: CGFloat = 50.0
    
    /* headerHeight
     * - used to decide the visibel height of the header of sheet.
     */
    var headerHeight: CGFloat = 44.0
    
    /* headerShouldStuckOnBottom
     * - used to decide that header should be stuck on bottom or not.
     */
    var headerShouldStuckOnBottom: Bool = false
    
    /* backgroundOpacity
     * - used to set the opacity for the background color.
     */
    var backgroundOpacity: CGFloat = 0.4
    
    /* headerCornerRadius
     * - used to give the top corners
     */
    var headerCornerRadius: CGFloat = 10.0
    
    /* animationDuration
     * - duration in which sheet will present/dismiss
     */
    var animationDuration: TimeInterval = 0.4
    
    /* isPanGestureEnabled
     * - Used to decide user will able to present/hide by fingre drag.
     */
    var isPanGestureEnabled: Bool = true
    
    /* headerView
     * - used as the header of the sheet
     */
    var headerView: UIView?
    
    
    //MARK:- Private
    private var presentedViewController: UIViewController!
    
    private var sheetHeight: CGFloat {
        let height = self.parentViewController?.view.height ?? UIScreen.main.bounds.height
        return height - gapFromTop
    }
    
    private var oldPanPoint = CGPoint.zero

    //MARK:- Sheet Life Cycle
    //MARK:-
    private override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.initialSetups()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetups()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: self)
        if location.y <= gapFromTop {
            self.dismiss(animated: true)
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        updateViewSetup()
        
        addPanGesture()
    }
    
    private func updateViewSetup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(self.backgroundOpacity)
    }
    
    private func show(animated: Bool) {
        
        self.updateViewSetup()
        UIView.animate(withDuration: animated ? animationDuration*2.0 : 0.0, delay: 0.0, usingSpringWithDamping: animated ? 0.7 : 0.0, initialSpringVelocity: animated ? 0.4 : 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.mainContainerBottomConstraint.constant = 0.0
            
            sSelf.layoutIfNeeded()
            }, completion: { (isDone) in
                
        })
    }
    
    private func hide(animated: Bool, completion: ((Bool)->Void)? = nil) {
        self.delegate?.willHide(self)
        UIView.animate(withDuration: animated ? animationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.mainContainerBottomConstraint.constant = sSelf.headerShouldStuckOnBottom ? -(sSelf.sheetHeight - sSelf.headerHeight) : -(sSelf.sheetHeight)
            
            sSelf.layoutIfNeeded()
            }, completion: { (isDone) in
                completion?(isDone)
        })
    }
    
    private func setupContainerView() {
        
        presentedViewController.view.frame = dataContainerView.bounds
        presentedViewController.view.translatesAutoresizingMaskIntoConstraints = true
        dataContainerView.addSubview(presentedViewController.view)
    }
    
    private func setupHeaderView() {
        mainContainerHeightConstraint.constant = sheetHeight
        headerHeightConstraint.constant = headerHeight
        
        if let hView = self.headerView {
            hView.translatesAutoresizingMaskIntoConstraints = true
            hView.frame = headerContainerView.bounds
            headerContainerView.addSubview(hView)
        }
        
        mainContainerView.roundCorners(corners: [.topLeft, .topRight], radius: headerCornerRadius)
        mainContainerView.layer.masksToBounds = true
    }
    
    private func addPanGesture() {
        if isPanGestureEnabled {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handelPanGesture(_:)))
            self.mainContainerView?.addGestureRecognizer(pan)
        }
    }
    
    @objc private func handelPanGesture(_ sender: UIGestureRecognizer) {
        guard isPanGestureEnabled else {return}
        
        let touchedPoint = sender.location(in: self.window)
        
        if sender.state == .began {
            oldPanPoint = touchedPoint
        }
        else if sender.state == .changed {
            let diff = -(touchedPoint.y - oldPanPoint.y)
            if diff > 0 {
                //show
                mainContainerBottomConstraint.constant = -(sheetHeight - diff)
            }
            else {
                //hide
                mainContainerBottomConstraint.constant = diff
            }
        }
        else if sender.state == .ended {
            if mainContainerBottomConstraint.constant > -(self.sheetHeight/2.0) {
                //show
                self.show(animated: true)
            }
            else {
                //hide
                self.dismiss(animated: true)
            }
        }
    }
    
    //MARK:- Public
    func present(presentedViewController: UIViewController, animated: Bool) {
        
        self.presentedViewController = presentedViewController
        
        initialSetups()
        
        setupContainerView()
        setupHeaderView()
        
        hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.show(animated: animated)
        }
    }
    
    func dismiss(animated: Bool) {
        self.hide(animated: animated) { [weak self](isDone) in
            guard let sSelf = self else {return}
            if !sSelf.headerShouldStuckOnBottom {
                sSelf.removeFromSuperview()
            }
        }
    }
    
    //MARK:- Action
}


extension PKBottomSheet {
    class var instanceFromNib: PKBottomSheet {
        let myClassNib = UINib(nibName: "PKBottomSheet", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! PKBottomSheet
    }
    
    class func present(onViewController: UIViewController, presentedViewController: UIViewController, headerView: UIView?) {
        let sheet = PKBottomSheet.instanceFromNib
        sheet.headerView = headerView
        sheet.frame = onViewController.view.bounds
        onViewController.view.addSubview(sheet)
        sheet.present(presentedViewController: presentedViewController, animated: true)
    }
}
