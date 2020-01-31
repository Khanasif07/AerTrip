//
//  HotelResultVC+animations.swift
//  AERTRIP
//
//  Created by apple on 18/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelResultVC {
    
    func searchBarFrame(isInSearchMode: Bool) -> CGRect {
        return CGRect(x: isInSearchMode ? self.searchIntitialFrame.origin.x  - 2 :   self.searchIntitialFrame.origin.x + 20
            , y: self.searchIntitialFrame.origin.y - 45, width: self.searchIntitialFrame.width - (isInSearchMode ? 64.0 : 100.0), height: 50)
    }
    
    func showSearchAnimation() {
        self.filterButton.isHidden = true
//        self.mapButton.isHidden = true
        self.cancelButton.alpha = 1
        self.backButton.alpha = 0
        self.searchButton.alpha = 0
        self.searchBarContainerView.isHidden = false
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.searchBarContainerView.frame = self.searchBarFrame(isInSearchMode: true)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideSearchAnimation() {
        self.filterButton.isHidden = false
//        self.mapButton.isHidden = false
        self.searchBarContainerView.isHidden = false
        self.searchButton.alpha = 1
        self.cancelButton.alpha = 0
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations:{ [weak self] in
                self?.searchBarContainerView.backgroundColor = AppColors.clear
            }) { [weak self] (done)  in
                if done {
                    self?.backButton.alpha = 1
                    self?.searchBarContainerView.backgroundColor = AppColors.clear
                }
            }
        
    }
    
    
    // Animate button on List View
    
    private func animateFloatingButtonOnListView() {
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
    
    private func animateFloatingButtonOnMapView() {
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
    }
    
    func animateButton() {
            self.animateFloatingButtonOnListView()
    }
}
