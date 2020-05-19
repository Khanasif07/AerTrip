//
//  QualityFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol  QualityFilterDelegate : FilterDelegate {
    func qualityFiltersChanged(_ filter : QualityFilter)
}

class QualityFilterViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate , FilterViewController {
    func initialSetup() {
        
    }
    
    func updateUIPostLatestResults() {
        qualityFilterTableView.reloadData()
    }
    
    @IBOutlet weak var qualityFilterTableView: UITableView!
    
    var qualityFilterArray = [QualityFilter]()
    private var estimatedHeightsAt : [IndexPath: CGFloat] = [:]
    weak var delegate : QualityFilterDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        qualityFilterArray.sort { (firstFilter, secondFilter) -> Bool in
            firstFilter.filterKey < secondFilter.filterKey
        }
        setupTableView()
    }

    fileprivate func setupTableView () {
        qualityFilterTableView.allowsMultipleSelection = true
        qualityFilterTableView.separatorStyle = .none
        qualityFilterTableView.isScrollEnabled = false
        qualityFilterTableView.bounces = false
        qualityFilterTableView.register(UINib(nibName: "QaulityFilterTableCell", bundle: nil), forCellReuseIdentifier: "QaulityFilterTableCell")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return qualityFilterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dequeueQualityFilterCell(tableView, indexPath)
    }
    
    private func dequeueQualityFilterCell(_ tableView: UITableView,_ indexPath: IndexPath) -> QaulityFilterTableCell {
        guard let qualityCell = tableView.dequeueReusableCell(withIdentifier: "QaulityFilterTableCell", for: indexPath) as? QaulityFilterTableCell else { fatalError("unable to dequeue QalityFilterTableCell")}
        qualityCell.configure(qualityFilterArray[indexPath.row])
        return qualityCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var filter = qualityFilterArray[indexPath.row]
        filter.isSelected = !filter.isSelected
        qualityFilterArray[indexPath.row] = filter
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.qualityFiltersChanged( filter)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func resetFilter() {
        
        qualityFilterArray = qualityFilterArray.map{
            var qualityFilter = $0
            qualityFilter.isSelected = false
            return qualityFilter
        }
        qualityFilterTableView.reloadData()
  }
    
}
