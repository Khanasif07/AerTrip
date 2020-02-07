//
//  HotelResultVC+MapDelegate.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
// marker.tracksViewChanges = false
extension HotelsMapVC {
    
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
            
//            mapView?.delegate = self
            mapView?.isMyLocationEnabled = true
            mapView?.settings.myLocationButton = false
            mapView?.setMinZoom(self.minZoomLabel, maxZoom: self.maxZoomLabel)
            mapView?.animate(toZoom: self.defaultZoomLabel)
            
        }
        
        mapView?.frame = mapContainerView.bounds
        
        self.prevZoomLabel = self.minZoomLabel
        
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
        self.drawMarkers(atZoomLabel: self.mapView?.camera.zoom ?? self.defaultZoomLabel)
    }
    
    func removeAllMerkers() {
        self.mapView?.clear()
        self.markersOnLocations.removeAll()
        printDebug("map pins cleared")
    }
    
    func hideMarker() {
        self.markersOnLocations.keys.forEach { (locStr) in
            if let marker = self.markersOnLocations[locStr] as? HotelMarker {
                if self.viewModel.collectionViewList.keys.contains(locStr) {
                    marker.opacity = 1.0
                } else {
                    marker.opacity = 0.0
                }
            }
        }
    }
    func focusMarker(coordinates: CLLocationCoordinate2D) {
            CATransaction.begin()
            CATransaction.setValue(AppConstants.kAnimationDuration, forKey: kCATransactionAnimationDuration)
            self.mapView?.animate(toLocation: coordinates)
            CATransaction.commit()
    }
    
    func animateZoomLabel() {
        if let currentZoom = self.mapView?.camera.zoom {
            self.mapView?.animate(toZoom: currentZoom + 4.0)
            
            delay(seconds: 0.3) { [weak self] in
                self?.mapView?.animate(toZoom: currentZoom)
            }
        }
    }
    
    func adjustMapPadding() {
            self.mapView?.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func updateMarker(atIndex: Int) {
        
        if self.viewModel.collectionViewLocArr.indices.contains(atIndex) {
            let locStr = self.viewModel.collectionViewLocArr[atIndex]
            if let loc = self.getLocationObject(fromLocation: locStr) {
                self.updateMarker(atLocation: loc, isSelected: false)
            }
        }
    }
}

// MARK: - Methods for Marker Ploating

extension HotelsMapVC {
    func drawMarkers(atZoomLabel: Float, didChange: Bool = false) {
        guard !self.viewModel.collectionViewList.isEmpty else {
            return
        }
        
        if !didChange {
            self.removeAllMerkers()
            self.addCityLocation()
            self.drawAllCustomMarkers()
        }
        
        
        if atZoomLabel >= self.thresholdZoomLabel {
            // draw markers as custom marker
            if didChange {
                updateMarkerViewForZoomInState(forZoomInState: true)
            }
        }
        else {
            // draw markers as dot marker
            //self.drawAllDotMarkers(showFirstMarker: hoteResultViewType != .MapView)
            //            self.drawAllCustomMarkers(showFirstMarker: hoteResultViewType != .MapView)
//            if didChange {
                updateMarkerViewForZoomInState(forZoomInState: false)
//            }
        }
        
    }
    
