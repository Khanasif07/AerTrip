//
//  ATWebViewVC.swift
//  AERTRIP
//
//  Created by Admin on 08/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class ATWebViewVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var webViewContainer: UIView! {
        didSet {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webViewContainer.addSubview(webView)
        }
    }
    
    @IBOutlet weak var navViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurViewContainer: BlurView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = .lightContent
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            self.statusBarStyle = .default
        }
    }
    
    //MARK:- Properties
    //MARK:- Public
    var urlToLoad: URL?
    var navTitle: String = AppConstants.kAppName
    var htmlString: String?
    
    //MARK:- Private
    private var webView: WKWebView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        topNavView.configureNavBar(title: navTitle, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .clear)
        topNavView.navTitleLabel.numberOfLines = 1
        topNavView.navTitleLabel.lineBreakMode = .byTruncatingTail
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"), selectedImage: #imageLiteral(resourceName: "black_cross"))
        topNavView.delegate = self
        topNavView.backView.backgroundColor = .clear
        topNavView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        //blurViewContainer.addShadow(withColor: UIColor.black.withAlphaComponent(0.2))
        //blurViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        //create webView
        if let _ = self.urlToLoad {
            self.loadUrl()
        } else if let _ = self.htmlString {
            self.loadhtml()
        }
        webView.navigationDelegate = self
        
        if #available(iOS 13.0, *) {
            navViewHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
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
        
        webView.load(URLRequest(url: url))
    }
    
    private func loadhtml() {
        guard let html = htmlString else {
            fatalError("There is not url to load")
        }
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

extension ATWebViewVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension ATWebViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
}
