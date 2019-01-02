//
//  ViewController.swift
//  AERTRIPDEMO
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Appinvenitv Technologies. All rights reserved.
//

import UIKit

protocol CollectionViewContainerTVCellDelegate: class {
    func didChangeSegmentTo(_ segment: MainDashboardVC.Segment, isDirectionForward: Bool)
    func currentPageScrollPercentage(_ percentage: Double, isDirectionForward: Bool)
}

class CollectionViewContainerTVCell: UITableViewCell, UIScrollViewDelegate{
    
    weak var delegate: CollectionViewContainerTVCellDelegate?
    
    private var currentSegment: MainDashboardVC.Segment = .aerin
    private var lastContentOffset: CGFloat = 0
    private var isMovingForward: Bool = false
    
    @IBOutlet weak var vcContainerScroll: UIScrollView!
    @IBOutlet weak var firstVcView: UIView!
    @IBOutlet weak var secondVcView: UIView!
    @IBOutlet weak var thirdVcView: UIView!
    @IBOutlet weak var fourthVcView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vcContainerScroll.delegate = self
        
        self.setupView()
    }
    
    private func setupView() {
        
        let firstView = AerinVC.instantiate(fromAppStoryboard: .Dashboard)
        self.firstVcView.addSubview(firstView.view)
        
        let secondView = FlightsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.secondVcView.addSubview(secondView.view)
        
        let thirdView = HotelsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.thirdVcView.addSubview(thirdView.view)
        
        let fourthView = TripsVC.instantiate(fromAppStoryboard: .Dashboard)
        self.fourthVcView.addSubview(fourthView.view)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if let segment = MainDashboardVC.Segment(rawValue: page) {
            if currentSegment != segment {
                self.currentSegment = segment
                self.delegate?.didChangeSegmentTo(segment, isDirectionForward: self.isMovingForward)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.isMovingForward = self.lastContentOffset < scrollView.contentOffset.x
        let percentage = (scrollView.contentOffset.x / scrollView.frame.size.width).truncatingRemainder(dividingBy: 1)
        let directionalPercentage = self.isMovingForward ? percentage : (1-percentage)
        self.delegate?.currentPageScrollPercentage(Double(directionalPercentage), isDirectionForward: self.isMovingForward)
    }
    
    
}

class MainDashboardVC: BaseVC {
    
    enum Segment: Int, CaseIterable {
        case aerin = 0
        case flight = 1
        case hotel = 2
        case trip = 3
        
        var title: String {
            switch self {
            case .aerin:
                return LocalizedString.aerin.localized
                
            case .flight:
                return LocalizedString.flights.localized
                
            case .hotel:
                return LocalizedString.hotels.localized
                
            case .trip:
                return LocalizedString.trips.localized
            }
        }
        
        var next: Segment? {
            return Segment(rawValue: self.rawValue+1)//min(self.rawValue+1, Segment.allCases.count-1))
        }
        
        var previous: Segment? {
            return Segment(rawValue: self.rawValue-1)//Segment(rawValue: max(self.rawValue-1, 0))
        }
    }
    
    private var currentSegment: MainDashboardVC.Segment = .aerin
    private let transformScalePercent: CGFloat = 0.25
    private let fadeAlphaPercentage: CGFloat = 0.6
    private let expandCurve:CAMediaTimingFunction   = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    private var isFirstTime = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sectionHeader: UIView!
    
    @IBOutlet weak var aerinTitleLabel: UILabel!
    @IBOutlet weak var flightsTitleLabel: UILabel!
    @IBOutlet weak var hotelsTitleLabel: UILabel!
    @IBOutlet weak var tripsTitleLabel: UILabel!
    
    @IBOutlet weak var aerinContainerView: UIView!
    @IBOutlet weak var flightsContainerView: UIView!
    @IBOutlet weak var hotelsContainerView: UIView!
    @IBOutlet weak var tripsContainerView: UIView!
    @IBOutlet weak var aerinImage: UIImageView!
    @IBOutlet weak var flightImage: UIImageView!
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var profileButton: ATNotificationButton!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    
    
    private var currentView: UIView {
        switch currentSegment {
        case .aerin: return aerinContainerView
        case .flight: return flightsContainerView
        case .hotel: return hotelsContainerView
        case .trip: return tripsContainerView
        }
    }
    
    
    private var nextView: UIView? {
        guard let nextSegemnt = self.currentSegment.next else {return nil}
        switch nextSegemnt {
        case .aerin: return aerinContainerView
        case .flight: return flightsContainerView
        case .hotel: return hotelsContainerView
        case .trip: return tripsContainerView
        }
    }
    
    private var previousView: UIView? {
        guard let prevSegment = self.currentSegment.previous else {return nil}
        switch prevSegment {
        case .aerin: return aerinContainerView
        case .flight: return flightsContainerView
        case .hotel: return hotelsContainerView
        case .trip: return tripsContainerView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initialSetups()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isFirstTime {
            
            
//            let expandAnim = CABasicAnimation(keyPath: "transform.scale")
//            let expandScale = 0.0
//            expandAnim.fromValue            = 1.0
//            expandAnim.toValue              = max(expandScale,1.0)
//            expandAnim.timingFunction       = self.expandCurve
//            expandAnim.duration             = 0.4
//            expandAnim.fillMode             = .forwards
//            expandAnim.isRemovedOnCompletion  = false
//
//            CATransaction.setCompletionBlock {
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.setOriginalState(completion: nil)
//                    self.view.layer.removeAllAnimations() // make sure we remove all animation
//                }
//            }
            
//            self.view.layer.add(expandAnim, forKey: expandAnim.keyPath)
//
//            CATransaction.commit()
            
            self.view.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.headerView.transform = CGAffineTransform(translationX: 0, y: -self.headerView.height)
            self.sectionHeader.transform = CGAffineTransform(translationX: 0, y: -(self.headerView.height + self.sectionHeader.height))
            
            UIView.animate(withDuration: 0.6, animations: {

                self.view.transform = .identity
            })
            
            UIView.animate(withDuration:  0.9,  animations: {
                
                self.headerView.transform = .identity
                self.sectionHeader.transform = .identity
                
            }, completion: { success in
                self.isFirstTime = false
            })
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.profileButton.cornerRadius = self.profileButton.height/2
    }
    
    override func setupFonts() {
        self.aerinTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.flightsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.hotelsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.tripsTitleLabel.font = AppFonts.SemiBold.withSize(14.0)
    }
    
    override func setupTexts() {
        self.aerinTitleLabel.text = Segment.aerin.title
        self.flightsTitleLabel.text = Segment.flight.title
        self.hotelsTitleLabel.text = Segment.hotel.title
        self.tripsTitleLabel.text = Segment.trip.title
    }
    
    override func setupColors() {
        self.aerinTitleLabel.textColor = AppColors.themeWhite
        self.flightsTitleLabel.textColor = AppColors.themeWhite
        self.hotelsTitleLabel.textColor = AppColors.themeWhite
        self.tripsTitleLabel.textColor = AppColors.themeWhite
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.sideMenuController?.toggleMenu()
    }
    
    @IBAction func aerinButtonAction(_ sender: UIButton) {
        
        self.currentSegment = .aerin
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CollectionViewContainerTVCell else {return}
        cell.vcContainerScroll.contentOffset = CGPoint(x: 0, y: 0)
        
        self.aerinContainerView.alpha = 1
        self.aerinContainerView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        
        if let prevView = self.previousView {
            
            prevView.transform = .identity
            prevView.alpha = self.fadeAlphaPercentage
        }
    }
    
    @IBAction func flightsButtonAction(_ sender: Any) {
        
        self.currentSegment = .flight
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CollectionViewContainerTVCell else {return}
        cell.vcContainerScroll.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        self.flightsContainerView.alpha = 1
        self.flightsContainerView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        
        if let prevView = self.previousView {
            
            prevView.transform = .identity
            prevView.alpha = self.fadeAlphaPercentage
        }
    }
    
    @IBAction func hotelsButtonAction(_ sender: UIButton) {
        
        self.currentSegment = .hotel
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CollectionViewContainerTVCell else {return}
        cell.vcContainerScroll.contentOffset = CGPoint(x: 2 * UIScreen.main.bounds.width, y: 0)
        
        self.hotelsContainerView.alpha = 1
        self.hotelsContainerView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        
        if let prevView = self.previousView {
            
            prevView.transform = .identity
            prevView.alpha = self.fadeAlphaPercentage
        }
    }
    
    @IBAction func tripsButtonAction(_ sender: UIButton) {
        
        self.currentSegment = .trip
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CollectionViewContainerTVCell else {return}
        cell.vcContainerScroll.contentOffset = CGPoint(x: 3 * UIScreen.main.bounds.width, y: 0)
        
        self.tripsContainerView.alpha = 1
        self.tripsContainerView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        
        if let prevView = self.previousView {
            
            prevView.transform = .identity
            prevView.alpha = self.fadeAlphaPercentage
        }
    }
}

extension MainDashboardVC {
    
    func initialSetups() {
        
        self.tableViewTopConstraint.constant = UIApplication.shared.statusBarFrame.height
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44)
        //        self.sectionHeader.backgroundColor = AppColors.themeGreen
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = self.headerView
        self.aerinContainerView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        self.flightsContainerView.alpha = self.fadeAlphaPercentage
        self.hotelsContainerView.alpha = self.fadeAlphaPercentage
        self.tripsContainerView.alpha = self.fadeAlphaPercentage
        
        if let profileImage = UserInfo.loggedInUser?.profileImage, let url = URL(string: profileImage) {
            self.profileButton.kf.setImage(with: url, for: UIControl.State.normal)
        }
    }
    
    private func setOriginalState(completion:(()->Void)?) {
        // enable again the user interaction
        self.view.layer.cornerRadius = self.view.cornerRadius
    }
}

extension MainDashboardVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewContainerTVCell", for: indexPath) as! CollectionViewContainerTVCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700//tableView.frame.height - 100
    }
}

