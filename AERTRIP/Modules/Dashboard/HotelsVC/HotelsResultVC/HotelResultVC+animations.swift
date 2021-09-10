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
            
            self.unPinAllFavouriteButton.alpha = 0.0
            self.emailButton.alpha = 0.0
            self.shareButton.alpha = 0.0
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                self?.unPinAllFavouriteButton.alpha = 1.0
                self?.emailButton.alpha = 1.0
                self?.shareButton.alpha = 1.0
                self?.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailButton.transform = CGAffineTransform(translationX: 26, y: 0)
                self?.shareButton.transform = CGAffineTransform(translationX: 80, y: 0)
                self?.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 134, y: 0)
            }, completion: nil)
            
        } else {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.emailButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.shareButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.emailButton.transform = CGAffineTransform(translationX: 26, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 80, y: 0)
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 134, y: 0)
        }
    }
    
    func hideFavsButtons(isAnimated: Bool = false) {
        if isAnimated {
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.unPinAllFavouriteButton.alpha = 0.0
                self?.emailButton.alpha = 0.0
                self?.shareButton.alpha = 0.0
                self?.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self?.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self?.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { [weak self] (success) in
                self?.unPinAllFavouriteButton.isHidden = true
                self?.emailButton.isHidden = true
                self?.shareButton.isHidden = true
                self?.unPinAllFavouriteButton.alpha = 1.0
                self?.emailButton.alpha = 1.0
                self?.shareButton.alpha = 1.0
            })
        } else {
            self.unPinAllFavouriteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.emailButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.unPinAllFavouriteButton.isHidden = true
            self.emailButton.isHidden = true
            self.shareButton.isHidden = true
        }
    }
    
    func animateButton() {
        self.animateFloatingButtonOnListView()
    }
}


