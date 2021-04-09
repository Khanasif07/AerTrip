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
    }
    
    func animateZoomLabel() {
//        if let currentZoom = self.mapView?.camera.zoom {
//            self.mapView?.animate(toZoom: currentZoom + 4.0)
//
//            delay(seconds: 0.3) { [weak self] in
//                self?.mapView?.animate(toZoom: currentZoom)
//            }
//        }
    }
    
    func adjustMapPadding() {
//        self.mapView?.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
        
    func showHotelOnMap(duration: Double, index: Int? = nil) {
        delay(seconds: duration) { [weak self] in
            guard let strongSelf = self else {return}
            let indexOfMajorCell = index ?? strongSelf.getCurrentCollectionIndex()
            strongSelf.manageForCollectionView(atIndex: indexOfMajorCell)
        }
    }
}

// MARK: - Methods for Marker Ploating

extension HotelsMapVC {
    func isMarkerWithinScreen(markerPosition: CLLocationCoordinate2D) -> Bool {
//        guard let region = self.mapView?.projection.visibleRegion() else {return false}
//
//        let bounds = GMSCoordinateBounds(region: region)
//        return bounds.contains(markerPosition)
        return false
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
}

extension HotelsMapVC: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        guard let lat = mapView.myLocation?.coordinate.latitude,
//            let lng = mapView.myLocation?.coordinate.longitude else { return false }
//        
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: self.mapView?.camera.zoom ?? 20)
//        mapView.animate(to: camera)
        
        return true
    }
    
    func updateFullMarkerView(){
        
        if self.isMapInFullView {
            //show collection view list
            self.isHidingOnMapTap = true
            self.isMapInFullView = false
            //self.currentLocationButton.isHidden = false
            let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                guard let sSelf = self else {return}
                sSelf.collectionViewBottomConstraint.constant = 0.0
                sSelf.floatingViewBottomConstraint.constant = 183.0
                sSelf.mapContainerViewBottomConstraint.constant = (!UIDevice.isIPhoneX) ? 173.0 : 207.0
                sSelf.headerContainerViewTopConstraint.constant = 0.0
                sSelf.mapContainerTopConstraint.constant = (!UIDevice.isIPhoneX) ? 70.0 : 94.0
                sSelf.mapContainerView.layoutSubviews()
                sSelf.hotelsMapCV.backgroundColor = AppColors.clear
                sSelf.view.layoutIfNeeded()
            }
            
            animator.addCompletion { [weak self](pos) in
                self?.isHidingOnMapTap = false
                DispatchQueue.main.async {
                    self?.removeBlur()
                }
            }
            animator.startAnimation()
            self.showHotelOnMap(duration: 0.4)
            
            FirebaseEventLogs.shared.logHotelMapViewEvents(with: .ShowElementsOnMapClick)
        }
        else {
            //hide collection view list
            self.isHidingOnMapTap = true
            self.isMapInFullView = true
            let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) { [weak self] in
                guard let sSelf = self else {return}
                sSelf.collectionViewBottomConstraint.constant = -300.0
                sSelf.mapContainerViewBottomConstraint.constant = 0.0
                sSelf.floatingViewBottomConstraint.constant = 0.0
                sSelf.headerContainerViewTopConstraint.constant = -300.0
                sSelf.mapContainerTopConstraint.constant = 0.0
                sSelf.mapContainerView.layoutSubviews()
                sSelf.hotelsMapCV.backgroundColor = AppColors.themeWhite
                sSelf.view.layoutIfNeeded()
            }
            
            animator.addCompletion { [weak self](pos) in
                self?.isHidingOnMapTap = false
                DispatchQueue.main.async {
                    self?.addBlurView()
                }
            }
            animator.startAnimation()
            
            FirebaseEventLogs.shared.logHotelMapViewEvents(with: .HideElementsOnMapClick)
        }
        printDebug("Coordinate on tapped")
    }
    
    
    
    // MARK: - GMSMarker Dragging
    
    func movetoDetailPage(data: HotelSearched, isNeedToOpen:Bool = true) {
        if let lat = data.lat, let long = data.long, let index = Array(self.viewModel.collectionViewList.keys).firstIndex(of: "\(lat),\(long)") , let scrollIndex = self.viewModel.collectionViewLocArr.firstIndex(of: "\(lat),\(long)"){
            let index = IndexPath(item: scrollIndex, section: 0)
            self.selectedIndexPath = index
            guard let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[index.item]] as? [HotelSearched] else {return}
            self.hotelsMapCV.scrollToItem(at: IndexPath(item: scrollIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.hotelsMapCV.setNeedsDisplay()
            guard isNeedToOpen else {return}
            if hData.count > 1 {
                self.expandGroup((self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[index.row]] as? [HotelSearched]) ?? [])
            } else {
                delay(seconds: 0.2) {
                    if let cell = self.hotelsMapCV.cellForItem(at: IndexPath(item: scrollIndex, section: 0)) as? HotelCardCollectionViewCell{
                        //self.presentController(cell: cell, hotelInfo: data, sid:  self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest)
                        AppFlowManager.default.presentHotelDetailsVC(self, hotelInfo: data, sid: self.viewModel.sid, hotelSearchRequest: self.viewModel.hotelSearchRequest, filterParams: self.viewModel.getFilterParams(), searchFormData: self.viewModel.searchedFormData)
                    }
                }
            }
        }
    }
}
