//
//  NoResultsScreenViewController.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 08/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit



class NoResultsScreenViewController: UIViewController {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate : NoResultScreenDelegate?
    @IBOutlet weak var revolvingIndicatorView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicatorView()
        self.view.backgroundColor = AppColors.themeWhite
        header.font = AppFonts.Regular.withSize(22)
        subTitle.font = AppFonts.Regular.withSize(18)
    }


    fileprivate func setupIndicatorView() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 
        rotationAnimation.duration = 7
        rotationAnimation.repeatCount = .infinity
        revolvingIndicatorView.layer.add(rotationAnimation, forKey: nil)
    }
    
    func noResultsScreen() {
        header.text = "Flight Not Found"
        subTitle.text = "Try loading for other routes or dates."
        button.setTitle("Try again", for: .normal)
        button.tag = 100
    }
    
    func noFilteredResults() {
        header.text = "No results match your filters"
        subTitle.text = "Try different filters, or clear all."
        button.setTitle("Clear Filters", for: .normal)
        button.tag = 200
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if sender.tag == 100 {
            delegate?.restartFlightSearch()
        }
        
        if sender.tag == 200 {
            delegate?.clearFilters()
        }
    }
}
