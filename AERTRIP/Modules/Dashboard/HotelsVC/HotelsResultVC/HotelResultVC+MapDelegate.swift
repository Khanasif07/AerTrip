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
        
        if mapView == nil {
            //this code will call only once or when mapview in nill
            let camera = GMSCameraPosition.camera(withLatitude: viewModel.hotelSearchRequest?.requestParameters.latitude.toDouble ?? 0.0, longitude: viewModel.hotelSearchRequest?.requestParameters.longitude.toDouble ?? 0.0, zoom: 10.0)

            let mapV = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
            mapView = mapV
            mapContainerView.mapView = mapView
            
            mapView?.delegate = self
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = false
            mapView?.setMinZoom(self.minZoomLabel, maxZoom: self.maxZoomLabel)
            mapView?.animate(toZoom: self.defaultZoomLabel - 4.0)
            
            if self.useGoogleCluster {
                self.setUpClusterManager()
            }
        }
        
        mapView?.frame = mapContainerView.bounds
        
        self.prevZoomLabel = self.minZoomLabel
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
        if self.useGoogleCluster {
            self.generateClusterItems()
        }
        else {
            self.drawMarkers(atZoomLabel: self.defaultZoomLabel)
        }
    }
    
    func removeAllMerkers() {
        self.mapView?.clear()
    }
    
    func focusMarker(coordinates: CLLocationCoordinate2D) {
        self.mapView?.animate(toLocation: coordinates)
    }
    
    func animateZoomLabel() {
        if let currentZoom = self.mapView?.camera.zoom {
            self.mapView?.animate(toZoom: currentZoom + 4.0)
            
            delay(seconds: 0.3) { [weak self] in
                self?.mapView?.animate(toZoom: currentZoom)
            }
        }
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
        let hotels = self.fetchedResultsController.fetchedObjects ?? []
        for hotel in hotels {
            let item = ATClusterItem(position: CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0), hotel: hotel)
            clusterManager.add(item)
        }
        
        if !hotels.isEmpty {
            // if there are some hotels in search result then need to animate the map, to render the markers for first time
            delay(seconds: 0.6) { [weak self] in
                guard let sSelf = self else { return }
                sSelf.mapView?.animate(toZoom: sSelf.defaultZoomLabel)
            }
        }
    }
}

// MARK: - Methods for Marker Ploating

extension HotelResultVC {
    func drawMarkers(atZoomLabel: Float) {
        guard !self.viewModel.collectionViewList.isEmpty else {
            return
        }
        
        self.removeAllMerkers()
        if atZoomLabel >= self.thresholdZoomLabel {
            // draw markers as custom marker
            self.drawAllCustomMarkers()
        }
        else {
            // draw markers as dot marker
            self.drawAllDotMarkers()
        }
    }
    
    func getLocationObject(fromLocation: String) -> CLLocationCoordinate2D? {
        let all = fromLocation.components(separatedBy: ",")
        guard all.count == 2, let lat = all[0].toDouble, let long = all[1].toDouble else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func getString(fromLocation: CLLocationCoordinate2D) -> String {
        return "\(fromLocation.latitude),\(fromLocation.longitude)"
    }
    
    func drawAllCustomMarkers() {
        for locStr in Array(self.viewModel.collectionViewList.keys) {
            if let location = self.getLocationObject(fromLocation: locStr), let allHotels = self.viewModel.collectionViewList[locStr] as? [HotelSearched] {
                if allHotels.count > 1 {
                    // create cluster marker
                    self.addClusterMarker(forHotels: allHotels, atLocation: location)
                }
                else if allHotels.count == 1 {
                    // create custom marker
                    self.addCustomMarker(forHotel: allHotels.first!, atLocation: location)
                }
            }
        }
    }
    
    func drawAllDotMarkers() {
        for locStr in Array(self.viewModel.collectionViewList.keys) {
            if let location = self.getLocationObject(fromLocation: locStr), let allHotels = self.viewModel.collectionViewList[locStr] as? [HotelSearched] {
                if allHotels.count > 1 {
                    // create cluster marker
                    self.addClusterMarker(forHotels: allHotels, atLocation: location)
                }
                else if allHotels.count == 1 {
                    // create dot markers
                    self.addDotMarker(forHotel: allHotels.first!, atLocation: location)
                }
            }
        }
    }
    
    func addDotMarker(forHotel: HotelSearched, atLocation: CLLocationCoordinate2D) {
        if let selected = self.displayingHotelLocation, atLocation.latitude == selected.latitude, atLocation.longitude == selected.longitude {
            // add custom marker
            self.addCustomMarker(forHotel: forHotel, atLocation: atLocation)
        }
        else {
            let marker = GMSMarker(position: atLocation)
            
            let dotView = CustomDotMarker.instanceFromNib()
            dotView.hotel = forHotel
            
            marker.iconView = dotView
            
            marker.map = self.mapView
            
            self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
        }
    }
    
    func addCustomMarker(forHotel: HotelSearched, atLocation: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: atLocation)
        
        let customMarkerView = CustomMarker.instanceFromNib()
        customMarkerView.hotel = forHotel
        
        if let loc = self.displayingHotelLocation, marker.position.latitude == loc.latitude, marker.position.longitude == loc.longitude {
            customMarkerView.isSelected = true
        }
        else {
            customMarkerView.isSelected = false
        }
        marker.iconView = customMarkerView
        
        marker.map = self.mapView
        
        self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
    }
    
