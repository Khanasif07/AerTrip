//
//  AccountLadgerDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import MXParallaxHeader

class AccountLadgerDetailsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountLadgerDetailsVM()
    
    //MARK:- Private
    private var headerView: AccountLadgerDetailHeader!
    private let headerHeightForNormal: CGFloat = 185.0
    private let headerHeightForCredit: CGFloat = 122.0
    private let parallexHeaderMinHeight: CGFloat = 0.0
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.viewModel.fetchLadgerDetails()

        self.setupParallexHeaderView()
        
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        
        self.topNavView.delegate = self
        self.topNavView.backgroundColor = AppColors.clear
        self.topNavView.containerView.backgroundColor = AppColors.clear
        
        if let event = self.viewModel.ladgerEvent, let img = event.iconImage {
            self.topNavView.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: img, endText: "  \(event.title)", font: AppFonts.SemiBold.withSize(18.0))
        }
        else {
            self.topNavView.navTitleLabel.text = self.viewModel.ladgerEvent?.title ?? ""
        }
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //after loading the data check if table view scrollable or not
//        delay(seconds: 0.4) { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.tableView.isScrollEnabled = (sSelf.tableView.contentSize.height > sSelf.tableView.height)
//        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupParallexHeaderView() {
        self.headerView = AccountLadgerDetailHeader.instanceFromNib()
        self.headerView.ladgerEvent = self.viewModel.ladgerEvent

        self.headerView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 0)
        
        self.tableView.parallaxHeader.view = self.headerView
        self.tableView.parallaxHeader.minimumHeight = self.parallexHeaderMinHeight
        
        self.tableView.parallaxHeader.height = self.headerHeightForNormal
        if let event = self.viewModel.ladgerEvent, event.voucher == .debitNote {
            self.tableView.parallaxHeader.height = self.headerHeightForCredit
        }

        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.tableView.parallaxHeader.delegate = self
        
        self.view.bringSubviewToFront(self.topNavView)
        
        self.manageHeader(isHidden: true, animated: false)
    }
    
    var isHeaderHidden: Bool {
        return self.topNavView.navTitleLabel.alpha == 0.0
    }
    
    private func manageHeader(isHidden: Bool, animated: Bool) {
        
        //stop to re-animate in current state
        if isHidden, self.isHeaderHidden {
            return
        }
        else if !isHidden, !self.isHeaderHidden {
            return
        }
        
        if isHidden {
            self.topNavView.navTitleLabel.alpha = 1.0
            self.topNavView.navTitleLabel.transform = .identity
            
            self.topNavView.dividerView.alpha = 1.0
            self.topNavView.dividerView.transform = .identity
        }
        
        let transformForHide = CGAffineTransform(translationX: 0.0, y: -50.0)
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {[weak self] in
            guard let sSelf = self else {return}
            
            sSelf.topNavView.navTitleLabel.alpha = isHidden ? 0.0 : 1.0
            sSelf.topNavView.navTitleLabel.transform = isHidden ? transformForHide : CGAffineTransform.identity
            
            sSelf.topNavView.dividerView.alpha = isHidden ? 0.0 : 1.0
            sSelf.topNavView.dividerView.transform = isHidden ? transformForHide : CGAffineTransform.identity
            
            sSelf.topNavView.containerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(isHidden ? 0.001 : 1.0)
            
            }, completion: { (isDone) in
        })
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- ViewModel delegate methods
//MARK:-
extension AccountLadgerDetailsVC: AccountLadgerDetailsVMDelegate {
    func willFetchLadgerDetails() {
    }
    
    func fetchLadgerDetailsSuccess() {
        self.tableView.reloadData()
    }
    
    func fetchLadgerDetailsFail() {
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountLadgerDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //cross button action
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- MXParallaxHeaderDelegate methods
//MARK:-
extension AccountLadgerDetailsVC: MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        
        let prallexProgress = self.tableView.parallaxHeader.progress
        printDebug("progress %f \(prallexProgress)")
        self.manageHeader(isHidden: (prallexProgress > 0.48), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateForParallexProgress()
    }
}
