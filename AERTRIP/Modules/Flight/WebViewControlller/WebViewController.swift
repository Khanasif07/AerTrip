//
//  WebViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 13/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
class WebViewController: UIViewController , WKUIDelegate {

    @IBOutlet weak var baseView: UIView!
    var webView: WKWebView!
    var urlPath : String?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard  let urlToLoad =  urlPath else {
            return
        }

        let webConfiguration = WKWebViewConfiguration()
        

        webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.uiDelegate = self
        self.view.addSubview(webView)
    
        webView.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.topMargin.equalTo(54.0)
            maker.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
        guard let myURL = URL(string:urlToLoad) else {return}
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    @IBAction func onDoneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
