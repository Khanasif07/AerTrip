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
        
    var  priceHighToLow : Bool = false
    var  durationLongestFirst : Bool = false
    weak var delegate : SortFilterDelegate?
    var selectedSorting = Sort.Smart
    var airportsArr = [AirportLegFilter]()
    
    private var curSelectedIndex: Int?
    private var earliestFirstAtDepartArrive: [Int: Bool] = [:]
    
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
    
    fileprivate func getAttributedStringFor(index : Int) ->NSAttributedString? {
        
        if  let sortFilter = Sort(rawValue: index) {
            
            var attributes : [NSAttributedString.Key : Any]
            if ( sortFilter == selectedSorting) {
                attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 18)! ,
                              NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
            }
            else {
                attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 18)!]
            }
            
            let attributedString = NSMutableAttributedString(string: sortFilter.title, attributes: attributes)
            
            var substring = "  " + sortFilter.subTitle
            
            if index == 1  && priceHighToLow {
                substring = "  "  + "High to Low"
            }
            if index == 2 && durationLongestFirst {
                substring = "  " + "Longest first"
            }
            let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR  ])
            attributedString.append(substringAttributedString)
         
            return attributedString
        }
        return nil
    }

    
    private func tapLabel(gesture: UITapGestureRecognizer){
   
        guard let label = gesture.view as? UILabel  else { return }
        guard  let text = label.text else { return }
        let learnMoreRange = (text as NSString).range(of: "Learn more")
        if gesture.didTapAttributedTextInLabel(label: label, inRange: learnMoreRange) {
        
            let webviewController = WebViewController()
            webviewController.urlPath = "https://aertrip.com/smart-sort"
            self.parent?.present(webviewController, animated: true, completion: nil)
        }
    }
    
    func initialSetup() {
        setupTableView()
        selectedSorting = Sort.Smart
        curSelectedIndex = 0
    }
    
    func resetFilter() {
        selectedSorting = Sort.Smart
        curSelectedIndex = 0
        delegate?.sortFilterChanged(sort: selectedSorting)
        sortTableview.reloadData()
    }
    
    func updateUIPostLatestResults() {
        
    }
}

extension IntReturnAndMCSortVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + (airportsArr.count*2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0..<3:
            cell.textLabel?.attributedText = self.getAttributedStringFor(index: indexPath.row)
        case 3..<(airportsArr.count + 3):
            let attStr = getDepartArriveAttString("Departure from " + airportsArr[indexPath.row - 3].leg.origin, indexPath)
            cell.textLabel?.attributedText = attStr
        case (airportsArr.count + 3)..<((airportsArr.count*2) + 3):
            let attStr = getDepartArriveAttString("Arrival at " + airportsArr[indexPath.row - (airportsArr.count + 3)].leg.destination, indexPath)
            cell.textLabel?.attributedText = attStr
        default:
           cell.textLabel?.attributedText = self.getAttributedStringFor(index: indexPath.row - ((airportsArr.count*2) + 3))
        }
        cell.accessoryView = nil
        
        if curSelectedIndex == indexPath.row {
            cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
        }
        
        return cell
    }
    
    
    private func getDepartArriveAttString(_ str: String,_ indexPath: IndexPath) -> NSAttributedString {
        var attributes : [NSAttributedString.Key : Any]
        if ( curSelectedIndex == indexPath.row) {
            attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 18)! ,
                          NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
        }
        else {
            attributes = [NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 18)!]
        }
        let attributedString = NSMutableAttributedString(string: str, attributes: attributes)
        
        var substring = "  " + "Earliest First"
        
        if earliestFirstAtDepartArrive[indexPath.row] == false {
            substring = "  " + "Latest First"
        }
        
        let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR  ])
           attributedString.append(substringAttributedString)
        
        return attributedString
    }

    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.row == 1 {
            priceHighToLow = false
        }
        
        if indexPath.row == 2 {
            durationLongestFirst = false
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if earliestFirstAtDepartArrive[indexPath.row] == nil {
            earliestFirstAtDepartArrive[indexPath.row] = false
        }
        
        earliestFirstAtDepartArrive.forEach { (key, val) in
            if key == indexPath.row && curSelectedIndex == indexPath.row {
                earliestFirstAtDepartArrive.updateValue(!val, forKey: key)
            } else {
                earliestFirstAtDepartArrive.updateValue(true, forKey: key)
            }
        }
        curSelectedIndex = indexPath.row
                
        if indexPath.row != 1 {
            priceHighToLow = false
        }
        
        if indexPath.row != 2 {
            durationLongestFirst = false
        }
        
        
        if tableView.indexPathForSelectedRow == indexPath {
            
            if indexPath.row == 1 {
                priceHighToLow.toggle()
            }
            
            if indexPath.row == 2 {
                durationLongestFirst.toggle()
            }
        }
        
        switch  indexPath.row {
        case 0:
            delegate?.sortFilterChanged(sort: .Smart)
        case 1 :
            delegate?.priceFilterChangedWith(priceHighToLow)
        case 2 :
            delegate?.durationFilterChangedWith(durationLongestFirst)
            
        case 3..<(airportsArr.count+3):
            let curLegIndex = indexPath.row - 3
            delegate?.departSortFilterChangedWith(curLegIndex, earliestFirstAtDepartArrive[indexPath.row] ?? true)
            
        case (airportsArr.count+3)..<((airportsArr.count*2) + 3):
            let curLegIndex = indexPath.row - (airportsArr.count+3)
            delegate?.arrivalSortFilterChangedWith(curLegIndex, earliestFirstAtDepartArrive[indexPath.row] ?? true)
        default :
            break
        }
        
        if let sortFilter = Sort(rawValue: indexPath.row) {
           
            self.selectedSorting = sortFilter

        }
        self.sortTableview.reloadData()
        
        return indexPath
    }
}
