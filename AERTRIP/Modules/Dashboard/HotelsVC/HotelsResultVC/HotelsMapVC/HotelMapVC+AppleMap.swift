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
        let annotationView = ResistantAnnotationView(annotation: annatation, reuseIdentifier: "route")
        let image = returnImageForMarker(annotation: annatation)
        annotationView.image = image
        annotationView.canShowCallout = true
        annotationView.isUserInteractionEnabled = true
        annotationView.centerOffset = CGPoint(x: 0, y: -image.size.height / 2);
        if annatation.markerType == .city {
            annotationView.centerOffset = CGPoint(x: 0, y: 0);
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard (view.annotation as? MyAnnotation)?.markerType != .city else {return}
        updateSelectedMarker(view.annotation)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        self.updateRegionMarker()
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        self.moveLegalLabel()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.updateRegionMarker()
        self.hideUnhideCurrentLocationBtn()
        self.moveLegalLabel()
    }
    
    func addGestureRecognizerForTap(){
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomInGesture))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        self.appleMap.addGestureRecognizer(doubleTapGesture)
        
        let tapInterceptor = UITapGestureRecognizer(target: self, action: #selector(tapOnMAp))
        tapInterceptor.numberOfTapsRequired = 1
        tapInterceptor.numberOfTouchesRequired = 1
        tapInterceptor.delegate = self
        tapInterceptor.require(toFail: doubleTapGesture)
        self.appleMap.addGestureRecognizer(tapInterceptor)
        
        
    }
    
    
    func moveLegalLabel() {
        if self.appleMap.subviews.count > 2{// && !isMapInFullView
            let mapLogoView: UIView = self.appleMap.subviews[1]
            let legalLabel: UIView = self.appleMap.subviews[2]
            let mapLogoY = self.appleMap.height - mapLogoView.height - 7
            let legalLabelY = self.appleMap.height - legalLabel.height - 11
            let nextLegalLabeYPosition = self.isMapInFullView ? legalLabelY + 30 : legalLabelY - 30
            if self.appleMap.height < nextLegalLabeYPosition {
                return
            }
            printDebug("self.appleMap: \(self.appleMap.frame)")
            printDebug("legalLabel: \(legalLabel.frame)")
            UIView.animateKeyframes(withDuration: 0.6, delay: 0.0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    legalLabel.frame.origin.x = UIScreen.main.bounds.width/2 + 26
                    legalLabel.frame.origin.y = nextLegalLabeYPosition
                    
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    mapLogoView.frame.origin.x = UIScreen.main.bounds.width/2 - 50
                    mapLogoView.frame.origin.y = self.isMapInFullView ? mapLogoY + 30 : mapLogoY - 30

                }
            })
            
        }else if self.appleMap.subviews.count > 1{// IOS12 and lower devices.// && !isMapInFullView
            let legalLabel: UIView = self.appleMap.subviews[1]
            let legalLabelY = self.appleMap.height - legalLabel.height - 7
            UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    legalLabel.frame.origin.x = UIScreen.main.bounds.width/2 - 14
                    legalLabel.frame.origin.y = self.isMapInFullView ? legalLabelY + 30 : legalLabelY - 30

                }
                
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        guard gestureRecognizer
        var legalLabel: UIView = UIView()
        if self.appleMap.subviews.count > 2{
             legalLabel = self.appleMap.subviews[2]
        } else if self.appleMap.subviews.count > 1{ // IOS12 and lower devices.//
             legalLabel = self.appleMap.subviews[1]
        }
        
        if (touch.view?.isKind(of: MKAnnotationView.self) ?? false){
            return false
        } else if (touch.view === legalLabel) {
            return false
        }else if legalLabel.frame.contains(touch.location(in: self.appleMap)){
            return false
        }else{
            return true
        }
    }
    
    
    @objc func tapOnMAp(_ gesture: UITapGestureRecognizer){
        if (gesture.state != .ended){
            return
        }
        self.updateFullMarkerView()
        self.updateAnnotationOnMapTap()
    }
    
    @objc func zoomInGesture() {
        var region = self.appleMap.region
        var span = self.appleMap.region.span
        span.latitudeDelta *= CLLocationDegrees(0.5)
        span.longitudeDelta *= CLLocationDegrees(0.5)
        region.span = span
        self.appleMap.setRegion(region, animated: true)
    }
    
    func updateAnnotationOnMapTap(){
        if !self.isMapInFullView {
            let index = self.getCurrentCollectionIndex()
            if self.viewModel.collectionViewLocArr.indices.contains(index) {
                let locStr = self.viewModel.collectionViewLocArr[index]
                guard let loc = self.getLocationObject(fromLocation: locStr) else{return}
                guard let currentAnnotation = self.appleMap.annotations.first(where: {self.compareTwoCoordinate($0.coordinate, loc)}) as? MyAnnotation else{ return}
                self.updateMarkerImageFor(annotation: currentAnnotation, isSelected: true, isDetaisShow: true)
            }
        }else{
            guard  let selectedAnnotation = self.detailsShownMarkers.first(where: {($0.markerImageView?.isSelected ?? false)||( $0.clusterView?.isSelected ?? false)}) else {return}
            self.updateMarkerImageFor(annotation: selectedAnnotation, isSelected: false, isDetaisShow: true)
        }
        
    }
    
    func addAllMarker(isNeedToShowAll: Bool = true) {
        if self.viewModel.collectionViewLocArr.count != 0{
            guard let location = self.getLocationObject(fromLocation: self.viewModel.collectionViewLocArr.first!) else{return}
            self.setInitailRegionToShow(location: location)
        }
        self.addMakerToMap(isNeedToShowAll)
    }
    
    func addMakerToMap(_ isNeedToShowAll: Bool = true){
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
        if isNeedToShowAll{
            self.appleMap.showAnnotations(self.appleMap.annotations, animated: true)
        }else{
            if ((self.hotelsMapCV.numberOfSections != 0) && (self.hotelsMapCV.numberOfItems(inSection: 0) != 0)){
                self.hotelsMapCV.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: false)
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
        let visibleAnnotation = appleMap.annotations(in: self.appleMap.visibleMapRect).compactMap{($0 as! MyAnnotation)}
        print( appleMap.getZoomLevel())
//        if appleMap.getZoomLevel() <= 14{//All annotation on zoom level 14
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
//        }else{
//            self.removePreviouseSelected()
//            visibleAnnotation.forEach { annotation in
//                if !detailsShownMarkers.contains(annotation){ detailsShownMarkers.append(annotation)}
//                self.updateMarkerImageFor(annotation: annotation, isSelected: annotation.isSelected, isDetaisShow: true)
//            }
//        }
    }
    
    func updateSelectedMarker(_ annotation: MKAnnotation?, isTappedMarker:Bool = true){
        self.removePreviouseSelected()
        guard  let anno = annotation as? MyAnnotation else {return}
        self.updateMarkerImageFor(annotation: anno, isSelected: true, isDetaisShow: true)
        var isTapSelected = false
        if !self.detailsShownMarkers.contains(anno){
            detailsShownMarkers.forEach { annotation in
                self.updateMarkerImageFor(annotation: annotation, isSelected: false, isDetaisShow: false)
            }
            detailsShownMarkers = []
            detailsShownMarkers.append(anno)
        }else{
            isTapSelected = true
        }
//        self.appleMap.deselectAnnotation(anno, animated: false)
        self.setRegionToShow(location: anno.coordinate)
        updateRegionMarker()
        if isTappedMarker{
            if anno.markerType == .customMarker{
                if let data = anno.hotel {
                    movetoDetailPage(data: data, isNeedToOpen: isTapSelected)
                }
            } else if anno.markerType == .clusterMarker {
                if let data = anno.hotelTtems?.first {
                    movetoDetailPage(data: data, isNeedToOpen: isTapSelected)
                }
            }
        }
        if let annotationView = self.appleMap.view(for: anno)  as?  ResistantAnnotationView{
                annotationView.resistantLayer.resistantZPosition = 1000
        }
        
        appleMap.deselectAnnotation(anno, animated: false)
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
            if let annotationView = self.appleMap.view(for: selectedAnnotation)  as?  ResistantAnnotationView{
                    annotationView.resistantLayer.resistantZPosition = 1000
            }
            self.detailsShownMarkers.append(selectedAnnotation)
        }else if selectedAnnotation.clusterView?.hotelTtems != nil{
            selectedAnnotation.clusterView?.isSelected = true
            appleMap.view(for: selectedAnnotation)?.image = selectedAnnotation.clusterView?.asImage() ?? UIImage()
            selectedAnnotation.isSelected = true
            if let annotationView = self.appleMap.view(for: selectedAnnotation)  as?  ResistantAnnotationView{
                    annotationView.resistantLayer.resistantZPosition = 1000
            }
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
                let switchOn = (!isSwitchOn) ? self.switchView.isOn : isSwitchOn
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
        self.addAllMarker(isNeedToShowAll: false)
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
                self.addAllMarker(isNeedToShowAll: false)
            }
        }
    }
    
    
    func hideUnhideCurrentLocationBtn(){
        let centreLocation = CLLocation(latitude: self.appleMap.centerCoordinate.latitude, longitude: self.appleMap.centerCoordinate.longitude)
        guard let cityCoordinates  = viewModel.searchedCityLocation else {return}
        let cityLocation = CLLocation(latitude: cityCoordinates.latitude, longitude: cityCoordinates.longitude)
        if centreLocation.distance(from: cityLocation) < 5{
            self.currentLocationButton.isHidden = true
        }else{
            self.currentLocationButton.isHidden = false
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
//            if  markerView.isDetailsShown || markerView.isSelected{
                detailsShownMarkers.append(annotation)
                return markerView.asImage()
//            }else {
//                if annotation.hotel?.fav ?? "0" == "0"{
//                   return UIImage(named: "clusterSmallTag") ?? UIImage()
//                }else{
//                    return UIImage(named: "favHotelWithShadowMarker") ?? UIImage()
//                }
//            }
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
                
            if markerView.connectorView != nil {
                markerView.isSelected = isSelected
            }
            markerView.isDetailsShown = isDetaisShow
//            if  markerView.isDetailsShown || markerView.isSelected{

                self.appleMap.view(for: annotation)?.image = markerView.asImage()
//            }else {
//                if annotation.hotel?.fav ?? "0" == "0"{
//                    self.appleMap.view(for: annotation)?.image = UIImage(named: "clusterSmallTag") ?? UIImage()
//                }else{
//                    self.appleMap.view(for: annotation)?.image = UIImage(named: "favHotelWithShadowMarker") ?? UIImage()
//                }
//            }
        }
        if let annotationView = self.appleMap.view(for: annotation)  as?  ResistantAnnotationView{
            if isSelected || isDetaisShow {
                annotationView.resistantLayer.resistantZPosition = isSelected ? 1000 : 100
            } else {
                annotationView.resistantLayer.resistantZPosition = 0
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
        var region = MKCoordinateRegion(center: location, latitudinalMeters: 6000, longitudinalMeters: 6000)
        if isZoomLevelOnceSet {
            region = MKCoordinateRegion(center: location, span: self.currentMapSpan)
        }
        
        self.appleMap.setRegion(region, animated: true)
        if !isZoomLevelOnceSet{
            self.appleMap.layoutMargins = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 40.0, right: 40.0)
        }
        isZoomLevelOnceSet = true
    }
    
    func addBlurView(){
        let height = UIApplication.shared.statusBarFrame.height
        blurView = UIVisualEffectView(frame: CGRect(x: 0.0, y: 0.0, width: Double(UIDevice.screenWidth), height: Double(height)))
        self.statusBarColor = AppColors.clear
        blurView.backgroundColor = AppColors.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        blurView.contentView.addSubview(blurEffectView)
        self.view.addSubview(blurView)
    }
    
    func removeBlur(){
        self.statusBarColor = AppColors.themeWhite
        blurView.removeFromSuperview()
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

class ResistantLayer: CALayer {

    override var zPosition: CGFloat {
        get { return super.zPosition }
        set {}
    }
    var resistantZPosition: CGFloat {
        get { return super.zPosition }
        set { super.zPosition = newValue }
    }
}

class ResistantAnnotationView: MKAnnotationView {

    override class var layerClass: AnyClass {
        return ResistantLayer.self
    }
    var resistantLayer: ResistantLayer {
        return self.layer as! ResistantLayer
    }
}
