//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import MXParallaxHeader
import UIKit

enum FetchRequestType {
    case FilterApplied
    case Searching
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
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var shimmerView: UIView!
    // MARK: - Properties
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    var time: Float = 0.0
    var timer: Timer?
    private var completion: (() -> Void)? = nil
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
    
    let parallexHeaderHeight = CGFloat(200.0)
    var fetchRequestType: FetchRequestType = .Searching
    
    // MARK: - Public
    
    // MARK: - Private
    
    let viewModel = HotelsResultVM()
    var header = HotelsResultHeaderView.instanceFromNib()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container = NSPersistentContainer(name: "AERTRIP")
        
        self.container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        self.initialSetups()
        self.registerXib()
        delay(seconds: 0.5) {
             self.setupMapView()
        }
       
        self.startProgress()
        self.collectionView.addSubview(shimmerView)
        delay(seconds: 1) {
            self.shimmerView.removeFromSuperview()
        }
        self.completion = { [weak self] in
           self?.loadSaveData()
        }
        self.applyPreviousFilter()
       
        
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        self.setupParallaxHeader()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        
       self.reloadHotelList()
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.SemiBold.withSize(13.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = "New Delhi"
        self.descriptionLabel.text = "30 Jun - 1 Jul • 2 Rooms"
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderMinHeight = CGFloat(0.0)
        
        // header = HotelsResultHeaderView.instanceFromNib()
        
        self.collectionView.parallaxHeader.view = header
        self.collectionView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.collectionView.parallaxHeader.height = parallexHeaderHeight
        self.collectionView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.collectionView.parallaxHeader.delegate = self
    }
    
    private func setupMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: header.frame.origin.x, y: header.frame.origin.y, width: UIDevice.screenWidth, height: 200), camera: camera)
        
        mapView.isMyLocationEnabled = true
        mapView.isUserInteractionEnabled = false
        self.locManager.delegate = self
        self.locManager.startUpdatingLocation()
        mapView.backgroundColor = .red
        
        // self.header.addSubview(mapView)
        self.header.mapImageView.addSubview(mapView)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        
        marker.title = marker.title
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    private func reloadHotelList() {
        self.collectionView.reloadData()
    }
    
    private func searchHotels(forText: String) {
        self.fetchRequestType = .Searching
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.loadSaveData()
        self.reloadHotelList()
    }
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        self.collectionView.register(UINib(nibName: "SectionFooter", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")
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
    
    private func applyPreviousFilter() {
        AppToast.default.showToastMessage(message: LocalizedString.ApplyPreviousFilter.localized, onViewController: self, buttonTitle: LocalizedString.Apply.localized, buttonImage: nil, buttonAction: self.completion)
    }
    
    // MARK: Show progress
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView.setProgress(self.time / 10, animated: true)
        
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        printDebug("timer\(self.timer!)")
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.8) {
                 self.progressView.isHidden = true
            }
           
           
        }
    }
    
    private func loadSaveData() {
        if self.fetchRequestType == .FilterApplied {
            self.fetchedResultsController.fetchRequest.sortDescriptors?.removeAll()
            self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionTitle", ascending: true)]
            guard let  filter = UserInfo.loggedInUser?.hotelFilter else {
              printDebug("filter not found")
                return
                
            }
            switch filter.sortUsing {
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
            
            var amentitiesPredicate: NSPredicate? = nil
            var predicates = [AnyHashable]()
            for amentities: String in filter.amentities {
                predicates.append(NSPredicate(format: "amenities == \(String(amentities))"))
            }
            if predicates.count > 0 {
                if let predicates = predicates as? [NSPredicate] {
                    amentitiesPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                }
            }

              let distancePredicate = NSPredicate(format: "distance <= \(filter.distanceRange)")
            let minimumPricePredicate = NSPredicate(format: "price >= \(HotelFilterVM.shared.minimumPrice)")
//            let maximumPricePredicate = NSPredicate(format: "price <= \(HotelFilterVM.shared.maximumPrice)")
//
            let starPredicate = NSPredicate(format: "star IN %@", HotelFilterVM.shared.ratingCount)
            let tripAdvisorPredicate = NSPredicate(format: "rating IN %@", HotelFilterVM.shared.tripAdvisorRatingCount)
            
//            let amentitiesPredicate = NSPredicate(format: "amenities CONTAINS %@", HotelFilterVM.shared.amenitites)
            
        //  let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [distancePredicate, minimumPricePredicate,starPredicate,tripAdvisorPredicate])
          //  let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [distancePredicate, minimumPricePredicate])
            self.fetchedResultsController.fetchRequest.predicate = amentitiesPredicate
        } else {
            if self.predicateStr == "" {
                self.fetchedResultsController.fetchRequest.predicate = nil
                
            } else {
                self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "hotelName CONTAINS[cd] %@", self.predicateStr)
            }
        }
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC(self)
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
//        self.header.height = UIDevice.screenHeight
//        self.header.layoutIfNeeded()
//        AppFlowManager.default.moveToMapVC(self.viewModel.hotelSearchRequest ?? HotelSearchRequestModel())
    }
}

