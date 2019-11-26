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
        
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .easeInOut) { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.headerContatinerViewHeightConstraint.constant = 100
            sSelf.tableViewTopConstraint.constant = 100
            sSelf.mapContainerTopConstraint.constant = 100
            sSelf.headerContainerViewTopConstraint.constant = 0.0
            sSelf.searchBarContainerView.backgroundColor = AppColors.themeWhite
            sSelf.mapContainerViewBottomConstraint.constant = 0.0
            sSelf.searchBarContainerView.frame = sSelf.searchIntitialFrame
            sSelf.titleLabel.transform = .identity
            sSelf.descriptionLabel.transform = .identity
            sSelf.mapContainerView.layoutSubviews()
            sSelf.view.layoutIfNeeded()
        }

        animator.startAnimation()
        
//        self.headerContatinerViewHeightConstraint.constant = 100
//        self.tableViewTopConstraint.constant = 100
//        self.mapContainerTopConstraint.constant = 100
//        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
//        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.searchBarContainerView.frame = sSelf.searchIntitialFrame
//            sSelf.titleLabel.transform = .identity
//            sSelf.descriptionLabel.transform = .identity
//            sSelf.mapContainerView.layoutSubviews()
//            sSelf.view.layoutIfNeeded()
//        })
    }
    
    func animateHeaderToMapView() {
        
        let animator = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .easeInOut) { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.headerContatinerViewHeightConstraint.constant = 50
            sSelf.tableViewTopConstraint.constant = 50
            sSelf.mapContainerTopConstraint.constant = 50
            sSelf.headerContainerViewTopConstraint.constant = 0.0
           sSelf.mapContainerViewBottomConstraint.constant = 230.0
            sSelf.searchBarContainerView.translatesAutoresizingMaskIntoConstraints = true
            sSelf.searchBarContainerView.backgroundColor = AppColors.clear
            
            sSelf.searchBarContainerView.frame = sSelf.searchBarFrame(isInSearchMode: (sSelf.hoteResultViewType == .ListView))
            sSelf.titleLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            sSelf.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            sSelf.mapContainerView.layoutSubviews()

            sSelf.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self](pos) in
            guard let sSelf = self else {return}
            sSelf.view.bringSubviewToFront(sSelf.searchBarContainerView)
        }
        
        animator.startAnimation()
        
