//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import GoogleMaps
import MXParallaxHeader
import UIKit

class HotelResultVC: BaseVC {
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var headerContainerView: UIView!
    @IBOutlet var navContainerView: UIView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
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
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.setupMapView()
        printDebug(self.viewModel.hotelListResult)
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        self.setupParallaxHeader()
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
            CLLocationManager.authorizationStatus() == .authorizedAlways {
        }
        
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.hotelListResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        cell.hotelData = nil
        cell.hotelListData = self.viewModel.hotelListResult[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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


extension HotelResultVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        printDebug("location \(String(describing: locations.last))")
        self.currentLocation = locations.last
        self.setupMapView()
    }
}