extension MainDashboardVC: CollectionViewContainerTVCellDelegate {
    
    func didChangeSegmentTo(_ segment: MainDashboardVC.Segment, isDirectionForward: Bool) {
        //        print("DidChange Segment index = \(segment.rawValue)")
        self.currentSegment = segment
        self.currentView.transform = CGAffineTransform(scaleX: 1 + transformScalePercent, y: 1 + transformScalePercent)
        [self.aerinContainerView, self.flightsContainerView, self.hotelsContainerView, self.tripsContainerView].forEach{
            if $0 != self.currentView {
                if let transform = $0?.transform, transform != .identity {
                    $0?.transform = .identity
                    $0?.alpha = self.fadeAlphaPercentage
                }
            }
        }
    }
    
    func currentPageScrollPercentage(_ percentage: Double, isDirectionForward: Bool) {
        
        if isDirectionForward {
            print("Direction Forward")
            if let nextView = self.nextView {
                if percentage == 0.0 {return}
                let scale = CGFloat(1 + (0.25 * percentage))
                nextView.alpha = 0.6 + CGFloat(percentage)
                nextView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        } else {
            print("Direction Backward")
            if let prevView = self.previousView {
                let scale = CGFloat(1 + (0.25 * percentage))
                prevView.alpha = 0.6 + CGFloat(percentage)
                prevView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        let scale = CGFloat(1 + (0.25 * (1 - percentage)))
        currentView.transform = CGAffineTransform(scaleX: scale, y: scale)
        currentView.alpha = 0.6 + CGFloat(1 - percentage)
        
    }
    
    
    
}

