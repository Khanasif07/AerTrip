//
//  HotelResultVC+animations.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelsMapVC {
    func animateHeaderToListView() {
        
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .easeInOut) { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.headerContatinerViewHeightConstraint.constant = 100
//            sSelf.tableViewTopConstraint.constant = 100
            sSelf.mapContainerTopConstraint.constant = 100
            sSelf.headerContainerViewTopConstraint.constant = 0.0
            sSelf.searchBarContainerView.backgroundColor = AppColors.themeWhite
            sSelf.searchBarContainerView.frame = sSelf.searchIntitialFrame
            sSelf.mapContainerView.layoutSubviews()
            sSelf.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }
    
    func animateHeaderToMapView() {
        
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .easeInOut) { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.headerContatinerViewHeightConstraint.constant = 50
//            sSelf.tableViewTopConstraint.constant = 50
            sSelf.mapContainerTopConstraint.constant = 50
            sSelf.headerContainerViewTopConstraint.constant = 0.0
            sSelf.searchBarContainerView.translatesAutoresizingMaskIntoConstraints = true
            sSelf.searchBarContainerView.backgroundColor = AppColors.clear
            sSelf.searchBarContainerView.frame = sSelf.searchBarFrame(isInSearchMode: false)
            sSelf.mapContainerView.layoutSubviews()
            sSelf.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self](pos) in
            guard self != nil else {return}
            //sSelf.view.bringSubviewToFront(sSelf.searchBarContainerView)
        }
        
        animator.startAnimation()
    }
    
    func searchBarFrame(isInSearchMode: Bool) -> CGRect {
        return CGRect(x: isInSearchMode ? self.searchIntitialFrame.origin.x + 3 :   self.searchIntitialFrame.origin.x + 25
        , y: self.searchIntitialFrame.origin.y - 2, width: self.searchIntitialFrame.width - (20), height: 50)
        
    }
    
    func showSearchAnimation() {
        self.filterButton.isHidden = true
        self.cancelButton.alpha = 1
        self.backButton.alpha = 0
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBarContainerView.frame = self.searchBarFrame(isInSearchMode: true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideSearchAnimation() {
        self.filterButton.isHidden = false
        self.cancelButton.alpha = 0
        
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations:  { [weak self] in
                guard let sSelf = self else {return}
                sSelf.searchBarContainerView.frame = sSelf.searchBarFrame(isInSearchMode: false)
                sSelf.view.layoutIfNeeded()
            },completion: nil)
        
    }
    
    func animateCollectionView(isHidden: Bool, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let hiddenFrame: CGRect = CGRect(x: hotelsMapCV.width, y: (UIDevice.screenHeight - hotelsMapCV.height), width: hotelsMapCV.width, height: hotelsMapCV.height)
        if !isHidden {
            self.hotelsMapCV.isHidden = false
            self.floatingButtonBackView.isHidden = false
        }
        
        // resize the map view for map/list view
        self.mapView?.animate(toZoom: isHidden ? self.defaultZoomLabel : (self.defaultZoomLabel))
       // isHidden ? self.moveMapToCurrentCity() : self.animateMapToFirstHotelInMapMode()
        self.animateMapToFirstHotelInMapMode()
        let animator = UIViewPropertyAnimator(duration: animated ? AppConstants.kAnimationDuration : 0.0, curve: .easeInOut) {[weak self] in
            
            guard let sSelf = self else {return}
            sSelf.hotelsMapCV.alpha = isHidden ? 0.0 : 1.0
            sSelf.floatingViewInitialConstraint = isHidden ? 10.0 : (hiddenFrame.height)
            // floating buttons animation
            sSelf.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
            sSelf.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
            sSelf.cardGradientView.alpha = isHidden ? 0.0 : 1.0
            sSelf.collectionViewBottomConstraint.constant = 0.0
            sSelf.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self](position) in
            guard let sSelf = self else {return}
            if isHidden {
                sSelf.floatingButtonBackView.isHidden = true
                sSelf.hotelsMapCV.isHidden = true
                sSelf.relocateSwitchButton(shouldMoveUp: true, animated: true)
            }
            completion?(true)
            //sSelf.view.bringSubviewToFront(sSelf.collectionView)
            sSelf.mapContainerView.layoutSubviews()
        }
        
        animator.startAnimation()
    }
    
    // Animate button on List View
    
     func animateFloatingButtonOnListView() {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self?.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self?.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self?.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 54, y: 0)
                        self?.emailButton.transform = CGAffineTransform(translationX: 108, y: 0)
                        self?.shareButton.transform = CGAffineTransform(translationX: 162, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
    }
    
    // Animate Button on map View
    
    func animateFloatingButtonOnMapView(isAnimated: Bool = true) {
        if isAnimated {
        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
                       delay: 0,
                       usingSpringWithDamping: self.defaultDamping,
                       initialSpringVelocity: self.defaultVelocity,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 55, y: 0)
                       },
                       completion: { _ in
                           printDebug("Animation finished")
        })
        } else {
            self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 55, y: 0)
        }
    }
    
    func animateButton() {
            self.animateFloatingButtonOnMapView()
    }
}
