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
    @IBOutlet weak var blurView: BlurView!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .clear//AppColors.themeGray04
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var whiteContainerView: UIView!
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountLadgerDetailsVM()
    
    //MARK:- Private
    private var headerView: AccountLadgerDetailHeader!
    private let headerHeightForNormal: CGFloat = 152.0
    private let headerHeightForCredit: CGFloat = 152.0
    private let headerHeightFlightSale: CGFloat = 190.0
    private let headerHeightHotelSale: CGFloat = 215.0
    private let parallexHeaderMinHeight: CGFloat = 0.0
    private var parallexHeaderMaxHeight: CGFloat {
        if let event = self.viewModel.ladgerEvent, event.voucher == .sales {
            if event.productType == .flight {
                self.headerView.titleHeightConstraint.constant = 21.0
                return self.headerHeightFlightSale
            }
            else {
                return self.headerHeightHotelSale
            }
        }
        else {
            self.headerView.bottomContainerBottomConstraint.constant = 0.0
            self.headerView.bottomDetailContainerHeightConstraint.constant = 0.0
            return self.headerHeightForCredit
        }
    }
    // Make navigation bar height as 88.0 on iphone X .
    private var headerViewHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    private var setupHeader = false
    var maxValue: CGFloat = 1.0
    var minValue: CGFloat = 0.0
    var finalMaxValue: Int = 0
    var currentProgress: CGFloat = 0
    var currentProgressIntValue: Int = 0
    var isScrollingFirstTime: Bool = true
    var isNavBarHidden:Bool = true
    let headerHeightToAnimate: CGFloat = 30.0
    var isHeaderAnimating: Bool = false
    var isBackBtnTapped = false
    fileprivate let refreshControl = UIRefreshControl()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.tableView.registerCell(nibName: DownloadInvoiceTableViewCell.reusableIdentifier)
        DispatchQueue.main.async {
            self.topNavView.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true, backgroundType: .blurAnimatedView(isDark: false))
            self.topNavView.dividerView.isHidden = true
            self.topNavView.delegate = self
            self.topNavView.backgroundColor = AppColors.clear
            self.navBarHeight.constant = self.headerViewHeight
            self.topNavView.navTitleLabel.numberOfLines = 1
            self.blurView.isHidden = true
            self.viewModel.fetchLadgerDetails()
            self.setupParallexHeaderView()
            
            /*
            self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            self.refreshControl.tintColor = AppColors.themeGreen
            self.tableView.refreshControl = self.refreshControl
 */
        }
        
        self.containerView.backgroundColor = AppColors.themeGray04
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //after loading the data check if table view scrollable or not
        //        delay(seconds: 0.4) { [weak self] in
        //            guard let sSelf = self else {return}
        //            sSelf.tableView.isScrollEnabled = (sSelf.tableView.contentSize.height > sSelf.tableView.height)
        //        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.isDownloadingRecipt = false
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.setupHeader{
            self.setupHeader = true
            self.setupParallexHeaderView()
        }
        if let view = self.headerView {
            view.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: self.parallexHeaderMaxHeight)
            view.layoutIfNeeded()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupParallexHeaderView() {
        self.headerView = AccountLadgerDetailHeader.instanceFromNib()
        
        if let event = self.viewModel.ladgerEvent{
            switch event.productType {
            case .flight, .hotel:  headerView.bookingIdButton.isHidden = false
            default:  headerView.bookingIdButton.isHidden = true
            }
        }
        headerView.delegate = self
        self.headerView.ladgerEvent = self.viewModel.ladgerEvent
        self.headerView.backgroundColor = AppColors.themeWhite
        self.headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: self.parallexHeaderMaxHeight)
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.headerView?.widthAnchor.constraint(equalToConstant: tableView?.width ?? 0.0).isActive = true
        self.tableView.parallaxHeader.view = self.headerView
        self.tableView.parallaxHeader.minimumHeight = self.parallexHeaderMinHeight
        self.tableView.parallaxHeader.height = self.parallexHeaderMaxHeight
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.tableView.parallaxHeader.delegate = self
        self.view.bringSubviewToFront(self.topNavView)
        self.tableView.layoutIfNeeded()
        
        //self.manageHeader(isHidden: true, animated: false)
    }
    
    var isHeaderHidden: Bool {
        return self.topNavView.navTitleLabel.alpha == 0.0
    }
    
    //    private func manageHeader(isHidden: Bool, animated: Bool) {
    //
    //        //stop to re-animate in current state
    //        if isHidden, self.isHeaderHidden {
    //            return
    //        }
    //        else if !isHidden, !self.isHeaderHidden {
    //            return
    //        }
    //
    //        if isHidden {
    //            self.topNavView.navTitleLabel.alpha = 1.0
    //            self.topNavView.navTitleLabel.transform = .identity
    //
    //            self.topNavView.dividerView.alpha = 1.0
    //            self.topNavView.dividerView.transform = .identity
    //        }
    //
    //        let transformForHide = CGAffineTransform(translationX: 0.0, y: -50.0)
    //        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {[weak self] in
    //            guard let sSelf = self else {return}
    //
    //            sSelf.topNavView.navTitleLabel.alpha = isHidden ? 0.0 : 1.0
    //            sSelf.topNavView.navTitleLabel.transform = isHidden ? transformForHide : CGAffineTransform.identity
    //
    //            sSelf.topNavView.dividerView.alpha = isHidden ? 0.0 : 1.0
    //            sSelf.topNavView.dividerView.transform = isHidden ? transformForHide : CGAffineTransform.identity
    //
    //            sSelf.topNavView.containerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(isHidden ? 0.001 : 1.0)
    //
    //            }, completion: { (isDone) in
    //        })
    //    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.fetchAccountDetails()
    }
}

