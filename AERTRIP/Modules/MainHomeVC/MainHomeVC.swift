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
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var sideMenuController: PKSideMenuController?
    private(set) var viewProfileVC: ViewProfileVC?
    private(set) var socialLoginVC: SocialLoginVC?
    private(set) var sideMenuVC: SideMenuVC?
    
    //MARK:- Private
    private var profileView: SlideMenuProfileImageHeaderView?
    private var logoView: SideMenuLogoView?
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuController?.viewWillAppear(animated)
        self.viewProfileVC?.viewWillAppear(animated)
        self.socialLoginVC?.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sideMenuController?.viewDidAppear(animated)
        self.viewProfileVC?.viewDidAppear(animated)
        self.socialLoginVC?.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.sideMenuController?.viewWillDisappear(animated)
        self.viewProfileVC?.viewWillDisappear(animated)
        self.socialLoginVC?.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sideMenuController?.viewDidAppear(animated)
        self.viewProfileVC?.viewDidAppear(animated)
        self.socialLoginVC?.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.sideMenuController?.viewDidLayoutSubviews()
        self.viewProfileVC?.viewDidLayoutSubviews()
        self.socialLoginVC?.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        //setup scroll view
        self.scrollViewSetup()
        self.socialLoginVC?.backButton.isHidden = true
        delay(seconds: 0.2) {[weak self] in
            self?.setupProfileView()
            self?.setupLogoView()
        }
    }
    
    private func scrollViewSetup() {
        
        //set content size
        self.scrollView.contentSize = CGSize(width: UIDevice.screenWidth * 2.0, height: UIDevice.screenHeight)
        
        //setup side menu controller
        let sideVC = self.createSideMenu()
        sideVC.view.frame = CGRect(x: UIDevice.screenWidth * 0.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        
        self.scrollView.addSubview(sideVC.view)
        self.addChild(sideVC)
        sideVC.didMove(toParent: self)
        
        if let _ = UserInfo.loggedInUserId {
            //setup view profile vc
            let viewProfile = self.createViewProfile()
            viewProfile.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
            
            self.scrollView.addSubview(viewProfile.view)
            self.addChild(viewProfile)
            viewProfile.didMove(toParent: self)
        }
        else {
            //setup social login vc
            let social = self.createSocialLoginVC()
            social.view.frame = CGRect(x: UIDevice.screenWidth * 1.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight)
            
            self.scrollView.addSubview(social.view)
            self.addChild(social)
            social.didMove(toParent: self)
        }
    }
    
    private func createSideMenu() -> PKSideMenuController {
        PKSideMenuOptions.opacityViewBackgroundColor = AppColors.themeDarkGreen
        PKSideMenuOptions.mainViewShadowColor = AppColors.themeDarkGreen
        PKSideMenuOptions.dropOffShadowColor = AppColors.themeBlack.withAlphaComponent(0.5)
        
        let sideMenuVC = PKSideMenuController()
        sideMenuVC.view.frame = UIScreen.main.bounds
    
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
        self.socialLoginVC = obj
        
        return obj
    }
    
    private func setupLogoView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.logoView = sideMenu.getAppLogoView()
        
        self.logoView?.isHidden = true
//        self.logoView?.translatesAutoresizingMaskIntoConstraints = true
//        self.logoView?.backgroundColor = .red
        self.logoView?.frame.origin.x = sideMenu.sideMenuTableView.x
        self.mainContainerView.addSubview(self.logoView!)
    }
    
    private func setupProfileView() {
        guard let sideMenu = self.sideMenuVC else {return}
        self.profileView = sideMenu.getProfileView()
        self.profileView?.frame = CGRect(x: sideMenu.sideMenuTableView.width, y: 50.0, width: sideMenu.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
        
        self.profileView?.isHidden = true
        self.profileView?.gradientView.isHidden = true
        self.profileView?.gradientView.alpha = 0
        self.mainContainerView.addSubview(self.profileView!)
    }
    
    private func pushProfileAnimation() {
        
        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        
        self.viewProfileVC?.profileImageHeaderView?.isHidden = true
        self.profileView?.isHidden = false
        self.sideMenuVC?.profileContainerView.isHidden = true
        
        let finalFrame = self.viewProfileVC?.profileImageHeaderView?.bounds ?? CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: UIDevice.screenHeight*0.45)
        
        self.profileView?.emailIdLabel.isHidden = false
        self.profileView?.mobileNumberLabel.isHidden = false
        self.profileView?.backgroundImageView.isHidden = false
        //self.profileView?.gradientView.alpha = 1.0
        self.profileView?.dividerView.isHidden = false
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            
            self.scrollView.contentOffset = pushPoint
            self.profileView?.frame = finalFrame
            
            self.profileView?.emailIdLabel.alpha = 1.0
            self.profileView?.mobileNumberLabel.alpha = 1.0
            self.profileView?.backgroundImageView.alpha = 1.0
            self.profileView?.gradientView.alpha = 1.0
            self.profileView?.dividerView.alpha = 1.0
            self.profileView?.profileContainerView.transform = CGAffineTransform.identity
            self.profileView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            
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
        
        let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 0.0, y: 70.0, width: self.sideMenuVC?.sideMenuTableView.width ?? 100.0, height: UIDevice.screenHeight*0.22)
        
        let trans = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.scrollView.contentOffset = popPoint
            self.profileView?.frame = finalFrame
            
            self.profileView?.emailIdLabel.alpha = 0.0
            self.profileView?.mobileNumberLabel.alpha = 0.0
            self.profileView?.backgroundImageView.alpha = 0.0
            self.profileView?.dividerView.alpha = 0.0
            self.profileView?.profileContainerView.transform = trans
            
            self.profileView?.layoutIfNeeded()
        }, completion: { (isDone) in
            
            self.profileView?.emailIdLabel.isHidden = true
            self.profileView?.mobileNumberLabel.isHidden = true

            self.profileView?.backgroundImageView.isHidden = true
            self.profileView?.dividerView.isHidden = true
            
            self.viewProfileVC?.profileImageHeaderView?.isHidden = true
            self.profileView?.isHidden = true
            self.sideMenuVC?.profileContainerView.isHidden = false
        })
    }
    
    private func pushLogoAnimation() {
        
        let pushPoint = CGPoint(x: UIDevice.screenWidth, y: 0.0)
        
        self.socialLoginVC?.logoContainerView.isHidden = true
        self.logoView?.isHidden = false
        self.sideMenuVC?.logoContainerView.isHidden = true
        self.socialLoginVC?.backButton.isHidden = true
        let finalFrame = self.socialLoginVC?.logoContainerView.frame ?? CGRect(x: (UIDevice.screenWidth * 0.125), y: 80.0, width: UIDevice.screenWidth * 0.75, height: self.sideMenuVC?.logoContainerView?.height ?? 110.0)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            
            self.scrollView.contentOffset = pushPoint
            self.logoView?.frame = finalFrame
            self.logoView?.layoutIfNeeded()
            
        }, completion: { (isDone) in
            self.socialLoginVC?.backButton.isHidden = false
            self.socialLoginVC?.logoContainerView.isHidden = false
            self.logoView?.isHidden = true
            self.sideMenuVC?.logoContainerView.isHidden = true
        })
    }
    
    private func popLogoAnimation() {
        
        let popPoint = CGPoint(x: 0.0, y: 0.0)
        
        self.socialLoginVC?.logoContainerView.isHidden = true
        self.logoView?.isHidden = false
        self.sideMenuVC?.logoContainerView.isHidden = true

        let finalFrame = CGRect(x: self.sideMenuVC?.sideMenuTableView.x ?? 0.0, y: self.sideMenuVC?.sideMenuTableView.y ?? 0.0, width: self.sideMenuVC?.sideMenuTableView.width ?? 110.0, height: 180.0)

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
