//
//  HotelsMapVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import CoreData
import UIKit
import Kingfisher
import MapKit

class MapContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = AppColors.clear
    }
    deinit {
        printDebug("MapContainerView deinit")
    }
}

class HotelsMapVC: StatusBarAnimatableViewController {
    
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
            self.hotelsMapCV.showsVerticalScrollIndicator = false
            self.hotelsMapCV.showsHorizontalScrollIndicator = false
            self.hotelsMapCV.backgroundColor = AppColors.clear
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
    
    @IBOutlet weak var hotelSearchTableView: ATTableView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(searchTabeleTapped(tap:)))
            self.hotelSearchTableView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonBackView: UIView!
    @IBOutlet weak var mapContainerView: MapContainerView!
    @IBOutlet weak var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var cardGradientView: UIView!
    
    @IBOutlet weak var switchGradientView: UIView!
    @IBOutlet weak var appleMap: MKMapView!
    
    
    // MARK: - Properties
    
    //    var container: NSPersistentContainer!
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    var aerinFilterUndoCompletion : (() -> Void)?
    weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    var displayingHotelLocation: CLLocationCoordinate2D?
    
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
    var maxVisblePriceMarker = 6
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
    var detailsShownMarkers = [MyAnnotation]()
    var seletedIndexForSearchTable:Int?
    var isRemovingAllFav:Bool = false
    var currentMapSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta:  0.035)
    internal var transition: CardTransition?
    override var statusBarAnimatableConfig: StatusBarAnimatableConfig{
        return StatusBarAnimatableConfig(prefersHidden: false, animation: .slide)
    }
    var blurView = UIVisualEffectView()
    var isMapZoomNeedToSet = false
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        self.mapContainerViewBottomConstraint.constant = (!UIDevice.isIPhoneX) ? 203.0 : 237.0
//        self.mapContainerTopConstraint.constant = (!UIDevice.isIPhoneX) ? 100 : 144
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
        
        self.currentLocationButton.isHidden = false
        animateHeaderToMapView()
        animateFloatingButtonOnMapView(isAnimated: false)
        self.switchContainerView.isHidden = self.viewModel.favouriteHotels.isEmpty
        self.floatingButtonOnMapView.isHidden = !self.viewModel.isFavouriteOn
        self.switchView.isOn = self.viewModel.isFavouriteOn
        //        self.animateMapToFirstHotelInMapMode()
        self.filterButton.isSelected = self.viewModel.isFilterApplied
        searchBar.setTextField(color: UIColor(displayP3Red: 153/255, green: 153/255, blue: 153/255, alpha: 0.12))
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
        self.addMapView()
        self.appleMap.delegate = self
        self.addGestureRecognizerForTap()
//        if AppGlobals.shared.isNetworkRechable() {
//            delay(seconds: 0.2) { [weak self] in
//                guard let strongSelf = self else {return}
//               // strongSelf.mapView?.delegate = self
                self.loadFinalDataOnScreen()
//            }
//        } else {
//            self.noHotelFound()
//            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
//        }
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
    }
    
    
    override func bindViewModel() {
        self.viewModel.hotelMapDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer?.frame = self.cardGradientView.bounds
    }
    
    deinit {
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
            self.selectedIndexPath = nil
            
            self.viewModel.getFavouriteHotels(shouldReloadData: true)
            //            self.updateMarkers()
            //            self.showHotelOnMap(duration: 0.4)
        }
        else if let _ = note.object as? HCDataSelectionVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        }
        else if let _ = note.object as? HotelResultVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        } else if let _ = note.object as? HotelsGroupExpendedVC {
            
        }
        
        if let index = self.seletedIndexForSearchTable{
            self.updateFavouriteAnnotationDetail(duration: 0.4, index: index)
            self.seletedIndexForSearchTable = nil
        }else{
            self.updateFavouriteAnnotationDetail(duration: 0.4)
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
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -7)
        layout.scrollDirection = .horizontal
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 1.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 201)
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
        
        // replaced the switch with flight switch
        switchView.tintColor = AppColors.themeGray20
        switchView.offTintColor = AppColors.themeGray10
        switchView.isOn = false
        switchView.setupUI()
        /*
        self.switchView.originalColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.switchView.selectedColor = AppColors.themeRed
        self.switchView.originalBorderColor = AppColors.themeGray04//AppColors.themeGray20
        self.switchView.selectedBorderColor = AppColors.themeRed
        self.switchView.originalBorderWidth = 0.0//1.5
        self.switchView.selectedBorderWidth = 0.0//1.5
        self.switchView.iconBorderWidth = 0.0
        self.switchView.iconBorderColor = AppColors.clear
        self.switchView.originalImage = #imageLiteral(resourceName: "switch_fav_on").maskWithColor(color: UIColor(displayP3Red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
        self.switchView.selectedImage = #imageLiteral(resourceName: "switch_fav_on")
        self.switchView.isBackgroundBlurry = true
        */
        self.switchGradientView.backgroundColor = AppColors.clear
        self.switchGradientView.addGrayShadow(ofColor: AppColors.themeBlack.withAlphaComponent(0.2), radius: 18, offset: .zero, opacity: 2, cornerRadius: 100)
        // self.manageFloatingView(isHidden: true)
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
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeRed])
        let cencelBtn = PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen,titleFont: AppFonts.SemiBold.withSize(20))
        _ = PKAlertController.default.presentActionSheet(LocalizedString.FloatingButtonsTitle.localized,titleFont: AppFonts.SemiBold.withSize(14), titleColor: AppColors.themeGray40, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: cencelBtn) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Email")
                self?.presentEmailVC()
            } else if index == 1 {
                printDebug("Share")
                self?.openSharingSheet()
            } else if index == 2 {
                self?.isRemovingAllFav = true
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
            guard let self = self else {return}
            self.viewModel.loadSaveData()
            if self.viewModel.isResetAnnotation{
                self.appleMap.removeAnnotations(self.appleMap.annotations)
                self.addAllMarker()
                self.viewModel.isResetAnnotation = false
            }
        }
        // nitin       self.getFavouriteHotels(shouldReloadData: false)
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        guard let loc = self.viewModel.searchedCityLocation else{return}
        MKMapView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
        self.appleMap.setRegion(MKCoordinateRegion(center: loc, span: self.currentMapSpan), animated: true)
        }, completion: nil)
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            printDebug("Long press tapped")
            AppFlowManager.default.presentAerinTextSpeechVC()
        }
    }
    
    @objc func searchTabeleTapped(tap:UITapGestureRecognizer) {
        let location = tap.location(in: self.hotelSearchTableView)
        let path = self.hotelSearchTableView.indexPathForRow(at: location)
        if let indexPathForRow = path {
            self.tableView(self.hotelSearchTableView, didSelectRowAt: indexPathForRow)
        } else if (hotelSearchTableView.backgroundView == nil || hotelSearchTableView.backgroundView?.isHidden ?? false){
            // handle tap on empty space below existing rows however you want
            printDebug("tapped at empty space of table view")
            self.cancelButtonTapped(self.cancelButton)
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
