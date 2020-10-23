//
//  AerinCustomPopoverVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/10/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AerinCustomPopoverVC: BaseVC {

    // MARK: Variables
    
    enum StartPoint {
        case center
        case top
    }
    
    private var initialPoint: CGFloat = .zero
    private var midPoint: CGFloat = .zero
    private var maxPoint: CGFloat = .zero
    private var minPoint: CGFloat = .zero
    private let maxViewColorAlpha: CGFloat = 0.4

    
    var startPoint: StartPoint = .center
    
    // MARK: Outlets
    
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var popoverViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popoverViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var dragView: UIView!
    
    @IBOutlet weak var aerinImgView: UIImageView!
    @IBOutlet weak var morningBackView: UIView!
    @IBOutlet weak var morningLbl: UILabel!
    @IBOutlet weak var whereToGoLbl: UILabel!
    
    @IBOutlet weak var alignmentView: UIView!
    @IBOutlet weak var alignmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alignmentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var textViewBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var messageTextView: IQTextView!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    // MARK: View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentAnimation()
        delay(seconds: 0.33) {
            self.animateMorningLabel()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        addKeyboard()
        self.statusBarStyle = .darkContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboard()
        IQKeyboardManager.shared().isEnabled = true
    }
    
    // MARK: Actions
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        startDismissAnimation()
    }
    
    
    // MARK: Functions
    
    internal override func initialSetup() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        messageTextView.delegate = self
        setupSubViews()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupSubViews() {
        chatTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: 0, right: 0)
        setupPopoverView()
        addPanGesture()
        setUpAttributes()
    }
    
    //MARK:- Set view attributes
    private func setUpAttributes(){
        alignmentView.backgroundColor = .clear
        whereToGoLbl.font = AppFonts.Regular.withSize(28)
        morningLbl.textColor = UIColor.black
        morningLbl.alpha = 1
        whereToGoLbl.alpha = 0
        setMorningLabelText()
        messageTextView.font = AppFonts.Regular.withSize(18)
        messageTextView.delegate = self
        messageTextView.autocorrectionType = .no
        chatTableView.isHidden = true
        messageTextView.tintColor = AppColors.themeGreen
        messageTextView.placeholder = LocalizedString.TryDelhiToGoaTomorrow.localized
    }
    
    private func setMorningLabelText(){
        if let info = UserInfo.loggedInUser, !info.firstName.isEmpty {
            let morningStr = "Good \(Date().morningOrEvening), \(info.firstName)"
            morningLbl.attributedText = morningStr.attributeStringWithColors(subString: info.firstName, strClr: UIColor.black, substrClr: AppColors.themeGreen, strFont: AppFonts.Regular.withSize(28), subStrFont: AppFonts.SemiBold.withSize(28))
        }else{
            morningLbl.text = "Good \(Date().morningOrEvening)"
        }
    }
    
    //MARK:- MorningView animation
    private func animateMorningLabel(){
        delay(seconds: 1.0) {
            self.animateWhereToGoLabel()
        }
    }
    
    func animateWhereToGoLabel(){
        self.morningLbl.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.whereToGoLbl.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.whereToGoLbl.transform = CGAffineTransform(translationX: 0, y: (-(self.morningLbl.frame.height + 2)))
        }, completion: nil)
    }
    
    private func setupPopoverView() {
        popoverView.roundParticularCorners(10, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        popoverViewHeight.constant = view.bounds.height
        midPoint = view.bounds.height * 0.4
        maxPoint = 0
        minPoint = view.bounds.height
        popoverViewTop.constant = minPoint
        dragView.backgroundColor = AppColors.blackWith20PerAlpha
        dragView.roundedCorners(cornerRadius: dragView.height)
    }
    
    private func startPresentAnimation() {
        self.initialPoint = startPoint == .center ? midPoint : maxPoint
        UIView.animate(withDuration: 0.33) {
            let fractionForAlpha = self.maxViewColorAlpha - (((self.startPoint == .center ? self.midPoint : self.maxPoint)/self.minPoint)) * self.maxViewColorAlpha
            self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: fractionForAlpha)
            self.popoverViewTop.constant = self.initialPoint
            self.alignmentViewBottom.constant = (self.popoverViewTop.constant + self.popoverViewHeight.constant + self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top) - self.view.bounds.height
            self.view.layoutIfNeeded()
        }
    }
    
    private func startDismissAnimation(_ animationDuration: TimeInterval = 0.3) {
//        onDismissTap?()
        UIView.animate(withDuration: animationDuration, animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.popoverViewTop.constant = self.minPoint
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
}

extension AerinCustomPopoverVC {
    private func addPanGesture() {
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewToDismiss(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func didPanViewToDismiss(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        if yTranslation > 0 {
            messageTextView.resignFirstResponder()
        }
                
        switch sender.state {
        case .ended:
            let yVelocity = sender.velocity(in: view).y
            if (yVelocity > 500) && (popoverViewTop.constant > view.bounds.height * 0.75) && (popoverViewTop.constant < minPoint) {
                startDismissAnimation()
            } else if popoverViewTop.constant >= minPoint {
                startDismissAnimation(0.0)
            } else if popoverViewTop.constant >= midPoint && popoverViewTop.constant < minPoint {
                startPoint = .center
                startPresentAnimation()
            } else {
                if (startPoint == .top) && (yVelocity > 500) {
                    startPoint = .center
                } else {
                    startPoint = .top
                }
                startPresentAnimation()
            }
        default:
            transformViewBy(yTranslation)
        }
    }
    
    private func transformViewBy(_ yTranslation: CGFloat) {
        guard (initialPoint + yTranslation) >= maxPoint else { return }
        popoverViewTop.constant = initialPoint + yTranslation
        let whiteViewBottomConstant = (popoverViewTop.constant + popoverViewHeight.constant + view.safeAreaInsets.bottom + view.safeAreaInsets.top) - view.bounds.height
        if popoverViewTop.constant <= midPoint {
            alignmentViewBottom.constant = whiteViewBottomConstant
        }
        let fractionForAlpha = maxViewColorAlpha - ((popoverViewTop.constant/minPoint) * maxViewColorAlpha)
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: fractionForAlpha)
    }
}


//MARK:- Keyboard SetUp
extension AerinCustomPopoverVC {
    
    private func addKeyboard(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (notification) in
            guard let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            guard let strongSelf = self else {return}
            let keyBoardHeight = info.cgRectValue.height
            
            var safeAreaBottomInset : CGFloat = 0
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = strongSelf.view.safeAreaInsets.bottom
            } else { }
            UIView.animate(withDuration: 0.1,  delay: 0, options: .curveEaseInOut, animations: {
                if (info.cgRectValue.origin.y) >= UIDevice.screenHeight {
                    strongSelf.textViewBackViewBottom.constant = 0
                } else {
                    strongSelf.textViewBackViewBottom.constant = -(keyBoardHeight - safeAreaBottomInset)
                }
                strongSelf.view.layoutIfNeeded()
                
            }, completion: nil)
            
        })
    }
    
    private func removeKeyboard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK: Text View Delegates
extension AerinCustomPopoverVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if startPoint == .center {
            startPoint = .top
            startPresentAnimation()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}