    func updateMarkerViewForZoomInState(forZoomInState: Bool) {
        var counter = 0
        var visibleMarkerList: [HotelMarker] = []
        
        self.markersOnLocations.keys.forEach { [weak self] (locStr) in
            guard let strongSelf = self else {return}
            if let marker = strongSelf.markersOnLocations[locStr] as? HotelMarker {
                if strongSelf.isMarkerWithinScreen(markerPosition: marker.position) {
                    if forZoomInState {
                        if marker.markerType == .dotMarker {
                            marker.map = nil
                            strongSelf.markersOnLocations[strongSelf.getString(fromLocation: marker.position)] = nil
                            strongSelf.addCustomMarker(forHotel: marker.hotel!, atLocation: marker.position, showHotelPrice: false)
                        } else if marker.markerType == .customMarker {
                            strongSelf.updateMarker(atLocation: marker.position, isSelected: false)
                        }
                    } else {
                        visibleMarkerList.append(marker)
                        //                        show top max marker
                        //                        if counter < maxVisblePriceMarker {
                        //                            if marker.markerType == .dotMarker {
                        //                                marker.map = nil
                        //                                self.markersOnLocations[self.getString(fromLocation: marker.position)] = nil
                        //                                self.addCustomMarker(forHotel: marker.hotel!, atLocation: marker.position, showHotelPrice: false)
                        //                                counter += 1
                        //                            } else if marker.markerType == .customMarker {
                        //                                //self.updateMarker(atLocation: marker.position, isSelected: false)
                        //                                counter += 1
                        //                            }
                        //
                        //                        } else {
                        //                            if marker.markerType == .customMarker {
                        //                                self.updateMarker(atLocation: marker.position, isSelected: false)
                        //                            }
                        //                        }
                    }
                } else {
                    if marker.markerType == .customMarker {
                        strongSelf.updateMarker(atLocation: marker.position, isSelected: false)
                    }
                }
            }
        }
        
        if !forZoomInState {
            var showPerNightPrice = false
            if  let filter = UserInfo.hotelFilter, filter.priceType == .PerNight {
                showPerNightPrice = true
            }
            let isDistanceFilterApplied = self.viewModel.filterApplied.sortUsing == .DistanceNearestFirst
            
            visibleMarkerList.sort { [weak self] (marker1, marker2) -> Bool in
                guard let strongSelf = self else {return false}
                //                printDebug("hotel price")
                //                printDebug(showPerNightPrice ? marker1.hotel?.perNightPrice : marker1.hotel?.price)
                //                printDebug(showPerNightPrice ? marker2.hotel?.perNightPrice : marker2.hotel?.price)
                //                printDebug("hotel distance")
                //                printDebug((marker1.hotel?.distance ?? 0.0))
                //                printDebug((marker2.hotel?.distance ?? 0.0))
                if marker1.markerType == .clusterMarker || marker2.markerType == .clusterMarker {
                    return true
                }
                if isDistanceFilterApplied {
                    return (marker1.hotel?.distance ?? 0.0) < (marker2.hotel?.distance ?? 0.0)
                } else {
                    let m1Price = showPerNightPrice ? (marker1.hotel?.perNightPrice ?? 0.0) : (marker1.hotel?.price ?? 0.0)
                    let m2Price = showPerNightPrice ? (marker2.hotel?.perNightPrice ?? 0.0) : (marker2.hotel?.price ?? 0.0)
                    return m1Price < m2Price
                }
            }
            
            visibleMarkerList.forEach { [weak self] (marker) in
                guard let strongSelf = self else {return}
                if isDistanceFilterApplied {
                    printDebug("distance after sorting")
                    printDebug((marker.hotel?.distance ?? 0.0))
                } else {
                    printDebug("Price after sorting")
                    printDebug(showPerNightPrice ? marker.hotel?.perNightPrice : marker.hotel?.price)
                }
                
                if counter < maxVisblePriceMarker {
                    if marker.markerType == .dotMarker {
                        marker.map = nil
                        strongSelf.markersOnLocations[strongSelf.getString(fromLocation: marker.position)] = nil
                        strongSelf.addCustomMarker(forHotel: marker.hotel!, atLocation: marker.position, showHotelPrice: false)
                        counter += 1
                    } else if marker.markerType == .customMarker {
                        //self.updateMarker(atLocation: marker.position, isSelected: false)
                        counter += 1
                    }
                    
                } else {
                    if marker.markerType == .customMarker {
                        strongSelf.updateMarker(atLocation: marker.position, isSelected: false)
                    }
                }
            }
        }
                
    }
        
