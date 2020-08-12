//
//  CommunicationVC.swift
//  AERTRIP
//
//  Created by Apple  on 12.08.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class CommunicationVC: BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var webContainerView: UIView! {
        didSet {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webContainerView.addSubview(webView)
        }
    }
    
    @IBOutlet weak var navViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var blurViewContainer: BlurView!
    
    //MARK:- Properties
    //MARK:- Public
    var urlToLoad: URL?
    var navTitle: String = AppConstants.kAppName
    var htmlString: String?
    var  height:CGFloat{
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let ht = UIScreen.height - (self.titleView.frame.height + bottom)
        return ht
        
    }
    var timeString = ""
    //MARK:- Private
    private var webView: WKWebView!
    
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
    override func initialSetup() {
        topNavView.configureNavBar(title: nil, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .color(color: AppColors.themeWhite))
        topNavView.navTitleLabel.numberOfLines = 1
        topNavView.navTitleLabel.lineBreakMode = .byTruncatingTail
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"), selectedImage: #imageLiteral(resourceName: "black_cross"))
        topNavView.delegate = self
//        topNavView.backView.backgroundColor = .clear
//        topNavView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        webView.frame.size.height = height
        //blurViewContainer.addShadow(withColor: UIColor.black.withAlphaComponent(0.2))
        //blurViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        //create webView
        setupText()
        webView.frame.size.width = UIScreen.width
        webView.frame.size.height = height
        
        if let _ = self.urlToLoad {
            self.loadUrl()
        } else if let _ = self.htmlString {
            self.loadhtml()
        }
        webView.navigationDelegate = self
        
//        if #available(iOS 13.0, *) {
//            navViewHeightConstraint.constant = 56
//        } else {
//            self.view.backgroundColor = AppColors.themeWhite
//        }
        
    }
    
    func setupText(){
        self.titleLabel.font  = AppFonts.SemiBold.withSize(22.0)
        self.timeLabel.font = AppFonts.Regular.withSize(16.0)
        self.timeLabel.textAlignment = .right
        self.titleLabel.textColor = AppColors.themeBlack
        self.timeLabel.textColor = AppColors.themeGray140
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = self.navTitle
        self.timeLabel.text = self.timeString
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        webView.frame = webContainerView.bounds
        
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

extension CommunicationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension CommunicationVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.webView.scrollView.isScrollEnabled = false
        if height < webView.scrollView.contentSize.height{
            webView.frame.size.height = webView.scrollView.contentSize.height
        }else{
            webView.frame.size.height = height
        }
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
    }
}



