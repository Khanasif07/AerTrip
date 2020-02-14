//
//  HotelsMapVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import UIKit
import Kingfisher

class MapContainerView: UIView {
    weak var mapView: GMSMapView? {
        didSet {
            if let vw = mapView {
                self.addSubview(vw)
                vw.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //  self.mapView?.frame = self.bounds
        
        self.backgroundColor = AppColors.clear
        self.mapView?.backgroundColor = AppColors.themeGreen
        
    }
    
    deinit {
        printDebug("MapContainerView deinit")
    }
}

class HotelsMapVC: BaseVC {
    
    // MARK: - IBOutlets
    // MARK: -
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var navContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var unPinAllFavouriteButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var switchView: ATSwitcher!
    
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var hotelsMapCV: UICollectionView! {
        didSet {
            self.hotelsMapCV.registerCell(nibName: HotelCardCollectionViewCell.reusableIdentifier)
            self.hotelsMapCV.registerCell(nibName: HotelGroupCardCollectionViewCell.reusableIdentifier)
//            self.hotelsMapCV.isPagingEnabled = true
//            self.hotelsMapCV.delegate = self
//            self.hotelsMapCV.dataSource = self
            self.hotelsMapCV.showsVerticalScrollIndicator = false
            self.hotelsMapCV.showsHorizontalScrollIndicator = false
        }
    }
    
    
    
    @IBOutlet weak var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonOnMapView: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var mapContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    // Searching View
    @IBOutlet weak var hotelSearchView: UIView! {
        didSet {
            self.hotelSearchView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
            self.hotelSearchView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var hotelSearchTableView: ATTableView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonBackView: UIView!
    @IBOutlet weak var mapContainerView: MapContainerView!
    @IBOutlet weak var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var cardGradientView: UIView!
    
    @IBOutlet weak var switchGradientView: UIView!
    // MARK: - Properties
    
    //    var container: NSPersistentContainer!
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    var aerinFilterUndoCompletion : (() -> Void)?
    weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    var displayingHotelLocation: CLLocationCoordinate2D? {
        didSet {
            if let oLoc = oldValue, displayingHotelLocation != nil {
                self.updateMarker(atLocation: oLoc, isSelected: false)
            }
            if let loc = displayingHotelLocation {
                self.updateMarker(atLocation: loc)
            }
        }
    }
    
    var visibleMapHeightInVerticalMode: CGFloat = 160.0
    var oldScrollPosition: CGPoint = CGPoint.zero
    var selectedIndexPath: IndexPath?
    var selectedIndexPathForHotelSearch: IndexPath?
    var isMapInFullView: Bool = false
    var floatingViewInitialConstraint : CGFloat = 0.0
    let hotelResultCellIdentifier = "HotelSearchTableViewCell"
    
    var oldOffset: CGPoint = .zero //used in colletion view scrolling for map re-focus
    var isCollectionScrollingInc: Bool = false
    var isHidingOnMapTap: Bool = false
    
    //Map Related
    var mapView: GMSMapView?
    let minZoomLabel: Float = 1.0
    let maxZoomLabel: Float = 30.0
    let defaultZoomLabel: Float = 12.0
    let extraZoomLabelForMapView: Float = 1.0
    let thresholdZoomLabel: Float = 14.0
    var prevZoomLabel: Float = 1.0
    var markersOnLocations: JSONDictionary = JSONDictionary()
    var maxVisblePriceMarker = 5
    // Request and View Type
    var visualEffectView : UIVisualEffectView!
    var backView : UIView!
    
    
    // Empty State view
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    // No Hotel Found empty View
    lazy var noHotelFoundEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noHotelFound
        return newEmptyView
    }()
    
    // Not hotel Found Empty View on Filter
    lazy var noHotelFoundOnFilterEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noHotelFoundOnFilter
        return newEmptyView
    }()
    
    // MARK: - Public
    
    // MARK: - Private
    
    var viewModel = HotelsResultVM()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var hideSection = 0
    var footeSection = 1
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
    var applyButtonTapped: Bool = false
    private var gradientLayer: CAGradientLayer?
    //used for making collection view centerlized
    var indexOfCellBeforeDragging = 0
    
    //Manage Transition Created by golu
    internal var transition: CardTransition?
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        self.filterButton.isEnabled = false
        self.mapView?.isMyLocationEnabled = false
        // self.animateCollectionView(isHidden: true, animated: false)
        
        self.view.backgroundColor = AppColors.themeWhite
        
        self.initialSetups()
        self.registerXib()
        
        // toast completion,When undo button tapped
        self.aerinFilterUndoCompletion = {
            printDebug("Undo Button tapped")
        }
        self.cardGradientView.isHidden = false
        
        //call API to get vcode, sid
        animateHeaderToMapView()
        animateFloatingButtonOnMapView(isAnimated: false)
        self.switchContainerView.isHidden = self.viewModel.favouriteHotels.isEmpty
        self.floatingButtonOnMapView.isHidden = !self.viewModel.isFavouriteOn
        self.switchView.setOn(isOn: self.viewModel.isFavouriteOn, animated: false, shouldNotify: false)
//        self.animateMapToFirstHotelInMapMode()
        self.filterButton.isSelected = self.viewModel.isFilterApplied
        searchBar.setTextField(color: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.12))
        self.setUpLongPressOnFilterButton()
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.frame = self.cardGradientView.bounds
        let gradientColor = AppColors.themeWhite
        self.gradientLayer?.colors =
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.5).cgColor, gradientColor.withAlphaComponent(1.0).cgColor]
        self.gradientLayer?.locations = [0.0, 0.5, 1.0]
        self.cardGradientView.layer.addSublayer(self.gradientLayer!)
        self.cardGradientView.backgroundColor = AppColors.clear
        self.additionalSafeAreaInsets = .zero
        self.configureCollectionViewLayoutItemSize()
