//
//  HotelMapViewController.swift
//  AERTRIP
//
//  Created by apple on 16/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import GoogleMaps
import UIKit

let kClusterItemCount = 50
let kCameraLatitude = 19.0760
let kCameraLongitude = 72.8777

class HotelMapVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var unPinAllFavouriteButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var switchView: ATSwitcher!
    
    var markers: [(marker: CustomMarker, hid: Int)] = []
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var container: NSPersistentContainer!
    var marker = GMSMarker()
    var mapView: GMSMapView?
    let defaultDuration: CGFloat = 1.2
    let defaultDamping: CGFloat = 0.70
    let defaultVelocity: CGFloat = 15.0
    private var clusterManager: GMUClusterManager!
    var hotelSearchRequest: HotelSearchRequestModel?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container = NSPersistentContainer(name: "AERTRIP")
        
        self.container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        self.registerXib()
        self.setupMapView()
        self.initialSetUp()
        // self.setUpClusterManager()
        // self.generateClusterItems()
        //  self.clusterSetUp()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    // MARK: - Helper methods
    
    private func registerXib() {
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
    }
    
    private func initialSetUp() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.switchView.delegate = self
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
    }
    
    private func setupMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y + 100, width: UIDevice.screenWidth, height: self.view.frame.size.height - 420), camera: camera)
        
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        mapView?.backgroundColor = .red
        self.view.addSubview((mapView!))
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        let hotels = fetchedResultsController.fetchedObjects
        for hotel in hotels ?? [] {
            let marker = GMSMarker()
            let LocationAtual: CLLocation = CLLocation(latitude: Double(hotel.lat ?? "") ?? 0.0, longitude: Double(hotel.long ?? "") ?? 0.0)
            marker.position = CLLocationCoordinate2D(latitude: LocationAtual.coordinate.latitude, longitude: LocationAtual.coordinate.longitude)
            marker.title = marker.title
            //  marker.icon = hotel.fav == "0" ? UIImage(named: "clusterSmallTag") : UIImage(named: "favHotelWithShadowMarker")
            let customMarkerView = CustomMarker.instanceFromNib()
            customMarkerView.priceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(hotel.price.delimiter)").addPriceSymbolToLeft(using: AppFonts.SemiBold.withSize(16.0))
            marker.iconView = customMarkerView
            markers.append((marker: customMarkerView, hid: Int(hotel.hid ?? "") ?? 0))
            marker.map = mapView
        }
        self.view.bringSubviewToFront(self.collectionView)
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
    
    private func clusterSetUp() {
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        self.clusterManager.cluster()
        
        self.clusterManager.setDelegate(self, mapDelegate: self)
        
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude, longitude: kCameraLongitude, zoom: 6)
        if let mapView = mapView {
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    /// Randomly generates cluster items within some extent of the camera and
    /// adds them to the cluster manager.
    private func generateClusterItems() {
        let extent = 0.2
        for index in 1...kClusterItemCount {
            let lat = kCameraLatitude + extent * randomScale()
            let lng = kCameraLongitude + extent * randomScale()
            let name = "Item \(index)"
            let item =
                POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
            clusterManager.add(item)
        }
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double, hid: Int) {
        // Keep Rotation Short
//        CATransaction.begin()
//         CATransaction.setAnimationDuration(4)
//         self.marker.rotation = degrees
//        CATransaction.commit()
        
//        for marker in self.markers {
//            if marker.hid == hid {
//                marker.marker.priceView.backgroundColor = AppColors.themeGreen
//                marker.marker.priceLabel.textColor = AppColors.themeWhite
//            } else {
//                marker.marker.priceView.backgroundColor = AppColors.themeWhite
//                marker.marker.priceLabel.textColor = AppColors.themeGreen
//            }
//        }
        // Movement
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(duration)
        self.marker.position = coordinates
        
        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView?.animate(with: camera)
        
//        CATransaction.commit()
    }
    
    private func hideButtons() {
        self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
        self.unPinAllFavouriteButton.isHidden = true
        self.emailButton.isHidden = true
        self.shareButton.isHidden = true
    }
    
    func animateButton() {
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
                           self.emailButton.transform = CGAffineTransform(translationX: 98, y: 0)
                           self.shareButton.transform = CGAffineTransform(translationX: 142, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
}

extension HotelMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
    }
}

// MARK: - Collection view datasource and delegate methods

// MARK: -

extension HotelMapVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hData = fetchedResultsController.object(at: indexPath)
        var LocationAtual: CLLocation = CLLocation(latitude: Double(hData.lat ?? "") ?? 0.0, longitude: Double(hData.long ?? "") ?? 0.0)
        
        updateMarker(coordinates: CLLocationCoordinate2DMake(LocationAtual.coordinate.latitude, LocationAtual.coordinate.longitude), degrees: 10.0, duration: 4, hid: Int(hData.hid ?? "") ?? 0)
    }
    
    //  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //  _ = targetContentOffset.pointee.x
    
//        printDebug("content offset \(scrollView.contentOffset.x)")
//        let currentPoint = CGPoint(x: scrollView.contentOffset.x, y: 0)
//        if let indexPath = self.collectionView.indexPathForItem(at: currentPoint) {
//            let hData = fetchedResultsController.object(at: indexPath)
//            let LocationAtual: CLLocation = CLLocation(latitude: Double(hData.lat ?? "") ?? 0.0, longitude: Double(hData.long ?? "") ?? 0.0)
//            updateMarker(coordinates: CLLocationCoordinate2DMake(LocationAtual.coordinate.latitude, LocationAtual.coordinate.longitude), degrees: 2.0, duration: 4.0,hid: Int(hData.hid ?? "") ?? 0)
//        }
}

// MARK: - switch did change value

extension HotelMapVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        if value {
            self.unPinAllFavouriteButton.isHidden = false
            self.emailButton.isHidden = false
            self.shareButton.isHidden = false
            self.animateButton()
        } else {
            self.hideButtons()
        }
    }
}

// MARK: - GMUClusterRendererDelegate

extension HotelMapVC: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData is GMUCluster {} else {
            marker.icon = #imageLiteral(resourceName: "clusterSmallTag")
        }
    }
}

// MARK: - GMUMapViewDelegate

extension HotelMapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            printDebug("Did tap marker for cluster item \(poiItem.name)")
        } else {
            printDebug("Did tap a normal marker")
        }
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 20)
        mapView.animate(to: camera)
        
        return true
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

extension HotelMapVC: GMUClusterManagerDelegate {
    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        if let mapView = mapView {
            let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                     zoom: mapView.camera.zoom + 1)
            let update = GMSCameraUpdate.setCamera(newCamera)
            mapView.moveCamera(update)
        }
    }
}
