//
//  FlightsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsVC: BaseVC {
    // MARK: - Properties
    private var homeFlightsVC: UIViewController!
    private var previousOffset: CGPoint = .zero

    // MARK: -
        
    // MARK: - IBOutlets
    
    // MARK: -
    
    // MARK: - ViewLifeCycle
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    private func initialSetups() {
        addFlightsModuleView()
    }
    
    private func addFlightsModuleView() {
        let homeFlightStoryBoard = UIStoryboard(name: "FlightForm", bundle: nil)
        homeFlightsVC = homeFlightStoryBoard.instantiateViewController(withIdentifier: "FlightFormViewController")
        homeFlightsVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        self.addChild(homeFlightsVC)
        view.addSubview(homeFlightsVC.view)
        homeFlightsVC.didMove(toParent: self)
        setHomeFlightsVCScrollDelegate()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    private func setHomeFlightsVCScrollDelegate() {
        if let scrollView = homeFlightsVC.view.subviews.first as? UIScrollView {
            scrollView.delegate = self
        }
    }
    
    // MARK: - Public
    
    // MARK: - Action
    
}

extension FlightsVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffset.y
        
        if let parent = parent as? DashboardVC {
            if difference > 0 {
                // check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height {
                    if scrollView.contentOffset.y > 0.0 {
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            } else {
                if parent.mainScrollView.contentOffset.y > 0.0 {
                    if scrollView.contentOffset.y <= 0.0 {
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        
        self.previousOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = parent as? DashboardVC else { return }
        parent.innerScrollDidEndDragging(scrollView)
    }
}
