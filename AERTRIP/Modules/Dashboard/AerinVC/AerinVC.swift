//
//  AerinVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinVC: BaseVC {
    // MARK: - Properties
    
    // MARK: - Private
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var aerinButton: UIButton!
    @IBOutlet weak var commandHintLabel: UILabel!
    @IBOutlet weak var aerinContainer: UIView!
    @IBOutlet weak var contentView: UIView!
    //    @IBOutlet weak var weekendMessageLabel: UILabel!
    @IBOutlet weak var bottomCollectionView: UIView!
    //    @IBOutlet weak var bottomFirstView: UIView!
    //    @IBOutlet weak var bottomSecondView: UIView!
    @IBOutlet weak var bottomViewImage: UIImageView!
    @IBOutlet weak var aerinViewContainer: UIView!
    @IBOutlet weak var travelSafetyButton: UIButton!
    @IBOutlet weak var travelSafetyLabel: UILabel!
    @IBOutlet weak var travelSafetyViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var aerinViewTopConstraint: NSLayoutConstraint!
    
    private var previousOffSet = CGPoint.zero
    private var aerInPulsAnimator: PKPulseAnimation = PKPulseAnimation()
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        containerScrollView.alwaysBounceVertical = true
        containerScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.aerInPulsAnimator.start()
        
        if !(AppFlowManager.default.sideMenuController?.isOpen ?? true) {
            // self.setupInitialAnimation()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //        self.bottomViewImage.layer.cornerRadius = 20
        //        self.bottomViewImage.layer.borderWidth = 7
        //        self.bottomViewImage.layer.borderColor = AppColors.themeWhite.withAlphaComponent(0.4).cgColor
        
        
        //self.bottomCollectionView.layer.cornerRadius = 10
        //        self.bottomCollectionView.layer.borderWidth = 7
        //        self.bottomCollectionView.layer.borderColor = AppColors.themeWhite.withAlphaComponent(0.4).cgColor
        /*
         self.bottomFirstView.layer.cornerRadius = 10.3
         self.bottomFirstView.layer.borderWidth = 10
         self.bottomFirstView.layer.borderColor = AppColors.themeWhite.withAlphaComponent(0.3).cgColor
         
         self.bottomSecondView.layer.cornerRadius = 9
         self.bottomSecondView.layer.borderWidth = 8
         self.bottomSecondView.layer.borderColor = AppColors.themeWhite.withAlphaComponent(0.1).cgColor
         */
        let aerinTop =  (self.view.height - aerinViewContainer.height - 120 - 80)/2
        if  aerinTop > 0, self.aerinViewTopConstraint.constant != aerinTop  {
            aerinViewTopConstraint.constant = aerinTop
            
            let value = self.view.height - aerinTop - aerinViewContainer.height - 84 - 80
            if  value > 0, self.travelSafetyViewTopConstraint.constant != value  {
                self.travelSafetyViewTopConstraint.constant = value
            }
        }
        
    }
    
    override func initialSetup() {
        self.aerInPulsAnimator.numPulse = 6
        self.aerInPulsAnimator.radius = 100.0
        self.aerInPulsAnimator.currentAnimation = .line
        self.aerInPulsAnimator.lineWidth = 2.0
        self.aerInPulsAnimator.lineColor = AppColors.themeBlackGreen
        self.aerInPulsAnimator.backgroundColor = AppColors.themeGray60.cgColor
        self.aerinContainer.layer.insertSublayer(self.aerInPulsAnimator, below: self.aerinButton.layer)
        /*
         self.bottomFirstView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.3)
         self.bottomSecondView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.1)
         */
        self.bottomViewImage.cornerradius = 10
        self.bottomCollectionView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
        setupAnimation()
    }
    
    override func setupFonts() {
        self.messageLabel.font = AppFonts.Regular.withSize(16.0)
        //self.weekendMessageLabel.font = AppFonts.Regular.withSize(17.0)
        self.travelSafetyLabel.font = AppFonts.SemiBold.withSize(28.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.aerInPulsAnimator.position = CGPoint(x: self.aerinContainer.frame.width / 2.0, y: self.aerinContainer.frame.height / 2.0)
    }
    
    override func setupTexts() {
        let greetingAttrTxt = NSMutableAttributedString(string: LocalizedString.hiImAerin.localized, attributes: [.font: AppFonts.ExtraLight.withSize(28.0), .foregroundColor: AppColors.themeTextColor])
        greetingAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(28.0), range: (greetingAttrTxt.string as NSString).range(of: "Aerin"))
        self.greetingLabel.attributedText = greetingAttrTxt
        
        self.messageLabel.text = LocalizedString.yourPersonalTravelAssistant.localized
        
        let commandAttrTxt = NSMutableAttributedString(string: LocalizedString.tryAskingForFlightsFromMumbai.localized, attributes: [.font: AppFonts.ExtraLight.withSize(16.0), .foregroundColor: AppColors.themeTextColor])
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Flights"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Mumbai"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Delhi"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Christmas"))
        
        let attributedString = NSMutableAttributedString(string: "Try asking for \n“Flights from Mumbai to Delhi on Christmas”", attributes: [
            .font: AppFonts.Regular.withSize(16.0),
            .foregroundColor: AppColors.themeTextColor
        ])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(.font, value: AppFonts.Regular.withSize(14.0), range: NSRange(location: 0, length: 14))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.commandHintLabel.attributedText = attributedString
        
        //self.weekendMessageLabel.text = LocalizedString.weekendGetaway.localized
        self.travelSafetyLabel.text = LocalizedString.TravelSafetyGuidelines.localized
    }
    
    override func setupColors() {
        self.messageLabel.textColor = AppColors.themeTextColor
        //self.weekendMessageLabel.textColor = AppColors.themeWhite.withAlphaComponent(0.4)
        self.travelSafetyLabel.textColor = AppColors.themeTextColor
    }
    
    func setupInitialAnimation() {
        self.bottomCollectionView.transform = CGAffineTransform(translationX: 0.0, y: 110.0)
        //self.bottomSecondView.transform = CGAffineTransform(translationX: 0.0, y: 110.0)
        //self.bottomFirstView.transform = CGAffineTransform(translationX: 0.0, y: 110.0)
        //self.weekendMessageLabel.transform = CGAffineTransform(translationX: 0.0, y: 110.0)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.bottomCollectionView.transform = CGAffineTransform.identity
            //self.bottomSecondView.transform = CGAffineTransform.identity
            //self.bottomFirstView.transform = CGAffineTransform.identity
            //self.weekendMessageLabel.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    private func setupAnimation() {
        aerinViewContainer.transform = .init(scaleX: 0, y: 0)
        self.bottomCollectionView.transform = CGAffineTransform(translationX: 0.0, y: 200)
        //self.bottomSecondView.transform = CGAffineTransform(translationX: 0.0, y: 200)
        //self.bottomFirstView.transform = CGAffineTransform(translationX: 0.0, y: 200)
        //self.weekendMessageLabel.transform = CGAffineTransform(translationX: 0.0, y: 200)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.aerinViewContainer.transform = CGAffineTransform.identity
            self.bottomCollectionView.transform = CGAffineTransform.identity
            //self.bottomSecondView.transform = CGAffineTransform.identity
            //self.bottomFirstView.transform = CGAffineTransform.identity
            //self.weekendMessageLabel.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffSet.y
        
        if let parent = parent as? DashboardVC {
            if difference > 0 {
                // check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height {
                    if scrollView.contentOffset.y > 0.0 {
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            } else {
                if parent.mainScrollView.contentOffset.y > 0.0 {
                    if scrollView.contentOffset.y <= 0.0 {
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        
        self.previousOffSet = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = parent as? DashboardVC else { return }
        parent.innerScrollDidEndDragging(scrollView)
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func aerinButtonAction(_ sender: Any) {
        //        if !AppConstants.isReleasingToClient {
        // move to Aerin VC
        // AppFlowManager.default.showAerinTextToSpeechVC()
        // AppFlowManager.default.moveToAerinTextSpeechDetailVC()
        
        // AppFlowManager.default.moveToOtherBookingsDetailsVC()
        
        // for  showing my booking
        
        //  AppFlowManager.default.moveToMyBookingsVC()
        
        //   --------  for showing Boking hotel Detail --------
        /// AppFlowManager.default.moveToBookingHotelDetailVC()
        
        // for showing booking call VC
        
        // AppFlowManager.default.moveToBookingCallVC()
        
        // for showing bookig invoice VC
        
        // AppFlowManager.default.moveToTestViewController()
        
        //
        
        
        
        //            let obj = CreateProfileVC.instantiate(fromAppStoryboard: .PreLogin)
        //            AppFlowManager.default.mainNavigationController.pushViewController(obj, animated: true)
        
        
        //****  Booking DirectionVC ******
        
        //AppFlowManager.default.moveToBookingDirectionVC()
        
        //             let obj = SelectTripVC.instantiate(fromAppStoryboard: .HotelResults)
        //            AppFlowManager.default.mainNavigationController.present(obj, animated: true)
        
        let aerinPopoverVC = AerinCustomPopoverVC.instantiate(fromAppStoryboard: .Dashboard)
        aerinPopoverVC.modalPresentationStyle = .overCurrentContext
        AppFlowManager.default.mainNavigationController.present(aerinPopoverVC, animated: false, completion: nil)
        
//        let obj = ChatVC.instantiate(fromAppStoryboard: .Dashboard)
//        AppFlowManager.default.mainNavigationController.pushViewController(obj, animated: false)
        
        //        }
    }
    
    
    @IBAction func travelSafetyBtnTapped(_ sender: Any) {
        AppToast.default.showToastMessage(message: LocalizedString.UnderDevelopment.localized)
    }
}