    func isMarkerWithinScreen(markerPosition: CLLocationCoordinate2D) -> Bool {
        guard let region = self.mapView?.projection.visibleRegion() else {return false}
        
        let bounds = GMSCoordinateBounds(region: region)
        return bounds.contains(markerPosition)
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
    
    func drawAllCustomMarkers(showAccordingToMap: Bool = false) {
            var counter = 0
            self.viewModel.collectionViewList.keys.forEach { (locStr) in
                if let location = self.getLocationObject(fromLocation: locStr), let allHotels = self.viewModel.collectionViewList[locStr] as? [HotelSearched] {
                    if counter < maxVisblePriceMarker {
                        if allHotels.count > 1 {
                            // create cluster marker
                            self.addClusterMarker(forHotels: allHotels, atLocation: location)
                        }
                        else if allHotels.count == 1 {
                            // create custom marker
                            self.addCustomMarker(forHotel: allHotels.first!, atLocation: location, showHotelPrice: false)
                            counter += 1
                        }
                    } else {
                        if allHotels.count > 1 {
                            // create cluster marker
                            self.addClusterMarker(forHotels: allHotels, atLocation: location)
                        }
                        else if allHotels.count == 1 {
                            // create dot marker
                            self.addDotMarker(forHotel: allHotels.first!, atLocation: location)
                            
                        }
                    }
                }
            }
    }
    
    func drawAllDotMarkers(showFirstMarker: Bool = false) {
        if showFirstMarker {
            if let firstLoc = self.viewModel.collectionViewLocArr.first,let location = self.getLocationObject(fromLocation: firstLoc), let allHotels = self.viewModel.collectionViewList[firstLoc] as? [HotelSearched] {
                self.addDotMarker(forHotel: allHotels.first!, atLocation: location)
                self.displayingHotelLocation = location
            }
        } else {
            self.viewModel.collectionViewList.keys.forEach { (locStr) in
                if let location = self.getLocationObject(fromLocation: locStr), let allHotels = self.viewModel.collectionViewList[locStr] as? [HotelSearched] {
                    //                if allHotels.count > 1 {
                    //                    // create cluster marker
                    //                    self.addClusterMarker(forHotels: allHotels, atLocation: location)
                    //                }
                    //                else if allHotels.count == 1 {
                    // create dot markers
                    self.addDotMarker(forHotel: allHotels.first!, atLocation: location)
                    
                    //                }
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
            let marker = HotelMarker(position: atLocation)
            
            let dotView = CustomDotMarker.instanceFromNib()
            dotView.hotel = forHotel
            
            //            marker.iconView = dotView
            marker .icon = dotView.asImage()
            marker.markerType = .dotMarker
            marker.hotel = forHotel
            marker.map = self.mapView
            marker.isFlat = true
            marker.tracksViewChanges = false
            
            self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
        }
    }
    
    func addCustomMarker(forHotel: HotelSearched, atLocation: CLLocationCoordinate2D, isSelected: Bool = false, showHotelPrice: Bool = false ) {
        let marker = HotelMarker(position: atLocation)
        
        let customMarkerView = CustomMarker.instanceFromNib()
        customMarkerView.hotel = forHotel
        
        if let loc = self.displayingHotelLocation, marker.position.latitude == loc.latitude, marker.position.longitude == loc.longitude {
            if isMapInFullView {
                customMarkerView.isSelected = false
            }else {
                customMarkerView.isSelected = true
            }
        }
        else {
            customMarkerView.isSelected = isSelected
        }
        //        marker.iconView = customMarkerView
        marker.icon = customMarkerView.asImage()
        marker.markerType = .customMarker
        marker.hotel = forHotel
        marker.map = self.mapView
        marker.isFlat = true
        marker.tracksViewChanges = false
        marker.showHotelPrice = showHotelPrice
        marker.zIndex = isSelected ? 1000 : 500
        self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
    }
    
    func addClusterMarker(forHotels: [HotelSearched], atLocation: CLLocationCoordinate2D, isSelected: Bool = false) {
        let marker = HotelMarker(position: atLocation)
        
        let markerView = ClusterMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
        
        markerView.hotelTtems = forHotels
        markerView.isSelected = isSelected
        //        marker.iconView = markerView
        marker.icon = markerView.asImage()
        //marker.iconView?.contentMode = .scaleAspectFill
        marker.markerType = .clusterMarker
        marker.hotelTtems = forHotels
        marker.map = self.mapView
        marker.isFlat = true
        marker.tracksViewChanges = false
        marker.zIndex = 1000
        self.markersOnLocations[self.getString(fromLocation: atLocation)] = marker
    }
    
    func updateMarker(atLocation: CLLocationCoordinate2D, isSelected: Bool = true) {
        
        guard let marker = self.markersOnLocations[self.getString(fromLocation: atLocation)] as? HotelMarker else {
            return
        }
        
        if marker.markerType == .customMarker {
            //            let value = markerView.hotel
            //            markerView.hotel = value
            var markerSelected = false
            if isMapInFullView {
                markerSelected = false
            } else {
                markerSelected = isSelected
            }
            marker.map = nil
            self.markersOnLocations[self.getString(fromLocation: atLocation)] = nil
            if let currentZoom = self.mapView?.camera.zoom, currentZoom < self.thresholdZoomLabel, !marker.showHotelPrice {
                // make dot marker
                marker.map = nil
                self.addDotMarker(forHotel: marker.hotel!, atLocation: atLocation)
            }else {
                self.addCustomMarker(forHotel: marker.hotel!, atLocation: atLocation,isSelected: markerSelected, showHotelPrice: marker.showHotelPrice)
            }
        }
        else if marker.markerType == .dotMarker {
            if isSelected {
                // make custom marker
                marker.map = nil
                self.markersOnLocations[self.getString(fromLocation: atLocation)] = nil
                self.addCustomMarker(forHotel: marker.hotel!, atLocation: atLocation, showHotelPrice: marker.showHotelPrice)
            }
        }else if marker.markerType == .clusterMarker {
            //            let value = markerView.hotelTtems
            //            markerView.hotelTtems = value
            var markerSelected = false
            if isMapInFullView {
                markerSelected = false
            } else {
                markerSelected = isSelected
            }
            marker.map = nil
            self.markersOnLocations[self.getString(fromLocation: atLocation)] = nil
            self.addClusterMarker(forHotels: marker.hotelTtems!, atLocation: atLocation, isSelected: markerSelected)
            
            //            if isSelected {
            //                // make custom marker
            //                marker.map = nil
            //                self.addClusterMarker(forHotels: markerView.hotelTtems, atLocation: atLocation)
            //            }
        }
        
    }
    
    func deleteMarker(atLocation: CLLocationCoordinate2D) {
        guard let marker = self.markersOnLocations[self.getString(fromLocation: atLocation)] as? HotelMarker else {
            return
        }
        marker.map = nil
        self.markersOnLocations[self.getString(fromLocation: atLocation)] = nil
        
    }
}

extension HotelsMapVC: GMSMapViewDelegate {
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
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(mapViewChanged), with: nil, afterDelay: 0.3)
        /*
         let current = position.zoom
         if hoteResultViewType == .MapView {
         if !self.useGoogleCluster {
         if current > self.prevZoomLabel, ((self.prevZoomLabel...current) ~= self.thresholdZoomLabel) {
         self.drawMarkers(atZoomLabel: current)
         }
         else if current < self.prevZoomLabel, ((current...self.prevZoomLabel) ~= self.thresholdZoomLabel) {
         self.drawMarkers(atZoomLabel: current)
         } else if current >= self.thresholdZoomLabel {
         self.drawMarkers(atZoomLabel: current,didChange: true)
         }
         }
         }
         self.prevZoomLabel = current
         */
    }
    
    @objc func mapViewChanged() {
        guard let current = self.mapView?.camera.zoom else {return}
        printDebug("mapViewChanged \(current)")
        
//        if hoteResultViewType == .MapView {
            //            if !self.useGoogleCluster {
            //                if current > self.prevZoomLabel, ((self.prevZoomLabel...current) ~= self.thresholdZoomLabel) {
            //                    self.drawMarkers(atZoomLabel: current)
            //                }
            //                else if current < self.prevZoomLabel, ((current...self.prevZoomLabel) ~= self.thresholdZoomLabel) {
            //                    self.drawMarkers(atZoomLabel: current)
            //                } else if current >= self.thresholdZoomLabel {
            //                    self.drawMarkers(atZoomLabel: current,didChange: true)
            //                }
            //            }
            self.drawMarkers(atZoomLabel: current,didChange: true)
//        }
        self.prevZoomLabel = current
        
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            if self.isMapInFullView {
                //show collection view list
                self.isHidingOnMapTap = true
                self.isMapInFullView = false
                self.currentLocationButton.isHidden = false
                let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                    guard let sSelf = self else {return}
                    sSelf.collectionViewBottomConstraint.constant = 0.0
                    sSelf.floatingViewBottomConstraint.constant = sSelf.floatingViewInitialConstraint
                    sSelf.mapContainerViewBottomConstraint.constant = 230.0
                    sSelf.headerContainerViewTopConstraint.constant = 0.0
                    sSelf.mapContainerTopConstraint.constant = 50.0
                    sSelf.mapContainerView.layoutSubviews()
                    //sSelf.view.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self](pos) in
                    self?.isHidingOnMapTap = false
                    if let loc = self?.displayingHotelLocation {
                        self?.updateMarker(atLocation: loc)
                    }
                }
                animator.startAnimation()
            }
            else {
                //hide collection view list
                self.isHidingOnMapTap = true
                self.isMapInFullView = true
                self.currentLocationButton.isHidden = true
                if let loc = displayingHotelLocation {
                    self.updateMarker(atLocation: loc,isSelected: false)
                }
                let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                    guard let sSelf = self else {return}
                    sSelf.collectionViewBottomConstraint.constant = -300.0
                    sSelf.mapContainerViewBottomConstraint.constant = 0.0
                    sSelf.floatingViewBottomConstraint.constant = 0.0
                    sSelf.headerContainerViewTopConstraint.constant = -300.0
                    sSelf.mapContainerTopConstraint.constant = 0.0
                    sSelf.mapContainerView.layoutSubviews()
                    sSelf.view.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self](pos) in
                    self?.isHidingOnMapTap = false
                }
                animator.startAnimation()
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
        guard let hotelMarker = marker as? HotelMarker else { return  true}
        if hotelMarker.markerType == .customMarker || hotelMarker.markerType == .dotMarker {
            if let data = hotelMarker.hotel {
                movetoDetailPage(data: data)
            }
        } else if hotelMarker.markerType == .clusterMarker {
            if let data = hotelMarker.hotelTtems?.first {
                movetoDetailPage(data: data)
            }
        }
        
