//
//  SeatMapContainerVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import Parchment

class SeatMapContainerVC: UIViewController {

    // MARK: Properties
    
    internal var viewModel = SeatMapContainerVM()
    internal var allChildVCs = [SeatMapVC]()
    
    // Parchment View
    fileprivate var parchmentView : PagingViewController?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var topNavBarView: TopNavigationView!
    @IBOutlet weak var seatMapContainerView: UIView!
    
    @IBOutlet weak var planeLayoutView: UIView!
    @IBOutlet weak var planeLayoutScrollView: UIScrollView!
    @IBOutlet weak var planeLayoutScrollContentView: UIView!
    @IBOutlet weak var bodyImgView: UIImageView!
    @IBOutlet weak var noseImgView: UIImageView!
    @IBOutlet weak var topWingImgView: UIImageView!
    @IBOutlet weak var bottomWingImgView: UIImageView!
    @IBOutlet weak var tailImgView: UIImageView!
    @IBOutlet weak var planeLayoutCollView: UICollectionView!
    @IBOutlet weak var planeLayoutCollViewWidth: NSLayoutConstraint!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.parchmentView?.view.frame = self.seatMapContainerView.bounds
        self.parchmentView?.loadViewIfNeeded()
    }
    
    // MARK: IBActions
    
    // MARK: Functions
    
    private func initialSetup() {
        setupNavBar()
        viewModel.delegate = self
        viewModel.fetchSeatMapData()
        setupPlaneLayoutCollView()
    }
    
    func setViewModel(_ vm: SeatMapContainerVM) {
        self.viewModel = vm
    }
    
    private func setupPlaneLayoutCollView() {
        planeLayoutScrollContentView.backgroundColor = AppColors.themeGray04
        
        planeLayoutCollView.showsHorizontalScrollIndicator = false
        planeLayoutCollView.register(UINib(nibName: "LayoutSeatCollCell", bundle: nil), forCellWithReuseIdentifier: "LayoutSeatCollCell")
        planeLayoutCollView.backgroundColor = AppColors.themeGray10
        planeLayoutCollView.delegate = self
        planeLayoutCollView.dataSource = self
    }
    
    private func setupNavBar() {
        topNavBarView.configureNavBar(title: LocalizedString.seatMap.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        
        topNavBarView.configureLeftButton(normalTitle: LocalizedString.ClearAll.localized, normalColor: AppColors.themeGreen)
        
        topNavBarView.configureFirstRightButton(normalTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, font: AppFonts.Bold.withSize(18))
        
        topNavBarView.delegate = self
    }
    
    private func setUpViewPager() {
        self.allChildVCs.removeAll()

        for index in 0..<viewModel.allTabsStr.count {
            let vc = SeatMapVC.instantiate(fromAppStoryboard: .Rishabh_Dev)
            vc.setFlightData(viewModel.allFlightsData[index])
            self.allChildVCs.append(vc)
        }
        self.view.layoutIfNeeded()
        if let _ = self.parchmentView{
            self.parchmentView?.view.removeFromSuperview()
            self.parchmentView = nil
        }
        setupParchmentPageController()
    }
    
    private func setupParchmentPageController(){
        
        self.parchmentView = PagingViewController()
        self.parchmentView?.menuItemSpacing = (self.view.width - 251.5) / 2
        self.parchmentView?.menuInsets = UIEdgeInsets(top: 0.0, left: 33.0, bottom: 0.0, right: 38.0)
        self.parchmentView?.menuItemSize = .sizeToFit(minWidth: 150, height: 56)
        self.parchmentView?.indicatorOptions = PagingIndicatorOptions.visible(height: 2, zIndex: Int.max, spacing: UIEdgeInsets.zero, insets: UIEdgeInsets.zero)
        self.parchmentView?.borderOptions = PagingBorderOptions.visible(
            height: 0.5,
            zIndex: Int.max - 1,
            insets: UIEdgeInsets.zero)
        let nib = UINib(nibName: "MenuItemCollectionCell", bundle: nil)
        self.parchmentView?.register(nib, for: MenuItem.self)
        self.parchmentView?.borderColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.parchmentView?.font = AppFonts.Regular.withSize(16.0)
        self.parchmentView?.selectedFont = AppFonts.SemiBold.withSize(16.0)
        self.parchmentView?.indicatorColor = AppColors.themeGreen
        self.parchmentView?.selectedTextColor = AppColors.themeBlack
        self.seatMapContainerView.addSubview(self.parchmentView!.view)
        
        self.parchmentView?.dataSource = self
        self.parchmentView?.delegate = self
        self.parchmentView?.sizeDelegate = self
        self.parchmentView?.select(index: 0)
        
        self.parchmentView?.reloadData()
        self.parchmentView?.reloadMenu()
        self.parchmentView?.menuBackgroundColor = UIColor.clear
        self.parchmentView?.collectionView.backgroundColor = UIColor.clear
    }
    
    private func createAttHeaderTitle(_ origin: String,_ destination: String) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: origin + " " )
        let desinationAtrributedString = NSAttributedString(string: " " + destination)
        let imageString = getStringFromImage(name : "oneway")
        fullString.append(imageString)
        fullString.append(desinationAtrributedString)
        return fullString
    }
    
    private func getStringFromImage(name : String) -> NSAttributedString {
        
        let imageAttachment = NSTextAttachment()
        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
        let iconImage = UIImage(named: name )!
        imageAttachment.image = iconImage
        
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    private func setCurrentPlaneLayout(_ index: Int) {
        planeLayoutCollView.reloadData()
        planeLayoutCollViewWidth.constant = planeLayoutCollView.contentSize.width + 5
        UIView.animate(withDuration: 0.33, animations: {
            self.planeLayoutScrollView.layoutIfNeeded()
        }) { (_) in
            self.planeLayoutCollView.reloadData()
            self.planeLayoutScrollView.layoutIfNeeded()
        }
    }
}

