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
        self.view.addGestureRecognizer(swipeGesture)
        
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
    
   @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        var initialTouchPoint = CGPoint.zero

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
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