//        delay(seconds: 1.0) {
            self.addMapView()
//        }
        if AppGlobals.shared.isNetworkRechable() {
            delay(seconds: 0.2) { [weak self] in
                guard let strongSelf = self else {return}
//                strongSelf.addMapView()
                strongSelf.mapView?.delegate = self
                strongSelf.loadFinalDataOnScreen()
            }
        } else {
            self.noHotelFound()
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarColor = AppColors.clear
        self.statusBarStyle = .default
        
        addCustomBackgroundBlurView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
        backView.removeFromSuperview()
        //        if  self.isMovingFromParent {
        //            backView.removeFromSuperview()
        //        }
    }
    
    
    override func bindViewModel() {
        self.viewModel.hotelMapDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer?.frame = self.cardGradientView.bounds

        //        self.configureCollectionViewLayoutItemSize()
    }
    
    deinit {
//        CoreDataManager.shared.deleteData("HotelSearched")
        printDebug("HotelResultVC deinit")
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .GRNSessionExpired {
            //re-hit the search API
            self.manageShimmer(isHidden: false)
            CoreDataManager.shared.deleteData("HotelSearched")
            self.viewModel.hotelListOnPreferencesApi()
        }
        else if let _ = note.object as? HotelDetailsVC {
            //fav updated from hotel details
            //updateFavOnList(forIndexPath: selectedIndexPath)
            // manage favourite switch buttons
            self.selectedIndexPath = nil
            self.viewModel.getFavouriteHotels(shouldReloadData: true)
            self.updateMarkers()
            self.sowHotelOnMap(duration: 0.4)
            //            updateFavouriteSuccess(isHotelFavourite: true)
        }
        else if let _ = note.object as? HCDataSelectionVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        }
        else if let _ = note.object as? HotelResultVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        } else if let _ = note.object as? HotelsGroupExpendedVC {
            
        }
    }
    
    func addCustomBackgroundBlurView(){
        
        visualEffectView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: visualEffectViewHeight))
        visualEffectView.effect = UIBlurEffect(style: .prominent)
        
        backView = UIView(frame: CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: 20))
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        backView.addSubview(visualEffectView)
        
        let backVisualEfectView = UIVisualEffectView(frame:  CGRect(x: 0 , y: 0, width:self.view.frame.size.width , height: backContainerView.height))
        backVisualEfectView.effect = UIBlurEffect(style: .prominent)
        backVisualEfectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        backContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        //backContainerView.addSubview(backVisualEfectView)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        //self.navigationController?.view.addSubview(backView)
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem=nil
        
    }
    
    func setupCollection() {
        let layout = self.hotelsMapCV.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -5)
        layout.scrollDirection = .horizontal
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 1.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 192)
    }
    // MARK: - Methods
    
    // MARK: - Private
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: keyboardSize.height))
            self.hotelSearchTableView.tableFooterView = footerView
        }
    }
    override func keyboardWillHide(notification: Notification) {
        if let _ = self.view.window {
            //checking if the screen in window only then this method should call
            self.hotelSearchTableView.tableFooterView = nil
        }
    }
    
    func initialSetups() {
        self.setUpFloatingView()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBarContainerView.frame
        //self.reloadHotelList()
        self.floatingButtonOnMapView.isHidden = true
        self.cancelButton.alpha = 0
        self.hotelSearchTableView.separatorStyle = .none
        self.hotelSearchTableView.delegate = self
        self.hotelSearchTableView.dataSource = self
        
        self.hotelSearchTableView.backgroundView = noResultemptyView
        self.hotelSearchTableView.reloadData()
        
        
        //  self.searchBar.backgroundColor = .red
        self.searchBar.searchBarStyle = .default
        self.switchView.originalColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.switchView.selectedColor = AppColors.themeRed
        self.switchView.originalBorderColor = AppColors.themeGray04//AppColors.themeGray20
        self.switchView.selectedBorderColor = AppColors.themeRed
        self.switchView.originalBorderWidth = 0.0//1.5
        self.switchView.selectedBorderWidth = 0.0//1.5
        self.switchView.iconBorderWidth = 0.0
        self.switchView.iconBorderColor = AppColors.clear
        self.switchView.originalImage = #imageLiteral(resourceName: "switch_fav_on").maskWithColor(color: #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
        self.switchView.selectedImage = #imageLiteral(resourceName: "switch_fav_on")
        self.switchView.isBackgroundBlurry = true
        self.switchGradientView.backgroundColor = AppColors.clear
        self.switchGradientView.addGrayShadow(ofColor: AppColors.themeBlack.withAlphaComponent(0.2), radius: 18, offset: .zero, opacity: 2, cornerRadius: 100)
        self.manageFloatingView(isHidden: true)
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func registerXib() {
        self.hotelsMapCV.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        self.hotelsMapCV.register(UINib(nibName: "SectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")
        self.hotelSearchTableView.register(UINib(nibName: self.hotelResultCellIdentifier, bundle: nil), forCellReuseIdentifier: self.hotelResultCellIdentifier)
    }
    
    
    private func presentEmailVC() {
        
        func showEmailComposer() {
            self.viewModel.getPinnedTemplate(hotels: self.viewModel.favouriteHotels) { [weak self] (status) in
                guard let strongSelf = self else {return}
                if status {
                    // url fetched
                    AppFlowManager.default.presentMailComposerVC(strongSelf.viewModel.favouriteHotels, strongSelf.viewModel.hotelSearchRequest ?? HotelSearchRequestModel(), strongSelf.viewModel.shortUrl)
                    AppFlowManager.default.removeLoginConfirmationScreenFromStack()
                }
            }
        }
        AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginVerificationForBulkbooking) { (_) in
            guard AppGlobals.shared.isNetworkRechable(showMessage: true) else {return}
            showEmailComposer()
        }
        
    }
    
    func manageShimmer(isHidden: Bool) {
        self.hotelsMapCV.isHidden = !isHidden
        if !isHidden {
            self.manageSwitchContainer(isHidden: true)
        }
    }
    
    private func setUpLongPressOnFilterButton() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        self.filterButton.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.viewModel.hotelResultDelegate?.updateFavouriteAndFilterView()
        self.statusBarStyle = .lightContent
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC(self)
    }
    
    
    @IBAction func unPinAllFavouriteButtonTapped(_ sender: Any) {
        self.removeAllFavouritesHotels()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        self.openSharingSheet()
    }
    
    @IBAction func EmailButtonTapped(_ sender: Any) {
        self.presentEmailVC()
    }
    
    @IBAction func floatingButtonOptionOnMapViewTapped(_ sender: Any) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(LocalizedString.FloatingButtonsTitle.localized, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Email")
                self?.presentEmailVC()
            } else if index == 1 {
                printDebug("Share")
                self?.openSharingSheet()
            } else if index == 2 {
                self?.removeAllFavouritesHotels()
                printDebug("Remove All photo")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        backButton.alpha = 1
        self.viewModel.searchedHotels.removeAll()
        self.viewModel.fetchRequestType = .normal
        
        self.hideSearchAnimation()
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.viewModel.searchTextStr = ""
        self.reloadHotelList()
        delay(seconds: 0.1) { [weak self] in
            self?.viewModel.loadSaveData()
        }
        // nitin       self.getFavouriteHotels(shouldReloadData: false)
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        self.moveMapToCurrentCity()
        self.mapView?.animate(toZoom: self.defaultZoomLabel + 5.0)
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            printDebug("Long press tapped")
            AppFlowManager.default.presentAerinTextSpeechVC()
        }
    }
    
    override func checkForReachability(_ notification: Notification) {
        
        guard let networkReachability = notification.object as? Reachability else {return}
        let remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if remoteHostStatus == .notReachable {
            print("Not Reachable")
            // self.noHotelFound()
            
        }
        else if remoteHostStatus == .reachableViaWiFi {
            print("Reachable via Wifi")
        }
        else {
            print("Reachable")
        }
    }
    
    
    
    
}
