//
//  DashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class DashboardVC: BaseVC {
    
    @IBOutlet weak var innerScrollTopConst: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerScrollView: UIScrollView!
    @IBOutlet weak var innerScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var segmentCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var aertripLogoImageView: UIImageView!
    @IBOutlet weak var homeAertripLogoImageView: UIImageView!
    //segment views
    @IBOutlet weak var aerinView: UIView!
    @IBOutlet weak var flightsView: UIView!
    @IBOutlet weak var hotelsView: UIView!
    @IBOutlet weak var tripsView: UIView!
    
    @IBOutlet weak var aerinLabel: UILabel!
    @IBOutlet weak var flightsLabel: UILabel!
    @IBOutlet weak var hotelsLabel: UILabel!
    @IBOutlet weak var tripsLabel: UILabel!
    @IBOutlet weak var profileButton: ATNotificationButton!
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var backgroundGradientView: AppGradientView!
    
    var overlayView = UIView()
    private var previousOffset = CGPoint.zero
    private var mainScrollViewOffset = CGPoint.zero
    
    private var firstTime = true
    private var userDidScrollUp = false
    private var isSelectingFromTabs = false
    var toBeSelect : SelectedOption = .aerin
    private var previousSelected : SelectedOption = .aerin
    private var alreadyTransformedValue : CGFloat = 0.0
    private var identitySize = CGSize.zero
    private var smallerSize = CGSize.zero
    
    private var isInitialAminationDone: Bool = false
    
    private var isAnimatingButtons = false
    var lastInnerScrollViewContentOffset = CGPoint.zero
    var initialOffsetY : CGFloat = 0.0
    var scrollingDirection = ""
    var itemWidth : CGFloat {
        return aerinView.width
    }
    
    enum SelectedOption : Int {
        case aerin = 0
        case flight = 1
        case hotels = 2
        case trips = 3
    }
    
    var selectedOption : SelectedOption = .aerin
    
    var visualEffectView : UIVisualEffectView!
    var backView : UIView!
    var isLaunchThroughSplash = false
    private var isScrollHeightSet = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetItems()
        self.innerScrollView.isScrollEnabled = true
        headerTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        aerinView.transform = .identity
        aerinView.alpha = 1.0
        // nitin change
        if isLaunchThroughSplash {
            self.splashView.isHidden = true
        } else {
            self.splashView.isHidden = true
            self.addOverlayView()
        }
        
        self.backgroundGradientView.colors = AppConstants.appthemeGradientColors.reversed()
        mainScrollView.delaysContentTouches = false
        self.profileButton.imageView?.contentMode = .scaleAspectFill
        //addViewOnTop()
        updateProfileButton()
        
        delay(seconds: 0.2) {
            switch self.toBeSelect {
            case .aerin: self.aerinAction(UIButton())
            case .flight: self.flightsAction(UIButton())
            case .hotels: self.hotelsAction(UIButton())
            case .trips: self.aerinAction(UIButton())
            }
        }
        
    }
    
    deinit {
        printDebug("deinit DashboardVC")
    }
    
    private func addViewOnTop() {
        let safeAreaView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: UIApplication.shared.statusBarFrame.height))
        let safeAreaImgView = UIImageView(frame: safeAreaView.bounds)
        safeAreaImgView.image = UIImage(named: "statusBarColor")
        safeAreaView.addSubview(safeAreaImgView)
        view.addSubview(safeAreaView)
        view.bringSubviewToFront(safeAreaView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let guideHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        let fullHeight = UIScreen.main.bounds.size.height
        
        //Rishabh - Added 30 and changed mainscrollview bottom constraint to -30 in dashboard to resolve bottom card getting cut issue.
        let temp = UIScreen.main.bounds.size.height + 30 - (fullHeight - guideHeight) - segmentContainerView.bounds.height + headerTopConstraint.constant
        
        if !isScrollHeightSet {
            isScrollHeightSet = true
            let extraHeightForSafeArea: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 26 : 0
            innerScrollViewHeightConstraint.constant = temp + extraHeightForSafeArea
        }
        self.profileButton.cornerradius = self.profileButton.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VersionControler.shared.checkForUpdate()
        
        registerBulkEnquiryNotification()
        
        if firstTime {
            firstTime = false
            identitySize = aerinView.bounds.applying(CGAffineTransform.identity).size
            smallerSize = flightsView.bounds.applying(CGAffineTransform(scaleX: 0.75, y: 0.75)).size
        }
        
        if !(AppFlowManager.default.sideMenuController?.isOpen ?? true), !isInitialAminationDone {
            isInitialAminationDone = true
            self.setupInitialAnimation()
        }
        //addCustomBackgroundBlurView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.deRegisterBulkEnquiryNotification()
        
        if  self.isMovingFromParent {
            backView?.removeFromSuperview()
        }
    }
    
    override func dataChanged(_ note: Notification) {
        //        printDebug("data changed notfication received")
        //        resetItems()
        updateProfileButton()
    }
    
    private func registerBulkEnquiryNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(bulkEnguirySent), name: .bulkEnquirySent, object: nil)
    }
    
    private func deRegisterBulkEnquiryNotification() {
        NotificationCenter.default.removeObserver(self, name: .bulkEnquirySent, object: nil)
    }
    
    @objc final func bulkEnguirySent() {
        if selectedOption == .hotels {return}
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.hotels.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    //MARK:- IBAction
    @IBAction func aerinAction(_ ff: UIButton) {
        if selectedOption == .aerin || isAnimatingButtons {return}
        toBeSelect = .aerin
        isSelectingFromTabs = true
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.aerin.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    @IBAction func flightsAction(_ sender: UIButton) {
        if selectedOption == .flight || isAnimatingButtons {return}
        toBeSelect = .flight
        isSelectingFromTabs = true
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.flight.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    @IBAction func hotelsAction(_ sender: UIButton) {
        
        if selectedOption == .hotels || isAnimatingButtons {return}
        toBeSelect = .hotels
        isSelectingFromTabs = true
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.hotels.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    
    @IBAction func tripsAction(_ sender: UIButton) {
        
        if selectedOption == .trips || isAnimatingButtons {return}
        toBeSelect = .trips
        isSelectingFromTabs = true
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.trips.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    
    @IBAction func profileButtonAction(_ sender: ATNotificationButton) {
        AppFlowManager.default.sideMenuController?.toggleMenu() // nitin change
    }
    
    
    //MARK:- Private
    private func resetItems(){
        aerinView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        aerinView.alpha = 0.5
        flightsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        flightsView.alpha = 0.5
        hotelsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        hotelsView.alpha = 0.5
        tripsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        tripsView.alpha = 0.5
        statusBarStyle = .lightContent
    }
    
    private func addOverlayView() {
        overlayView.frame = self.view.bounds
        overlayView.alpha = 1.0
        overlayView.backgroundColor = AppColors.themeWhite
        self.view.addSubview(overlayView)
        
        let maskLayer = CAShapeLayer()
        
        // Create a path with the rectangle in it.
        let path = CGMutablePath()
        
        let radius : CGFloat = 50.0
        let xOffset : CGFloat = view.frame.midX
        let yOffset : CGFloat = view.frame.midY + 50.0
        
        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
        path.addRect(CGRect(x: 0, y: 0, width: overlayView.frame.width, height: overlayView.frame.height))
        
        maskLayer.backgroundColor = AppColors.themeWhite.cgColor
        
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
    }
    
    private func setupInitialAnimation() {
        // for top header down animation
        let tScale = CGAffineTransform(scaleX: 15.0, y: 15.0)
        let tTrans = CGAffineTransform(translationX: 0.0, y: -(self.view.height))
        
        self.overlayView.isHidden = false
        self.headerView.transform = CGAffineTransform(translationX: 0.0, y: -60.0)
        self.segmentContainerView.transform = CGAffineTransform(translationX: 0.0, y: -150.0)
        
        let rDuration = 1.0 / 2.0
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: .calculationModeLinear, animations: {
            
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.overlayView.transform = tScale.concatenating(tTrans)
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.5), relativeDuration: (rDuration * 2.0), animations: {
                self.headerView.transform = CGAffineTransform.identity
                self.segmentContainerView.transform = CGAffineTransform.identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.2), relativeDuration: (rDuration * 2.0), animations: {
                self.splashView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                self.splashView.alpha = 0.0
            })
            
            
        }) { (isDone) in
            self.overlayView.isHidden = true
            self.splashView.isHidden = true
        }
        
    }
    
    private func updateProfileButton() {
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty{
            var image = UserInfo.loggedInUser?.profilePlaceholder ?? UIImage()
            if let _ = UserInfo.loggedInUser?.firstName {
                image = AppGlobals.shared.getImageFor(firstName: UserInfo.loggedInUser?.firstName, lastName: UserInfo.loggedInUser?.lastName)
            }
            
            // Commented as profile picture was not getting set for fb users that didn't have one
            // not used kf.setImage on button as error could not be extracted
            //self.profileButton.kf.setImage(with: URL(string: imagePath), for: UIControl.State.normal, placeholder: image, options: [.keepCurrentImageWhileLoading])
            UIImageView().setImageWithUrl(imageUrl: imagePath, placeholder: image, showIndicator: false) { (downloadedImage, err) in
                if let urlImg = downloadedImage {
                    self.profileButton.setImage(urlImg, for: .normal)
                } else {
                    self.profileButton.setImage(image, for: .normal)
                }
            }
            
//            profileButton.kf.setImage(with: URL(string: imagePath), for: .normal, placeholder: image, options: [.keepCurrentImageWhileLoading], progressBlock: nil) { (result) in
//
//            }

            //        self.profileButton.imageView?.setImageWithUrl(imagePath, placeholder: AppPlaceholderImage.user, showIndicator: false)
        } else {
            if let userInfo = UserInfo.loggedInUser {
                let image = userInfo.profileImagePlaceholder()
                self.profileButton.setImage(image, for: .normal)
                self.profileButton.layer.borderColor = AppColors.profileImageBorderColor.cgColor
                self.profileButton.layer.borderWidth = 2.0
            }
            else {
                self.profileButton.setImage(AppPlaceholderImage.user, for: .normal)
                self.profileButton.layer.borderColor = AppColors.clear.cgColor
                self.profileButton.layer.borderWidth = 0.0
            }
            
        }
    }
    
    func addCustomBackgroundBlurView(){
        
        visualEffectView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: visualEffectViewHeight))
        visualEffectView.effect = UIBlurEffect(style: .light)
        
        backView = UIView(frame: CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: 20))
        backView.backgroundColor = UIColor.clear
        backView.addSubview(visualEffectView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.addSubview(backView)
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem=nil
    }
}

