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
    
    // MARK: - Properties
    
    var container: NSPersistentContainer!
    var predicateStr: String = ""
    let maxTime: Float = 10.0
    var currentTime: Float = 0.0
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
        let fetchRequest: NSFetchRequest<HotelSearched> = HotelSearched.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "distance", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "distance", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error {
            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        }
        return fetchedResultsController
    }()
    
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
        self.setupMapView()
       // self.startProgress()
//       let  filteDistance = CoreDataManager.shared.filterData(fromEntity: "HotelSearched", forAttribute: "distance")
        
        //  printDebug(self.viewModel.hotelListResult)
    }
    
   
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        self.setupParallaxHeader()
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 2)
        
        self.reloadHotelList()
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.SemiBold.withSize(13.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = "Mumbai"
        self.descriptionLabel.text = "30 Jun - 1 Jul • 2 Rooms"
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(200.0)
        
        let parallexHeaderMinHeight = CGFloat(0.0)
        
        // header = HotelsResultHeaderView.instanceFromNib()
        
        self.collectionView.parallaxHeader.view = header
        self.collectionView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.collectionView.parallaxHeader.height = parallexHeaderHeight
        self.collectionView.parallaxHeader.mode = MXParallaxHeaderMode.center
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
//        header.mapView = mapView
        
        self.header.addSubview(mapView)
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
        printDebug("searching text is \(forText)")
        self.predicateStr = forText
        self.reloadHotelList()
    }
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
    }
    
    private func startProgress() {
        self.progressView.setProgress(self.currentTime, animated: true)
        perform(#selector(self.updateProgress), with: nil, afterDelay: 1.0)
    }
    
    @objc func updateProgress() {
        self.progressView.progress = self.currentTime / maxTime
        
        if self.maxTime / 3 < self.progressView.progress {
            self.currentTime = self.currentTime + 0.05
            perform(#selector(self.updateProgress), with: nil, afterDelay: 0.20)
        } else {
            print("stop")
            perform(#selector(self.updateProgress), with: nil, afterDelay: 0.01)
            self.currentTime = self.currentTime + 0.20
            return
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
        // return self.viewModel.hotelListResult.count
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        let hData = fetchedResultsController.object(at: indexPath) as? HotelSearched
        
//        cell.hotelListData = self.viewModel.hotelListResult[indexPath.row]
        cell.hotelListData = hData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIDevice.screenWidth, height: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sections = fetchedResultsController.sections else {
            fatalError("section not found")
        }

        if kind == "UICollectionElementKindSectionHeader" {
            if let sectionHeader = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
                sectionHeader.backgroundColor = .red
                sectionHeader.sectionHeaderLabel.text = sections[indexPath.section].name
                return sectionHeader
            }
        }

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
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
        printDebug("done button tapped")
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
            self.predicateStr = ""
            self.reloadHotelList()
        } else {
            self.searchHotels(forText: searchText)
        }
    }
}
