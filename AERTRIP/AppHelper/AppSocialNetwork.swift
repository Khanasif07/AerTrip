//
//  AppSocialNetwork.swift
//  AERTRIP
//
//  Created by Admin on 20/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

enum AppSocialNetwork: String {
    case Facebook, Twitter, Instagram
    func url() -> SocialNetworkUrl {
        switch self {
        case .Facebook: return SocialNetworkUrl(scheme: "fb://profile/375143382517674", pageURL: "https://www.facebook.com/aertrip", title: self.rawValue)
        case .Twitter: return SocialNetworkUrl(scheme: "twitter:///user?screen_name=aertrip", pageURL: "https://twitter.com/aertrip", title: self.rawValue)
        case .Instagram: return SocialNetworkUrl(scheme: "instagram://user?username=aertrip", pageURL:"https://www.instagram.com/aertrip", title: self.rawValue)
        }
    }
    func openPage() {
        self.url().openPage()
    }
}

struct SocialNetworkUrl {
    let scheme: String
    let pageURL: String
    let title: String

    func openPage() {
        if let appUrl = URL(string: scheme) {
            if UIApplication.shared.canOpenURL(appUrl ) {
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            } else {
                if let pageUrl = URL(string: pageURL) {
                    AppFlowManager.default.showURLOnATWebView(pageUrl, screenTitle:  title, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)

                }
            }
        }
    }
}