extension DashboardVC  {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isSelectingFromTabs = false
        
        previousSelected = selectedOption
        if scrollView == innerScrollView {
            lastInnerScrollViewContentOffset.x = scrollView.contentOffset.x
            lastInnerScrollViewContentOffset.y = scrollView.contentOffset.y
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == innerScrollView {
            
            if lastInnerScrollViewContentOffset.x < scrollView.contentOffset.x {
                // moved right
                printDebug("right")
                self.scrollingDirection = "right"
            } else if lastInnerScrollViewContentOffset.x > scrollView.contentOffset.x {
                // moved left
                printDebug("left")
                self.scrollingDirection = "left"
            } else if lastInnerScrollViewContentOffset.y < scrollView.contentOffset.y {
                printDebug("up")
                self.scrollingDirection = "up"
                innerScrollDidEndDragging(scrollView)
            } else if lastInnerScrollViewContentOffset.y > scrollView.contentOffset.y {
                printDebug("down")
                self.scrollingDirection = "down"
                innerScrollDidEndDragging(scrollView)
            }
        }
    }
    
    func setTransformAfterDraging(selectedTap: SelectedOption, isOnlyAlpha: Bool){
        
        UIView.animate(withDuration: 0.2, animations:{
            
            
            self.aerinView.alpha = (selectedTap == SelectedOption.aerin) ? 1.0 : 0.5
            self.flightsView.alpha = (selectedTap == SelectedOption.flight) ? 1.0 : 0.5
            self.hotelsView.alpha = (selectedTap == SelectedOption.hotels) ? 1.0 : 0.5
            self.tripsView.alpha = (selectedTap == SelectedOption.trips) ? 1.0 : 0.5
            
            if !isOnlyAlpha{
                
                self.aerinView.transform = CGAffineTransform(scaleX: (selectedTap == SelectedOption.aerin) ? 1.0 : 0.75, y: (selectedTap == SelectedOption.aerin) ? 1.0 : 0.75)
                
                self.flightsView.transform = CGAffineTransform(scaleX: ((selectedTap == SelectedOption.flight) ? 1.0 : 0.75), y: ((selectedTap == SelectedOption.flight) ? 1.0 : 0.75))
                
                self.hotelsView.transform = CGAffineTransform(scaleX: ((selectedTap == SelectedOption.hotels) ? 1.0 : 0.75), y: ((selectedTap == SelectedOption.hotels) ? 1.0 : 0.75))
                
                self.tripsView.transform = CGAffineTransform(scaleX: ((selectedTap == SelectedOption.trips) ? 1.0 : 0.75), y: ((selectedTap == SelectedOption.trips) ? 1.0 : 0.75))
            }
            
        })
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == innerScrollView {
            let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
            guard let currentOption = SelectedOption(rawValue: page) else {return}
            if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                if self.scrollingDirection.lowercased() == "right" || self.scrollingDirection.localized == "left"{
                    self.setTransformAfterDraging(selectedTap: currentOption, isOnlyAlpha: false)
                }
            }else{
                self.setTransformAfterDraging(selectedTap: currentOption, isOnlyAlpha: true)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {            
            var transform : CGFloat = 0.0
            
            let offset = scrollView.contentOffset
            
            // MARK: Commented by Rishabh for vertical rubberband effect
            //            guard offset.y <= UIApplication.shared.statusBarFrame.height + 44 else {
            //                scrollView.contentOffset.y = UIApplication.shared.statusBarFrame.height + 44
            //                return
            //            }
            
            let upperBound = scrollView.contentSize.height - scrollView.bounds.height
            guard 0...upperBound ~= offset.y else {
                return
            }
            
            let progress: CGFloat = offset.y.truncatingRemainder(dividingBy: scrollView.bounds.height) / scrollView.bounds.height
            
            if progress != 0 {
                self.aertripLogoImageView.alpha = 0.2 - progress
                self.profileButton.alpha = 0.2 - progress
                self.homeAertripLogoImageView.alpha = 0.2 - progress
            } else {
                self.aertripLogoImageView.alpha = 1
                self.profileButton.alpha = 1
                self.homeAertripLogoImageView.alpha = 1
            }
            
            //            printDebug("current progress \(progress)")
            //            Asif change, InnerCollView top Const is given 5 pixel ======================
            if scrollView.contentOffset.y - mainScrollViewOffset.y >= 0 {
                let valueMoved = scrollView.contentOffset.y - mainScrollViewOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateUpLabels(with: headerValueMoved)
                //transform = 1.0 - headerValueMoved/4.0 - 0.08
                transform = 1.0 - headerValueMoved/4.0
                if offset.y == 80 {
                    updateUpLabels(with: 1)
                }
                userDidScrollUp = true
                self.innerScrollTopConst.constant = 19.0
                //                printDebug("Scrolling up \(transform)")
            }else{
                let valueMoved = mainScrollViewOffset.y - scrollView.contentOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateDownLabels(with: headerValueMoved)
                transform = 1.0 + headerValueMoved/4.0
                userDidScrollUp = false
                self.innerScrollTopConst.constant = 0.0
                //                 printDebug("Scrolling down \(transform)")
            }
            updateSegmentYPosition(for: scrollView.contentOffset.y)
            updateSegmentTop(for: scrollView.contentOffset.y)
            updateInnerScrollTop(for: scrollView.contentOffset.y)
            let isIncreasing = (scrollView.contentOffset.y - self.initialOffsetY) < 0
            switch selectedOption{
            case .aerin: checkAndApplyTransform(aerinView, transformValue: transform, scrolledUp: userDidScrollUp, isIncreasing: isIncreasing, isForVertical:true)
            case .flight: checkAndApplyTransform(flightsView, transformValue: transform, scrolledUp: userDidScrollUp, isIncreasing: isIncreasing, isForVertical:true)
            case .hotels: checkAndApplyTransform(hotelsView, transformValue: transform, scrolledUp: userDidScrollUp, isIncreasing: isIncreasing, isForVertical:true)
            case .trips: checkAndApplyTransform(tripsView, transformValue: transform, scrolledUp: userDidScrollUp, isIncreasing: isIncreasing, isForVertical:true)
            }
            
            mainScrollViewOffset = scrollView.contentOffset
            
        }else{
            //only perform size animation on horizontal scroll if outermost is at the top
            let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
            let offset = scrollView.contentOffset
            let isForward = (offset.x - previousOffset.x) > 0
            if isForward {
                
                //as we want on scale of 0.0 to 1.0 so i divide it by the width
                let valueMoved = offset.x - previousOffset.x
                let progressValueMoved = valueMoved/scrollView.bounds.width
                
                let increaseTransform = 1.0 + progressValueMoved/4.0
                let decreaseTransform = 1.0 - progressValueMoved/4.0
                printDebug("increaseTransform: \(increaseTransform)")
                printDebug("decreaseTransform: \(decreaseTransform)")
                if scrollView.contentOffset.x >= 0 {
                    if self.isSelectingFromTabs {
                        if self.selectedOption != self.toBeSelect {
                            animateForPage(fromPage: self.selectedOption.rawValue, toPage: self.toBeSelect.rawValue)
                        }
                    }
                    else {
                        animateForPage(moved: progressValueMoved, page: page, isForward: true, increaseSize: increaseTransform, decreaseSize : decreaseTransform)
                    }
                }
            }else{
                
                let valueMoved = previousOffset.x - offset.x
                let tabValueMoved = valueMoved/scrollView.bounds.width
                
                let increaseTransform = 1.0 + tabValueMoved/4
                let decreaseTransform = 1.0 - tabValueMoved/4
                printDebug("increaseTransform: \(increaseTransform)")
                printDebug("decreaseTransform: \(decreaseTransform)")
                if scrollView.contentOffset.x >= 0 {
                    if self.isSelectingFromTabs {
                        if self.selectedOption != self.toBeSelect {
                            animateForPage(fromPage: self.selectedOption.rawValue, toPage: self.toBeSelect.rawValue)
                        }
                    }
                    else {
                        animateForPage(moved: tabValueMoved, page: page, isForward: false, increaseSize: increaseTransform, decreaseSize : decreaseTransform)
                    }
                }
            }
            previousOffset = scrollView.contentOffset
        }
    }
    
    private func updateSegmentYPosition(for scrolledY: CGFloat) {
        // MARK: Commented by Rishabh for vertical rubberband effect and top spacing
        //        let valueToBe: CGFloat = 20
        let valueToBe: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 30 : 25
        
        let ratio = valueToBe / (headerTopConstraint.constant + headerView.height)
        
        segmentCenterYConstraint.constant = ratio * scrolledY
        //        printDebug("segment y pos:  \(segmentCenterYConstraint.constant)")
    }
    
    private func updateInnerScrollTop(for scrolledY: CGFloat) {
        // MARK: Commented by Rishabh as dashboard icons were getting cut
        //        let valueToDecrease: CGFloat = 18.0
        let valueToDecrease: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 6 : 18
        let ratio = valueToDecrease / (headerTopConstraint.constant + headerView.height)
        let final = (ratio * scrolledY)
        if final == 0 {
            self.innerScrollTopConst.constant = 0.0
            innerScrollView.transform = CGAffineTransform.identity
        }
        else {
            //            printDebug("final value is \(final)")
            //innerScrollView.transform = CGAffineTransform(translationX: 0, y: -(final))
            self.innerScrollTopConst.constant = final
            innerScrollView.transform = CGAffineTransform(translationX: 0.0, y: -(final))
        }
    }
    
    private func updateSegmentTop(for scrolledY: CGFloat) {
        let valueToDecrease: CGFloat = 1
        let ratio = valueToDecrease / (headerTopConstraint.constant + headerView.height)
        let final = (ratio * scrolledY)
        if final == 0 {
            self.innerScrollTopConst.constant = 0.0
            segmentContainerView.transform = CGAffineTransform.identity
        }
        else {
            self.innerScrollTopConst.constant = final
            // segmentContainerView.transform = CGAffineTransform(translationX: -(final - 4), y: -(final - 0.3))
            segmentContainerView.transform = CGAffineTransform(translationX: 0.0, y: -(final))
        }
    }
    
    
    private func checkAndApplyTransform(_ view : UIView, transformValue : CGFloat, scrolledUp : Bool, isIncreasing:Bool, isForVertical:Bool = false){
        
        let initialTransform = view.transform

        if isSelectingFromTabs {
            view.transform = (transformValue == 1.0) ? CGAffineTransform.identity : CGAffineTransform(scaleX: transformValue, y: transformValue)
        }
        else {
            //            if transformedBounds.size.width >= identitySize.width && !scrolledUp{
            //                view.transform = CGAffineTransform.identity
            //            }else
            
            // MARK: Commented by Rishabh as it is causing jerk in small devices
            //            if transformedBounds.size.width < smallerSize.width && scrolledUp{
            //                view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            //            }else{
            //                view.transform = view.transform.scaledBy(x: transformValue, y: transformValue)
            //            }
            if !isForVertical{
                if isIncreasing{
                    if view.transform.a >= 1.0{
                        return
                    }
                }else{
                    if view.transform.a <= 0.75{
                        return
                    }
                    
                }
            }
            view.transform = view.transform.scaledBy(x: transformValue, y: transformValue)
            
        }
    }
    
    //    private func checkAndApplyTransform(_ view : UIView, transformValue : CGFloat, scrolledUp : Bool){
    //
    //        let initialTransform = view.transform
    //        let transformedBounds = view.bounds.applying(initialTransform.scaledBy(x: transformValue, y: transformValue))
    //
    //        if isSelectingFromTabs {
    //            view.transform = (transformValue == 1.0) ? CGAffineTransform.identity : CGAffineTransform(scaleX: transformValue, y: transformValue)
    //        }
    //        else {
    //            if transformedBounds.size.width >= identitySize.width && !scrolledUp{
    //                view.transform = CGAffineTransform.identity
    //            }else if transformedBounds.size.width < smallerSize.width && scrolledUp{
    //                view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    //            }else{
    //                view.transform = view.transform.scaledBy(x: transformValue, y: transformValue)
    //            }
    //        }
    //    }
    
    private func updateUpLabels(with alpha : CGFloat){
        
        let extraAlpha: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 0 : 0
        
        headerView.alpha = max(headerView.alpha - alpha, 0.0)
        
        aerinLabel.alpha = max(aerinLabel.alpha - (alpha + extraAlpha), 0.0)
        flightsLabel.alpha = max(flightsLabel.alpha - (alpha + extraAlpha), 0.0)
        hotelsLabel.alpha = max(hotelsLabel.alpha - (alpha + extraAlpha), 0.0)
        tripsLabel.alpha = max(tripsLabel.alpha - (alpha + extraAlpha), 0.0)
    }
    
    private func updateDownLabels(with alpha : CGFloat){
        
        let extraAlpha: CGFloat = UIApplication.shared.statusBarFrame.height > 20 ? 0 : 0
        
        headerView.alpha = min(headerView.alpha + alpha, 1.0)
        
        aerinLabel.alpha = min(aerinLabel.alpha + (alpha + extraAlpha), 1.0)
        flightsLabel.alpha = min(flightsLabel.alpha + (alpha + extraAlpha), 1.0)
        hotelsLabel.alpha = min(hotelsLabel.alpha + (alpha + extraAlpha), 1.0)
        tripsLabel.alpha = min(tripsLabel.alpha + (alpha + extraAlpha), 1.0)
    }
    
    private func viewFor(option: SelectedOption) -> UIView {
        switch option {
        case .flight: return self.flightsView
        case .hotels: return self.hotelsView
        case .trips: return self.tripsView
        default: return self.aerinView
        }
    }
    
    private func animateForPage(fromPage: Int, toPage: Int){
        
        guard let fromPg = SelectedOption(rawValue: fromPage), let toPg = SelectedOption(rawValue: toPage) else {return}
        selectedOption = toPg
        
        let fromV = viewFor(option: fromPg)
        let toV = viewFor(option: toPg)
        
        isAnimatingButtons = true
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration * 0.6, curve: .linear) { [weak self] in
            guard let `self` = self else {return}
            
            fromV.alpha = 0.5
            toV.alpha = 1.0
            if !self.userDidScrollUp {
                self.checkAndApplyTransform(fromV, transformValue: 0.75, scrolledUp: true, isIncreasing: false)
                self.checkAndApplyTransform(toV, transformValue: 1.0, scrolledUp: true, isIncreasing: true)
            }
        }
        
        animator.addCompletion { [weak self](pos) in
            DispatchQueue.delay(0.05) {
                self?.isSelectingFromTabs = false
                self?.isAnimatingButtons = false
            }
        }
        
        animator.startAnimation()
    }
    
