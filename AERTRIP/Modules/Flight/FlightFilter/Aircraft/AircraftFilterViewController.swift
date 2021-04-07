//
//  AircraftFilterViewController.swift
//  AERTRIP
//
//  Created by Monika Sonawane on 19/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit


protocol AircraftFilterDelegate : FilterDelegate {
//    func allAirlinesSelected(_ status: Bool)
//    func hideMultiAirlineItineraryUpdated(_ filter: AirlineLegFilter )
    func aircraftFilterUpdated(allAircraftsSelected : Bool, _ filter : AircraftFilter)
}

class AircraftFilterViewController: UIViewController , FilterViewController {
   
    
    @IBOutlet weak var aircraftTableView: UITableView!
    
//    var selectAllAircrafts = false
    var aircraftArray = [[String:Any]]()

    var aircraftFilter = AircraftFilter()
    var flightSearchParameters = JSONDictionary()
    
    weak var delegate : AircraftFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func setupTableView() {
        aircraftTableView.separatorStyle = .none
        aircraftTableView.tableFooterView = UIView(frame: .zero)
        aircraftTableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        aircraftTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    @objc func aircraftRadioButtonTapped(sender : UIButton) {
   
    }
    
    func resetFilter(){
        self.aircraftFilter.selectedAircraftsArray.removeAll()
        self.aircraftTableView.reloadData()
    }
    
    
    func initialSetup() {
        
    }
    
    func updateUIPostLatestResults() {
        
    }
    
    
    func updateAircraftList(filter : AircraftFilter){
        
//        printDebug("aircraft filter count....\(filter.allAircrafts.count)")
        
        let starAircrafts = filter.allAircraftsArray.filter { $0.quality == 1 }.sorted { (craft1, craft2) -> Bool in
            craft1.name < craft2.name
        }
        
        let withoutStarAircrafts = filter.allAircraftsArray.filter { $0.quality != 1 }.sorted { (craft1, craft2) -> Bool in
            craft1.name < craft2.name
        }
        
        var combinedArray = starAircrafts
        combinedArray.append(contentsOf: withoutStarAircrafts)
        
        self.aircraftFilter.allAircraftsArray = combinedArray
        self.aircraftFilter.selectedAircraftsArray = filter.selectedAircraftsArray
        
//        printDebug("aircraftFilter in vc...\(self.aircraftFilter.allAircrafts)")

        aircraftTableView.reloadData()
                
    }
    
}

extension AircraftFilterViewController : UITableViewDataSource , UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 2
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        printDebug("count is..\(self.aircraftFilter.allAircraftsArray.count)")
        return section == 0 ? 1 : self.aircraftFilter.allAircraftsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
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
            return 0.5
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonTableViewCell {

            
            if indexPath.section == 0 {
                
                cell.configureAllAircraftsCell()
                
                cell.imageView?.image = nil
                cell.radioButton.setImage(nil, for: .normal)
                cell.radioButton.setImage(nil, for: .selected)
                if self.aircraftFilter.selectedAircraftsArray.count == self.aircraftFilter.allAircraftsArray.count {
                    cell.radioButton.setBackgroundImage(#imageLiteral(resourceName: "radioButtonSelect"), for: .normal)
                }else{
                    cell.radioButton.setBackgroundImage(#imageLiteral(resourceName: "radioButtonUnselect"), for: .normal)
                }
//                cell.radioButton.setImage(self.aircraftFilter.selectedAircraftsArray.count == self.aircraftFilter.allAircraftsArray.count ? #imageLiteral(resourceName: "selectOption") : #imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
           
            } else {
                
               // cell.configureAircraftCell(title: self.aircraftFilter.allAircrafts[indexPath.row])

//                cell.textLabel?.text = self.aircraftFilter.allAircraftsArray[indexPath.row].name
                
//                if self.aircraftFilter.selectedAircraftsArray.contains(self.aircraftFilter.allAircraftsArray[indexPath.row]) {
//
//                        cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .normal)
//
//                    } else {
//
//                        cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
//
//                    }
                cell.imageView?.image = nil
                cell.radioButton.setImage(nil, for: .normal)
                cell.radioButton.setImage(nil, for: .selected)
            if self.aircraftFilter.selectedAircraftsArray.contains(self.aircraftFilter.allAircraftsArray[indexPath.row]) {
                    cell.radioButton.setBackgroundImage(#imageLiteral(resourceName: "radioButtonSelect"), for: .normal)
                }else{
                    cell.radioButton.setBackgroundImage(#imageLiteral(resourceName: "radioButtonUnselect"), for: .normal)
                }
                
        cell.textLabel?.text = self.aircraftFilter.allAircraftsArray[indexPath.row].quality == 1 ? "⭑ \(self.aircraftFilter.allAircraftsArray[indexPath.row].name)" : self.aircraftFilter.allAircraftsArray[indexPath.row].name

            }
            
            cell.radioButton.isUserInteractionEnabled = false
            cell.radioButton.imageView?.contentMode = .scaleAspectFill
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if self.aircraftFilter.selectedAircraftsArray.count == self.aircraftFilter.allAircraftsArray.count {
                self.aircraftFilter.selectedAircraftsArray = []
            } else {
                self.aircraftFilter.selectedAircraftsArray = self.aircraftFilter.allAircraftsArray
            }
            
        } else {
            
            if let ind = self.aircraftFilter.selectedAircraftsArray.firstIndex(where: { (item) -> Bool in
                return item.name.lowercased() == self.aircraftFilter.allAircraftsArray[indexPath.row].name.lowercased()
               }) {
                   self.aircraftFilter.selectedAircraftsArray.remove(at: ind)
               } else {
                   self.aircraftFilter.selectedAircraftsArray.append(self.aircraftFilter.allAircraftsArray[indexPath.row])
               }
               
        }
        
        aircraftTableView.reloadData()
        self.delegate?.aircraftFilterUpdated(allAircraftsSelected: self.aircraftFilter.selectedAircraftsArray.count == self.aircraftFilter.allAircraftsArray.count, self.aircraftFilter)
        
    }
    
    
    
}
