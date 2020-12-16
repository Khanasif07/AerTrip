//
//  FlightFilterSortViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class IntReturnAndMCSortVC: UIViewController, FilterViewController {

    @IBOutlet weak var sortTableview: UITableView!
        
    let viewModel = IntReturnAndMCSortVM()
    private let whySmartSortView = WhySmartSortView()
    
    //MARK:- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }

    //MARK:- Additional setup methods
    fileprivate func setupTableView ()
    {
        sortTableview.separatorStyle = .none
        sortTableview.isScrollEnabled = true
        whySmartSortView.onLearnMoreTap = { [weak self] gesture in
            self?.tapLabel(gesture: gesture)
        }
        
        sortTableview.tableFooterView = whySmartSortView
    }
    
    private func tapLabel(gesture: UITapGestureRecognizer){
        
        guard let label = gesture.view as? UILabel  else { return }
        guard  let text = label.text else { return }
        let learnMoreRange = (text as NSString).range(of: "Learn more")
        if gesture.didTapAttributedTextInLabel(label: label, inRange: learnMoreRange) {
            
            //            let webviewController = WebViewController()
            //            webviewController.urlPath = "https://aertrip.com/smart-sort"
            //            self.parent?.present(webviewController, animated: true, completion: nil)
            
            if let url = URL(string: APIEndPoint.smartSort.rawValue) {
                AppFlowManager.default.showURLOnATWebView(url, screenTitle:  "Smart Sort", presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
            }
        }
    }
    
    func initialSetup() {
        setupTableView()
        viewModel.selectedSorting = Sort.Smart
        viewModel.curSelectedIndex = 0
    }
    
    func resetFilter() {
        viewModel.selectedSorting = Sort.Smart
        viewModel.curSelectedIndex = 0
        viewModel.delegate?.sortFilterChanged(sort: viewModel.selectedSorting)
        sortTableview.reloadData()
    }
    
    func updateUIPostLatestResults() {
        
    }
}

extension IntReturnAndMCSortVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (viewModel.airportsArr.count*2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0..<3:
            cell.textLabel?.attributedText = self.viewModel.getAttributedStringFor(index: indexPath.row)
        case 3..<(viewModel.airportsArr.count + 3):
            let attStr = viewModel.getDepartArriveAttString("Departure from " + viewModel.airportsArr[indexPath.row - 3].leg.origin, indexPath)
            cell.textLabel?.attributedText = attStr
        case (viewModel.airportsArr.count + 3)..<((viewModel.airportsArr.count*2) + 3):
            let attStr = viewModel.getDepartArriveAttString("Arrival at " + viewModel.airportsArr[indexPath.row - (viewModel.airportsArr.count + 3)].leg.destination, indexPath)
            cell.textLabel?.attributedText = attStr
        default:
            cell.textLabel?.attributedText = self.viewModel.getAttributedStringFor(index: indexPath.row - ((viewModel.airportsArr.count*2) + 3))
        }
        cell.accessoryView = nil
        
        if viewModel.curSelectedIndex == indexPath.row {
            cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.row == 1 {
            viewModel.priceHighToLow = false
        }
        
        if indexPath.row == 2 {
            viewModel.durationLongestFirst = false
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if viewModel.earliestFirstAtDepartArrive[indexPath.row] == nil {
            viewModel.earliestFirstAtDepartArrive[indexPath.row] = false
        }
        
        viewModel.earliestFirstAtDepartArrive.forEach { (key, val) in
            if key == indexPath.row && viewModel.curSelectedIndex == indexPath.row {
                viewModel.earliestFirstAtDepartArrive.updateValue(!val, forKey: key)
            } else {
                viewModel.earliestFirstAtDepartArrive.updateValue(true, forKey: key)
            }
        }
        viewModel.curSelectedIndex = indexPath.row
                
        if indexPath.row != 1 {
            viewModel.priceHighToLow = false
        }
        
        if indexPath.row != 2 {
            viewModel.durationLongestFirst = false
        }
        
        
        if tableView.indexPathForSelectedRow == indexPath {
            
            if indexPath.row == 1 {
                viewModel.priceHighToLow.toggle()
            }
            
            if indexPath.row == 2 {
                viewModel.durationLongestFirst.toggle()
            }
        }
        
        switch  indexPath.row {
        case 0:
            viewModel.delegate?.sortFilterChanged(sort: .Smart)
        case 1 :
            viewModel.delegate?.priceFilterChangedWith(viewModel.priceHighToLow)
        case 2 :
            viewModel.delegate?.durationFilterChangedWith(viewModel.durationLongestFirst)
            
        case 3..<(viewModel.airportsArr.count+3):
            let curLegIndex = indexPath.row - 3
            viewModel.delegate?.departSortFilterChangedWith(curLegIndex, viewModel.earliestFirstAtDepartArrive[indexPath.row] ?? true)
            
        case (viewModel.airportsArr.count+3)..<((viewModel.airportsArr.count*2) + 3):
            let curLegIndex = indexPath.row - (viewModel.airportsArr.count+3)
            viewModel.delegate?.arrivalSortFilterChangedWith(curLegIndex, viewModel.earliestFirstAtDepartArrive[indexPath.row] ?? true)
        default :
            break
        }
        
        if let sortFilter = Sort(rawValue: indexPath.row) {
           
            self.viewModel.selectedSorting = sortFilter

        }
        self.sortTableview.reloadData()
        
        return indexPath
    }
}