    private func animateForPage(moved : CGFloat, page : Int, isForward : Bool, increaseSize : CGFloat, decreaseSize : CGFloat){
        
        guard let currentOption = SelectedOption(rawValue: page) else {return}
        selectedOption = currentOption
        if isForward{
            switch currentOption{
            case .aerin:
                aerinView.alpha = max(aerinView.alpha - moved, 0.5)
                flightsView.alpha = min(flightsView.alpha + moved, 1.0)
                
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                    checkAndApplyTransform(aerinView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(flightsView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
                
            case .flight:
                flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                    checkAndApplyTransform(flightsView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(hotelsView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
            case .hotels:
                hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                tripsView.alpha = min(tripsView.alpha + moved, 1.0)
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                    checkAndApplyTransform(hotelsView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(tripsView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
            case .trips: break
            }
        }else{
            
            switch currentOption{
            case .aerin:
                flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                aerinView.alpha = min(aerinView.alpha + moved, 1.0)
                
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                    checkAndApplyTransform(flightsView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(aerinView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
                
            case .flight:
                hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                flightsView.alpha = min(flightsView.alpha + moved, 1.0)
                // Asif Change ====================== ======================  ======================
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height - 19.0 {
                    checkAndApplyTransform(hotelsView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(flightsView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
            case .hotels:
                
                tripsView.alpha = max(tripsView.alpha - moved, 0.5)
                hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)
                
                if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height -  19.0 {
                    checkAndApplyTransform(tripsView, transformValue: decreaseSize, scrolledUp: isForward, isIncreasing: false)
                    checkAndApplyTransform(hotelsView, transformValue: increaseSize, scrolledUp: isForward, isIncreasing: true)
                }
            case .trips: break
            }
        }
    }
}

// MARK: Child scroll view methods
// added by Rishabh
extension DashboardVC {
    
    func innerScrollDidEndDragging(_ scrollView: UIScrollView) {
        self.scrollToTopOrBottom()
    }
    
    private func scrollToTopOrBottom(_ duration: TimeInterval = 0.3) {
        let mainScrollYOffset = mainScrollView.contentOffset.y
        let maxYOffsetForMainScroll = self.mainScrollView.contentSize.height - self.mainScrollView.height
        let midConstant: CGFloat = (maxYOffsetForMainScroll/2) + 3
        
        if mainScrollYOffset < midConstant {
            //            UIView.animate(withDuration: duration, animations: {
            //
            //            }, completion: { _ in
            //
            //            })
            let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
                guard let `self` = self else {return}
                
                for offset in stride(from: mainScrollYOffset, through: 0, by: -0.1) {
                    self.mainScrollView.contentOffset.y = offset
                    self.mainScrollView.layoutIfNeeded()
                }
                switch self.selectedOption {
                case .aerin:
                    self.aerinView.transform = .identity
                    self.aerinView.alpha = 1
                case .flight:
                    self.flightsView.transform = .identity
                    self.flightsView.alpha = 1
                case .hotels:
                    self.hotelsView.transform = .identity
                    self.hotelsView.alpha = 1
                case .trips:
                    self.tripsView.transform = .identity
                    self.tripsView.alpha = 1
                }
            }
            
            animator.addCompletion { [weak self](pos) in
                guard let `self` = self else {return}
                if self.mainScrollView.contentOffset.y != 0 {
                    self.scrollToTopOrBottom(0.15)
                }
            }
            
            animator.startAnimation()
        } else {
            //            UIView.animate(withDuration: duration, animations: {
            //                for offset in stride(from: mainScrollYOffset, through: maxYOffsetForMainScroll, by: 0.1) {
            //                    self.mainScrollView.contentOffset.y = offset
            //                    self.mainScrollView.layoutIfNeeded()
            //                }
            //            }, completion: { _ in
            //                if self.mainScrollView.contentOffset.y < maxYOffsetForMainScroll {
            //                    self.scrollToTopOrBottom(0.15)
            //                }
            //            })
            
            let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
                guard let `self` = self else {return}
                
                for offset in stride(from: mainScrollYOffset, through: maxYOffsetForMainScroll, by: 0.1) {
                    self.mainScrollView.contentOffset.y = offset
                    self.mainScrollView.layoutIfNeeded()
                }
            }
            
            animator.addCompletion { [weak self](pos) in
                guard let `self` = self else {return}
                if self.mainScrollView.contentOffset.y < maxYOffsetForMainScroll {
                    self.scrollToTopOrBottom(0.15)
                }
            }
            
            animator.startAnimation()
        }
    }
}
