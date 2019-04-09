//
//  HotelResultVC+MapDelegate.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelResultVC {
    func addMapView() {
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
            
            let iconView = CityMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 62.0, height: 62.0), shouldAddRippel: false)
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
    
  
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if hoteResultViewType == .MapView {
            if self.isMapInFullView == false {
                UIView.animate(withDuration: 0.4) { [weak self] in
                    self?.collectionView.isHidden = true
                    self?.collectionViewHeightConstraint.constant = 0
                    self?.collectionView.alpha = 0
                    self?.floatingViewBottomConstraint.constant = 10
                    self?.isMapInFullView = true
                }
           
            } else {
                UIView.animate(withDuration: 0.4) { [weak self] in
                    self?.collectionView.isHidden = false
                    self?.collectionViewHeightConstraint.constant = 230
                    self?.floatingViewBottomConstraint.constant = self?.floatingViewInitialConstraint ?? 0.0
                    self?.isMapInFullView = false
                    self?.collectionView.alpha = 1
                }
               
            }
        }
        printDebug("Coordinate on tapped")
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let clusterItem = marker.userData as? ATClusterItem, let data = clusterItem.hotelDetails {
            AppFlowManager.default.presentHotelDetailsVC(self,hotelInfo: data, sourceView: self.collectionView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
        }
        return true
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
