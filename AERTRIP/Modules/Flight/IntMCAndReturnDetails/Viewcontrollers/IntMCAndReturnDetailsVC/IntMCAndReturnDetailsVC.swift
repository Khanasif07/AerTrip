//
//  InternationalReturnAndMulticityVC.swift
//  Aertrip
//
//  Created by Apple  on 16.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol UpdateSelectedJourneyDelegate: NSObjectProtocol{
    func selectedJourney(journeyId:String)
}

class IntMCAndReturnDetailsVC: UIViewController {
    
    @IBOutlet weak var headerCollection: UICollectionView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var visualEffectsView: UIVisualEffectView!
    @IBOutlet weak var backNavigationView: UIView!
   
    //Constraint Outlets
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerCollectionViewTop: NSLayoutConstraint!
    
    
    
    //MARK:-  Properties or variables.
    var viewModel = IntMCAndReturnDetailsVM()
    let journeyCompactViewHeight : CGFloat = 44.0// Height of selected cell on header.
    var lastTargetContentOffsetX: CGFloat = 0
    var scrollviewInitialYOffset = CGFloat(0.0)
    var statusBarHeight : CGFloat {
        UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height//Height of status bar.
    }
    var navigationBlurView:CGFloat{
        statusBarHeight + 44.0
    }
    var fareBreakupVC:IntFareBreakupVC?
    var viewForFare = UIView()
    var resultTitle : UILabel!
    var resultsubTitle: UILabel!
    var infoButton : UIButton!
    let separatorView = ATDividerView()
    weak var selectionDelegate:UpdateSelectedJourneyDelegate?
    weak var pinnedDelegate:flightDetailsPinFlightDelegate?
    weak var refundDelegate:UpdateRefundStatusDelegate?
    
    var onJourneySelect: ((String) -> ())?
    
    let backButton = UIButton(type: .custom)
    var isConditionReverced = false
    var appliedFilterLegIndex = -1

    //MARK:-  Life cycle and override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleAndButton()
        self.setupCollectionCellAndDelegate()
        self.setupScrollView()
        self.showHintAnimation()
        self.viewModel.delegate = self
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            self.baseScrollView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.isHidden = false
        self.setupNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height// + statusBarHeight
        baseScrollView.contentSize = CGSize( width: (CGFloat(self.viewModel.numberOfLegs) * width ), height:height)

        for view in self.baseScrollView.subviews{
            if view is IntJourneyHeaderView {
                continue
            }
            var frame = view.frame
            frame.size.height = height
            view.frame = frame
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for view in self.baseScrollView.subviews{
            if let table = view as? UITableView{
                let index = table.tag - 1000
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.updateUIForTableviewAt(index)
                }
            }
        }
    }
    
    
    
    //MARK:-  Private functions
    private func setupCollectionCellAndDelegate(){
        self.headerCollection.register(UINib(nibName: "IntHeaderCollectionCell", bundle: nil), forCellWithReuseIdentifier: "IntHeaderCollectionCell")
        self.headerCollection.bounces = false
        self.headerCollection.isScrollEnabled = false
        self.headerCollection.delegate = self
        self.headerCollection.dataSource = self
    }
    
    private func setupTitleAndButton(){
        resultTitle = UILabel(frame: CGRect(x:  50, y:1.0 , width: (UIScreen.width - 100), height: 42))
//        resultTitle.font = UIFont(name: "SourceSansPro-semibold", size: 18)!
        resultTitle.font = AppFonts.SemiBold.withSize(18)
        resultTitle.text = self.viewModel.largeTitle
        resultTitle.textAlignment = .center
        resultTitle.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        
    }
    
    private func setupNavigation(){
        self.backNavigationView.viewWithTag(200)?.removeFromSuperview()
        var backView = UIView()
        let visualEffectView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width: UIScreen.width , height: 44))
        visualEffectView.effect = UIBlurEffect(style: .prominent)
        
        backView = UIView(frame: CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: 44))
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        backView.addSubview(visualEffectView)
        backView.tag = 200
        let buttonImage = AppImages.green
        backButton.setImage(buttonImage, for: .normal)
        backButton.setImage(buttonImage, for: .selected)
        
        backButton.frame = CGRect(x: 8, y: 8.5, width: 27, height: 27)
        separatorView.frame = CGRect(x: 0, y: 43.5, width: UIScreen.width, height: 0.5)
        separatorView.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
        
        backButton.addTarget(self, action: #selector(popToPreviousScreen), for: .touchUpInside)
        visualEffectView.contentView.addSubview(resultTitle)
        separatorView.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
        visualEffectView.contentView.addSubview(separatorView)
        visualEffectView.contentView.addSubview(backButton)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        self.backNavigationView.addSubview(backView)
        self.backNavigationView.bringSubviewToFront(backView)
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        // Added Blur view Behind Status bar to avoid content getting merged with status bars
        self.view.viewWithTag(180)?.removeFromSuperview()
        let statusBarBlurView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width: UIScreen.width , height: statusBarHeight))
        statusBarBlurView.effect = UIBlurEffect(style: .prominent)
        statusBarBlurView.tag = 180
        self.view.addSubview(statusBarBlurView)
        
    }
    
    @objc func popToPreviousScreen(_ sender: UIButton){
        printDebug("back")
        sender.isEnabled = false
        sender.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.navigationController?.popViewController(animated: true)
        delay(seconds: 0.5) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}