//        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: { [weak self] in
//            guard let sSelf = self else {return}
//            sSelf.searchBarContainerView.frame = sSelf.searchBarFrame(isInSearchMode: (sSelf.hoteResultViewType == .ListView))
//            sSelf.titleLabel.transform = CGAffineTransform(translationX: 0, y: -60)
//            sSelf.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -60)
//            sSelf.mapContainerView.layoutSubviews()
//            sSelf.view.layoutIfNeeded()
//        }, completion: { [weak self](isDone) in
//            guard let sSelf = self else {return}
//            sSelf.view.bringSubviewToFront(sSelf.searchBarContainerView)
//        })
    }
    
    func searchBarFrame(isInSearchMode: Bool) -> CGRect {
        return CGRect(x: isInSearchMode ? self.searchIntitialFrame.origin.x  - 2 :   self.searchIntitialFrame.origin.x + 20
            , y: self.searchIntitialFrame.origin.y - 45, width: self.searchIntitialFrame.width - (isInSearchMode ? 64.0 : 100.0), height: 50)
    }
    
    func showSearchAnimation() {
        self.filterButton.isHidden = true
        self.mapButton.isHidden = true
        self.cancelButton.alpha = 1
        self.backButton.alpha = 0
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBarContainerView.frame = self.searchBarFrame(isInSearchMode: true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideSearchAnimation() {
        self.filterButton.isHidden = false
        self.mapButton.isHidden = false
        self.cancelButton.alpha = 0
        
        if self.hoteResultViewType == .MapView {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations:  {
                self.searchBarContainerView.frame = self.searchBarFrame(isInSearchMode: false)
                self.view.layoutIfNeeded()
            },completion: nil)
        } else {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations:{
                 self.searchBarContainerView.backgroundColor = AppColors.clear
            }) { (done) in
                if done {
                    self.backButton.alpha = 1
                    self.searchBarContainerView.backgroundColor = AppColors.clear
                }
            }
        }
    }
    
    func animateCollectionView(isHidden: Bool, animated: Bool, completion: ((Bool) -> Void)? = nil) {
//        self.collectionView.translatesAutoresizingMaskIntoConstraints = true
        let hiddenFrame: CGRect = CGRect(x: collectionView.width, y: (UIDevice.screenHeight - collectionView.height), width: collectionView.width, height: collectionView.height)
//        let shownFrame: CGRect = CGRect(x: 0.0, y: (UIDevice.screenHeight - (collectionView.height + AppFlowManager.default.safeAreaInsets.bottom)), width: collectionView.width, height: collectionView.height)
        
        if !isHidden {
            self.collectionView.isHidden = false
            self.floatingButtonBackView.isHidden = false
        }
        
        // resize the map view for map/list view
        self.mapView?.animate(toZoom: isHidden ? self.defaultZoomLabel : (self.defaultZoomLabel))
       // isHidden ? self.moveMapToCurrentCity() : self.animateMapToFirstHotelInMapMode()
        self.animateMapToFirstHotelInMapMode()
        let animator = UIViewPropertyAnimator(duration: animated ? AppConstants.kAnimationDuration : 0.0, curve: .easeInOut) {[weak self] in
            
            guard let sSelf = self else {return}
            // map resize animation
//            sSelf.mapView?.frame = sSelf.mapContainerView.bounds
            
            // vertical list animation
            sSelf.collectionViewLeadingConstraint.constant = isHidden ? -((hiddenFrame.width)) : 0.0
            sSelf.collectionView.alpha = isHidden ? 0.0 : 1.0
            sSelf.floatingViewInitialConstraint = isHidden ? 10.0 : (hiddenFrame.height)
            // floating buttons animation
            sSelf.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
            sSelf.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
            
            // horizontal list animation
            sSelf.tableViewTopConstraint.constant = isHidden ? 100.0 : UIDevice.screenHeight
            sSelf.tableViewVertical.alpha = isHidden ? 1.0 : 0.0
            sSelf.cardGradientView.alpha = isHidden ? 0.0 : 1.0
            sSelf.collectionViewBottomConstraint.constant = 0.0
            sSelf.view.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self](position) in
            guard let sSelf = self else {return}
            if isHidden {
                sSelf.floatingButtonBackView.isHidden = true
                sSelf.collectionView.isHidden = true
                sSelf.relocateSwitchButton(shouldMoveUp: true, animated: true)
            }
            completion?(true)
            sSelf.view.bringSubviewToFront(sSelf.collectionView)
            sSelf.mapContainerView.layoutSubviews()
        }
        
        animator.startAnimation()
        
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
//            // map resize animation
//            self.mapView?.frame = mapFrame
//
//            // vertical list animation
//            self.collectionView.frame = isHidden ? hiddenFrame : shownFrame
//            self.collectionView.alpha = isHidden ? 0.0 : 1.0
//            self.floatingViewInitialConstraint = isHidden ? 10.0 : (hiddenFrame.height)
//            // floating buttons animation
//            self.floatingViewBottomConstraint.constant = isHidden ? 10.0 : (hiddenFrame.height)
//            self.floatingButtonBackView.alpha = isHidden ? 0.0 : 1.0
//
//            // horizontal list animation
//            self.tableViewTopConstraint.constant = isHidden ? 100.0 : UIDevice.screenHeight
//            self.tableViewVertical.alpha = isHidden ? 1.0 : 0.0
//
//            self.view.layoutIfNeeded()
//        }, completion: { _ in
//            if isHidden {
//                self.floatingButtonBackView.isHidden = true
//                self.collectionView.isHidden = true
//                self.relocateSwitchButton(shouldMoveUp: true, animated: true)
//                self.cardGradientView.isHidden = true
//            }
//            self.view.bringSubviewToFront(self.collectionView)
//        })
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
                           self.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 55, y: 0)
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