        return true
    }
    
    private func movetoDetailPage(data: HotelSearched) {
        if let lat = data.lat, let long = data.long, let index = Array(self.viewModel.collectionViewList.keys).firstIndex(of: "\(lat),\(long)") {
            let index = IndexPath(item: index, section: 0)
            self.selectedIndexPath = index
            guard let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[index.item]] as? [HotelSearched] else {return}
            if hData.count > 1 {
                self.expandGroup((self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[index.row]] as? [HotelSearched]) ?? [])
            } else {
                AppFlowManager.default.presentHotelDetailsVC(self, hotelInfo: data, sourceView: self.collectionView, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
            }
        }
    }
}

// MARK: - GMUClusterManagerDelegate

//extension HotelsMapVC: GMUClusterManagerDelegate, GMUClusterRendererDelegate {
//    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
//        if let item = marker.userData as? ATClusterItem, let hotel = item.hotelDetails {
//            marker.position = CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0)
//
//            printDebug("willRenderMarker \(marker.position)")
//
//            let customMarkerView = CustomMarker.instanceFromNib()
//
//            customMarkerView.hotel = hotel
//
//            if let loc = self.displayingHotelLocation, marker.position.latitude == loc.latitude, marker.position.longitude == loc.longitude {
//                customMarkerView.isSelected = true
//            }
//            else {
//                customMarkerView.isSelected = false
//            }
//            // marker.iconView = customMarkerView
//            marker.icon = customMarkerView.asImage()
//
//        }
//    }
//
//    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
//        let marker = GMSMarker()
//
//        let markerView = ClusterMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
//
//        if let cluster = object as? GMUStaticCluster, let allItems = cluster.items as? [ATClusterItem], let hotel = allItems.first?.hotelDetails {
//            marker.position = CLLocationCoordinate2D(latitude: hotel.lat?.toDouble ?? 0.0, longitude: hotel.long?.toDouble ?? 0.0)
//
//            printDebug("markerFor object \(marker.position)")
//
//            markerView.items = allItems
//        }
//
//        //        marker.iconView = markerView
//        marker.icon = markerView.asImage()
//
//        return marker
//    }
//
//    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
//        if let mapView = mapView {
//            let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
//                                                     zoom: mapView.camera.zoom + 1)
//            let update = GMSCameraUpdate.setCamera(newCamera)
//            mapView.moveCamera(update)
//        }
//    }
//}



class HotelMarker: GMSMarker {
    
    enum TypeOfMarker {
        case dotMarker
        case customMarker
        case clusterMarker
        case none
    }
    
    var hotel: HotelSearched?
    var hotelTtems: [HotelSearched]?
    var markerType = TypeOfMarker.none
    var showHotelPrice = false
    
    deinit {
        self.map = nil
        self.icon = nil
        printDebug("HotelMarker deinit")
    }
    
}
