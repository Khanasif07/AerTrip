//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import UIKit

enum FetchRequestType {
    case FilterApplied
    case Searching
    case normalInSearching
    case normal
}

enum HotelResultViewType {
    case MapView
    case ListView
}

class HotelResultVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var navContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var unPinAllFavouriteButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var switchView: ATSwitcher!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.registerCell(nibName: HotelCardCollectionViewCell.reusableIdentifier)
            self.collectionView.registerCell(nibName: HotelGroupCardCollectionViewCell.reusableIdentifier)
            self.collectionView.isPagingEnabled = true
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.showsVerticalScrollIndicator = false
            self.collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var tableViewVertical: ATTableView! {
        didSet {
            self.tableViewVertical.registerCell(nibName: HotelCardTableViewCell.reusableIdentifier)
            self.tableViewVertical.register(HotelResultSectionHeader.self, forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            self.tableViewVertical.register(UINib(nibName: "HotelResultSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HotelResultSectionHeader")
            self.tableViewVertical.delegate = self
            self.tableViewVertical.dataSource = self
            self.tableViewVertical.separatorStyle = .none
            self.tableViewVertical.showsVerticalScrollIndicator = false
            self.tableViewVertical.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var floatingButtonOnMapView: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var mapContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var cardGradientView: UIView!
    @IBOutlet weak var cardGradientViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shimmerGradientView: UIView!
    
    @IBOutlet weak var switchGradientView: UIView!
    // MARK: - Properties
    
//    var container: NSPersistentContainer!
    var searchTextStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    var completion: (() -> Void)?
    var toastDidClose : (() -> Void)?
    var aerinFilterUndoCompletion : (() -> Void)?
    weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    var displayingHotelLocation: CLLocationCoordinate2D? {
        didSet {
            if let oLoc = oldValue {
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
    
    var oldOffset: CGPoint = .zero //used in colletion view scrolling for map re-focus
    var isCollectionScrollingInc: Bool = false
    
    //Map Related
    var clusterManager: GMUClusterManager!
    let useGoogleCluster: Bool = true
    var mapView: GMSMapView?
    let minZoomLabel: Float = 1.0
    let maxZoomLabel: Float = 30.0
    let defaultZoomLabel: Float = 15.0
    let extraZoomLabelForMapView: Float = 1.0
    let thresholdZoomLabel: Float = 12.0
    var prevZoomLabel: Float = 1.0
    var markersOnLocations: JSONDictionary = JSONDictionary()
    var fetchRequest: NSFetchRequest<HotelSearched> = HotelSearched.fetchRequest()
    
    // fetch result controller
   lazy var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
       
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "bc", ascending: true)]
      
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
//        }
        return fetchedResultsController
    }()
    
    // Request and View Type
    var isLoadingListAfterUpdatingAllFav: Bool = false
    var fetchRequestType: FetchRequestType = .normal
    var hoteResultViewType: HotelResultViewType = .ListView
    var favouriteHotels: [HotelSearched] = []
    let hotelResultCellIdentifier = "HotelSearchTableViewCell"
    var searchedHotels: [HotelSearched] = []
    var andPredicate : NSCompoundPredicate?
    
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
    
    let viewModel = HotelsResultVM()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    var hideSection = 0
    var footeSection = 1
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
        
    //used for making collection view centerlized
    var indexOfCellBeforeDragging = 0
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func initialSetup() {
        
        self.filterButton.isEnabled = false
        self.mapButton.isEnabled = false
        self.mapView?.isMyLocationEnabled = false
        self.animateCollectionView(isHidden: true, animated: false)
        self.floatingButtonBackView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        
        self.view.backgroundColor = AppColors.themeWhite
        
        self.initialSetups()
        self.registerXib()
        
        self.startProgress()
        self.completion = { [weak self] in
            UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
            self?.fetchRequestType = .FilterApplied
            if let old = UserInfo.hotelFilterApplied {
                HotelFilterVM.shared.setData(from: old)
            }
            self?.doneButtonTapped()
        }
        
        // toast Completion when toast goes way from the screen
        self.toastDidClose = {
            UserDefaults.setObject(false, forKey: "shouldApplyFormStars")
            UserInfo.hotelFilterApplied = nil
            UserInfo.hotelFilter = nil
            HotelFilterVM.shared.resetToDefault()
        }
        
        // toast completion,When undo button tapped
        self.aerinFilterUndoCompletion = {
            printDebug("Undo Button tapped")
        }
        self.cardGradientView.isHidden = true
        //call API to get vcode, sid
        if AppGlobals.shared.isNetworkRechable() {
             self.viewModel.hotelListOnPreferencesApi()
        } else {
            self.noHotelFound()
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
       
        
        self.getPinnedHotelTemplate()
        self.statusBarStyle = .default
        collectionViewLayout.minimumLineSpacing = 0
        self.setUpLongPressOnFilterButton()
        self.cardGradientView.backgroundColor = AppColors.clear
        self.cardGradientView.addGredient(isVertical: true, cornerRadius: 0.0, colors: [AppColors.themeWhite.withAlphaComponent(0.01),AppColors.themeWhite.withAlphaComponent(1.0)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarColor = AppColors.themeWhite
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.configureCollectionViewLayoutItemSize()
        self.mapView?.frame = self.mapContainerView.bounds
    }
    
    override func keyboardWillHide(notification: Notification) {
        if let _ = self.view.window, self.searchedHotels.isEmpty {
            //checking if the screen in window only then this method should call
            self.cancelButtonTapped(self.cancelButton)
        }
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
            updateFavOnList(forIndexPath: selectedIndexPath)
            // manage favourite switch buttons 
            self.getFavouriteHotels(shouldReloadData: true)
        }
        else if let _ = note.object as? HCDataSelectionVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        }
        else if let _ = note.object as? HotelResultVC {
            updateFavOnList(forIndexPath: selectedIndexPath)
        }
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
    
    func initialSetups() {
        self.addShimmerGradient()
        self.setUpFloatingView()
        self.setupTableHeader()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBarContainerView.frame
        self.reloadHotelList()
        self.floatingButtonOnMapView.isHidden = true
        self.cancelButton.alpha = 0
        self.hotelSearchTableView.separatorStyle = .none
        self.hotelSearchTableView.delegate = self
        self.hotelSearchTableView.dataSource = self
        
        self.completion = { [weak self] in
            self?.loadSaveData()
        }
        
        self.hotelSearchTableView.backgroundView = noResultemptyView
        self.hotelSearchTableView.reloadData()
        
        self.switchView.originalColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.switchView.selectedColor = AppColors.themeRed
        self.switchView.originalBorderColor = AppColors.themeGray04//AppColors.themeGray20
        self.switchView.selectedBorderColor = AppColors.themeRed
        self.switchView.originalBorderWidth = 0.0//1.5
        self.switchView.selectedBorderWidth = 0.0//1.5
        self.switchView.iconBorderWidth = 0.0
        self.switchView.iconBorderColor = AppColors.clear
        self.switchView.originalImage = #imageLiteral(resourceName: "switch_fav_off")
        self.switchView.selectedImage = #imageLiteral(resourceName: "switch_fav_on")
        self.switchView.isBackgroundBlurry = true
        self.switchGradientView.backgroundColor = AppColors.clear
        self.switchGradientView.addGrayShadow(ofColor: AppColors.themeBlack.withAlphaComponent(0.2), radius: 18, offset: .zero, opacity: 2, cornerRadius: 100)
        self.addTapGestureOnMap()
        self.manageFloatingView(isHidden: true)
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(13.0)
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.setupNavigationTitleLabelText()
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        self.collectionView.register(UINib(nibName: "SectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")
        self.hotelSearchTableView.register(UINib(nibName: self.hotelResultCellIdentifier, bundle: nil), forCellReuseIdentifier: self.hotelResultCellIdentifier)
    }
    
    private func addShimmerGradient() {
        self.shimmerGradientView.backgroundColor = AppColors.clear
        self.shimmerGradientView.addGredient(isVertical: true, cornerRadius: 0.0, colors: [AppColors.themeWhite.withAlphaComponent(0.001), AppColors.themeWhite])
    }
    
    private func presentEmailVC() {
        
        AppFlowManager.default.proccessIfUserLoggedIn(verifyingFor: .loginVerificationForBulkbooking) { (_) in
             AppFlowManager.default.presentMailComposerVC(self.favouriteHotels, self.viewModel.hotelSearchRequest ?? HotelSearchRequestModel(), self.viewModel.shortUrl)
            AppFlowManager.default.removeLoginConfirmationScreenFromStack()
        }
    }
    
    func manageShimmer(isHidden: Bool) {
        self.shimmerView.isHidden = isHidden
        self.tableViewVertical.isHidden = !isHidden
        self.collectionView.isHidden = !isHidden
        if isHidden {
            self.view.sendSubviewToBack(self.shimmerView)
        }
        else {
            self.manageSwitchContainer(isHidden: true)
            self.view.bringSubviewToFront(self.shimmerView)
        }
    }
    
    private func setUpLongPressOnFilterButton() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        self.filterButton.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.statusBarStyle = .lightContent
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC(self)
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        self.hideFavsButtons()
        self.fetchRequestType = .normal
        self.backButton.isHidden = false
        self.cardGradientView.isHidden = true
        if self.hoteResultViewType == .ListView {
            self.mapButton.isSelected = true
            self.currentLocationButton.isHidden = false
            self.hoteResultViewType = .MapView
            self.animateHeaderToMapView()
            self.convertToMapView { [weak self] (isConverted) in
                if isConverted {
                    self?.switchView.setOn(isOn: self?.switchView.on ?? false)
                }
            }
            self.cardGradientView.isHidden = true
            
        } else {
            self.currentLocationButton.isHidden = true
            self.hoteResultViewType = .ListView
            self.mapButton.isSelected = false
            self.animateHeaderToListView()
            self.convertToListView { [weak self] (isConverted) in
                if isConverted {
                    self?.switchView.setOn(isOn: self?.switchView.on ?? false)
                }
            }
            self.cardGradientView.isHidden = false
            
        }
        
        self.reloadHotelList()
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
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeRed])
        
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
        if self.hoteResultViewType == .ListView {
            self.animateHeaderToListView()
        } else {
            backButton.alpha = 1
        }
        self.searchedHotels.removeAll()
        self.fetchRequestType = .normal
        
        self.hideSearchAnimation()
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.searchTextStr = ""
        self.loadSaveData()
        self.getFavouriteHotels(shouldReloadData: false)
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
            self.noHotelFound()
            
        }
        else if remoteHostStatus == .reachableViaWiFi {
            print("Reachable via Wifi")
        }
        else {
            print("Reachable")
        }
    }

}



