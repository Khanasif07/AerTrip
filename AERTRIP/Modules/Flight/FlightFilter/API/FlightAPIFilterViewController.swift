//
//  FlightAPIFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightAPIFilterViewController: UIViewController {

    @IBOutlet weak var APITableView: UITableView!
    
    var APIFilters :  Set<API> = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    fileprivate func setupTableView () {
        APITableView.allowsMultipleSelection = true
        APITableView.separatorStyle = .none
        APITableView.isScrollEnabled = false
        APITableView.bounces = false
    }
    
}

extension FlightAPIFilterViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.accessoryView = UIImageView(image: AppImages.UncheckedGreenRadioButton)
        if let APIFilter = API(rawValue: indexPath.row)
        {
//            let attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 18)!]
            let attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]

            let attributedString = NSAttributedString(string: APIFilter.title, attributes: attributes)
            cell.textLabel?.attributedText = attributedString
            
            if self.APIFilters.contains(APIFilter) {
                cell.accessoryView = UIImageView(image: AppImages.CheckedGreenRadioButton)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let APIFilter = API(rawValue: indexPath.row)
        {
            self.APIFilters.update(with: APIFilter)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryView = UIImageView(image: AppImages.CheckedGreenRadioButton)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let APIFilter = API(rawValue: indexPath.row)
        {
            self.APIFilters.remove(APIFilter)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryView = UIImageView(image: AppImages.UncheckedGreenRadioButton)
        }
    }
}
