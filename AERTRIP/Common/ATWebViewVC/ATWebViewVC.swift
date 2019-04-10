//
//  ATWebViewVC.swift
//  AERTRIP
//
//  Created by Admin on 08/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATWebViewVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var webViewContainer: UIView! {
        didSet {
            webView = UIWebView(frame: webViewContainer.bounds)
            webViewContainer.addSubview(webView)
        }
    }
    
    
    //MARK:- Properties
    //MARK:- Public
    var urlToLoad: URL?
    var navTitle: String = AppConstants.kAppName
    
    //MARK:- Private
    private var webView: UIWebView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        topNavView.configureLeftButton(normalImage: #imageLiteral(resourceName: "searchBarClearButton"), selectedImage: #imageLiteral(resourceName: "searchBarClearButton"))
        topNavView.delegate = self
        
        //create webView
        self.loadUrl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = webViewContainer.bounds
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func loadUrl() {
        guard let url = urlToLoad else {
            fatalError("There is not url to load")
        }
        
        webView.loadRequest(URLRequest(url: url))
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

extension ATWebViewVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
