//
//  HotelResultVC+animations.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelResultVC {
    func animateHeaderToListView() {
        self.headerContatinerViewHeightConstraint.constant = 100
        self.tableViewTopConstraint.constant = 100
        self.mapContainerTopConstraint.constant = 100
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBar.frame = self.searchIntitialFrame
            self.titleLabel.transform = .identity
            self.descriptionLabel.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
    
    func animateHeaderToMapView() {
        self.headerContatinerViewHeightConstraint.constant = 50
        self.tableViewTopConstraint.constant = 50
        self.mapContainerTopConstraint.constant = 50
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x + 10
                                          , y: self.searchBar.frame.origin.y - 45, width: self.searchBar.frame.width - 80, height: 50)
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            self.view.layoutIfNeeded()
        }
    }
    
    func showSearchAnimation() {
        self.filterButton.isHidden = true
        self.mapButton.isHidden = true
        self.cancelButton.alpha = 1
    }
    
    func hideSearchAnimation() {
        self.filterButton.isHidden = false
        self.mapButton.isHidden = false
        self.cancelButton.alpha = 0
    }
    
    func animateCollectionView(isHidden: Bool, animated: Bool) {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = true
        let hiddenFrame: CGRect = CGRect(x: collectionView.width, y: (UIDevice.screenHeight - collectionView.height), width: collectionView.width, height: collectionView.height)
        let shownFrame: CGRect = CGRect(x: 0.0, y: (UIDevice.screenHeight - (collectionView.height + AppFlowManager.default.safeAreaInsets.bottom)), width: collectionView.width, height: collectionView.height)
        
        if !isHidden {
            self.collectionView.isHidden = false
            self.floatingButtonBackView.isHidden = false
        }
        
        // resize the map view for map/list view
        let mapFrame = CGRect(x: 0.0, y: 0.0, width: mapContainerView.width, height: isHidden ? visibleMapHeightInVerticalMode : mapContainerView.height)
        
        self.mapView?.animate(toZoom: isHidden ? mapIntitalZoomLabel : (mapIntitalZoomLabel + 5.0))
        self.moveMapToCurrentCity()
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            // map resize animation
            self.mapView?.frame = mapFrame
            
            // vertical list animation
            self.collectionView.frame = isHidden ? hiddenFrame : shownFrame
            self.collectionView.alpha = isHidden ? 0.0 : 1.0
            
            // floating buttons animation
            self.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
            self.currentLocationButton.isHidden = isHidden
            self.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
            
            // horizontal list animation
            self.tableViewTopConstraint.constant = isHidden ? 100.0 : UIDevice.screenHeight
            self.tableViewVertical.alpha = isHidden ? 1.0 : 0.0
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if isHidden {
                self.floatingButtonBackView.isHidden = true
                self.collectionView.isHidden = true
                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
            }
        })
    }
    
    // Animate button on List View
    
    private func animateFloatingButtonOnListView() {
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
                           self.emailButton.transform = CGAffineTransform(translationX: 108, y: 0)
                           self.shareButton.transform = CGAffineTransform(translationX: 162, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    // Animate Button on map View
    
    private func animateFloatingButtonOnMapView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: {
                           self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 65, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    func animateButton() {
        if self.hoteResultViewType == .ListView {
            self.animateFloatingButtonOnListView()
        } else {
            self.animateFloatingButtonOnMapView()
        }
    }
}
