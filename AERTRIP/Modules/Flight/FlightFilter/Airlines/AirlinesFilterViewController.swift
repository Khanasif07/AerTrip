//
//  AirlinesFilterViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol AirlineFilterDelegate : FilterDelegate {
    func allAirlinesSelected()
    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter )
    func airlineFilterUpdated(_ filter : AirlineLegFilter)
}

class AirlinesFilterViewController: UIViewController , FilterViewController {
    
    //MARK:- State Properties
    var currentSelectedMultiCityIndex = 0
    var showMultiAirlineItineraryUI = true
    var showingForReturnJourney = false 
    var airlinesFilterArray = [ AirlineLegFilter]()
    var currentSelectedAirlineFilter : AirlineLegFilter!
    var allAirlineSelectedByUserInteraction = false
    var isIntReturnOrMCJourney = false
    weak var delegate : AirlineFilterDelegate?
    
    //MARK:- Outlets
    @IBOutlet weak var airlinesTableView: UITableView!
    @IBOutlet weak var heightConstraintForMulticityView: NSLayoutConstraint!
    @IBOutlet weak var multicitySegmentView: UIView!
    @IBOutlet weak var JourneyTitle: UILabel!
    
    
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
    }
    
    
    fileprivate func setmultiLegSubviews () {
        
        multicitySegmentView.subviews.forEach { $0.removeFromSuperview() }
        
        multicitySegmentView.layer.cornerRadius = 3
        multicitySegmentView.layer.borderColor = UIColor.AertripColor.cgColor
        multicitySegmentView.layer.borderWidth = 1.0
        multicitySegmentView.clipsToBounds = true
        
        let numberOfStops = airlinesFilterArray.count
        
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
            stopButton.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            
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
        currentSelectedAirlineFilter = airlinesFilterArray[0]
        showMultiAirlineItineraryUI = currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if isIntReturnOrMCJourney {
            showMultiAirlineItineraryUI = airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        setupTableView()
        setmultiLegSubviews()
    }
    
    
    
    func updateUIPostLatestResults() {
       
        
        airlinesTableView.reloadData()
    }
    
    func resetFilter() {
        
        currentSelectedAirlineFilter.airlinesArray = currentSelectedAirlineFilter.airlinesArray.map{
            var airline = $0
            airline.isSelected = false
            return airline
        }
        showMultiAirlineItineraryUI = currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if isIntReturnOrMCJourney {
            showMultiAirlineItineraryUI = airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        currentSelectedAirlineFilter.allAirlinesSelected = false
        currentSelectedAirlineFilter.hideMultipleAirline = false
        allAirlineSelectedByUserInteraction = false
        self.airlinesTableView.reloadData()
    }
    
    //MARK:- Action methods
    @objc fileprivate func tappedOnMulticityButton( sender : UIButton) {
        
        
        let tag = sender.tag
        
        if tag == currentSelectedMultiCityIndex {
            return
        }
        else {
            
            airlinesFilterArray[currentSelectedMultiCityIndex] = currentSelectedAirlineFilter
            currentSelectedMultiCityIndex = tag
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
        
        currentSelectedAirlineFilter = airlinesFilterArray[currentSelectedMultiCityIndex]
        showMultiAirlineItineraryUI = currentSelectedAirlineFilter.multiAl == 0 ? false : true
        if isIntReturnOrMCJourney {
            showMultiAirlineItineraryUI = airlinesFilterArray.map { $0.multiAl }.reduce(0, +) > 0
        }
        JourneyTitle.attributedText = currentSelectedAirlineFilter.leg.descriptionOneFiveThree
        self.airlinesTableView.reloadData()
        
        
    }
    
    @objc func airlineRadioButtonTapped(sender : UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        
        
        if sender.tag == 1 {
            currentSelectedAirlineFilter.allAirlinesSelected = sender.isSelected
            currentSelectedAirlineFilter.hideMultipleAirline  = sender.isSelected
            currentSelectedAirlineFilter.airlinesArray = currentSelectedAirlineFilter.airlinesArray.map {
                var airline = $0
                airline.isSelected = sender.isSelected
                return airline
            }
            allAirlineSelectedByUserInteraction = sender.isSelected
            airlinesTableView.reloadData()
            
            if showingForReturnJourney {
                self.delegate?.allAirlinesSelected()
                self.delegate?.allAirlinesSelected()
            }
            else {
                self.delegate?.allAirlinesSelected()
            }
            return
        }
        if sender.tag == 2 {
            currentSelectedAirlineFilter.hideMultipleAirline = sender.isSelected
            
            if showingForReturnJourney {
                self.delegate?.hideMultiAirlineItineraryUpdated(currentSelectedAirlineFilter)
                self.delegate?.hideMultiAirlineItineraryUpdated(currentSelectedAirlineFilter)
            }
            else {
                self.delegate?.hideMultiAirlineItineraryUpdated(currentSelectedAirlineFilter)
            }
            return
        }
        
        if sender.tag >= 1000 {
            
            let selectedRow = sender.tag - 1000
            var airline = currentSelectedAirlineFilter.airlinesArray[selectedRow]
            airline.isSelected = sender.isSelected
            currentSelectedAirlineFilter.airlinesArray[selectedRow] = airline
            
            let combinedSelection = currentSelectedAirlineFilter.airlinesArray.reduce(true) { (result, next) -> Bool in
                return result &&  next.isSelected
            }
            
            currentSelectedAirlineFilter.allAirlinesSelected = combinedSelection
            allAirlineSelectedByUserInteraction = combinedSelection
            airlinesTableView.reloadRows(at: [IndexPath(row: selectedRow, section: 2) , IndexPath(row: 0, section: 0)], with: .none)
            
            // if airlineArray contains only one element , applying airline filter does not affect filtered flight results
            if currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return
            }
        }
        
        
        if showingForReturnJourney {
            self.delegate?.airlineFilterUpdated(currentSelectedAirlineFilter)
        }
        else {
            self.delegate?.airlineFilterUpdated(currentSelectedAirlineFilter)
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
            if currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return 0
            }
            return 1
        }
        
        if section == 1 {
            
            if showMultiAirlineItineraryUI {
                return 1
            }else {
                return 0
            }
        }
     return currentSelectedAirlineFilter.airlinesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonTableViewCell {
            cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .selected)
            cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
            cell.selectionStyle = .none
            if indexPath.section == 0 {
                cell.textLabel?.text = "All Airlines"
                cell.radioButton.tag = 1
                cell.radioButton.isSelected = currentSelectedAirlineFilter.allAirlinesSelected
                
                if allAirlineSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                }
            }
            if indexPath.section == 1 {
                
                cell.textLabel?.text = "Hide Multi-Airline Itinerary"
                cell.imageView?.image = UIImage(named:"MultiAirlineItinery")
                cell.radioButton.tag = 2
                cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .selected)
                cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
                cell.radioButton.isSelected = currentSelectedAirlineFilter.hideMultipleAirline
            }
            if indexPath.section == 2 {
                let airline = currentSelectedAirlineFilter.airlinesArray[indexPath.row]
                cell.textLabel?.text = airline.name
                if let image = tableView.resourceFor(urlPath: airline.iconImageURL , forView: indexPath.row) {
                    
                    let resizedImage = image.resizeImage(30.0, opaque: false)
                    cell.imageView?.contentMode = .scaleAspectFit
                    cell.imageView?.image = resizedImage
                }
                cell.radioButton.tag = 1000 + indexPath.row
                cell.radioButton.isSelected = airline.isSelected
                
                if allAirlineSelectedByUserInteraction {
                   cell.radioButton.isSelected  = true
                }
            }
            
            
            cell.radioButton.addTarget(self, action: #selector(airlineRadioButtonTapped(sender:)) , for: .touchDown)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            // if airlineArray contains only one element , footer separator for 'All Airlines' option is hidden and separator below it is not required
            if currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return nil
            }
            
            let footerView = UIView()
            
            
            let view = UIView(frame: CGRect(x: 16, y: 0, width: self.view.frame.size.width - 16, height: 0.5))
            view.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
            footerView.addSubview(view)
            return footerView
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
        if section == 0 {

            // if airlineArray contains only one element , footer separator for 'All Airlines' option is hidden and separator below it is not required
            if currentSelectedAirlineFilter.airlinesArray.count == 1 {
                return 0
            }
            
            return 0.5
        }
        return 0
    }
    
    

    
}



