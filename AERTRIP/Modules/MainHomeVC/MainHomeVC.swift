//
//  MainHomeVC.swift
//  AERTRIP
//
//  Created by Admin on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MainHomeVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    //MARK:- Properties
    //MARK:- Public
    private(set) weak var sideMenuController: PKSideMenuController?
    private(set) weak var viewProfileVC: ViewProfileVC?
    private(set) weak var socialLoginVC: SocialLoginVC?
    private(set) weak var sideMenuVC: SideMenuVC?
    
    //MARK:- Private
    private weak var profileView: SlideMenuProfileImageHeaderView?
    private weak var logoView: SideMenuLogoView?
    
    var transitionAnimator: UIViewPropertyAnimator?
    var animationProgress: CGFloat = 0
    
    var isPushedToNext: Bool {
        return !(self.scrollView.contentOffset.x < UIDevice.screenWidth)
    }
    var isLaunchThroughSplash = false
    
    private var logoViewOriginalFrame: CGRect?
    private var profileImgViewOriginalFrame: CGRect?
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sideMenu = AppFlowManager.default.sideMenuController, sideMenu.isOpen {
            self.statusBarStyle = .default
        }
        else {
            self.statusBarStyle = .lightContent
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.sideMenuController?.viewDidLayoutSubviews()
        self.viewProfileVC?.viewDidLayoutSubviews()
        self.socialLoginVC?.viewDidLayoutSubviews()
        
        self.viewProfileVC?.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        self.socialLoginVC?.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .userLoggedInSuccess {
            self.scrollViewSetup()
            self.makeDefaultSetup()
        }
        else if let noti = note.object as? ATNotification, noti == .profileChanged {
            self.setUserDataOnProfileHeader()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.statusBarStyle = .lightContent

        self.view.layoutIfNeeded()
        self.view.backgroundColor = AppColors.screensBackground.color
        self.contentView.backgroundColor = AppColors.screensBackground.color
        
        //setup scroll view
        self.scrollViewSetup()
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        self.makeDefaultSetup()
        
        self.addEdgeSwipeGesture()
    }
    
    private func makeDefaultSetup() {
        delay(seconds: 0.3) {[weak self] in
            if UserInfo.loggedInUserId == nil {
                self?.setupLogoView()
            }
            else {
                self?.setupProfileView()
            }
        }
    }
    
    private func scrollViewSetup() {
        
        //set content size
        
        //setup side menu controller
        let sideVC = self.createSideMenu()
        sideVC.view.frame = CGRect(x: UIDevice.screenWidth * 0.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        
        self.contentView.addSubview(sideVC.view)
        self.addChild(sideVC)
        sideVC.didMove(toParent: self)
        
        if let _ = UserInfo.loggedInUserId {
            //setup view profile vc
            let viewProfile = self.createViewProfile()
            viewProfile.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
            
            self.contentView.addSubview(viewProfile.view)
            self.addChild(viewProfile)
            viewProfile.didMove(toParent: self)
        }
        else {
            //setup social login vc
            let social = self.createSocialLoginVC()
            social.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight-44.0)
            
            self.contentView.addSubview(social.view)
            self.addChild(social)
            social.didMove(toParent: self)
        }
    }
    
    private func addEdgeSwipeGesture() {
        let openGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeSwipeAction(_:)))
        openGesture.edges = .left
        openGesture.delegate = self
        
        self.view.addGestureRecognizer(openGesture)
    }
    
    @objc private func edgeSwipeAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began, self.isPushedToNext {
            if UserInfo.loggedInUserId == nil {
                self.popLogoAnimation()
            }
            else {
                self.popProfileAnimation()
            }
        }
    }
    
    private func createSideMenu() -> PKSideMenuController {
        PKSideMenuOptions.opacityViewBackgroundColor = AppColors.themeBlackGreen
        PKSideMenuOptions.mainViewShadowColor = AppColors.themeBlackGreen
        PKSideMenuOptions.dropOffShadowColor = AppColors.themeBlack.withAlphaComponent(0.5)
        
        let sideMenuVC = PKSideMenuController()
        sideMenuVC.delegate = self
        sideMenuVC.view.frame = UIScreen.main.bounds
        sideMenuVC.view.backgroundColor = AppColors.screensBackground.color
    
        let dashBoardScene = DashboardVC.instantiate(fromAppStoryboard: .Dashboard)
        dashBoardScene.isLaunchThroughSplash = self.isLaunchThroughSplash
        sideMenuVC.mainViewController(dashBoardScene)
        
        let sideMenu = SideMenuVC.instantiate(fromAppStoryboard: .Dashboard)
        sideMenu.delegate = self
        self.sideMenuVC = sideMenu

        sideMenuVC.menuViewController(sideMenu)
        
        self.sideMenuController = sideMenuVC
        
        return sideMenuVC
    }
    
    private func createViewProfile() -> ViewProfileVC {
        let obj = ViewProfileVC.instantiate(fromAppStoryboard: .Profile)
        obj.delegate = self
        self.viewProfileVC = obj
        
        return obj
    }
    
    private func createSocialLoginVC() -> SocialLoginVC {
        let obj = SocialLoginVC.instantiate(fromAppStoryboard: .PreLogin)
        obj.delegate = self
     

        
        obj.view.backgroundColor = AppColors.clear
        self.socialLoginVC = obj
        self.socialLoginVC?.fbButton.isSocial = true
        self.socialLoginVC?.googleButton.isSocial = true
        self.socialLoginVC?.linkedInButton .isSocial = true
        self.socialLoginVC?.fbButton.layer.applySketchShadow()
        self.socialLoginVC?.googleButton.layer.applySketchShadow(color: AppColors.themeRed, alpha: 1.0, x: 2, y: 2, blur: 6, spread: 0)
        
        return obj
    }
    
    private func setupProfileView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.profileView = sideMenu.getProfileView()
        self.setUserDataOnProfileHeader()
        self.profileView?.currentlyUsingAs = .sideMenu
        
        let newFrame = self.sideMenuVC?.profileSuperView?.convert(self.sideMenuVC?.profileSuperView?.frame ?? .zero, to: self.mainContainerView) ?? .zero
        let finalFrame = CGRect(x: self.sideMenuController?.visibleSpace ?? 120.0, y: newFrame.origin.y + 20.0, width: newFrame.size.width, height: newFrame.size.height)
        
        self.profileView?.frame = finalFrame
        
        self.profileView?.isHidden = true
        self.mainContainerView.addSubview(self.profileView!)
    }
    
    private func setUserDataOnProfileHeader() {
        self.profileView?.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized ) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized )"
        self.profileView?.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        self.profileView?.mobileNumberLabel.text = UserInfo.loggedInUser?.mobileWithISD
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            //self.profileView?.profileImageView.kf.setImage(with: URL(string: imagePath))
            self.profileView?.profileImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? UIImage(), showIndicator: false)
            //  self.profileView?.backgroundImageView.kf.setImage(with: URL(string: imagePath))
            self.profileView?.backgroundImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder(font:AppConstants.profileViewBackgroundNameIntialsFont) ?? UIImage(), showIndicator: false)
        }
        else {
            self.profileView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            self.profileView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font:AppConstants.profileViewBackgroundNameIntialsFont, textColor: AppColors.themeBlack)
        }
    }
    
    private func pushProfileAnimation() {
        self.statusBarStyle = .lightContent
        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        viewProfileVC?.profileImageHeaderView?.profileImageView.isHidden = true
        let toAddImgView = UIImageView()
        if let imgCell = sideMenuVC?.sideMenuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SideMenuProfileImageCell, let imgView = imgCell.profileImageView {
            let imgViewFrameWRTSuperview = imgCell.convert(imgView.frame, to: view)
            toAddImgView.frame = CGRect(x: imgViewFrameWRTSuperview.origin.x, y: imgView.y + UIApplication.shared.statusBarFrame.height - (self.sideMenuVC?.sideMenuTableView.contentOffset.y ?? 0), width: imgView.width, height: imgView.width)
            imgView.isHidden = true
        }
        toAddImgView.layer.cornerRadius = (toAddImgView.frame.size.width ) / 2
        toAddImgView.clipsToBounds = true
        toAddImgView.layer.borderWidth = 2.5
        toAddImgView.layer.borderColor = AppColors.themeGray20.cgColor
        toAddImgView.image = self.profileView?.profileImageView.image
        view.addSubview(toAddImgView)
        view.bringSubviewToFront(toAddImgView)
        profileImgViewOriginalFrame = toAddImgView.frame
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
            self.scrollView.contentOffset = pushPoint
            toAddImgView.layoutIfNeeded()
            if let profileImage = self.viewProfileVC?.profileImageHeaderView?.profileImageView {
                toAddImgView.frame.size = profileImage.frame.size
                toAddImgView.center.x = self.view.center.x
                toAddImgView.center.y = profileImage.center.y
                toAddImgView.layer.cornerRadius = (toAddImgView.frame.size.width ) / 2
            }
        }

        animator.addCompletion { (position) in
            toAddImgView.removeFromSuperview()
            self.viewProfileVC?.profileImageHeaderView?.profileImageView.isHidden = false
            
        }

        animator.startAnimation()
    }
    
    private func popProfileAnimation() {
        self.statusBarStyle = .default
        let popPoint = CGPoint(x: 0.0, y: 0.0)
        
        viewProfileVC?.profileImageHeaderView?.profileImageView.isHidden = true
        let toAddImgView = UIImageView()
        if let imgView = viewProfileVC?.profileImageHeaderView?.profileImageView {
            toAddImgView.frame = CGRect(x: imgView.x, y: imgView.y, width: imgView.width, height: imgView.width)
        }
        toAddImgView.layer.cornerRadius = (toAddImgView.frame.size.width ) / 2
        toAddImgView.clipsToBounds = true
        toAddImgView.layer.borderWidth = 2.5
        toAddImgView.layer.borderColor = AppColors.themeGray20.cgColor
        toAddImgView.image = viewProfileVC?.profileImageHeaderView?.profileImageView.image
        view.addSubview(toAddImgView)
        view.bringSubviewToFront(toAddImgView)
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
            self.scrollView.contentOffset = popPoint
            toAddImgView.layoutIfNeeded()
            if let profileFrame = self.profileImgViewOriginalFrame {
                toAddImgView.frame = profileFrame
                toAddImgView.layer.cornerRadius = (toAddImgView.frame.size.width ) / 2
            }
        }
        
        animator.addCompletion { (position) in
            if let imgCell = self.sideMenuVC?.sideMenuTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SideMenuProfileImageCell, let imgView = imgCell.profileImageView {
                imgView.isHidden = false
            }
            
            toAddImgView.removeFromSuperview()
            
        }
        
        animator.startAnimation()
    }
    
    private func setupLogoView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.logoView = sideMenu.getAppLogoView()
        self.logoView?.currentlyUsingFor = .sideMenu
        self.logoView?.isHidden = true
        self.logoView?.messageLabel.isHidden = true
        self.logoView?.frame.origin = CGPoint(x: (sideMenuVC?.view.frame.origin.x ?? 0) - 5, y: 30.0)
