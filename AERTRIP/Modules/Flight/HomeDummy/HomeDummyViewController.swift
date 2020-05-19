//
//  HomeDummyViewController.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 02/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class HomeDummyViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var baseView: UIView!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

    let clearCache = ClearCache()
    
    override func viewDidLoad() {
    super.viewDidLoad()
        addFlightFormViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearCache.checkTimeAndClearUpgradeDataCache()
        clearCache.checkTimeAndClearFlightPerformanceResultCache(journey: nil)
        _ = clearCache.checkTimeAndClearIntFlightPerformanceResultCache(journey: nil)
        clearCache.checkTimeAndClearFlightBaggageResultCache()

          DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        addGradientToBackgroundView()

    }
    
    fileprivate func addGradientToBackgroundView() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  self.view.frame
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        let colorOne = UIColor(displayP3Red: 0.0, green: ( 204.0 / 255.0) , blue: ( 153.0 / 255.0), alpha: 1.0)
        let colorTwo = UIColor(displayP3Red: 0.0, green: ( 160.0 / 255.0) , blue: ( 168.0 / 255.0), alpha: 1.0)
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func addFlightFormViewController() {

        let homeFlightStoryBoard = UIStoryboard(name: "FlightForm", bundle: nil)
        let homeFlightVC = homeFlightStoryBoard.instantiateViewController(withIdentifier: "FlightFormViewController")
        homeFlightVC.view.frame = CGRect(x: 0, y: 0, width: self.baseView.frame.size.width, height: self.baseView.frame.size.height)
        self.addChild(homeFlightVC)
        baseView.addSubview(homeFlightVC.view)

        homeFlightVC.didMove(toParent: self)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
}
