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
}

enum HotelResultViewType {
    case MapView
    case ListView
}

enum CurrentlyTableViewUsing {
    case SearchTableView
    case ListTableView
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
    
    @IBOutlet var tableViewVertical: UITableView! {
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
    @IBOutlet var hotelSearchView: UIView!
    @IBOutlet var hotelSearchTableView: UITableView!
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet var floatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var floatingButtonBackView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var mapContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet var switchContainerView: UIView!
    
    // MARK: - Properties
    
    private var clusterManager: GMUClusterManager!
    var mapView: GMSMapView?
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    var isAboveTwentyKm: Bool = false
    var isFotterVisible: Bool = false
    var searchIntitialFrame: CGRect = .zero
    private var completion: (() -> Void)?
    private weak var hotelsGroupExpendedVC: HotelsGroupExpendedVC?
    private var displayingHotelLocation: CLLocationCoordinate2D?
    
    private var visibleMapHeightInVerticalMode: CGFloat = 160.0
    private var oldScrollPosition: CGPoint = CGPoint.zero
    private let mapIntitalZoomLabel: Float = 12.0
    
    // fetch result controller
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
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
    var fetchRequestType: FetchRequestType = .Searching
    var hoteResultViewType: HotelResultViewType = .ListView
    var tableViewType: CurrentlyTableViewUsing = .ListTableView
    
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
        self.getFavouriteHotels()
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
    
    private func initialSetups() {
        self.setUpFloatingView()
        self.setupTableHeader()
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.searchIntitialFrame = self.searchBar.frame
        self.reloadHotelList()
        self.floatingView.isHidden = true
        self.floatingButtonOnMapView.isHidden = true
        self.cancelButton.alpha = 0
        self.hotelSearchView.isHidden = true
        self.hotelSearchTableView.separatorStyle = .none
        self.hotelSearchTableView.delegate = self
        self.hotelSearchTableView.dataSource = self
        self.completion = { [weak self] in
            self?.loadSaveData()
        }
        
        self.hotelSearchTableView.backgroundView = noResultemptyView
        self.hotelSearchTableView.reloadData()
    }
    
    private func setUpFloatingView() {
        self.switchView.delegate = self
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
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
    
    private func setupTableHeader() {
        self.tableViewVertical.backgroundView = nil
        self.tableViewVertical.backgroundColor = AppColors.clear
        
        let shadowsHeight: CGFloat = 60.0
        
        let hView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: visibleMapHeightInVerticalMode))
        hView.backgroundColor = AppColors.clear
        
        let shadowView = UIView(frame: CGRect(x: 0.0, y: (hView.frame.height - shadowsHeight), width: UIDevice.screenWidth, height: shadowsHeight))
        shadowView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.01), AppColors.themeWhite])
        hView.addSubview(shadowView)
        
        self.tableViewVertical.tableHeaderView = hView
    }
    
    private func setupNavigationTitleLabelText() {
        let checkIn = Date.getDateFromString(stringDate: viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM") ?? ""
        let checkOut = Date.getDateFromString(stringDate: viewModel.hotelSearchRequest?.requestParameters.checkOut ?? " ", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM") ?? ""
        let numberOfRoom = self.viewModel.hotelSearchRequest?.requestParameters.numOfRooms ?? ""
        self.descriptionLabel.text = "\(checkIn) - \(checkOut) • \(numberOfRoom) Rooms"
    }
    
    func reloadHotelList() {
        self.tableViewVertical.isHidden = true
        if let section = self.fetchedResultsController.sections, !section.isEmpty {
            self.tableViewVertical.isHidden = false
        }
        self.tableViewVertical.reloadData()
        self.collectionView.reloadData()
    }
    
    func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        self.collectionView.register(UINib(nibName: "SectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")
        self.hotelSearchTableView.register(UINib(nibName: self.hotelResultCellIdentifier, bundle: nil), forCellReuseIdentifier: self.hotelResultCellIdentifier)
    }
    
    private func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    private func getSavedFilter() {
        guard let filter = UserInfo.loggedInUser?.hotelFilter else {
            printDebug("filter not found")
            return
        }
        self.filterApplied = filter
    }
    
    private func applyPreviousFilter() {
        AppToast.default.showToastMessage(message: LocalizedString.ApplyPreviousFilter.localized, onViewController: self, buttonTitle: LocalizedString.apply.localized, buttonImage: nil, buttonAction: self.completion)
    }
    
    func convertToMapView() {
        self.animateCollectionView(isHidden: false, animated: true)
    }
    
    func convertToListView() {
        self.animateCollectionView(isHidden: true, animated: true)
    }
    
    private func animateCollectionView(isHidden: Bool, animated: Bool) {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = true
        let hiddenFrame: CGRect = CGRect(x: collectionView.width, y: (UIDevice.screenHeight - collectionView.height), width: collectionView.width, height: collectionView.height)
        let shownFrame: CGRect = CGRect(x: 0.0, y: (UIDevice.screenHeight - (collectionView.height + AppFlowManager.default.safeAreaInsets.bottom)), width: collectionView.width, height: collectionView.height)
        
        if !isHidden {
            self.collectionView.isHidden = false
            self.floatingButtonBackView.isHidden = false
        }
        
        // resize the map view for map/list view
        let mapFrame = CGRect(x: 0.0, y: 0.0, width: mapContainerView.width, height: isHidden ? visibleMapHeightInVerticalMode : mapContainerView.height)
        
        self.mapView?.animate(toZoom: isHidden ? mapIntitalZoomLabel : (mapIntitalZoomLabel + 5.0))
        self.moveMapToCurrentCity()
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            // map resize animation
            self.mapView?.frame = mapFrame
            
            // vertical list animation
            self.collectionView.frame = isHidden ? hiddenFrame : shownFrame
            self.collectionView.alpha = isHidden ? 0.0 : 1.0
            
            // floating buttons animation
            self.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
            self.currentLocationButton.isHidden = isHidden
            self.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
            
            // horizontal list animation
            self.tableViewTopConstraint.constant = isHidden ? 100.0 : UIDevice.screenHeight
            self.tableViewVertical.alpha = isHidden ? 1.0 : 0.0
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if isHidden {
                self.floatingButtonBackView.isHidden = true
                self.collectionView.isHidden = true
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
            }
        })
    }
    
    func animateHeaderToListView() {
        self.headerContatinerViewHeightConstraint.constant = 100
        self.tableViewTopConstraint.constant = 100
        self.mapContainerTopConstraint.constant = 100
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBar.frame = self.searchIntitialFrame
            self.titleLabel.transform = .identity
            self.descriptionLabel.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    func animateHeaderToMapView() {
        self.headerContatinerViewHeightConstraint.constant = 50
        self.tableViewTopConstraint.constant = 50
        self.mapContainerTopConstraint.constant = 50
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x + 10
                                          , y: self.searchBar.frame.origin.y - 45, width: self.searchBar.frame.width - 80, height: 50)
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.view.layoutIfNeeded()
        }
    }
    
    func showSearchAnimation() {
        self.filterButton.isHidden = true
        self.mapButton.isHidden = true
        self.cancelButton.alpha = 1
    }
    
    func hideSearchAnimation() {
        self.filterButton.isHidden = false
        self.mapButton.isHidden = false
        self.cancelButton.alpha = 0
    }
    
    private func getFavouriteHotels() {
        self.favouriteHotels = self.fetchedResultsController.fetchedObjects?.filter { $0.fav == "1" } ?? []
    }
    
    private func getPinnedHotelTemplate() {
        if !self.favouriteHotels.isEmpty {
            self.viewModel.getPinnedTemplate(hotels: self.favouriteHotels)
        }
    }
    
    // MARK: Show progress
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.8) {
                self.progressView.isHidden = true
            }
        }
    }
    
    func loadSaveData() {
        if self.fetchRequestType == .FilterApplied {
            var subpredicates : [NSPredicate] = []
            self.fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
            
            switch self.filterApplied.sortUsing {
            case .BestSellers:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "bc", ascending: true))
            case .PriceLowToHigh:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "price", ascending: true))
            case .TripAdvisorRatingHighToLow:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "rating", ascending: false))
            case .StartRatingHighToLow:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "star", ascending: false))
            case .DistanceNearestFirst:
                self.fetchedResultsController.fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "distance", ascending: true))
            }
            
            var amentitiesPredicate: NSPredicate?
            var predicates = [AnyHashable]()
            for amentity in self.filterApplied.amentities {
                predicates.append(NSPredicate(format: "amenities CONTAINS[c] ',\(amentity)'"))
            }
            if predicates.count > 0 {
                if let predicates = predicates as? [NSPredicate] {
                    amentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                }
            }
            
           
            let minimumPricePredicate = NSPredicate(format: "price >= \(filterApplied.leftRangePrice)")
            let maximumPricePredicate = NSPredicate(format: "price <= \(filterApplied.rightRangePrice)")
            subpredicates.append(minimumPricePredicate)
            subpredicates.append(maximumPricePredicate)
            if filterApplied.distanceRange > 0 {
                let distancePredicate = NSPredicate(format: "distance <= \(self.filterApplied.distanceRange)")
                subpredicates.append(distancePredicate)
            }
            

            
            var starPredicate : NSPredicate?
            var starPredicates = [AnyHashable]()
            for star in self.filterApplied.ratingCount {
                starPredicates.append(NSPredicate(format: "filterStar CONTAINS[c] '\(star)'"))
            }
            
            if starPredicates.count > 0 {
                if let starPredicates = starPredicates as? [NSPredicate] {
                    starPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: starPredicates)
                }
            }
            
            var tripAdvisorPredicate : NSPredicate?
            var tripAdvisorPredicates = [AnyHashable]()
            for rating in self.filterApplied.tripAdvisorRatingCount {
                tripAdvisorPredicates.append(NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '\(rating)'"))
            }
            
            if tripAdvisorPredicates.count > 0 {
                if let tripAdvisorPredicates = tripAdvisorPredicates as? [NSPredicate] {
                    tripAdvisorPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: tripAdvisorPredicates)
                }
            }
            
            if let amentitiesPredicate = amentitiesPredicate {
                subpredicates.append(amentitiesPredicate)
            }
            
            if let starPredicate = starPredicate {
                subpredicates.append(starPredicate)
            }
            
            
            if let tripAdvisorPredicate = tripAdvisorPredicate {
                subpredicates.append(tripAdvisorPredicate)
            }
          
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: subpredicates)
            self.fetchedResultsController.fetchRequest.predicate = andPredicate
            
        } else {
            if self.predicateStr == "" {
                self.fetchedResultsController.fetchRequest.predicate = nil
                
            } else {
                let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [NSPredicate(format: "hotelName CONTAINS[cd] %@", self.predicateStr), NSPredicate(format: "address CONTAINS[cd] %@", self.predicateStr)])
                self.fetchedResultsController.fetchRequest.predicate = orPredicate
            }
        }
        
        do {
            try self.fetchedResultsController.performFetch()
            self.getHotelsCount()
            if !self.predicateStr.isEmpty {
                self.searchedHotels = self.fetchedResultsController.fetchedObjects ?? []
                self.hotelSearchTableView.backgroundColor = self.searchedHotels.count > 0 ? AppColors.themeWhite : AppColors.clear
                self.hotelSearchTableView.reloadData()
            }
            self.reloadHotelList()
        } catch {
            printDebug(error.localizedDescription)
            print("Fetch failed")
        }
        self.reloadHotelList()
    }
    
    private func openSharingSheet() {
        let textToShare = [self.viewModel.shortUrl]
        let activityViewController =
            UIActivityViewController(activityItems: textToShare as [Any],
                                     applicationActivities: nil)
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        present(activityViewController, animated: true)
    }
    
    private func removeAllFavouritesHotels() {
        self.viewModel.updateFavourite(forHotels: self.favouriteHotels, isUnpinHotels: true)
    }
    
    private func expandGroup(_ hotels: [HotelSearched]) {
        if let topVC = UIApplication.topViewController() {
            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
            self.hotelsGroupExpendedVC = dataVC
            dataVC.viewModel.samePlaceHotels = hotels
            let sheet = PKBottomSheet.instanceFromNib
            sheet.headerHeight = 24.0
            sheet.headerView = dataVC.headerView
            sheet.frame = topVC.view.bounds
            sheet.delegate = self
            topVC.view.addSubview(sheet)
            sheet.present(presentedViewController: dataVC, animated: true)
        }
    }
    
    private func relocateSwitchButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.switchContainerView.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    private func relocateCurrentLocationButton(shouldMoveUp: Bool, animated: Bool) {
        let trans = shouldMoveUp ? CGAffineTransform.identity : CGAffineTransform(translationX: 0.0, y: 30.0)
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0) { [weak self] in
            self?.currentLocationButton.transform = trans
            self?.view.layoutIfNeeded()
        }
    }
    
    
    private func moveMapToCurrentCity() {
        if let loc = self.viewModel.searchedCityLocation {
            self.updateMarker(coordinates: loc)
        }
    }
    
    private func getHotelsCount() {
        if fetchRequestType == .Searching {
            HotelFilterVM.shared.totalHotelCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
            HotelFilterVM.shared.filterHotelCount =  HotelFilterVM.shared.totalHotelCount
        } else {
            HotelFilterVM.shared.filterHotelCount = self.fetchedResultsController.fetchedObjects?.count ?? 0
        }
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
        if self.hoteResultViewType == .ListView {
            self.animateHeaderToMapView()
            self.mapButton.isSelected = true
            self.convertToMapView()
            self.hoteResultViewType = .MapView
        } else {
            self.animateHeaderToListView()
            self.convertToListView()
            self.hoteResultViewType = .ListView
            self.mapButton.isSelected = false
        }
    }
    
    @IBAction func unPinAllFavouriteButtonTapped(_ sender: Any) {
        self.removeAllFavouritesHotels()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        self.openSharingSheet()
    }
    
    @IBAction func EmailButtonTapped(_ sender: Any) {
        AppFlowManager.default.presentMailComposerVC(self.favouriteHotels, self.viewModel.hotelSearchRequest ?? HotelSearchRequestModel(), self.viewModel.shortUrl)
    }
    
    @IBAction func floatingButtonOptionOnMapViewTapped(_ sender: Any) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Email.localized, LocalizedString.Share.localized, LocalizedString.RemoveFromFavourites.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(LocalizedString.FloatingButtonsTitle.localized, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("Email")
                
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
        self.animateHeaderToListView()
        self.hideSearchAnimation()
        self.hotelSearchView.isHidden = true
        self.view.endEditing(true)
        self.tableViewType = .ListTableView
        self.reloadHotelList()
    }
    
    @IBAction func currentLocationButtonAction(_ sender: UIButton) {
        self.moveMapToCurrentCity()
        self.mapView?.animate(toZoom: self.mapIntitalZoomLabel + 5.0)
    }
}