//        self.logoView?.alpha = 0.6
        self.mainContainerView.addSubview(self.logoView!)
        
        logoViewOriginalFrame = logoView?.frame
        logoViewOriginalFrame?.origin.x = (sideMenuVC?.view.frame.origin.x ?? 0) - 5
    }
    
    private func pushLogoAnimation() {
        
        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        logoViewOriginalFrame?.origin.y = -(self.sideMenuVC?.sideMenuTableView.contentOffset.y ?? 0)
//        self.socialLoginVC?.logoContainerView.isHidden = true
        
        toggleSocialLoginLogoViewHidden(true)
        self.logoView?.isHidden = false
        self.sideMenuVC?.logoContainerView.logoImageView.isHidden = true
        self.sideMenuVC?.logoContainerView.logoTextView.isHidden = true
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        let finalFrame = self.socialLoginVC?.logoContainerView.frame ?? CGRect(x: (UIDevice.screenWidth * 0.125), y: 80.0, width: UIDevice.screenWidth * 0.75, height: self.sideMenuVC?.logoContainerView?.height ?? 179.0)
        
        self.socialLoginVC?.animateContentOnLoad()
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            
            self.scrollView.contentOffset = pushPoint
            self.logoView?.frame = finalFrame
            self.logoView?.currentlyUsingFor = .socialLogin
            self.logoView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            self.socialLoginVC?.topNavView.leftButton.isHidden = false
            self.socialLoginVC?.logoContainerView.isHidden = false
            self.logoView?.isHidden = true
//            self.sideMenuVC?.logoContainerView.isHidden = true
            self.toggleSocialLoginLogoViewHidden(false)
        })
    }
    
    private func toggleSocialLoginLogoViewHidden(_ isHidden: Bool) {
        if let logoContView = self.socialLoginVC?.logoContainerView {
            logoContView.subviews.forEach { (subView) in
                if let logoSubView = subView as? SideMenuLogoView {
                    logoSubView.logoImageView.isHidden = isHidden
                    logoSubView.logoTextView.isHidden = isHidden
                }
            }
        }
    }
    
    private func popLogoAnimation() {
        
        let popPoint = CGPoint(x: 0.0, y: 0.0)
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        self.logoView?.isHidden = false
        self.socialLoginVC?.animateContentOnPop()
        self.toggleSocialLoginLogoViewHidden(true)
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.scrollView.contentOffset = popPoint
            self.logoView?.frame = self.logoViewOriginalFrame!
            self.logoView?.currentlyUsingFor = .sideMenu
            self.logoView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            
            self.toggleSocialLoginLogoViewHidden(false)
            self.logoView?.isHidden = true
            self.sideMenuVC?.logoContainerView.logoImageView.isHidden = false
            self.sideMenuVC?.logoContainerView.logoTextView.isHidden = false
        })
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}


