//
//  AirlinesFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class AirlinesFilterViewController: UIViewController , FilterViewController {
    
    //MARK:- State Properties
    let viewModel = AirlinesFilterVM()
    
    //MARK:- Outlets
    @IBOutlet weak var airlinesTableView: UITableView!
    @IBOutlet weak var heightConstraintForMulticityView: NSLayoutConstraint!
    @IBOutlet weak var multicitySegmentView: UIView!
    @IBOutlet weak var JourneyTitle: UILabel!
    var selectedAirlineArray = [String]()
    
    //MARK :- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    //MARK:- Additional UI Methods
    fileprivate func setupTableView() {
        
        airlinesTableView.separatorStyle = .none
        airlinesTableView.tableFooterView = UIView(frame: .zero)
        airlinesTableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        airlinesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    
    fileprivate func setmultiLegSubviews () {
        
        multicitySegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multicitySegmentView.layer.cornerRadius = 3
        multicitySegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multicitySegmentView.layer.borderWidth = 1.0
        multicitySegmentView.clipsToBounds = true
        
        let numberOfStops = viewModel.airlinesFilterArray.count
        
        for  i in 1...numberOfStops  {
            
            let segmentViewWidth = UIScreen.main.bounds.size.width - 32
            let width = segmentViewWidth / CGFloat(numberOfStops)
            let xcordinate = CGFloat( i - 1 ) * width
            let height = self.multicitySegmentView.frame.size.height
            var rect = CGRect(x: xcordinate, y: 0, width: width, height: height)
            let stopButton = UIButton(frame: rect)
            stopButton.isSelected = false
            stopButton.tag = i - 1
            let title = "\(i)"
            stopButton.setTitle(title , for: .normal)
            stopButton.setTitleColor(UIColor.AertripColor, for: .normal)
            stopButton.setTitleColor(UIColor.white, for: .selected)
            
            stopButton.addTarget(self, action: #selector(tappedOnMulticityButton(sender:)), for: .touchDown)
//            stopButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            stopButton.titleLabel?.font = AppFonts.Regular.withSize(16)

            if i == 1 {
                stopButton.isSelected = true
                stopButton.backgroundColor = UIColor.AertripColor
            }
            
            
            
            multicitySegmentView.addSubview(stopButton)
            
            if i != numberOfStops {
                rect  = CGRect(x: xcordinate + width - 1 , y: 0, width: 1, height: 30)
                let verticalSeparator = UIView(frame: rect)
                verticalSeparator.backgroundColor = UIColor.AertripColor
                multicitySegmentView.addSubview(verticalSeparator)
            }
        }
    }
    
    
    //MARK:- Filter State management methods
    
    func initialSetup() {
        
        heightConstraintForMulticityView.constant = 0
        multicitySegmentView.isHidden = true
        viewModel.currentSelectedAirlineFilter = viewModel.airlinesFilterArray[0]
        viewModel.showMultiAirlineItineraryUI = viewModel.currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if viewModel.isIntReturnOrMCJourney {
            viewModel.showMultiAirlineItineraryUI = viewModel.airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        setupTableView()
        setmultiLegSubviews()
    }
    
    
    
    func updateUIPostLatestResults() {
        
        for i in 0..<viewModel.currentSelectedAirlineFilter.airlinesArray.count{
            for airline in selectedAirlineArray{
                if (viewModel.currentSelectedAirlineFilter.airlinesArray[i].name == airline) || (viewModel.currentSelectedAirlineFilter.airlinesArray[i].code == airline){
                    viewModel.currentSelectedAirlineFilter.airlinesArray[i].isSelected = true
                }else{
                    //                    viewModel.currentSelectedAirlineFilter.airlinesArray[i].isSelected = false
                }
            }
        }
        guard airlinesTableView != nil else { return }
        airlinesTableView.reloadData()
    }
    
    func resetFilter() {
        selectedAirlineArray.removeAll()
        viewModel.resetFilter()
        guard airlinesTableView != nil else { return }
        self.airlinesTableView.reloadData()
    }
    
    //MARK:- Action methods
    @objc fileprivate func tappedOnMulticityButton( sender : UIButton) {
        
        let tag = sender.tag
        
        if tag == viewModel.currentSelectedMultiCityIndex {
            return
        }
        else {
            
            viewModel.airlinesFilterArray[viewModel.currentSelectedMultiCityIndex] = viewModel.currentSelectedAirlineFilter
            viewModel.currentSelectedMultiCityIndex = tag
        }
        
        
        let senderSelectedState = sender.isSelected
        multicitySegmentView.subviews.forEach { (view) in
            
            if let button = view as? UIButton {
                
                button.backgroundColor = UIColor.white
                button.isSelected = false
            }
        }
        
        if senderSelectedState {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.AertripColor
        }
        
        viewModel.currentSelectedAirlineFilter = viewModel.airlinesFilterArray[viewModel.currentSelectedMultiCityIndex]
        viewModel.showMultiAirlineItineraryUI = viewModel.currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if viewModel.isIntReturnOrMCJourney {
            viewModel.showMultiAirlineItineraryUI = viewModel.airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        JourneyTitle.attributedText = viewModel.currentSelectedAirlineFilter.leg.descriptionOneFiveThree
        self.airlinesTableView.reloadData()
        
        
    }
    
    @objc func airlineRadioButtonTapped(sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 1 {
            viewModel.currentSelectedAirlineFilter.allAirlinesSelected = sender.isSelected
            viewModel.currentSelectedAirlineFilter.airlinesArray = viewModel.currentSelectedAirlineFilter.airlinesArray.map {
                var airline = $0
                airline.isSelected = sender.isSelected
                return airline
            }
            viewModel.allAirlineSelectedByUserInteraction = sender.isSelected
            if sender.isSelected == false{
                selectedAirlineArray.removeAll()
            }
            airlinesTableView.reloadData()
            
            if viewModel.showingForReturnJourney {
                self.viewModel.delegate?.allAirlinesSelected(sender.isSelected)
                self.viewModel.delegate?.allAirlinesSelected(sender.isSelected)
            }
            else {
                self.viewModel.delegate?.allAirlinesSelected(sender.isSelected)
            }
            return
        }
        if sender.tag == 2 {
            viewModel.currentSelectedAirlineFilter.hideMultipleAirline = sender.isSelected
            
            if viewModel.showingForReturnJourney {
                self.viewModel.delegate?.hideMultiAirlineItineraryUpdated(viewModel.currentSelectedAirlineFilter)
                self.viewModel.delegate?.hideMultiAirlineItineraryUpdated(viewModel.currentSelectedAirlineFilter)
            }
            else {
                self.viewModel.delegate?.hideMultiAirlineItineraryUpdated(viewModel.currentSelectedAirlineFilter)
            }
            return
        }
        
        if sender.tag >= 1000 {
            
            let selectedRow = sender.tag - 1000
            var airline = viewModel.currentSelectedAirlineFilter.airlinesArray[selectedRow]
            airline.isSelected = sender.isSelected
            viewModel.currentSelectedAirlineFilter.airlinesArray[selectedRow] = airline
            
            if !selectedAirlineArray.contains(airline.name){
                selectedAirlineArray.append(airline.name)
            }else{
                selectedAirlineArray.removeAll(){$0 == airline.name}
            }
            
            let combinedSelection = viewModel.currentSelectedAirlineFilter.airlinesArray.reduce(true) { (result, next) -> Bool in
                return result &&  next.isSelected
            }
            
            viewModel.currentSelectedAirlineFilter.allAirlinesSelected = combinedSelection
            viewModel.allAirlineSelectedByUserInteraction = combinedSelection
            airlinesTableView.reloadRows(at: [IndexPath(row: selectedRow, section: 2) , IndexPath(row: 0, section: 0)], with: .none)
            
            // if airlineArray contains only one element , applying airline filter does not affect filtered flight results
            if viewModel.currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return
            }
        }
        
        
        if viewModel.showingForReturnJourney {
            self.viewModel.delegate?.airlineFilterUpdated(viewModel.currentSelectedAirlineFilter)
        }
        else {
            self.viewModel.delegate?.airlineFilterUpdated(viewModel.currentSelectedAirlineFilter)
        }
    }
    
}


extension AirlinesFilterViewController : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        // if airlineArray contains only one element , footer separator for 'All Airlines' option is hidden
            if viewModel.currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return 0
            }
            return 1
        }
        
        if section == 1 {
            
            if viewModel.showMultiAirlineItineraryUI {
                return 1
            }else {
                return 0
            }
        }
     return viewModel.currentSelectedAirlineFilter.airlinesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonTableViewCell {
            cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .selected)
            cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
            cell.imageView?.image = nil
            cell.selectionStyle = .none
            if indexPath.section == 0 {
                cell.textLabel?.text = "All Airlines"
                cell.radioButton.tag = 1
                cell.radioButton.isSelected = viewModel.currentSelectedAirlineFilter.allAirlinesSelected
                
                if viewModel.allAirlineSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                }
                cell.imageView?.image = nil

            }
            if indexPath.section == 1 {
                
                cell.textLabel?.text = "Hide Multi-Airline Itinerary"
                cell.imageView?.image = UIImage(named:"MultiAirlineItinery")
                cell.radioButton.tag = 2
                cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .selected)
                cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
                cell.radioButton.isSelected = viewModel.currentSelectedAirlineFilter.hideMultipleAirline
                cell.imageView?.image = nil
            }
            if indexPath.section == 2 {
                let airline = viewModel.currentSelectedAirlineFilter.airlinesArray[indexPath.row]
                cell.textLabel?.text = airline.name
                
                if let image = tableView.resourceFor(urlPath: airline.iconImageURL , forView: indexPath.row) {
                    
                    let resizedImage = image.resizeImage(30.0, opaque: false)
                    cell.imageView?.contentMode = .scaleAspectFit
                    cell.imageView?.image = resizedImage
                }
                cell.radioButton.tag = 1000 + indexPath.row
                cell.radioButton.isSelected = airline.isSelected
                
                if viewModel.allAirlineSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                }
            }
            cell.radioButton.isUserInteractionEnabled = false
//            cell.radioButton.addTarget(self, action: #selector(airlineRadioButtonTapped(sender:)) , for: .touchDown)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell else { return }
        airlineRadioButtonTapped(sender: cell.radioButton)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            // if airlineArray contains only one element , footer separator for 'All Airlines' option is hidden and separator below it is not required
            if viewModel.currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return nil
            }
            
            let footerView = UIView()
            
            let view = ATDividerView()
            view.frame = CGRect(x: 16, y: 0, width: self.view.frame.size.width - 16, height: 0.5)
            view.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
            footerView.addSubview(view)
            return footerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        if section == 0 {

            // if airlineArray contains only one element , footer separator for 'All Airlines' option is hidden and separator below it is not required
            if viewModel.currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return 0
            }
            
            return 0.5
        }
        return 0
    }
    
    

    
}



