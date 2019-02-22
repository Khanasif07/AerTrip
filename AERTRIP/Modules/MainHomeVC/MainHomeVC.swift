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
    private(set) var sideMenuController: PKSideMenuController?
    private(set) var viewProfileVC: ViewProfileVC?
    private(set) var socialLoginVC: SocialLoginVC?
    private(set) var sideMenuVC: SideMenuVC?
    
    //MARK:- Private
    private var profileView: SlideMenuProfileImageHeaderView?
    private var logoView: SideMenuLogoView?
    
    var transitionAnimator: UIViewPropertyAnimator?
    var animationProgress: CGFloat = 0
    
    private var isPushedToNext: Bool {
        return !(self.scrollView.contentOffset.x < UIDevice.screenWidth)
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.statusBarStyle = .lightContent
        
        self.view.backgroundColor = AppColors.screensBackground.color
        self.contentView.backgroundColor = AppColors.screensBackground.color
        
        //setup scroll view
        self.scrollViewSetup()
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        delay(seconds: 0.2) {[weak self] in
            if UserInfo.loggedInUserId == nil {
                self?.setupLogoView()
            }
            else {
                self?.setupProfileView()
            }
        }
        
        self.addEdgeSwipeGesture()
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
//        switch sender.state {
//        case .began:
//            self.startAnimation()
//
//        case .changed:
//            self.animationInProgress(sender)
//
//        case .ended:
//            self.animationComplete(sender)
//
//        default:
//            break
//        }
    }
    
    private func createSideMenu() -> PKSideMenuController {
        PKSideMenuOptions.opacityViewBackgroundColor = AppColors.themeDarkGreen
        PKSideMenuOptions.mainViewShadowColor = AppColors.themeDarkGreen
        PKSideMenuOptions.dropOffShadowColor = AppColors.themeBlack.withAlphaComponent(0.5)
        
        let sideMenuVC = PKSideMenuController()
        sideMenuVC.delegate = self
        sideMenuVC.view.frame = UIScreen.main.bounds
        sideMenuVC.view.backgroundColor = AppColors.screensBackground.color
    
        sideMenuVC.mainViewController(DashboardVC.instantiate(fromAppStoryboard: .Dashboard))
        
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
        obj.view.backgroundColor = AppColors.screensBackground.color
        self.socialLoginVC = obj
        
        return obj
    }
    
    private func setupLogoView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.logoView = sideMenu.getAppLogoView()
        
        self.logoView?.isHidden = true
        
        self.logoView?.frame.origin = CGPoint(x: sideMenu.sideMenuTableView.x, y: 30.0)
        self.mainContainerView.addSubview(self.logoView!)
    }
    
    private func setupProfileView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.profileView = sideMenu.getProfileView()
        
        let newFrame = self.sideMenuVC?.profileSuperView.convert(self.sideMenuVC?.profileSuperView.frame ?? .zero, to: self.mainContainerView) ?? .zero
        let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 120.0, y: newFrame.origin.y + 40.0, width: newFrame.size.width, height: newFrame.size.height)
        
        self.profileView?.frame = finalFrame
        
        self.profileView?.isHidden = true
        self.profileView?.gradientView.isHidden = true
        self.profileView?.gradientView.alpha = 0.0
        self.mainContainerView.addSubview(self.profileView!)
    }
    
    private func pushProfileAnimation() {

        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        
        self.viewProfileVC?.profileImageHeaderView?.isHidden = true
        self.profileView?.isHidden = false
        self.sideMenuVC?.profileContainerView.isHidden = true
        
        let finalFrame = CGRect(x: 0.0, y: -(UIApplication.shared.statusBarFrame.height), width: UIDevice.screenWidth, height: self.viewProfileVC?.profileImageHeaderView?.height ?? UIDevice.screenHeight*0.45)
        
        self.profileView?.emailIdLabel.isHidden = false
        self.profileView?.mobileNumberLabel.isHidden = false
        self.profileView?.backgroundImageView.isHidden = false
        self.profileView?.dividerView.isHidden = false
        self.profileView?.gradientView.isHidden = false
        
        self.viewProfileVC?.viewModel.webserviceForGetTravelDetail()

        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            
            self.scrollView.contentOffset = pushPoint
            self.profileView?.frame = finalFrame
            
            self.profileView?.emailIdLabel.alpha = 1.0
            self.profileView?.mobileNumberLabel.alpha = 1.0
            self.profileView?.backgroundImageView.alpha = 1.0
            self.profileView?.dividerView.alpha = 1.0
            self.profileView?.gradientView.alpha = 1.0
            self.profileView?.profileContainerView.transform = CGAffineTransform.identity
            self.profileView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            self.statusBarStyle = .lightContent
            self.viewProfileVC?.profileImageHeaderView?.isHidden = false
            self.profileView?.isHidden = true
            self.sideMenuVC?.profileContainerView.isHidden = true
        })
    }
    
    private func popProfileAnimation() {
        
        if let profile = self.profileView {
            self.sideMenuVC?.updateProfileView(view: profile)
        }

        let popPoint = CGPoint(x: 0.0, y: 0.0)

        self.viewProfileVC?.profileImageHeaderView?.isHidden = true
        self.profileView?.isHidden = false
        self.sideMenuVC?.profileContainerView.isHidden = true

        let newFrame = self.sideMenuVC?.profileSuperView.convert(self.sideMenuVC?.profileSuperView.frame ?? .zero, to: self.mainContainerView) ?? .zero
        let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 120.0, y: newFrame.origin.y + 40.0, width: newFrame.size.width, height: newFrame.size.height)
        
        self.statusBarStyle = .default
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
            self.scrollView.contentOffset = popPoint
            self.profileView?.frame = finalFrame

            self.profileView?.emailIdLabel.alpha = 0.0
            self.profileView?.mobileNumberLabel.alpha = 0.0
            self.profileView?.backgroundImageView.alpha = 0.0
            self.profileView?.dividerView.alpha = 0.0
            self.profileView?.gradientView.alpha = 0.0
            self.profileView?.profileContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            self.profileView?.layoutIfNeeded()
        }
        
        animator.addCompletion { (position) in
            
            self.profileView?.gradientView.isHidden = true
            
            self.profileView?.emailIdLabel.isHidden = true
            self.profileView?.mobileNumberLabel.isHidden = true

            self.profileView?.backgroundImageView.isHidden = true
            self.profileView?.dividerView.isHidden = true

            self.viewProfileVC?.profileImageHeaderView?.isHidden = true
//            self.viewProfileVC?.tableView.setContentOffset(CGPoint(x: 0.0, y: -(300.0 + UIApplication.shared.statusBarFrame.height)), animated: false)
            self.profileView?.isHidden = true
            self.sideMenuVC?.profileContainerView.isHidden = false
            self.sideMenuVC?.profileContainerView.isUserInteractionEnabled = true
        }
        
        animator.startAnimation()
    }
    
    private func pushLogoAnimation() {
        
        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        
        self.socialLoginVC?.logoContainerView.isHidden = true
        self.logoView?.isHidden = false
        self.sideMenuVC?.logoContainerView.isHidden = true
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        let finalFrame = self.socialLoginVC?.logoContainerView.frame ?? CGRect(x: (UIDevice.screenWidth * 0.125), y: 80.0, width: UIDevice.screenWidth * 0.75, height: self.sideMenuVC?.logoContainerView?.height ?? 179.0)
        
        self.socialLoginVC?.animateContentOnLoad()
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            
            self.scrollView.contentOffset = pushPoint
            self.logoView?.frame = finalFrame
            self.logoView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            self.socialLoginVC?.topNavView.leftButton.isHidden = false
            self.socialLoginVC?.logoContainerView.isHidden = false
            self.logoView?.isHidden = true
            self.sideMenuVC?.logoContainerView.isHidden = true
        })
    }
    
    private func popLogoAnimation() {
        
        let popPoint = CGPoint(x: 0.0, y: 0.0)
        self.socialLoginVC?.topNavView.leftButton.isHidden = true
        self.socialLoginVC?.logoContainerView.isHidden = true
        self.logoView?.isHidden = false
        self.sideMenuVC?.logoContainerView.isHidden = true

        let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 0.0, y: (self.sideMenuVC?.sideMenuTableView.y ?? 0.0) + 30.0, width: self.sideMenuVC?.sideMenuTableView.width ?? 110.0, height: 180.0)

        self.socialLoginVC?.animateContentOnPop()
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.scrollView.contentOffset = popPoint
            self.logoView?.frame = finalFrame
            self.logoView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            
            self.socialLoginVC?.logoContainerView.isHidden = false
            self.logoView?.isHidden = true
            self.sideMenuVC?.logoContainerView.isHidden = false
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
        self.sideMenuVC?.sideMenuTableView.setContentOffset(CGPoint(x: 0.0, y: -UIApplication.shared.statusBarFrame.height), animated: false)
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
                
                self.viewProfileVC?.profileImageHeaderView?.isHidden = true
                self.profileView?.isHidden = false
                self.sideMenuVC?.profileContainerView.isHidden = true
                
                let newFrame = self.sideMenuVC?.profileSuperView.convert(self.sideMenuVC?.profileSuperView.frame ?? .zero, to: self.mainContainerView) ?? .zero
                let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 120.0, y: newFrame.origin.y + 40.0, width: newFrame.size.width, height: newFrame.size.height)
                
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
                
                self.addComplition()
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
            
            let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 0.0, y: self.sideMenuVC?.sideMenuTableView.y ?? 0.0, width: self.sideMenuVC?.sideMenuTableView.width ?? 110.0, height: 180.0)
            
            self.socialLoginVC?.animateContentOnPop()
            
            self.transitionAnimator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                
                self.scrollView.contentOffset = popPoint
                self.logoView?.frame = finalFrame
                self.logoView?.layoutIfNeeded()
            }
            
            self.addComplition()
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
        print("animationInProgress: \(position.x / self.scrollView.width)")
        
        
        if self.transitionAnimator?.isReversed == true { fraction *= -1}
        
        self.transitionAnimator?.fractionComplete = fraction + self.animationProgress
    }
    
    func addComplition() {
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
                
                self.viewProfileVC?.profileImageHeaderView?.isHidden = true
                self.profileView?.isHidden = true
                self.sideMenuVC?.profileContainerView.isHidden = false
            }
            self.transitionAnimator?.pauseAnimation()
            self.transitionAnimator = nil
        }
    }
    
    func animationComplete(_ recognizer: UIPanGestureRecognizer) {
        print("animationComplete")
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
