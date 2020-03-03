//
//  HotelMapVC+AppleMap.swift
//  AERTRIP
//
//  Created by Apple  on 25.02.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import  UIKit
import MapKit

extension HotelsMapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annatation = annotation as? MyAnnotation else {return nil}
        let annotationView = MKAnnotationView(annotation: annatation, reuseIdentifier: "route")
        annotationView.image = returnImageForMarker(annotation: annatation)
        annotationView.canShowCallout = true
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard (view.annotation as? MyAnnotation)?.markerType != .city else {return}
        updateSelectedMarker(view.annotation)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        self.updateRegionMarker()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.updateRegionMarker()
    }
    
    func addGestureRecognizerForTap(){
        
        let tapInterceptor = UITapGestureRecognizer(target: self, action: #selector(tapOnMAp))
        tapInterceptor.numberOfTouchesRequired = 1
        tapInterceptor.delegate = self
        self.appleMap.addGestureRecognizer(tapInterceptor)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        guard gestureRecognizer
        if (touch.view?.isKind(of: MKAnnotationView.self) ?? false){
            return false
        }else{
            return true
        }
    }
    
    @objc func tapOnMAp(_ gesture: UITapGestureRecognizer){
        self.updateFullMarkerView()
    }
    
    func addAllMarker() {
        if self.viewModel.collectionViewLocArr.count != 0{
            guard let location = self.getLocationObject(fromLocation: self.viewModel.collectionViewLocArr.first!) else{return}
            self.setInitailRegionToShow(location: location)
        }
        self.addMakerToMap()
    }
    
    func addMakerToMap(){
        self.addCityLocationMarker()
        self.viewModel.collectionViewList.keys.forEach { (locStr) in
            if let location = self.getLocationObject(fromLocation: locStr), let allHotels = self.viewModel.collectionViewList[locStr] as? [HotelSearched] {
                let marker = MyAnnotation(coordinate: location)
                if allHotels.count == 1 {
                    let customMarkerView = CustomMarker.instanceFromNib()
                    customMarkerView.hotel = allHotels.first!
                    marker.markerImageView = customMarkerView
                    marker.markerType = .customMarker
                    marker.hotel = allHotels.first!
                }else{
                    let markerView = ClusterMarkerView(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
                    markerView.hotelTtems = allHotels
                    markerView.isSelected = false
                    marker.markerType = .clusterMarker
                    marker.hotelTtems = allHotels
                    marker.clusterView = markerView
                }
                self.appleMap.addAnnotation(marker)
            }
        }
        
    }
    
    
    func addCityLocationMarker(){
        if let loc = self.viewModel.searchedCityLocation {
            let view = Bundle.main.loadNibNamed("NewCityMarkerView", owner: self, options: [:])?.first as? NewCityMarkerView
            view?.frame.size.height = 62.0
            view?.frame.size.width = 62.0
            view?.initialSetUp()
            let cityMarker = MyAnnotation(coordinate: loc)
            cityMarker.markerType = .city
            cityMarker.cityMarkerView = view
            self.appleMap.addAnnotation(cityMarker)
        }
    }
    
    func updateRegionMarker(){
        if self.appleMap.annotations.count != 0{
            self.currentMapSpan = self.appleMap.region.span
            isMapZoomNeedToSet = true
        }
        var visibleAnnotation = appleMap.annotations(in: self.appleMap.visibleMapRect).compactMap{$0 as! MyAnnotation}
        print( appleMap.getZoomLevel())
        if appleMap.getZoomLevel() <= 14{
            self.removePreviouseSelected()
            if visibleAnnotation.count >= maxVisblePriceMarker{
                var counter = 1
                
                self.viewModel.collectionViewLocArr.forEach { [weak self] (locStr) in
                    guard let self = self, counter <= maxVisblePriceMarker else {return}
                    if let coordinate = self.getLocationObject(fromLocation: locStr), let annotation = visibleAnnotation.first(where: {self.compareTwoCoordinate(coordinate, $0.coordinate)}){
                        if !detailsShownMarkers.contains(annotation){ detailsShownMarkers.append(annotation)}
                        self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: true)
                        if annotation.markerType != .clusterMarker{
                            counter += 1
                        }
                    }
                }
            }else {
                for annotation in visibleAnnotation{
                    if !detailsShownMarkers.contains(annotation){ detailsShownMarkers.append(annotation)}
                    self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: true)
                }
                
            }
        }else{
            self.removePreviouseSelected()
            visibleAnnotation.forEach { annotation in
                if !detailsShownMarkers.contains(annotation){ detailsShownMarkers.append(annotation)}
                self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: true)
            }
        }
    }
    
    func updateSelectedMarker(_ annotation: MKAnnotation?, isTappedMarker:Bool = true){
        self.removePreviouseSelected()
        guard  let anno = annotation as? MyAnnotation else {return}
        self.updateMarkerImageFor(annotation: anno, isSelected: true, isDetaisShow: true)
        if !self.detailsShownMarkers.contains(anno){
            detailsShownMarkers.forEach { annotation in
                self.updateMarkerImageFor(annotation: annotation, isSelected: false, isDetaisShow: false)
            }
            detailsShownMarkers = []
            detailsShownMarkers.append(anno)
        }
        self.setRegionToShow(location: anno.coordinate)
        updateRegionMarker()
        if isTappedMarker{
            if anno.markerType == .customMarker{
                if let data = anno.hotel {
                    movetoDetailPage(data: data)
                }
            } else if anno.markerType == .clusterMarker {
                if let data = anno.hotelTtems?.first {
                    movetoDetailPage(data: data)
                }
            }
        }
    }
    
    
    
    
    func removePreviouseSelected(){
        var selectedAnnotation = MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
        if let index = self.detailsShownMarkers.firstIndex(where: {($0.markerImageView?.isSelected ?? false)||( $0.clusterView?.isSelected ?? false)}){
            selectedAnnotation = self.detailsShownMarkers[index]
        }
        
        self.detailsShownMarkers.forEach { anno in
            self.updateMarkerImageFor(annotation: anno, isSelected: false, isDetaisShow: false)
        }
        self.detailsShownMarkers = []
        if selectedAnnotation.markerImageView?.connectorView != nil{
            selectedAnnotation.markerImageView?.isSelected = true
            appleMap.view(for: selectedAnnotation)?.image = selectedAnnotation.markerImageView?.asImage() ?? UIImage()
            selectedAnnotation.isSelected = true
            self.detailsShownMarkers.append(selectedAnnotation)
        }else if selectedAnnotation.clusterView?.hotelTtems != nil{
            selectedAnnotation.clusterView?.isSelected = true
            appleMap.view(for: selectedAnnotation)?.image = selectedAnnotation.clusterView?.asImage() ?? UIImage()
            selectedAnnotation.isSelected = true
            self.detailsShownMarkers.append(selectedAnnotation)
        }
    }
    
    
    
    
    
    func updateFavouriteAnnotationDetail(duration: Double, index: Int? = nil, isSwitchOn:Bool = false){
        delay(seconds: duration) { [weak self] in
            guard let self = self else {return}
            let index = index ?? self.getCurrentCollectionIndex()
            if self.viewModel.collectionViewLocArr.indices.contains(index) {
                let locStr = self.viewModel.collectionViewLocArr[index]
                guard let loc = self.getLocationObject(fromLocation: locStr) else{return}
                self.displayingHotelLocation = loc
                guard let currentAnnotation = self.appleMap.annotations.first(where: {self.compareTwoCoordinate($0.coordinate, loc)}) as? MyAnnotation,
                    let hData = self.viewModel.collectionViewList[self.viewModel.collectionViewLocArr[index]] as? [HotelSearched] else {
                        if self.appleMap.annotations.count == 2{ self.updateSeletedUnfavouriteAll() }
                        return
                }
                let switchOn = (!isSwitchOn) ? self.switchView.on : isSwitchOn
                if self.appleMap.annotations.count == 2{
                    self.updateSeletedUnfavouriteAll()
                }else if currentAnnotation.markerType == .clusterMarker{
                    self.updateMarkerImageForFavourite(annotation: currentAnnotation, allHotel: hData, isSwitchOn: switchOn)
                }else{
                    self.updateMarkerImageForFavourite(annotation: currentAnnotation,hotel: hData.first, isSwitchOn: switchOn)
                }
            }
        }
        
    }
    
    func updateSeletedUnfavouriteAll(){
        self.appleMap.removeAnnotations(self.appleMap.annotations)
        self.addAllMarker()
        guard self.viewModel.collectionViewLocArr.count != 0,
            let location = self.getLocationObject(fromLocation: self.viewModel.collectionViewLocArr.first!),
            let anno = self.appleMap.annotations.first(where: {self.compareTwoCoordinate($0.coordinate, location)})else{return}
        self.updateSelectedMarker(anno,isTappedMarker: false)
        
    }
    
    func updateMarkerImageForFavourite(annotation: MyAnnotation,hotel:HotelSearched? = nil, allHotel:[HotelSearched] = [], isSwitchOn:Bool){
        if isSwitchOn{
            for annot in self.appleMap.annotations{
                let coord = "\(annot.coordinate.latitude),\(annot.coordinate.longitude)"
                if !self.viewModel.collectionViewLocArr.contains(coord){
                    self.appleMap.removeAnnotation(annot)
                    return
                }
            }
        }
        else{
            if let hotel = hotel{
                guard let markerView = annotation.markerImageView else {return}
                let isShown = markerView.isDetailsShown
                annotation.hotel = hotel
                markerView.hotel = hotel
                self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: isShown)
            }else{
                guard let markerView = annotation.clusterView else {return}
                annotation.hotelTtems = allHotel
                markerView.hotelTtems = allHotel
                self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: true)
            }
            if self.appleMap.annotations.count == 2{
                self.appleMap.removeAnnotations(self.appleMap.annotations)
                self.addAllMarker()
            }
        }
    }
    
    
    func selecteMarkerOnScrollCollection(location: CLLocationCoordinate2D){
        guard let currentAnnotation = self.appleMap.annotations.first(where: {self.compareTwoCoordinate($0.coordinate, location)}) as? MyAnnotation else {return}
        self.setRegionToShow(location: location)
        self.updateSelectedMarker(currentAnnotation, isTappedMarker: false)
        
    }
    
    
    func returnImageForMarker(annotation: MyAnnotation)->UIImage{
        
        switch annotation.markerType{
        case .clusterMarker:
            let view = annotation.clusterView
            return view?.asImage() ?? UIImage()
        case .city:
            if  let view = annotation.cityMarkerView{
                let img = view.asImage()
                return img
            }
            return UIImage()
        default:
            guard let markerView = annotation.markerImageView else {return UIImage()}
            if  markerView.isDetailsShown || markerView.isSelected{
                detailsShownMarkers.append(annotation)
                return markerView.asImage()
            }else {
                return UIImage(named: "clusterSmallTag") ?? UIImage()
            }
        }
    }
    
    func updateMarkerImageFor(annotation: MyAnnotation, isSelected:Bool, isDetaisShow:Bool){
        
        annotation.isSelected = isSelected
        
        switch annotation.markerType{
            
        case .clusterMarker:
            guard let markerView =  annotation.clusterView else {return}
            markerView.isSelected = isSelected
            let img = markerView.asImage()
            self.appleMap.view(for: annotation)?.image = img
        case .city:break;
        default:
            guard let markerView =  annotation.markerImageView else {return}
                markerView.isDetailsShown = isDetaisShow
            if markerView.connectorView != nil {
                markerView.isSelected = isSelected
            }
            if  markerView.isDetailsShown || markerView.isSelected{

                self.appleMap.view(for: annotation)?.image = markerView.asImage()
            }else {
                self.appleMap.view(for: annotation)?.image = UIImage(named: "clusterSmallTag") ?? UIImage()
            }
        }
    }

    func compareTwoCoordinate(_ first:CLLocationCoordinate2D, _ second: CLLocationCoordinate2D)-> Bool{
        return (first.latitude == second.latitude && first.longitude == second.longitude)
    }
    
    func setRegionToShow(location: CLLocationCoordinate2D){
        if isMapZoomNeedToSet{
            self.appleMap.setRegion(MKCoordinateRegion(center: location, span: self.currentMapSpan), animated: true)
        }
    }
    
    func setInitailRegionToShow(location: CLLocationCoordinate2D){
        self.appleMap.setRegion(MKCoordinateRegion(center: location, latitudinalMeters: 6000, longitudinalMeters: 6000), animated: true)
    }
}

class MyAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    dynamic var title: String?
    dynamic var subtitle: String?
    
    enum TypeOfMarker {
        case dotMarker
        case customMarker
        case clusterMarker
        case city
        case none
    }
    var isSelected  = false
    var hotel: HotelSearched?
    var hotelTtems: [HotelSearched]?
    var markerType:TypeOfMarker = .none
    var markerImageView:CustomMarker?
    var clusterView:ClusterMarkerView?
    var cityMarkerView:NewCityMarkerView?
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}

extension MKMapView {
    private var mercatorRadiu:Double{return 85445659.44705395}
    private var maxZoomLevel:Double{return 20.0}
    func getZoomLevel() -> Double {
        let longitudeDelta = region.span.longitudeDelta
        let mapWidthInPixels = bounds.size.width
        let zoomScale = longitudeDelta * mercatorRadiu * .pi / Double((180.0 * mapWidthInPixels))
        var zoomer = Double(maxZoomLevel - log2(zoomScale))
        if zoomer < 0 {
            zoomer = 0
        }
        return zoomer
    }
}
