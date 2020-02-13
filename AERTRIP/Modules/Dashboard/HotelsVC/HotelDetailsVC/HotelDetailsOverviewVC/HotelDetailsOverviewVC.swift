//
//  HotelDetailsOverviewVC.swift
//  AERTRIP
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class HotelDetailsOverviewVC: BaseVC {
    
    //Mark:- Variables
    //================
    let overViewText: String = ""
    let viewModel = HotelDetailsOverviewVM()
    private let maxHeaderHeight: CGFloat = 58.0
    var initialTouchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var overViewTextViewOutlet: UITextView! {
        didSet {
            self.overViewTextViewOutlet.contentInset = UIEdgeInsets(top: 10.0, left: 4.0, bottom: 20.0, right: 4.0)
            self.overViewTextViewOutlet.delegate = self
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var overViewLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContainerView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue()
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.Overview.localized
        self.stickyTitleLabel.text = LocalizedString.Overview.localized
    }
    
    override func initialSetup() {
        
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        mainContainerView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        self.mainContainerView.addGestureRecognizer(swipeGesture)
        
        self.dividerView.isHidden = true
        self.overViewTextViewOutlet.attributedText = self.viewModel.overViewInfo.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.rawValue, fontColor: AppColors.themeBlack)
        //Heading
//        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline).withSize(16.0)
//        // subheadline
//        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline).withSize(16.0)
//        // body
//        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).withSize(16.0)
    }
    
    //Mark:- Functions
    //================

    
    //Mark:- IBActions
    //================

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension HotelDetailsOverviewVC {
    
    func setValue() {
        let toDeduct = (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        let finalValue =  (self.view.height - toDeduct)
        self.mainContainerBottomConst.constant = 0.0
        self.mainContainerViewHeightConst.constant = finalValue
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(1.0)
        self.view.layoutIfNeeded()
        
    }
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.mainContainerView?.window)
        let velocity = sender.velocity(in: self.mainContainerView)
        print(velocity)
        switch sender.state {
        case .possible:
            print(sender.state)
        case .began:
            self.initialTouchPoint = touchPoint
        case .changed:
            let touchPointDiffY = initialTouchPoint.y - touchPoint.y
            print(touchPointDiffY)
            if  touchPoint.y > 62.0 {
                if touchPointDiffY > 0 {
                    self.mainContainerBottomConst.constant = -( UIScreen.main.bounds.height - 62.0) + (68.0) + touchPointDiffY
                }
                else if touchPointDiffY < -68.0 {
                    self.mainContainerBottomConst.constant = touchPointDiffY
                }
            }
        case .cancelled:
            print(sender.state)
        case .ended:
            print(sender.state)
            panGestureFinalAnimation(velocity: velocity,touchPoint: touchPoint)
            
        case .failed:
            print(sender.state)
            
        }
    }
    
    ///Call to use Pan Gesture Final Animation
     private func panGestureFinalAnimation(velocity: CGPoint,touchPoint: CGPoint) {
         //Down Direction
         if velocity.y < 0 {
             if velocity.y < -300 {
                self.openSheet()
             } else {
                 if touchPoint.y <= (UIScreen.main.bounds.height)/2 {
                    self.openSheet()
                 } else {
                     self.closeSheet()
                 }
             }
         }
             //Up Direction
         else {
             if velocity.y > 300 {
                 self.closeSheet()
             } else {
                 if touchPoint.y <= (UIScreen.main.bounds.height)/2 {
                    self.openSheet()
                 } else {
                     self.closeSheet()
                 }
             }
         }
         print(velocity.y)
     }
    
    func openSheet() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.mainContainerBottomConst.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeSheet() {
        func setValue() {
            self.mainContainerBottomConst.constant = -(self.mainContainerView.height + 100)
            self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(1.0)
            self.view.layoutIfNeeded()
            self.dismiss(animated: true, completion: nil)
        }
        let animater = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
            setValue()
        }
        animater.addCompletion { (position) in
        }
        animater.startAnimation()
    }
    
    
    func manageHeaderView(_ scrollView: UIScrollView) {
        
        let yOffset = (scrollView.contentOffset.y > headerContainerView.height) ? headerContainerView.height : scrollView.contentOffset.y
        printDebug(yOffset)
        
        dividerView.isHidden = yOffset < (headerContainerView.height - 5.0)
        
        //header container view height
        let heightToDecrease: CGFloat = 8.0
        let height = (maxHeaderHeight) - (yOffset * (heightToDecrease / headerContainerView.height))
        self.containerViewHeigthConstraint.constant = height
        
        //sticky label alpha
        let alpha = (yOffset * (1.0 / headerContainerView.height))
        self.stickyTitleLabel.alpha = alpha
        
        //reviews label
        self.titleLabel.alpha = 1.0 - alpha
        self.overViewLabelTopConstraints.constant = 23.0 - (yOffset * (23.0 / headerContainerView.height))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        manageHeaderView(scrollView)
        printDebug("scrollViewDidScroll")
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        manageHeaderView(scrollView)
//        printDebug("scrollViewDidEndDecelerating")
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        manageHeaderView(scrollView)
//        printDebug("scrollViewDidEndDragging")
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        manageHeaderView(scrollView)
//        printDebug("scrollViewDidEndScrollingAnimation")
//    }
}