// MARK: - Collection view datasource and delegate methods

// MARK: -

extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            printDebug("No sections in fetchedResultsController")
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        let hData = fetchedResultsController.object(at: indexPath)
        cell.hotelListData = hData
        cell.indexPath = indexPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         return CGSize(width: UIDevice.screenWidth, height: 53.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (self.fetchedResultsController.sections?.count ?? 0) - 1 == section {
            return CGSize(width: UIDevice.screenWidth, height: 106.0)
        } else {
            return CGSize(width: UIDevice.screenWidth, height: 0.0)
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sections = fetchedResultsController.sections else {
            fatalError("section not found")
        }
        
        if kind == "UICollectionElementKindSectionHeader" {
            if let sectionHeader = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
                sectionHeader.backgroundColor = .clear
                var removeFirstChar = sections[indexPath.section].name
                _ = removeFirstChar.removeFirst()
                sectionHeader.sectionHeaderLabel.text = removeFirstChar + " kms"
                return sectionHeader
            }
        } else if  kind == "UICollectionElementKindSectionFooter" {
            if let sectionFooter = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as? SectionFooter {
               sectionFooter.delegate = self
               sectionFooter.backgroundColor = .white
                return sectionFooter
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  AppFlowManager.default.showHotelDetailsVC()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        headerViewTopConstraint.constant = max(-scrollView.contentOffset.y,100)
        // collectionViewTopConstraint.constant  = -200
        
        // let newHeaderHeight =
        printDebug(scrollView.contentOffset.y)
        let newHeight = parallexHeaderHeight - scrollView.contentOffset.y
//        printDebug("newHeight is \(newHeight)")
//        if 0...200 ~= newHeight {
//            self.collectionView.parallaxHeader.height = newHeight
//        }
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension HotelResultVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        printDebug("progress \(parallaxHeader.progress)")
        
//            if parallaxHeader.progress > 0.5 {
//                 self.headerViewTopConstraint.constant = 0
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.view.layoutIfNeeded()
//                })
//            } else {
//                 self.headerContainerView.y = -100
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.view.layoutIfNeeded()
//                })
//
//            }
    }
}

// MARK: - Hotel filter Delegate methods

extension HotelResultVC: HotelFilteVCDelegate {
    func doneButtonTapped() {
        self.fetchRequestType = .FilterApplied
        HotelFilterVM.shared.saveDataToUserDefaults()
        printDebug("done button tapped")
        self.loadSaveData()
        self.reloadHotelList()
    }
}

extension HotelResultVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.setupMapView()
    }
}

// MARK: - Search bar delegate methods

extension HotelResultVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.fetchRequestType = .Searching
            self.predicateStr = ""
            self.loadSaveData()
            self.reloadHotelList()
        } else {
            self.searchHotels(forText: searchText)
        }
    }
}


// MARK: - Section Footer Delgate methods

extension HotelResultVC : SectionFooterDelegate {
    func showHotelBeyond() {
        printDebug("show hotel beyond ")
    }
    
    
}