//MARK:- SideMenuVC delegate methods
//MARK:-
extension MainHomeVC: SideMenuVCDelegate {
    func loginRegisterAction(_ sender: ATButton) {
        self.pushLogoAnimation()
    }
    
    func viewProfileAction(_ sender: ATButton) {
        self.pushProfileAnimation()
    }
}

//MARK:- PKSideMenuController delegate methods
//MARK:-
extension MainHomeVC: PKSideMenuControllerDelegate {
    func willCloseSideMenu() {
        self.statusBarStyle = .lightContent
    }
    
    func willOpenSideMenu() {
//        self.sideMenuVC?.sideMenuTableView.setContentOffset(CGPoint(x: 0.0, y: -UIApplication.shared.statusBarFrame.height), animated: false)
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: (UserInfo.loggedInUserId != nil), onView: self.view)
        self.statusBarStyle = .default
    }
}

//MARK:- ViewProfileVC delegate methods
//MARK:-
extension MainHomeVC: ViewProfileVCDelegate {
    func backButtonAction(_ sender: UIButton) {
        self.popProfileAnimation()
    }
}

//MARK:- ViewProfileVC delegate methods
//MARK:-
extension MainHomeVC: SocialLoginVCDelegate {
    func backButtonTapped(_ sender: UIButton) {
        self.popLogoAnimation()
    }
}