    func addClusterMarker(forHotels: [HotelSearched], atLocation: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: atLocation)
        
        let markerView = ClusterMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
        
        markerView.hotelTtems = forHotels
        marker.iconView = markerView
        
        marker.map = self.mapView
        
        self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
    }
    
    func updateMarker(atLocation: CLLocationCoordinate2D, isSelected: Bool = true) {
        guard let marker = self.markersOnLocations[self.getString(fromLocation: atLocation)] as? GMSMarker else {
            return
        }
        
        if let markerView = marker.iconView as? CustomMarker {
            markerView.isSelected = isSelected
            marker.map = self.mapView
            if let currentZoom = self.mapView?.camera.zoom, currentZoom < self.thresholdZoomLabel {
                // make dot marker
                marker.map = nil
                self.addDotMarker(forHotel: markerView.hotel!, atLocation: atLocation)
            }
        }
        else if let markerView = marker.iconView as? CustomDotMarker {
            if isSelected {
                // make custom marker
                marker.map = nil
                self.addCustomMarker(forHotel: markerView.hotel!, atLocation: atLocation)
            }
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
        //draw all markers as the zoom labels
        printDebug("zoom label \(position.zoom)")
        
        if !self.useGoogleCluster {
            let current = position.zoom
            if current > self.prevZoomLabel, ((self.prevZoomLabel...current) ~= self.thresholdZoomLabel) {
                self.drawMarkers(atZoomLabel: current)
            }
            else if current < self.prevZoomLabel, ((current...self.prevZoomLabel) ~= self.thresholdZoomLabel) {
                self.drawMarkers(atZoomLabel: current)
            }
            self.prevZoomLabel = current
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if hoteResultViewType == .MapView {
            if self.isMapInFullView {
                //show collection view list
                self.isHidingOnMapTap = true
                self.isMapInFullView = false

                let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                    guard let sSelf = self else {return}
                    sSelf.collectionViewBottomConstraint.constant = 0.0
                    sSelf.floatingViewBottomConstraint.constant = sSelf.floatingViewInitialConstraint
                    sSelf.mapContainerViewBottomConstraint.constant = 230.0
                    sSelf.mapContainerView.layoutSubviews()
                    sSelf.view.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self](pos) in
                    self?.isHidingOnMapTap = false
                }
                animator.startAnimation()
            }
            else {
                //hide collection view list
                self.isHidingOnMapTap = true
                self.isMapInFullView = true
                
                let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                    guard let sSelf = self else {return}
                    sSelf.collectionViewBottomConstraint.constant = -230.0
                    sSelf.mapContainerViewBottomConstraint.constant = 0.0
                    sSelf.floatingViewBottomConstraint.constant = 0.0
                    sSelf.mapContainerView.layoutSubviews()
                    sSelf.view.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self](pos) in
                    self?.isHidingOnMapTap = false
                }
                animator.startAnimation()
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
            if let lat = data.lat, let long = data.long, let index = Array(self.viewModel.collectionViewList.keys).index(of: "\(lat),\(long)") {
                self.selectedIndexPath = IndexPath(item: index, section: 0)
            }
            AppFlowManager.default.presentHotelDetailsVC(self, hotelInfo: data, sourceView: self.collectionView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
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
            }
            else {
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
