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
    case normal
}

enum HotelResultViewType {
    case MapView
    case ListView
}

class HotelResultVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var headerContainerView: UIView!
    @IBOutlet var navContainerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var unPinAllFavouriteButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var switchView: ATSwitcher!
    
    @IBOutlet var collectionView: UICollectionView! {
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
    
    @IBOutlet var tableViewVertical: ATTableView! {
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
    
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var shimmerView: UIView!
    @IBOutlet var headerContatinerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var floatingView: UIView!
    @IBOutlet var floatingButtonOnMapView: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    // Searching View
    @IBOutlet var hotelSearchView: UIView! {
        didSet {
            self.hotelSearchView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
            self.hotelSearchView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet var hotelSearchTableView: UITableView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var floatingButtonBackView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet var switchContainerView: UIView!
    @IBOutlet var searchBarContainerView: UIView!
    
    // MARK: - Properties
    
    var clusterManager: GMUClusterManager!
    var mapView: GMSMapView?
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    var completion: (() -> Void)?
    weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    var displayingHotelLocation: CLLocationCoordinate2D?
    
    var visibleMapHeightInVerticalMode: CGFloat = 160.0
    var oldScrollPosition: CGPoint = CGPoint.zero
    let mapIntitalZoomLabel: Float = 12.0
    var selectedIndexPath: IndexPath?
    var selectedIndexPathForHotelSearch: IndexPath?
    
    // fetch result controller
    
    var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
        var fetchRequest: NSFetchRequest<HotelSearched> = HotelSearched.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "sectionTitle", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        }
        return fetchedResultsController
    }()
    
    // Request and View Type
    var fetchRequestType: FetchRequestType = .normal
    var hoteResultViewType: HotelResultViewType = .ListView
    
    var favouriteHotels: [HotelSearched] = []
    let hotelResultCellIdentifier = "HotelSearchTableViewCell"
    var searchedHotels: [HotelSearched] = []
    
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
    
    // MARK: - ViewLifeCycle
    
    func getHotelsForMapView() -> [String: Any] {
        var temp = [String: Any]()
        if let allHotels = self.fetchedResultsController.fetchedObjects {
            for hs in allHotels {
                if let lat = hs.lat, let long = hs.long {
                    if var allHotles = temp["\(lat)\(long)"] as? [HotelSearched] {
                        allHotles.append(hs)
                        temp["\(lat)\(long)"] = allHotles
                    } else {
                        temp["\(lat)\(long)"] = [hs]
                    }
                }
            }
        }
        return temp
    }
    
    // MARK: -
    
    override func initialSetup() {
        self.animateCollectionView(isHidden: true, animated: false)
        self.floatingButtonBackView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        
        self.view.backgroundColor = AppColors.themeWhite
        
        self.container = NSPersistentContainer(name: "AERTRIP")
        
        self.container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        self.initialSetups()
        self.registerXib()
        
        self.startProgress()
        self.completion = { [weak self] in
            self?.loadSaveData()
        }
        
        self.viewModel.hotelListOnPreferenceResult()
        self.getPinnedHotelTemplate()
        self.statusBarStyle = .default
        
        self.addMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        self.setUpFloatingView()
        self.setupTableHeader()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBarContainerView.frame
        self.reloadHotelList()
        self.floatingView.isHidden = false
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
        
        self.switchView.originalColor = AppColors.themeGray04
        self.switchView.selectedColor = AppColors.themeRed
        self.switchView.originalBorderColor = AppColors.themeGray20
        self.switchView.selectedBorderColor = AppColors.themeRed
        self.switchView.originalBorderWidth = 1.5
        self.switchView.selectedBorderWidth = 1.5
        self.switchView.iconBorderWidth = 0.0
        self.switchView.iconBorderColor = AppColors.clear
//        self.switchView.originalImage = #imageLiteral(resourceName: "ic_fav_hotel_text")
//        self.switchView.selectedImage = #imageLiteral(resourceName: "save_icon_green")
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.SemiBold.withSize(13.0)
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = self.viewModel.hotelSearchRequest?.requestParameters.city
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
    
    private func presentEmailVC() {
        AppFlowManager.default.presentMailComposerVC(self.favouriteHotels, self.viewModel.hotelSearchRequest ?? HotelSearchRequestModel(), self.viewModel.shortUrl)
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
        self.hideButtons()
        self.switchView.setOn(isOn: false)
        self.fetchRequestType = .normal
        if self.hoteResultViewType == .ListView {
            self.mapButton.isSelected = true
            self.hoteResultViewType = .MapView
            self.animateHeaderToMapView()
            self.convertToMapView()
        } else {
            self.hoteResultViewType = .ListView
            self.mapButton.isSelected = false
            self.animateHeaderToListView()
            self.convertToListView()
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
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if self.hoteResultViewType == .ListView {
            self.animateHeaderToListView()
        }
        self.fetchRequestType = .normal
        self.hideSearchAnimation()
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.predicateStr = ""
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        self.moveMapToCurrentCity()
        self.mapView?.animate(toZoom: self.mapIntitalZoomLabel + 5.0)
    }
}