extension MainHomeVC {
    func startAnimation() {
        func setupForProfilePop() {
            if self.transitionAnimator == nil {
                if let profile = self.profileView {
                    self.sideMenuVC?.updateProfileView(view: profile)
                }
                
                let popPoint = CGPoint(x: 0.0, y: 0.0)
                
                self.viewProfileVC?.profileImageHeaderView?.profileImageView.isHidden = true
                self.profileView?.isHidden = false
                self.sideMenuVC?.profileContainerView.isHidden = true
                
                let newFrame = self.sideMenuVC?.profileSuperView.convert(self.sideMenuVC?.profileSuperView.frame ?? .zero, to: self.mainContainerView) ?? .zero
                let finalFrame = CGRect(x: self.sideMenuController?.visibleSpace ?? 120.0, y: newFrame.origin.y + 40.0, width: newFrame.size.width, height: newFrame.size.height)
                
                self.transitionAnimator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                    self.scrollView.contentOffset = popPoint
                    self.profileView?.frame = finalFrame
                    
                    self.profileView?.emailIdLabel.alpha = 0.0
                    self.profileView?.mobileNumberLabel.alpha = 0.0
                    self.profileView?.backgroundImageView.alpha = 0.0
                    self.profileView?.dividerView.alpha = 0.0
                    self.profileView?.profileContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    
                    self.profileView?.layoutIfNeeded()
                }
                
                self.addCompletion()
            }
            self.transitionAnimator?.startAnimation()
            self.transitionAnimator?.pauseAnimation()
        }
        