//MARK:-  Setup scroll view content size and adding tables
extension IntMCAndReturnDetailsVC{
    
    func setupScrollView() {
        let width =  UIScreen.width / 2.0
        let height = UIScreen.height
        baseScrollView.contentSize = CGSize( width: (CGFloat(self.viewModel.numberOfLegs) * width ), height:height + 44.0)
        baseScrollView.showsHorizontalScrollIndicator = false
        baseScrollView.showsVerticalScrollIndicator = false
        baseScrollView.delegate = self
        baseScrollView.bounces = false
        baseScrollView.isDirectionalLockEnabled = true
        for i in 0 ..< self.viewModel.numberOfLegs {
            setupTableView(At: i)
        }
    }
    
    func setupTableView(At index : Int) {
        
        let width = UIScreen.width / 2.0
        let height = UIScreen.height
        let rect = CGRect(x: (width * CGFloat(index)), y: 0, width: width, height: height)
        
        let tableView = UITableView(frame: rect)
        tableView.register(UINib(nibName: "InternationalReturnDetailsCell", bundle: nil), forCellReuseIdentifier: "InternationalReturnDetailsCell")
        tableView.dataSource = self
        tableView.tag = 1000 + index
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        let headerRect = CGRect(x: 0, y: 0, width: width, height: 94.0)
        let tableViewHeader = UIView(frame: headerRect)
        let separatorView = UIView(frame:CGRect(x: 0, y: 93.5, width: width, height: 0.5))
        separatorView.backgroundColor = .TWO_ZERO_FOUR_COLOR
        tableViewHeader.addSubview(separatorView)
        tableView.tableHeaderView = tableViewHeader
        
        let boarderRect = CGRect(x: ((width * CGFloat(index + 1)) - 1), y: 0, width: 0.5, height: height)
        let borderView = ATVerticalDividerView()
        borderView.frame = boarderRect //UIView(frame: boarderRect)
        borderView.backgroundColor = .TWO_ZERO_FOUR_COLOR
        
        baseScrollView.addSubview(tableView)
        baseScrollView.addSubview(borderView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateUIForTableviewAt(index)
        }
        DispatchQueue.main.async {
            self.updateUIForTableviewAt(index)
        }
        setupCompactJourneyView(width, index)

    }
    
    fileprivate func setupCompactJourneyView(_ width: CGFloat, _ index: Int) {
        
        let headerJourneyRect  = CGRect(x: (width * CGFloat(index)), y: (journeyCompactViewHeight) , width: width - 1 , height: journeyCompactViewHeight)
        let headerJourneyView = IntJourneyHeaderView(frame: headerJourneyRect)
        headerJourneyView.tag = 1000 + index
        self.viewModel.journeyHeaderViewArray.append(headerJourneyView)
        
        baseScrollView.addSubview(headerJourneyView)
        headerJourneyView.isHidden = true
        hideHeaderCellAt(index: index)
    }
}
extension IntMCAndReturnDetailsVC : flightDetailsPinFlightDelegate{
    
    func updateRefundStatusIfPending(fk: String) {
        
        if let _ = self.viewModel.internationalDataArray?.firstIndex(where: {$0.fk == fk}){
            self.pinnedDelegate?.updateRefundStatusIfPending(fk: fk)            
        }
        
    }
    
    func reloadRowFromFlightDetails(fk: String, isPinned: Bool, isPinnedButtonClicked: Bool) {
        guard self.viewModel.internationalDataArray != nil else {return}
        if let index = self.viewModel.internationalDataArray!.firstIndex(where: {$0.fk == fk}){
            
            var journey = self.viewModel.internationalDataArray![index]
            journey.isPinned = !journey.isPinned
            self.viewModel.internationalDataArray![index] = journey
            self.pinnedDelegate?.reloadRowFromFlightDetails(fk: fk, isPinned: isPinned, isPinnedButtonClicked: false)
            
            
        }
    }

}
