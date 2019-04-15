//
//  EditProfileVC+HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension EditProfileVC {
    func startLoading() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        topNavView.firstRightButton.isHidden = true
    }

    func stopLoading() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        topNavView.firstRightButton.isHidden = false
    }
}
