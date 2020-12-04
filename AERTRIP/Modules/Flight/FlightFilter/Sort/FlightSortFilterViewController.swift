//
//  FlightFilterSortViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

//protocol resetSortDelegate {
//    func resetSort()
//}

protocol SortFilterDelegate : FilterDelegate {

    func resetSort()
    func sortFilterChanged(sort : Sort )
    func departSortFilterChanged( departMode  : Bool )
    func arrivalSortFilterChanged( arrivalMode : Bool)
    func durationSortFilterChanged( longestFirst : Bool)
    
    func priceFilterChangedWith(_ highToLow: Bool)
    func durationFilterChangedWith(_ longestFirst: Bool)
    func departSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool)
    func arrivalSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool)
}

extension SortFilterDelegate {
    func priceFilterChangedWith(_ highToLow: Bool) { }
    func durationFilterChangedWith(_ latestFirst: Bool) { }
    func departSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool) { }
    func arrivalSortFilterChangedWith(_ index: Int,_ earliestFirst: Bool) { }
}

protocol FilterViewController : UIViewController {
    func initialSetup()
    func resetFilter()
    func updateUIPostLatestResults()
}

class FlightSortFilterViewController: UIViewController {

    @IBOutlet weak var smartSortDescription: UILabel!
    @IBOutlet weak var sortTableview: UITableView!
    
    var  departModeLatestFirst : Bool = false
    var  arrivalModeLatestFirst : Bool = false
    var  priceHighToLow : Bool = false
    var  durationLogestFirst : Bool = false

    weak var delegate : SortFilterDelegate?
    var selectedSorting = Sort.Smart
    var isInitialSetup = true
    var isFirstIndexSelected = true
    var selectedIndex = 0
    
    //MARK:- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    

    //MARK:- Additional setup methods
    fileprivate func setupTableView ()
    {
        sortTableview.separatorStyle = .none
        sortTableview.bounces = false
        sortTableview.isScrollEnabled = false
    }
    
    func resetSort()
    {
        departModeLatestFirst = false
        arrivalModeLatestFirst = false
        priceHighToLow = false
        durationLogestFirst = false
        selectedSorting = Sort.Smart
        delegate?.sortFilterChanged(sort: selectedSorting)
        self.sortTableview.reloadData()
    }
    
    
    fileprivate func getAttributedStringFor(index : Int) ->NSAttributedString? {
        
        if  let sortFilter = Sort(rawValue: index) {
            
            
            var attributes : [NSAttributedString.Key : Any]
            if ( sortFilter == selectedSorting) {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18),
                              NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
            }
            else {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]
            }
            
            let attributedString = NSMutableAttributedString(string: sortFilter.title, attributes: attributes)
            
            var substring = "  " + sortFilter.subTitle
            
            if index == 1 && priceHighToLow {
                substring = "  " + "High to low"
            }
            if index == 2  && durationLogestFirst {
                substring = "  "  + "Longest first"
            }
            if index == 3 && departModeLatestFirst{
                substring = "  " + "Latest first"
            }
            if index == 4 && arrivalModeLatestFirst  {
                substring = "  " + "Latest first"
            }

            let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR  ])
            attributedString.append(substringAttributedString)
         
            return attributedString
        }
        return nil
    }
    
    
    fileprivate func setupSortDescription() {
        
        let attributedString = NSMutableAttributedString(string: "Smart Sort enables you to select your flight from just the first few results. Flights are sorted after comparing price, duration and various other factors. Learn more", attributes: [
            .font: AppFonts.Regular.withSize(16),
            .foregroundColor: UIColor.black,
            .kern: 0.0
            ])
        attributedString.addAttributes([
            .font: AppFonts.Regular.withSize(16),
            .foregroundColor: UIColor.appColor
            ], range: NSRange(location: 156, length: 10))
        self.smartSortDescription.attributedText = attributedString
        self.smartSortDescription.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(tapLabel(gesture:)))
        self.smartSortDescription.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func  tapLabel(gesture: UITapGestureRecognizer){
   
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
        setupSortDescription()
        selectedSorting = Sort.Smart
    }
}

extension FlightSortFilterViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.attributedText = self.getAttributedStringFor(index: indexPath.row)
        cell.accessoryView = nil
        if  let sortFilter = Sort(rawValue: indexPath.row) {
            
            if sortFilter == selectedSorting {
//                cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
                
                if isInitialSetup == false
                {
                    let indicator = UIActivityIndicatorView(style: .gray)
                    indicator.color = .AertripColor
                    indicator.startAnimating()
                    indicator.hidesWhenStopped = true
                    cell.accessoryView = indicator
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        indicator.stopAnimating()
                        cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
                    }
                }else{
                    cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
                }
            }
        }
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.row == 1 {
            priceHighToLow = false
        }
        
        if indexPath.row == 2 {
            durationLogestFirst = false
        }
        
        if indexPath.row == 3 {
            departModeLatestFirst = false
        }
        
        if indexPath.row == 4{
            arrivalModeLatestFirst = false
        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {

        if indexPath.row == 0{
            if selectedIndex == indexPath.row{
                return indexPath
            }
        }
        selectedIndex = indexPath.row

        isInitialSetup = false
        
        if indexPath.row != 1 {
            priceHighToLow = false
        }
        
        if indexPath.row != 2 {
            durationLogestFirst = false
        }
        
        if indexPath.row != 3 {
            departModeLatestFirst = false
        }
        
        if indexPath.row != 4{
            arrivalModeLatestFirst = false
        }
        
        
        if tableView.indexPathForSelectedRow == indexPath {
            
            if indexPath.row == 1{
                priceHighToLow.toggle()
            }
            
            if indexPath.row == 2 {
                durationLogestFirst.toggle()
            }
            
            if indexPath.row == 3 {
                departModeLatestFirst.toggle()
            }
            
            if indexPath.row == 4{
                arrivalModeLatestFirst.toggle()
            }
        }
        
        if let sortFilter = Sort(rawValue: indexPath.row) {
           
            self.selectedSorting = sortFilter
            
            switch  indexPath.row
            {
          
            case 0:
                delegate?.sortFilterChanged(sort: .Smart)
            
            case 1:
                delegate?.priceFilterChangedWith(priceHighToLow)
                
            case 2 :
                delegate?.durationFilterChangedWith(durationLogestFirst)

            case 3 :
                delegate?.departSortFilterChanged(departMode: departModeLatestFirst)
                
            case 4 :
                delegate?.arrivalSortFilterChanged(arrivalMode: arrivalModeLatestFirst)
                
            default :
                break
//                if indexPath.row == 1 && priceHighToLow == true{
//                    delegate?.sortFilterChanged(sort: Sort(rawValue: 7)!)
//                }else{
//                    delegate?.sortFilterChanged(sort: sortFilter)
//                }
            }
        }
        self.sortTableview.reloadData()
        
        return indexPath
    }
}
