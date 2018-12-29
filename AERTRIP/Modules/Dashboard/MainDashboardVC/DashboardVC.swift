//
//  DashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

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

    /// To keep track of previous offset for the inner scroll view
    private var previousOffset = CGPoint.zero

    /// To keep track of outermost scrollview offset
    private var mainScrollViewOffset = CGPoint.zero

    /// do first time calculation
    private var firstTime = true

    /// To keep track of original size at the load of the screen
    private var identitySize = CGSize.zero

    /// To keep track of small size after applying transform at the time of screen loading
    private var smallerSize = CGSize.zero

    ///Keep track of currently loaded screen
    enum SelectedOption : Int {
        case aerin = 0
        case flight = 1
        case hotels = 2
        case trips = 3
    }

    private var selectedOption : SelectedOption = .aerin

    //The selected view will be identity and other views will be the smaller scale. This is done to ensure nothing pixelates if we stretch it. Affine Transforms were used over anything else to allow the font to animate the increase in size
    private let smallAffineTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        //logic i have applied is that the outermost scrollviews content size will just be larger by the header amount and status bar amount so that when scrolling up only that part disappears
        innerScrollViewHeightConstraint.constant = UIScreen.main.bounds.size.height - segmentContainerView.bounds.height - view.safeAreaInsets.bottom
        self.profileButton.cornerRadius = self.profileButton.height/2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if firstTime{
            firstTime = false
            //as by here autolayout has been applied and these will be the values of the frames after applying their respective transforms. This is used to ensure later on that sizes dont go greater or smaller than these
            identitySize = aerinView.bounds.applying(CGAffineTransform.identity).size
            smallerSize = flightsView.bounds.applying(CGAffineTransform(scaleX: 0.75, y: 0.75)).size
        }
    }
    
    //MARK:- IBAction
    @IBAction func aerinAction(_ sender: UIButton) {

        //no need to do anything else as other things are handled by the scrollviewdidscroll method
        if selectedOption == .aerin {return}
        scrollToCurrentOption()
    }

    @IBAction func flightsAction(_ sender: UIButton) {

        if selectedOption == .flight {return}
        scrollToCurrentOption()
    }

    @IBAction func hotelsAction(_ sender: UIButton) {

        if selectedOption == .hotels {return}
        scrollToCurrentOption()
    }

    
    @IBAction func tripsAction(_ sender: UIButton) {

        if selectedOption == .trips {return}
        scrollToCurrentOption()
    }
    
    @IBAction func profileButtonAction(_ sender: ATNotificationButton) {
        AppFlowManager.default.sideMenuController?.toggleMenu()
    }

    //MARK:- Private
    private func scrollToCurrentOption(){
        innerScrollView.setContentOffset(CGPoint(x: innerScrollView.bounds.size.width * CGFloat(SelectedOption.trips.rawValue), y: innerScrollView.contentOffset.y), animated: true)
    }

    private func initialSetup(){

        //done so that the the header doesn't overlap the status bar initially
        headerTopConstraint.constant = UIApplication.shared.statusBarFrame.height

        //as aerin is the first selected view, we set it to identity
        aerinView.transform = .identity
        aerinView.alpha = 1.0
        flightsView.transform = smallAffineTransform
        flightsView.alpha = 0.5
        hotelsView.transform = smallAffineTransform
        hotelsView.alpha = 0.5
        tripsView.transform = smallAffineTransform
        tripsView.alpha = 0.5
        
        let userData = UserModel(json: AppUserDefaults.value(forKey: .userData))
        
        if let url = URL(string: userData.picture) {
            self.profileButton.kf.setImage(with: url, for: UIControl.State.normal)
        }
        
        if userData.picture.isEmpty && !userData.firstName.isEmpty {
            let string = "\(userData.firstName.firstCharacter)" + "\(userData.lastName.firstCharacter)"
            let image = AppGlobals.shared.getTextFromImage(string)
            self.profileButton.setImage(image, for: .normal)
            self.profileButton.layer.borderColor = AppColors.profileImageBorderColor.cgColor
            self.profileButton.layer.borderWidth = 2.0
        }
    }
    
    func setupInitialAnimation() {
        
        let originalCenter = self.view.center
        self.view.alpha = 0.0
        self.view.center = self.view.center
        self.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: [.curveEaseOut], animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.center = originalCenter
            self.view.alpha = 1.0
        }, completion: nil)
    }
}

extension DashboardVC : UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == mainScrollView{

            //done to fade out alpha labels, the header and make selected icon smaller. This receives calls backs from the child
            var transform : CGFloat = 0.0
            var userDidScrollUp = false

            if scrollView.contentOffset.y - mainScrollViewOffset.y > 0{
                let valueMoved = scrollView.contentOffset.y - mainScrollViewOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y - view.safeAreaInsets.bottom)
                updateUpLabels(with: headerValueMoved)
                transform = 1.0 - headerValueMoved/4.0
                userDidScrollUp = true
            }else{
                let valueMoved = mainScrollViewOffset.y - scrollView.contentOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y - view.safeAreaInsets.bottom)
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

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == mainScrollView{
            if mainScrollView.contentOffset.y + mainScrollView.height >= mainScrollView.contentSize.height{
                updateSelected(transform: CGAffineTransform(scaleX: 0.75, y: 0.75))
            }else if mainScrollView.contentOffset.y == 0.0{
                updateSelected(transform: .identity)
            }
        }

        resetNonSelectedViews()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if !decelerate{
            if scrollView == mainScrollView{
                if mainScrollView.contentOffset.y + mainScrollView.height >= mainScrollView.contentSize.height{
                    updateSelected(transform: CGAffineTransform(scaleX: 0.75, y: 0.75))
                }else if mainScrollView.contentOffset.y == 0.0{
                    updateSelected(transform: .identity)
                }
            }

            resetNonSelectedViews()
        }
    }

    func childDidEndDragging(){
        resetNonSelectedViews()
    }

    func childDidEndDecelerating(){
        resetNonSelectedViews()
    }

    private func updateSelected(transform : CGAffineTransform){

        UIView.animate(withDuration: 0.3) {
            switch self.selectedOption{
                case .aerin: self.aerinView.transform = transform
                case .flight: self.flightsView.transform = transform
                case .hotels: self.hotelsView.transform = transform
                case .trips: self.tripsView.transform = transform
            }
        }
    }

    private func resetNonSelectedViews(){

        UIView.animate(withDuration: 0.3) {
            switch self.selectedOption{
            case .aerin:
                self.flightsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.hotelsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.tripsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            case .flight:
                self.aerinView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.hotelsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.tripsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            case .hotels:
                self.flightsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.aerinView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.tripsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            case .trips:
                self.flightsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.hotelsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.aerinView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }
        }
    }


    private func checkAndApplyTransform(_ view : UIView, transformValue : CGFloat, scrolledUp : Bool){

        let initialTransform = view.transform
        let transformedBounds = view.bounds.applying(initialTransform.scaledBy(x: transformValue, y: transformValue))

        if transformedBounds.size.width >= identitySize.width{
            print(view)
            view.transform = CGAffineTransform.identity
        }else if transformedBounds.size.width < smallerSize.width{
            print(view)
            view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }else{
            print(view)
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