//MARK:- ViewModel delegate methods
//MARK:-
extension AccountLadgerDetailsVC: AccountLadgerDetailsVMDelegate {
    func willFetchAccountDetail() {
        
    }
    
    func fetchAccountDetailSuccess(model: AccountDetailPostModel) {
        NotificationCenter.default.post(name: .accountDetailFetched, object: model)
        self.refreshControl.endRefreshing()
    }
    
    func fetchAccountDetailFail() {
        self.refreshControl.endRefreshing()
    }
    
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
        DispatchQueue.main.async {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //cross button action
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- MXParallaxHeaderDelegate methods
//MARK:-
extension AccountLadgerDetailsVC: MXParallaxHeaderDelegate {
    //    func updateForParallexProgress() {
    //
    //        let prallexProgress = self.tableView.parallaxHeader.progress
    //        printDebug("progress %f \(prallexProgress)")
    //        self.manageHeader(isHidden: (prallexProgress > 0.48), animated: true)
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
//        if (scrollView.contentOffset.y + 40) < -(self.parallexHeaderMaxHeight){
//            self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.top
//        } else {
//            self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
//        }
//        printDebug("self.parallexHeaderMaxHeight : \(self.parallexHeaderMaxHeight)")
//        printDebug("scrollView.contentOffset.y : \(scrollView.contentOffset.y)")
//        printDebug("scrollView.contentOffset.y : \((scrollView.contentOffset.y + 40))")
    }
    
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        self.updateForParallexProgress()
    //    }
    //
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        self.updateForParallexProgress()
    //    }
    
    @objc func updateForParallexProgress() {
        
        let prallexProgress = self.tableView.parallaxHeader.progress
      //  printDebug("intial progress value \(prallexProgress)")
        
      //  printDebug("progress value \(prallexProgress)")

        
        if isScrollingFirstTime && prallexProgress > 1.0 {
            maxValue = prallexProgress
            minValue = abs(1 - prallexProgress)
            finalMaxValue = Int(maxValue * 100)
            isScrollingFirstTime = false
           // printDebug("minvalue \(minValue) and maxValue \(maxValue)")
        }
        //
        //
        if minValue...maxValue ~= prallexProgress {
           // printDebug("progress value \(prallexProgress)")
            let intValue =  finalMaxValue - Int(prallexProgress * 100)
            
            //printDebug(" int value \(intValue)")
            let newProgress: Float = (Float(1) - (Float(1.3)  * (Float(intValue) / 100)))
            
           // printDebug("new progress value \(newProgress)")
            
            
           // printDebug("CGFloat progress  Value is \(newProgress.toCGFloat.roundTo(places: 3))")
            
            self.currentProgressIntValue = intValue
            self.currentProgress = newProgress.toCGFloat
            
            self.whiteContainerView.isHidden = (newProgress <= 0.8)
        }
        
        //
        if prallexProgress  <= 0.7 {
            
            
            if isNavBarHidden {
                
                self.topNavView.animateBackView(isHidden: true) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavView.leftButton.isSelected = false
                    sSelf.topNavView.leftButton.tintColor = AppColors.themeWhite
                    sSelf.topNavView.navTitleLabel.text = ""
                    sSelf.headerView?.titleLabel.alpha = 1
                    sSelf.headerView?.bookingIdKeyLabel.alpha = 1
                    sSelf.headerView?.bookingIdValueLabel.alpha = 1
                    sSelf.topNavView.dividerView.isHidden = true
                    sSelf.blurView.isHidden = true
                    //sSelf.whiteContainerView.isHidden = false
                }
                
            } else {
                
                self.topNavView.animateBackView(isHidden: false) { [weak self] _ in
                    guard let sSelf = self else { return }
                    sSelf.topNavView.leftButton.isSelected = true
                    sSelf.topNavView.leftButton.tintColor = AppColors.themeGreen
                    if let event = sSelf.viewModel.ladgerEvent, let img = event.iconImage {
                        if let abtTxt = event.attributedString{
                            sSelf.topNavView.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImageAttributedTxt(image: #imageLiteral(resourceName: "BookingDetailFlightNavIcon"), attributedText: abtTxt)
                        }else{
                            sSelf.topNavView.navTitleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: img, endText: "  \(event.title)", font: AppFonts.SemiBold.withSize(18.0))
                        }
                        
                    }
                    else {
                        if let abtTxt = sSelf.viewModel.ladgerEvent?.attributedString{
                            sSelf.topNavView.navTitleLabel.attributedText = abtTxt
                        }else{
                            sSelf.topNavView.navTitleLabel.text = sSelf.viewModel.ladgerEvent?.title ?? ""
                        }
                        
                    }
                    sSelf.blurView.isHidden = false
                    sSelf.headerView?.titleLabel.alpha = 0
                    sSelf.headerView?.bookingIdKeyLabel.alpha = 0
                    sSelf.headerView?.bookingIdValueLabel.alpha = 0
                    sSelf.topNavView.dividerView.isHidden = false
                    //sSelf.whiteContainerView.isHidden = true
                }
            }
        } else {
            
            self.topNavView.animateBackView(isHidden: true) { [weak self] _ in
                guard let sSelf = self else { return }
                sSelf.topNavView.leftButton.isSelected = false
                sSelf.topNavView.leftButton.tintColor = AppColors.themeWhite
                sSelf.topNavView.navTitleLabel.text = ""
                sSelf.headerView?.titleLabel.alpha = 1
                sSelf.headerView?.bookingIdKeyLabel.alpha = 1
                sSelf.headerView?.bookingIdValueLabel.alpha = 1
                sSelf.topNavView.dividerView.isHidden = true
                sSelf.blurView.isHidden = true
                //sSelf.whiteContainerView.isHidden = false
            }
            
        }
        self.isNavBarHidden = false
        
    }
}

extension AccountLadgerDetailsVC: AccountLadgerDetailHeaderDelegate{
    
    func tapBookingButton(){
        if let event = self.viewModel.ladgerEvent, event.voucher == .sales {
            switch event.productType {
            case .flight:
                let title = NSMutableAttributedString(string: event.title)
                AppFlowManager.default.moveToFlightBookingsDetailsVC(bookingId: event.bookingId,tripCitiesStr: title)
                
            case .hotel:
                AppFlowManager.default.moveToHotelBookingsDetailsVC(bookingId: event.bookingId)
            default: break
            }
            
            
        }
    }
    
}