        func setupForLogoPop() {
            
            let popPoint = CGPoint(x: 0.0, y: 0.0)
            self.socialLoginVC?.topNavView.leftButton.isHidden = true
            self.socialLoginVC?.logoContainerView.isHidden = true
            self.logoView?.isHidden = false
            self.sideMenuVC?.logoContainerView.isHidden = true
            
            let finalFrame = CGRect(x: self.sideMenuController?.visibleSpace ?? 0.0, y: self.sideMenuVC?.sideMenuTableView.y ?? 0.0, width: self.sideMenuVC?.sideMenuTableView.width ?? 110.0, height: 180.0)
            
            self.socialLoginVC?.animateContentOnPop()
            
            self.transitionAnimator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                
                self.scrollView.contentOffset = popPoint
                self.logoView?.frame = finalFrame
                self.logoView?.layoutIfNeeded()
            }
            
            self.addCompletion()
        }
        
        if UserInfo.loggedInUserId == nil {
            setupForLogoPop()
        }
        else {
            setupForProfilePop()
        }
        
        self.animationProgress = self.transitionAnimator?.fractionComplete ?? 0.0
    }
    
    func animationInProgress(_ recognizer: UIPanGestureRecognizer) {
        let position = recognizer.translation(in: self.view)
        var fraction = position.x / self.scrollView.width
        printDebug("animationInProgress: \(position.x / self.scrollView.width)")
        
        
        if self.transitionAnimator?.isReversed == true { fraction *= -1}
        
        self.transitionAnimator?.fractionComplete = fraction + self.animationProgress
    }
    
    func addCompletion() {
        self.transitionAnimator?.addCompletion { (position) in
            
            if UserInfo.loggedInUserId == nil {
                self.socialLoginVC?.logoContainerView.isHidden = false
                self.logoView?.isHidden = true
                self.sideMenuVC?.logoContainerView.isHidden = false
            }
            else {
                self.profileView?.emailIdLabel.isHidden = true
                self.profileView?.mobileNumberLabel.isHidden = true
                
                self.profileView?.backgroundImageView.isHidden = true
                self.profileView?.dividerView.isHidden = true
                
                self.viewProfileVC?.profileImageHeaderView?.profileImageView.isHidden = true
                self.profileView?.isHidden = true
                self.sideMenuVC?.profileContainerView.isHidden = false
            }
            self.transitionAnimator?.pauseAnimation()
            self.transitionAnimator = nil
        }
    }
    
    func animationComplete(_ recognizer: UIPanGestureRecognizer) {
        printDebug("animationComplete")
        self.transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)

        let position = recognizer.translation(in: self.view)
        let fraction = position.x / self.scrollView.width
        
        if fraction > 0.5 {
            self.popProfileAnimation()
        }
        else {
            self.pushProfileAnimation()
        }
    }
}