extension SeatMapContainerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        allChildVCs.enumerated().forEach { (index, seatMapVC) in
            seatMapVC.setFlightData(viewModel.allFlightsData[index])
            if seatMapVC.viewModel.flightData.md.rows.count > 0 {
                seatMapVC.seatMapCollView.reloadData()
            }
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SeatMapContainerVC: PagingViewControllerDataSource , PagingViewControllerDelegate ,PagingViewControllerSizeDelegate{
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        
        if let pagingIndexItem = pagingItem as? MenuItem{
            let text = pagingIndexItem.attributedTitle
            return (text?.size().width ?? 0) + 20
        }
        
        return 100.0
    }
    
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        viewModel.allTabsStr.count
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        allChildVCs[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return MenuItem(title: "", index: index, isSelected:true, attributedTitle: viewModel.allTabsStr[index])
    }
    
    func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool)  {
        
        if let pagingIndexItem = pagingItem as? MenuItem {
            viewModel.currentIndex = pagingIndexItem.index
            setCurrentPlaneLayout(viewModel.currentIndex)
        }
    }
}

extension SeatMapContainerVC: SeatMapContainerDelegate {
    
    func willFetchSeatMapData() {
        
        delay(seconds: 0.2) {
            AppGlobals.shared.startLoading()
            
        }
    }
    
    func failedToFetchSeatMapData() {
        AppGlobals.shared.stopLoading()
    }
    
    func didFetchSeatMapData() {
        AppGlobals.shared.stopLoading()
        var totalFlightsData = [SeatMapModel.SeatMapFlight]()
        viewModel.seatMapModel.data.leg.forEach {
            let flightsArr = $0.value.flights.map { $0.value }
            totalFlightsData.append(contentsOf: flightsArr)
            
            let flightsStr = $0.value.flights.map {
                createAttHeaderTitle($0.value.fr, $0.value.to)
            }
            viewModel.allTabsStr.append(contentsOf: flightsStr)
        }
        viewModel.allFlightsData = totalFlightsData
        setUpViewPager()
        planeLayoutCollView.reloadData()
        DispatchQueue.delay(0.5) {
            self.setCurrentPlaneLayout(0)
        }
    }
}
