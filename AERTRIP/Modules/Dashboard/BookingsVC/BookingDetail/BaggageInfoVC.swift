//
//  BaggageInfoVC.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BaggageInfoVC: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!
    
    var dimension: Dimension?
    
    override func initialSetup() {
        
        self.configureNavBar()
        self.doIntialSetUp()
        self.registerXib()
        topNavigationView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            navigationBarHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
        self.tableView.contentInset = UIEdgeInsets(top: topNavigationView.height, left: 0.0, bottom: 0.0, right: 0.0)

    }
    
    
    // MARK: - Helper methods
    
    private func doIntialSetUp() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func configureNavBar() {
      self.topNavigationView.configureNavBar(title: LocalizedString.HandBaggageDimensions.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
          self.topNavigationView.configureFirstRightButton(normalImage: AppImages.aerinBlackIcon, selectedImage:  AppImages.aerinBlackIcon)
        self.topNavigationView.delegate = self
    }
    
    private func registerXib() {
        self.tableView.registerCell(nibName: BaggageInfoTableViewCell.reusableIdentifier)
    }

}




// MARK: - Delegate methods


extension BaggageInfoVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        // 
    }
    
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BaggageInfoVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageInfoTableViewCell", for: indexPath) as? BaggageInfoTableViewCell else {
            fatalError("BaggageInfoTableViewCell not found")
        }
        
        cell.dimension = self.dimension
        
        return cell
    }
}
