//
//  FareRulesVC.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareRulesVC: BaseVC {
    
    // MARK: - IBOutlet
    @IBOutlet weak var fareRuleTableView: ATTableView!

    
    // MARK: - Override methods
    
    override func initialSetup() {
        registerXib()
        self.fareRuleTableView.dataSource = self
        self.fareRuleTableView.delegate = self
        self.fareRuleTableView.reloadData()
    }

    
    // MARK: - Helper methods
    
    private func registerXib() {
        self.fareRuleTableView.registerCell(nibName: FareRuleTableViewCell.reusableIdentifier)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension FareRulesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.fareRuleTableView.dequeueReusableCell(withIdentifier: "FareRuleTableViewCell", for: indexPath) as? FareRuleTableViewCell else {
            fatalError("FareRuleTableViewCell not found")
        }
        
        cell.configureCell()
        return cell
    }
    
    
}



