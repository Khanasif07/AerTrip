//
//  DashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class DashboardVC: BaseVC {

    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerScrollView: UIScrollView!
    @IBOutlet weak var innerScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentContainerView: UIView!
    
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
    
    private var overlayView = UIView()
    private var previousOffset = CGPoint.zero
    private var mainScrollViewOffset = CGPoint.zero

    private var firstTime = true
    private var userDidScrollUp = false
    private var previousSelected : SelectedOption = .aerin
    private var alreadyTransformedValue : CGFloat = 0.0
    private var identitySize = CGSize.zero
    private var smallerSize = CGSize.zero

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

    override func viewDidLoad() {
        super.viewDidLoad()
        resetItems()
        headerTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        aerinView.transform = .identity
        aerinView.alpha = 1.0
        self.addOverlayView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let guideHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        let fullHeight = UIScreen.main.bounds.size.height

        innerScrollViewHeightConstraint.constant = UIScreen.main.bounds.size.height - (fullHeight - guideHeight) - segmentContainerView.bounds.height + headerTopConstraint.constant
        self.profileButton.cornerRadius = self.profileButton.height/2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if firstTime{
            firstTime = false
            identitySize = aerinView.bounds.applying(CGAffineTransform.identity).size
            smallerSize = flightsView.bounds.applying(CGAffineTransform(scaleX: 0.75, y: 0.75)).size
        }
        
        if !(AppFlowManager.default.sideMenuController?.isOpen ?? true) {
            self.setupInitialAnimation()
        }
    }
    
    override func dataChanged(_ note: Notification) {
        printDebug("data changed notfication received")
//        resetItems()
        updateProfileButton()
    }
    
    //MARK:- IBAction
    @IBAction func aerinAction(_ sender: UIButton) {
        if selectedOption == .aerin {return}
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.aerin.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }

    @IBAction func flightsAction(_ sender: UIButton) {

        if selectedOption == .flight {return}
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.flight.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }

    @IBAction func hotelsAction(_ sender: UIButton) {

        if selectedOption == .hotels {return}
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.hotels.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }

    
    @IBAction func tripsAction(_ sender: UIButton) {

        if selectedOption == .trips {return}
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.trips.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }
    
    
    @IBAction func profileButtonAction(_ sender: ATNotificationButton) {
        AppFlowManager.default.sideMenuController?.toggleMenu()
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
        
        let tScale = CGAffineTransform(scaleX: 12.0, y: 12.0)
        let tTrans = CGAffineTransform(translationX: 0.0, y: -(self.view.height))
        
        self.overlayView.isHidden = false
        self.headerView.transform = CGAffineTransform(translationX: 0.0, y: -60.0)
        self.segmentContainerView.transform = CGAffineTransform(translationX: 0.0, y: -150.0)
        
        let rDuration = 1.0 / 2.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration * 2.0, delay: 0.0, options: .calculationModeLinear, animations: {


            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.overlayView.transform = tScale.concatenating(tTrans)
            })

            UIView.addKeyframe(withRelativeStartTime: (rDuration * 1.0), relativeDuration: (rDuration * 2.0), animations: {
                self.headerView.transform = CGAffineTransform.identity
                self.segmentContainerView.transform = CGAffineTransform.identity
            })

        }) { (isDone) in
            self.overlayView.isHidden = true
        }

        