// MARK: - Table view datasource and delegate methods

// MARK: -

extension HotelResultVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableViewType == .SearchTableView {
            return 1
        } else {
             self.hotelSearchView.isHidden = true
             self.showFloatingView()
            if self.fetchedResultsController.sections?.count == 0 && self.fetchRequestType == .FilterApplied {
                self.hotelSearchView.isHidden = false
                self.hideFloatingView()
                self.hotelSearchTableView.backgroundView = noHotelFoundOnFilterEmptyView
                self.noHotelFoundOnFilterEmptyView.backgroundColor = .red
                self.shimmerView.addSubview(noHotelFoundOnFilterEmptyView)
                self.view.bringSubviewToFront(shimmerView)
            }
            return (self.fetchedResultsController.sections?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableViewType == .SearchTableView {
            self.hotelSearchTableView.backgroundView?.isHidden = self.searchedHotels.count > 0
            return self.searchedHotels.count
        } else {
            guard let sections = self.fetchedResultsController.sections else {
                printDebug("No sections in fetchedResultsController")
                return 0
            }
            let sectionInfo = sections[section]
            if sectionInfo.numberOfObjects > 0 {
                self.shimmerView.removeFromSuperview()
            }
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableViewType == .SearchTableView {
            return UITableView.automaticDimension
        } else {
            return 53.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableViewType == .ListTableView {
            guard let sections = fetchedResultsController.sections, let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelResultSectionHeader") as? HotelResultSectionHeader else {
                return nil
            }
            
            var removeFirstChar = sections[section].name
            _ = removeFirstChar.removeFirst()
            let text = removeFirstChar + " kms"
            hView.titleLabel.text = "  \(text)   "
            
            return hView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableViewType == .ListTableView {
            return 203.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableViewType == .SearchTableView {
            guard let cell = hotelSearchTableView.dequeueReusableCell(withIdentifier: self.hotelResultCellIdentifier, for: indexPath) as? HotelSearchTableViewCell else {
                printDebug("HotelSearchTableViewCell not found")
                return UITableViewCell()
            }
            cell.searchText = self.predicateStr
            cell.hotelData = self.searchedHotels[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell") as? HotelCardTableViewCell else {
                fatalError("HotelCardTableViewCell not found")
            }
            
            let hData = fetchedResultsController.object(at: indexPath)
            self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
            self.isFotterVisible = self.isAboveTwentyKm
            cell.hotelListData = hData
            cell.delegate = self
            cell.contentView.backgroundColor = AppColors.themeWhite
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hData = fetchedResultsController.object(at: indexPath)
        if let cell = tableView.cellForRow(at: indexPath) {
            AppFlowManager.default.presentHotelDetailsVC(hotelInfo: hData, sourceView: cell.contentView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension HotelResultVC {
    func manageTopHeader(_ scrollView: UIScrollView) {
        guard scrollView === tableViewVertical else {
            return
        }
        
        let yPosition = scrollView.contentOffset.y
        if 20...30 ~= yPosition {
            // hide
            self.headerContainerViewTopConstraint.constant = -140
            self.tableViewTopConstraint.constant = 0
            self.mapContainerTopConstraint.constant = 0
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        } else if yPosition < 20 {
            // show
            self.headerContainerViewTopConstraint.constant = 0
            self.tableViewTopConstraint.constant = 100
            self.mapContainerTopConstraint.constant = 100
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func manageFloatingButtonOnPaginationScroll(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else {
            return
        }
        
//        printDebug(scrollView.contentOffset)
//
//        let xPosition = scrollView.contentOffset.x
//
//        let item = xPosition / UIDevice.screenWidth
//        printDebug(item)
        
        let xPos = scrollView.contentOffset.x
        
        let fractional: CGFloat = xPos / UIDevice.screenWidth
        let decimal: CGFloat = floor(fractional)
        let progress = fractional - decimal
        
        let currentPoint = CGPoint(x: decimal * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        guard 0.01...0.99 ~= progress else {
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
            } else {
                // current normal cell
                self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
            }
            return
        }
        
        let nextPoint = CGPoint(x: (decimal + 1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        let prevPoint = CGPoint(x: (decimal - 1) * UIDevice.screenWidth, y: scrollView.contentOffset.y)
        
        if xPos > self.oldScrollPosition.x {
            // forward
            printDebug("forward, \(fractional)")
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                if self.collectionView.indexPathForItem(at: nextPoint) != nil {
                    // next grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                } else {
                    // next normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            } else {
                // current normal cell
                if self.collectionView.indexPathForItem(at: nextPoint) != nil {
                    // next grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                } else {
                    // next normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        } else {
            // backward
            printDebug("backward, \(fractional)")
            
            if self.collectionView.indexPathForItem(at: currentPoint) != nil {
                // current grouped cell
                if self.collectionView.indexPathForItem(at: prevPoint) != nil {
                    // prev grouped cell
                    self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                } else {
                    // prev normal cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    }
                }
            } else {
                // current normal cell
                if self.collectionView.indexPathForItem(at: prevPoint) != nil {
                    // prev grouped cell
                    if progress < 0.5 {
                        self.relocateCurrentLocationButton(shouldMoveUp: true, animated: true)
                    } else {
                        self.relocateSwitchButton(shouldMoveUp: true, animated: true)
                    }
                } else {
                    // prev normal cell
                    self.relocateSwitchButton(shouldMoveUp: false, animated: true)
                    self.relocateCurrentLocationButton(shouldMoveUp: false, animated: true)
                }
            }
        }
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func manageMapViewOnScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.tableViewVertical, let mView = self.mapView else {
            return
        }
        
        let yPosition = min(scrollView.contentOffset.y, visibleMapHeightInVerticalMode)
        
        mView.frame = CGRect(x: 0.0, y: -yPosition, width: mView.width, height: mView.height)
        mView.isHidden = scrollView.contentOffset.y > visibleMapHeightInVerticalMode
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
        self.manageMapViewOnScroll(scrollView)
        self.manageFloatingButtonOnPaginationScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
        self.oldScrollPosition = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.manageTopHeader(scrollView)
    }
}

// MARK: - Hotel filter Delegate methods

extension HotelResultVC: HotelFilteVCDelegate {
    func clearAllButtonTapped() {
        self.fetchRequestType = .Searching
        self.filterButton.isSelected = false
        self.loadSaveData()
    }
    
    func doneButtonTapped() {
        self.fetchRequestType = .FilterApplied
        HotelFilterVM.shared.saveDataToUserDefaults()
        printDebug("done button tapped")
        self.filterButton.isSelected = true
        self.getSavedFilter()
        self.loadSaveData()
    }
}

extension HotelResultVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.addMapView()
    }
}

// MARK: - Section Footer Delgate methods

extension HotelResultVC: SectionFooterDelegate {
    func showHotelBeyond() {
        if self.isAboveTwentyKm {
            printDebug("hide hotel beyond ")
            self.isAboveTwentyKm = false
            //  self.hideSection = 1
            // self.footeSection = 2
            self.reloadHotelList()
        } else {
            printDebug("show hotel beyond ")
            self.isAboveTwentyKm = true
            // self.hideSection = 0
            // self.footeSection = 1
            self.reloadHotelList()
        }
    }
}

// MARK: - Hotel Card collection view Delegate methods

extension HotelResultVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        self.viewModel.updateFavourite(forHotels: [forHotel], isUnpinHotels: false)
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        //
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView) {
        printDebug("Hotel page scroll delegate ")
        
        if let cell = tableViewVertical.cellForRow(at: indexPath) as? HotelCardTableViewCell {
            cell.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
        }
    }
}

// MARK: - HotelResultVM Delegate methods

extension HotelResultVC: HotelResultDelegate {
    func willGetPinnedTemplate() {
        //
    }
    
    func getPinnedTemplateSuccess() {
        //
    }
    
    func getPinnedTemplateFail() {
        //
    }
    
    func willUpdateFavourite() {
        //
    }
    
    func updateFavouriteSuccess() {
        self.reloadHotelList()
    }
    
    func updateFavouriteFail() {
        //
    }
    
    func getAllHotelsListResultSuccess(_ isDone: Bool) {
        if !isDone {
            self.viewModel.hotelListOnPreferenceResult()
        } else {
            self.loadSaveData()
            self.getFavouriteHotels()
            let allHotels = self.getHotelsForMapView()
            
            self.floatingView.isHidden = self.favouriteHotels.count < 0
            self.getPinnedHotelTemplate()
            self.time += 1
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            self.updateMarkers()
            self.applyPreviousFilter()
        }
    }
    
    func getAllHotelsListResultFail(errors: ErrorCodes) {
        self.hotelSearchView.isHidden = false
        self.progressView.removeFromSuperview()
        self.shimmerView.removeFromSuperview()
        self.hideFloatingView()
        self.hotelSearchTableView.backgroundView = noHotelFoundEmptyView
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
    
    private func hideButtons() {
        if self.hoteResultViewType == .ListView {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.unPinAllFavouriteButton.isHidden = true
            self.emailButton.isHidden = true
            self.shareButton.isHidden = true
        } else {
            self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.floatingButtonOnMapView.isHidden = true
        }
    }
    
    // Animate button on List View
    
    private func animateFloatingButtonOnListView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                           self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 54, y: 0)
                           self.emailButton.transform = CGAffineTransform(translationX: 108, y: 0)
                           self.shareButton.transform = CGAffineTransform(translationX: 162, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    // Animate Button on map View
    
    private func animateFloatingButtonOnMapView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 65, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    private func animateButton() {
        if self.hoteResultViewType == .ListView {
            self.animateFloatingButtonOnListView()
        } else {
            self.animateFloatingButtonOnMapView()
        }
    }
    
    private func hideFloatingView() {
        self.floatingView.isHidden = true
    }
    
    private func showFloatingView() {
        self.floatingView.isHidden = false
    }
}

extension HotelResultVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        if value {
            if self.hoteResultViewType == .MapView {
                self.floatingButtonOnMapView.isHidden = false
            } else {
                self.unPinAllFavouriteButton.isHidden = false
                self.emailButton.isHidden = false
                self.shareButton.isHidden = false
            }
            self.animateButton()
            self.getFavouriteHotels()
        } else {
            self.hideButtons()
        }
    }
}

extension HotelResultVC: PKBottomSheetDelegate {
    func updateNavWhileInMapMode(isHidden: Bool) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.headerContatinerViewHeightConstraint.constant = isHidden ? 0.0 : 50.0
            self?.tableViewTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.mapContainerTopConstraint.constant = isHidden ? 0.0 : 50.0
            self?.progressView.isHidden = isHidden
            self?.view.layoutIfNeeded()
        }
    }
    
    func willShow(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: true)
    }
    
    func willHide(_ sheet: PKBottomSheet) {
        self.updateNavWhileInMapMode(isHidden: false)
        self.hotelsGroupExpendedVC?.animateCardsToClose()
    }
}

extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sections = self.fetchedResultsController.sections else {
//            printDebug("No sections in fetchedResultsController")
//            return 0
//        }
//        let sectionInfo = sections[section]
//        if sectionInfo.numberOfObjects > 0 {
//            self.shimmerView.removeFromSuperview()
//        }
        return self.getHotelsForMapView().keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])
        
//        self.isAboveTwentyKm = hData.isHotelBeyondTwentyKm
//        self.isFotterVisible = self.isAboveTwentyKm
        
        if hData?.count ?? 1 > 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelGroupCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelGroupCardCollectionViewCell else {
                fatalError("HotelGroupCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData?.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelCardCollectionViewCell.reusableIdentifier, for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelListData = hData?.first
            cell.delegate = self
            cell.shouldShowMultiPhotos = false
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])
        
        if hData?.count ?? 1 > 1 {
            // grouped cell
            return CGSize(width: UIDevice.screenWidth, height: 230.0)
        } else {
            // single cell
            return CGSize(width: UIDevice.screenWidth, height: 200.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? HotelGroupCardCollectionViewCell {
            self.expandGroup((Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched] ?? []))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        printDebug("willDisplay")
        let hData = (Array(self.getHotelsForMapView().values)[indexPath.row] as? [HotelSearched])?.first
        let loc = CLLocationCoordinate2D(latitude: hData!.lat?.toDouble ?? 0.0, longitude: hData?.long?.toDouble ?? 0)
        self.displayingHotelLocation = loc
        updateMarker(coordinates: loc)
    }
}

extension HotelResultVC {
    private func addMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.hotelSearchRequest?.requestParameters.latitude.toDouble ?? 0.0, longitude: viewModel.hotelSearchRequest?.requestParameters.longitude.toDouble ?? 0.0, zoom: 10.0)
        
        let mapRact = CGRect(x: 0.0, y: 0.0, width: mapContainerView.width, height: visibleMapHeightInVerticalMode)
        let mapV = GMSMapView.map(withFrame: mapRact, camera: camera)
        mapView = mapV
        mapV.setMinZoom(1.0, maxZoom: 30.0)
        mapV.animate(toZoom: mapIntitalZoomLabel)
        mapV.isMyLocationEnabled = false
        mapV.delegate = self
        
        mapContainerView.addSubview(mapV)
        
        self.setUpClusterManager()
        self.updateMarkers()
    }
    
    private func addCityLocation() {
        if let loc = self.viewModel.searchedCityLocation {
            let cityMarker = GMSMarker()
            
            let iconView = CityMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 62.0, height: 62.0))
            cityMarker.iconView = iconView
            cityMarker.position = loc
            cityMarker.map = self.mapView
        }
    }
    
    func updateMarkers() {
        self.addCityLocation()
        self.generateClusterItems()
    }
    
    func removeAllMerkers() {
        self.mapView?.clear()
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D) {
        self.mapView?.animate(toLocation: coordinates)
    }
    
    private func setUpClusterManager() {
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        if let mapView = mapView {
            let iconGenerator = GMUDefaultClusterIconGenerator()
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                     clusterIconGenerator: iconGenerator)
            renderer.delegate = self
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                               renderer: renderer)
        }
    }
    
    /// Randomly generates cluster items within some extent of the camera and
    /// adds them to the cluster manager.
    private func generateClusterItems() {
        let hotels = fetchedResultsController.fetchedObjects ?? []
        for hotel in hotels {
            let item = ATClusterItem(position: CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0), hotel: hotel)
            clusterManager.add(item)
        }
    }
}

