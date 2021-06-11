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

class FlightSortFilterViewController: UIViewController {

    @IBOutlet weak var smartSortDescription: UILabel!
    @IBOutlet weak var sortTableview: UITableView!
    
    @IBOutlet weak var whySmartLabel: UILabel!
    
    
    
    let viewModel = FlightSortFilterVM()
    
    //MARK:- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    

    //MARK:- Additional setup methods
    fileprivate func setupTableView () {
        sortTableview.separatorStyle = .none
        sortTableview.bounces = false
        sortTableview.isScrollEnabled = false
    }
    
    func resetSort() {
        viewModel.resetSort()
        self.sortTableview.reloadData()
    }
    
    
    fileprivate func getAttributedStringFor(index : Int) ->NSAttributedString? {
        
        if  let sortFilter = Sort(rawValue: index) {
            
            
            var attributes : [NSAttributedString.Key : Any]
            if ( sortFilter == viewModel.selectedSorting) {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18),
                              NSAttributedString.Key.foregroundColor : AppColors.commonThemeGreen]
            } else {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]
            }
            
            let attributedString = NSMutableAttributedString(string: sortFilter.title, attributes: attributes)
            
            var substring = "  " + sortFilter.subTitle
            
            if index == 1 && viewModel.priceHighToLow {
                substring = "  " + "High to low"
            }
            if index == 2  && viewModel.durationLogestFirst {
                substring = "  "  + "Longest first"
            }
            if index == 3 && viewModel.departModeLatestFirst{
                substring = "  " + "Latest first"
            }
            if index == 4 && viewModel.arrivalModeLatestFirst  {
                substring = "  " + "Latest first"
            }

            let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : AppColors.commonThemeGray ])
            attributedString.append(substringAttributedString)
         
            return attributedString
        }
        return nil
    }
    
    
    fileprivate func setupSortDescription() {
        
        let attributedString = NSMutableAttributedString(string: "Smart Sort enables you to select your flight from just the first few results. Flights are sorted after comparing price, duration and various other factors. Learn more", attributes: [
            .font: AppFonts.Regular.withSize(16),
            .foregroundColor: AppColors.commonThemeGray,
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
            
            
            
            if let url = URL(string: AppKeys.smartSort) {
                AppFlowManager.default.showURLOnATWebView(url, screenTitle:  "Smart Sort", presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
            }

        }
    }
    
    func initialSetup() {
        setUpColors()
        setupTableView()
        setupSortDescription()
        viewModel.selectedSorting = Sort.Smart
        viewModel.vmDelegate = self
        viewModel.setAppliedSortFromDeepLink()
    }
    
    func setUpColors(){
        self.whySmartLabel.textColor = AppColors.themeBlack
        self.smartSortDescription.textColor = AppColors.themeBlack
        self.view.backgroundColor = AppColors.themeWhiteDashboard
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
        
        cell.contentView.backgroundColor = AppColors.themeWhiteDashboard
        cell.accessoryView?.backgroundColor = AppColors.clear
        
        if  let sortFilter = Sort(rawValue: indexPath.row) {
            
            if sortFilter == viewModel.selectedSorting {
//                cell.accessoryView = UIImageView(image: UIImage(named: "greenTick"))
                
                if viewModel.isInitialSetup == false {
                    let indicator = UIActivityIndicatorView(style: .medium)
                    indicator.color = .AertripColor
                    indicator.startAnimating()
                    indicator.hidesWhenStopped = true
                    cell.accessoryView = indicator
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        indicator.stopAnimating()
                        cell.accessoryView = UIImageView(image: AppImages.greenTick)
                    }
                }else{
                    cell.accessoryView = UIImageView(image: AppImages.greenTick)
                }
            }
        }
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.row == 1 {
            viewModel.priceHighToLow = false
        }
        
        if indexPath.row == 2 {
            viewModel.durationLogestFirst = false
        }
        
        if indexPath.row == 3 {
            viewModel.departModeLatestFirst = false
        }
        
        if indexPath.row == 4{
            viewModel.arrivalModeLatestFirst = false
        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {

        if indexPath.row == 0{
            if viewModel.selectedIndex == indexPath.row{
                return indexPath
            }
        }
        viewModel.selectedIndex = indexPath.row

        viewModel.isInitialSetup = false
        
        if indexPath.row != 1 {
            viewModel.priceHighToLow = false
        }
        
        if indexPath.row != 2 {
            viewModel.durationLogestFirst = false
        }
        
        if indexPath.row != 3 {
            viewModel.departModeLatestFirst = false
        }
        
        if indexPath.row != 4{
            viewModel.arrivalModeLatestFirst = false
        }
        
        
        if tableView.indexPathForSelectedRow == indexPath {
            
            if indexPath.row == 1{
                viewModel.priceHighToLow.toggle()
            }
            
            if indexPath.row == 2 {
                viewModel.durationLogestFirst.toggle()
            }
            
            if indexPath.row == 3 {
                viewModel.departModeLatestFirst.toggle()
            }
            
            if indexPath.row == 4{
                viewModel.arrivalModeLatestFirst.toggle()
            }
        }
        
        if let sortFilter = Sort(rawValue: indexPath.row) {
           
            self.viewModel.selectedSorting = sortFilter
            
            switch  indexPath.row
            {
          
            case 0:
                viewModel.delegate?.sortFilterChanged(sort: .Smart)
            
            case 1:
                viewModel.delegate?.priceFilterChangedWith(viewModel.priceHighToLow)
                
            case 2 :
                viewModel.delegate?.durationFilterChangedWith(viewModel.durationLogestFirst)

            case 3 :
                viewModel.delegate?.departSortFilterChanged(departMode: viewModel.departModeLatestFirst)
                
            case 4 :
                viewModel.delegate?.arrivalSortFilterChanged(arrivalMode: viewModel.arrivalModeLatestFirst)
                
            default :
                break
            }
        }
        self.sortTableview.reloadData()
        
        return indexPath
    }
}

extension FlightSortFilterViewController: FlightsSortVMDelegate {
    func selectRow(row: Int) {
        sortTableview.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
    }
}
