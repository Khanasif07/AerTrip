//
//  FareInfoVC.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoVC: BaseVC {

    @IBOutlet weak var fareInfoTableView: ATTableView!
    
    
    
    override func initialSetup() {
        
        self.registerXib()
        self.fareInfoTableView.dataSource = self
        self.fareInfoTableView.delegate  = self
        self.fareInfoTableView.reloadData()
        
    }
    
    
    private func registerXib() {
        self.fareInfoTableView.registerCell(nibName: EconomySaverTableViewCell.reusableIdentifier)
        self.fareInfoTableView.registerCell(nibName: BookingInfoCommonCell.reusableIdentifier)
        self.fareInfoTableView.registerCell(nibName: FareInfoNoteTableViewCell.reusableIdentifier)
         self.fareInfoTableView.registerCell(nibName: EmptyDividerViewCellTableViewCell.reusableIdentifier)
    }
  
    
    func getCellForFareInfo(_ indexPath: IndexPath) -> UITableViewCell  {
        switch indexPath.row {
        case 0:
            guard let economySaveCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "EconomySaverTableViewCell", for: indexPath) as? EconomySaverTableViewCell else {
                fatalError("EconomySaverTableViewCell not found")
            }
            
            economySaveCell.configureCell()
            return economySaveCell
        case 1,2,3,4,6,7,8,9:
            guard  let commonCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                fatalError("BookingInfoCommonCell not found")
            }
            commonCell.leftLabel.text = "Type"
            commonCell.middleLabel.text = "Check-in"
            commonCell.rightLabel.text = "Cabin"
            return commonCell
        case 5,10:
            guard let emptyDividerViewCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
                fatalError("EmptyDividerViewCellTableViewCell not found")
            }
            return emptyDividerViewCell
        case 11:
            guard let fareInfoNoteCell = self.fareInfoTableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: ["Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello"])
            return fareInfoNoteCell
        default:
            return UITableViewCell()
        }
    }


}


// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension FareInfoVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getCellForFareInfo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: // Economy  saver cell
            return 76.0
            
        case 5,10: // Divider Cell
            return 30.0
        case 1,2,3,4,6,7,8,9: // Three part cell
            return 28.0
        case 11: // Notes table view cell
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    
}
