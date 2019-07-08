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
    
    var dimension: Dimension?
    
    override func initialSetup() {
        
        self.configureNavBar()
        self.doIntialSetUp()
        self.registerXib()
    }
    
    
    // MARK: - Helper methods
    
    private func doIntialSetUp() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func configureNavBar() {
      self.topNavigationView.configureNavBar(title: LocalizedString.HandBaggageDimensions.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
          self.topNavigationView.configureFirstRightButton(normalImage: UIImage(named: "aerinBlackIcon"), selectedImage: UIImage(named: "aerinBlackIcon"))
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
