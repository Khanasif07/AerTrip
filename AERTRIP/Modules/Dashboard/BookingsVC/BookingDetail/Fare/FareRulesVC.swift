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
    private var fareRules: String = LocalizedString.na.localized
    private var ruteString: String = LocalizedString.na.localized
    
    override func initialSetup() {
        registerXib()
        self.fareRuleTableView.dataSource = self
        self.fareRuleTableView.delegate = self
        self.fareRuleTableView.reloadData()
    }

    
    // MARK: - Helper methods
    
    func set(fareRules: String, ruteString: String) {
        self.fareRules = fareRules
        self.ruteString = ruteString
        self.fareRuleTableView?.reloadData()
    }
    
    private func registerXib() {
        self.fareRuleTableView.registerCell(nibName: FareRuleTableViewCell.reusableIdentifier)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension FareRulesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.fareRules.sizeCount(withFont: AppFonts.Regular.withSize(16.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0)).height + 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.fareRuleTableView.dequeueReusableCell(withIdentifier: "FareRuleTableViewCell", for: indexPath) as? FareRuleTableViewCell else {
            fatalError("FareRuleTableViewCell not found")
        }
        
        cell.configureCell(fareRules: self.fareRules, ruteString: self.ruteString)
        return cell
    }
}