extension HotelResultVC: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 20)
        mapView.animate(to: camera)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        printDebug("didChange position \(position)")
    }
    
    // MARK: - GMSMarker Dragging
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        printDebug("didBeginDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        printDebug("didDrag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        printDebug("didEndDragging")
    }
}

// MARK: - GMUClusterManagerDelegate

extension HotelResultVC: GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let item = marker.userData as? ATClusterItem, let hotel = item.hotelDetails {
            marker.position = CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0)
            
            printDebug("willRenderMarker \(marker.position)")
            
            let customMarkerView = CustomMarker.instanceFromNib()
            
            customMarkerView.hotel = hotel
            
            if let loc = self.displayingHotelLocation, marker.position.latitude == loc.latitude, marker.position.longitude == loc.longitude {
                customMarkerView.isSelected = true
            } else {
                customMarkerView.isSelected = false
            }
            marker.iconView = customMarkerView
        }
    }
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        let marker = GMSMarker()
        
        let markerView = ClusterMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
        
        if let cluster = object as? GMUStaticCluster, let allItems = cluster.items as? [ATClusterItem], let hotel = allItems.first?.hotelDetails {
            marker.position = CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0)
            
            printDebug("markerFor object \(marker.position)")
            
            markerView.items = allItems
        }
        
        marker.iconView = markerView
        
        return marker
    }
    
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        if let mapView = mapView {
            let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                     zoom: mapView.camera.zoom + 1)
            let update = GMSCameraUpdate.setCamera(newCamera)
            mapView.moveCamera(update)
        }
    }
}