//
//        UIView.animate(withDuration: 0.4, animations: {
//            self.overlayView.transform = tScale.concatenating(tTrans)
//        }) { (isDone) in
//            if isDone {
//                self.overlayView.isHidden = true
//                UIView.animate(withDuration: AppConstants.kAnimationDuration / 2, delay: 0.0, options: [.curveEaseOut], animations: {
//                    self.headerView.transform = CGAffineTransform.identity
//                    self.segmentContainerView.transform = CGAffineTransform.identity
//                }, completion: nil)
//            }
//        }
    }
    
    private func updateProfileButton() {
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty, let place = UserInfo.loggedInUser?.profileImagePlaceholder() {
            self.profileButton.kf.setImage(with: URL(string: imagePath), for: UIControl.State.normal, placeholder: place)
            //        self.profileButton.imageView?.setImageWithUrl(imagePath, placeholder: AppPlaceholderImage.user, showIndicator: false)
        } else {
            if let userInfo = UserInfo.loggedInUser {
                self.profileButton.setImage(userInfo.profileImagePlaceholder(), for: .normal)
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
}

extension DashboardVC  {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        previousSelected = selectedOption
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == mainScrollView {
            
            var transform : CGFloat = 0.0

            if scrollView.contentOffset.y - mainScrollViewOffset.y > 0 {
                let valueMoved = scrollView.contentOffset.y - mainScrollViewOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateUpLabels(with: headerValueMoved)
                transform = 1.0 - headerValueMoved/4.0
                userDidScrollUp = true
            }else{
                let valueMoved = mainScrollViewOffset.y - scrollView.contentOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateDownLabels(with: headerValueMoved)
                transform = 1.0 + headerValueMoved/4.0
                userDidScrollUp = false
            }
        
            switch selectedOption{
                case .aerin: checkAndApplyTransform(aerinView, transformValue: transform, scrolledUp: userDidScrollUp)
                case .flight: checkAndApplyTransform(flightsView, transformValue: transform, scrolledUp: userDidScrollUp)
                case .hotels: checkAndApplyTransform(hotelsView, transformValue: transform, scrolledUp: userDidScrollUp)
                case .trips: checkAndApplyTransform(tripsView, transformValue: transform, scrolledUp: userDidScrollUp)
            }
            
            mainScrollViewOffset = scrollView.contentOffset

        }else{

            //only perform size animation on horizontal scroll if outermost is at the top

            let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
            let offset = scrollView.contentOffset

            if offset.x - previousOffset.x > 0{

                //as we want on scale of 0.0 to 1.0 so i divide it by the width
                let valueMoved = offset.x - previousOffset.x
                let progressValueMoved = valueMoved/scrollView.bounds.width

                let increaseTransform = 1.0 + progressValueMoved/4.0
                let decreaseTransform = 1.0 - progressValueMoved/4.0

                animateForPage(moved: progressValueMoved, page: page, isForward: true, increaseSize: increaseTransform, decreaseSize : decreaseTransform)

            }else{

                let valueMoved = previousOffset.x - offset.x
                let tabValueMoved = valueMoved/scrollView.bounds.width

                let increaseTransform = 1.0 + tabValueMoved/4.0
                let decreaseTransform = 1.0 - tabValueMoved/4.0

                animateForPage(moved: tabValueMoved, page: page, isForward: false, increaseSize: increaseTransform, decreaseSize : decreaseTransform)
            }

            previousOffset = scrollView.contentOffset
        }
    }

    private func checkAndApplyTransform(_ view : UIView, transformValue : CGFloat, scrolledUp : Bool){

        let initialTransform = view.transform
        let transformedBounds = view.bounds.applying(initialTransform.scaledBy(x: transformValue, y: transformValue))

        if transformedBounds.size.width >= identitySize.width && !scrolledUp{
            view.transform = CGAffineTransform.identity
        }else if transformedBounds.size.width < smallerSize.width && scrolledUp{
            view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }else{
            view.transform = view.transform.scaledBy(x: transformValue, y: transformValue)
        }
    }

    private func updateUpLabels(with alpha : CGFloat){

        headerView.alpha = max(headerView.alpha - alpha, 0.0)

        aerinLabel.alpha = max(aerinLabel.alpha - alpha, 0.0)
        flightsLabel.alpha = max(flightsLabel.alpha - alpha, 0.0)
        hotelsLabel.alpha = max(hotelsLabel.alpha - alpha, 0.0)
        tripsLabel.alpha = max(tripsLabel.alpha - alpha, 0.0)
    }

    private func updateDownLabels(with alpha : CGFloat){

        headerView.alpha = min(headerView.alpha + alpha, 1.0)

        aerinLabel.alpha = min(aerinLabel.alpha + alpha, 1.0)
        flightsLabel.alpha = min(flightsLabel.alpha + alpha, 1.0)
        hotelsLabel.alpha = min(hotelsLabel.alpha + alpha, 1.0)
        tripsLabel.alpha = min(tripsLabel.alpha + alpha, 1.0)
    }

    private func animateForPage(moved : CGFloat, page : Int, isForward : Bool, increaseSize : CGFloat, decreaseSize : CGFloat){

        guard let currentOption = SelectedOption(rawValue: page) else {return}
        selectedOption = currentOption

        if isForward{
            switch currentOption{
                case .aerin:
                    aerinView.alpha = max(aerinView.alpha - moved, 0.5)
                    flightsView.alpha = min(flightsView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(aerinView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(flightsView, transformValue: increaseSize, scrolledUp: isForward)
                    }

                case .flight:
                    flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                    hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(flightsView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(hotelsView, transformValue: increaseSize, scrolledUp: isForward)
                    }
                case .hotels:
                    hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                    tripsView.alpha = min(tripsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(hotelsView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(tripsView, transformValue: increaseSize, scrolledUp: isForward)
                    }
                case .trips: break
            }
        }else{

            switch currentOption{
                case .aerin:
                    flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                    aerinView.alpha = min(aerinView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(flightsView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(aerinView, transformValue: increaseSize, scrolledUp: isForward)
                    }

                case .flight:
                    hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                    flightsView.alpha = min(flightsView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(hotelsView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(flightsView, transformValue: increaseSize, scrolledUp: isForward)
                    }
                case .hotels:

                    tripsView.alpha = max(tripsView.alpha - moved, 0.5)
                    hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y + mainScrollView.height < mainScrollView.contentSize.height{
                        checkAndApplyTransform(tripsView, transformValue: decreaseSize, scrolledUp: isForward)
                        checkAndApplyTransform(hotelsView, transformValue: increaseSize, scrolledUp: isForward)
                    }
                case .trips: break
            }
        }
    }
}
