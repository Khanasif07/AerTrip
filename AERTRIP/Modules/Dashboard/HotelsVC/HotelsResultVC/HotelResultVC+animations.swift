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
//        self.filterButton.isHidden = true
//        self.mapButton.isHidden = true
        self.searchBar.becomeFirstResponder()
        self.searchBarContainerView.alpha = 0.0
        self.searchBarContainerView.isHidden = false
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: { [weak self] in
            self?.searchBarContainerView.alpha = 1.0
            self?.cancelButton.alpha = 1
            self?.backButton.alpha = 0
            self?.searchButton.alpha = 0
            self?.titleLabel.alpha = 0
            self?.descriptionLabel.alpha = 0
        }, completion: { [weak self] (done)  in
            if done {
                self?.titleLabel.isHidden = true
                self?.descriptionLabel.isHidden = true
            }
        })
        
    }
    
    func hideSearchAnimation() {
//        self.filterButton.isHidden = false
//        self.mapButton.isHidden = false
        
        
        self.titleLabel.isHidden = false
        self.descriptionLabel.isHidden = false
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: { [weak self] in
            self?.searchButton.alpha = 1
            self?.cancelButton.alpha = 0
            self?.backButton.alpha = 1
            self?.titleLabel.alpha = 1
            self?.descriptionLabel.alpha = 1
            self?.searchBarContainerView.alpha = 0.0
        }, completion: { [weak self] (done)  in
            if done {
                self?.searchBarContainerView.isHidden = true
            }
        })

        
    }
    
    
    // Animate button on List View
    
    func animateFloatingButtonOnListView(isAnimated: Bool = true) {
        if isAnimated {
//        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
//                       delay: 0,
//                       usingSpringWithDamping: self.defaultDamping,
//                       initialSpringVelocity: self.defaultVelocity,
//                       options: .allowUserInteraction,
//                       animations: { [weak self] in
//                        self?.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                        self?.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                        self?.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                        self?.emailButton.transform = CGAffineTransform(translationX: 58, y: 0)
//                        self?.shareButton.transform = CGAffineTransform(translationX: 112, y: 0)
//                        self?.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 166, y: 0)
//                       },
//                       completion: { _ in
//                           printDebug("Animation finished")
//        })
            UIView.animate(withDuration: TimeInterval(0.1), delay: 0, options: .curveEaseOut, animations: { [weak self] in
             self?.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self?.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self?.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
             self?.emailButton.transform = CGAffineTransform(translationX: 58, y: 0)
             self?.shareButton.transform = CGAffineTransform(translationX: 112, y: 0)
             self?.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 166, y: 0)
            }, completion: nil)
            
        } else {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.emailButton.transform = CGAffineTransform(translationX: 58, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 112, y: 0)
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 166, y: 0)
        }
    }
    
    // Animate Button on map View
    
//    private func animateFloatingButtonOnMapView() {
//        UIView.animate(withDuration: TimeInterval(self.defaultDuration),
//                       delay: 0,
//                       usingSpringWithDamping: self.defaultDamping,
//                       initialSpringVelocity: self.defaultVelocity,
//                       options: .allowUserInteraction,
//                       animations: { [weak self] in
//                        self?.floatingButtonOnMapView.transform = CGAffineTransform(translationX: 55, y: 0)
//                       },
//                       completion: { _ in
//                           printDebug("Animation finished")
//        })
//    }
    
    func animateButton() {
            self.animateFloatingButtonOnListView()
    }
}
