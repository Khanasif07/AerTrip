//
//  WebViewVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 02/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC : UIViewController {

    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var webView: WKWebView!
    
    let webViewVm = WebViewVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetups()
        setUpNavigation()
        loadWebView()
    }
    
}

extension WebViewVC {
    
    private func initialSetups() {
        self.topNavView.delegate = self
        setUpNavigation()
    }
    
    private func setUpNavigation(){
        self.topNavView.configureNavBar(title:  self.webViewVm.webViewType.rawValue, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false)
    }
    
    func loadWebView(){
        guard let url = URL(string: self.webViewVm.getUrlToLoad()) else { return }
        self.webView.load(URLRequest(url : url))
    }
    
}

extension WebViewVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
