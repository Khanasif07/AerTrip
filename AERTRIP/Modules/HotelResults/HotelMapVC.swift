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

class HotelMapVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var floatingStackView: UIStackView!
    @IBOutlet var unPinAllFavouriteButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var switchView: ATSwitcher!
    
    @IBOutlet weak var floatingViewleadingConstraint: NSLayoutConstraint!
    var markers: [(marker: CustomMarker, hid: Int)] = []
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var container: NSPersistentContainer!
    var marker = GMSMarker()
    var mapView: GMSMapView?
    let defaultDuration: CGFloat = 2.0
    let defaultDamping: CGFloat = 0.22
    let defaultVelocity: CGFloat = 6.0
    
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
        self.floatingStackView.isHidden = true
        self.switchView.delegate = self
    }
    
    private func setupMapView() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {}
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y + 100, width: UIDevice.screenWidth, height: self.view.frame.size.height - 380), camera: camera)
        
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        mapView?.backgroundColor = .red
        self.view.addSubview((mapView!))
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentLocation?.coordinate.latitude ?? 0.0, longitude: currentLocation?.coordinate.longitude ?? 0.0)
        
        let hotels = fetchedResultsController.fetchedObjects
        for hotel in hotels! {
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
    
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double,hid: Int) {
        // Keep Rotation Short
        CATransaction.begin()
        //CATransaction.setAnimationDuration(4)
       // self.marker.rotation = degrees
        CATransaction.commit()
    
        
        for marker in self.markers {
            if marker.hid == hid {
                marker.marker.priceView.backgroundColor = AppColors.themeGreen
                marker.marker.priceLabel.textColor = AppColors.themeWhite
            } else {
                marker.marker.priceView.backgroundColor = AppColors.themeWhite
                marker.marker.priceLabel.textColor = AppColors.themeGreen
              
            }
        }
        // Movement
        CATransaction.begin()
      //  CATransaction.setAnimationDuration(duration)
        self.marker.position = coordinates
        
        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView?.animate(with: camera)
        
        CATransaction.commit()
    }
    
    func animateButton() {
        self.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.9)
        self.emailButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.9)
        self.shareButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.9)
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.unPinAllFavouriteButton.transform = .identity
                           self.emailButton.transform = .identity
                           self.shareButton.transform = .identity
                       },
                       completion: { _ in
                          printDebug("Animation finished")
        })
    }
    
    @IBAction func setMarkerToCurrentLocaton(_ sender: Any) {}
}

extension HotelMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
    }
}

extension HotelMapVC: GMSMapViewDelegate {
    // MARK: - GMSMarker Dragging
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
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
        updateMarker(coordinates: CLLocationCoordinate2DMake(LocationAtual.coordinate.latitude, LocationAtual.coordinate.longitude), degrees: 10.0, duration: 0,hid:Int(hData.hid ?? "") ?? 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        headerViewTopConstraint.constant = max(-scrollView.contentOffset.y,100)
        // collectionViewTopConstraint.constant  = -200
        
        // let newHeaderHeight =
        printDebug(scrollView.contentOffset.x)
        
        //        printDebug("newHeight is \(newHeight)")
        //        if 0...200 ~= newHeight {
        //            self.collectionView.parallaxHeader.height = newHeight
        //        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        _ = targetContentOffset.pointee.x

//        printDebug("content offset \(scrollView.contentOffset.x)")
//        let currentPoint = CGPoint(x: scrollView.contentOffset.x, y: 0)
//        if let indexPath = self.collectionView.indexPathForItem(at: currentPoint) {
//            let hData = fetchedResultsController.object(at: indexPath)
//            let LocationAtual: CLLocation = CLLocation(latitude: Double(hData.lat ?? "") ?? 0.0, longitude: Double(hData.long ?? "") ?? 0.0)
//            updateMarker(coordinates: CLLocationCoordinate2DMake(LocationAtual.coordinate.latitude, LocationAtual.coordinate.longitude), degrees: 2.0, duration: 4.0,hid: Int(hData.hid ?? "") ?? 0)
//        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == self.collectionView {
//            var currentCellOffset = self.collectionView.contentOffset
//            currentCellOffset.x += self.collectionView.frame.width / 2
//            if let indexPath = self.collectionView.indexPathForItem(at: currentCellOffset) {
//                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//        }
//    }
}

// MARK: - switch did change value

extension HotelMapVC: ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher, value: Bool) {
        if value {
            self.floatingStackView.showViewWithFade()
//            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut, animations: {
//                self.floatingStackView.spacing = 0
//               self.floatingViewleadingConstraint.constant = 0
//            }, completion: nil)
//            self.floatingStackView.spacing = -15
//            self.floatingViewleadingConstraint.constant = 10
            animateButton()
        } else {
            self.floatingStackView.hideViewWithFade()
        }
    }
}
