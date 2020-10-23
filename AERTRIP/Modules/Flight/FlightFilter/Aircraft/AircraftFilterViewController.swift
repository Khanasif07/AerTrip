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
    func aircraftFilterUpdated(_ filter : AircraftFilter)
}

class AircraftFilterViewController: UIViewController {
    
    @IBOutlet weak var aircraftTableView: UITableView!
    
    var selectAllAircrafts = false
    var aircraftArray = [[String:Any]]()

    var aircraftFilter = AircraftFilter()
    
    var c = 0
    
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
    
    func assignC(){
        c = 2
    }
    
    func updateAircraftList(filter : AircraftFilter){
        
        printDebug("aircraft filter count....\(filter.allAircrafts.count)")
        
        self.aircraftFilter = filter
        
        printDebug("c is...\(c)")
        
        aircraftTableView.reloadData()
                
    }
    
}


extension AircraftFilterViewController : UITableViewDataSource , UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 2
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        printDebug("count is..\(self.aircraftFilter.allAircrafts.count)")
        return section == 0 ? 1 : self.aircraftFilter.allAircrafts.count
        
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
                
                cell.radioButton.setImage(self.aircraftFilter.selectedAircrafts.count == self.aircraftFilter.allAircrafts.count ? #imageLiteral(resourceName: "selectOption") : #imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
           
            } else {
                
                cell.configureAircraftCell(title: self.aircraftFilter.allAircrafts[indexPath.row])

                if self.aircraftFilter.selectedAircrafts.contains(self.aircraftFilter.allAircrafts[indexPath.row]) {
                        
                        cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .normal)

                    } else {
                        
                        cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)

                    }
                
            }

            return cell
        }

        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if self.aircraftFilter.selectedAircrafts.count == self.aircraftFilter.allAircrafts.count {
                self.aircraftFilter.selectedAircrafts = []
            } else {
                self.aircraftFilter.selectedAircrafts = self.aircraftFilter.allAircrafts

            }

            
        } else {
            
            if let ind = self.aircraftFilter.selectedAircrafts.firstIndex(where: { (item) -> Bool in
                   return item == self.aircraftFilter.allAircrafts[indexPath.row]
               }) {
                   self.aircraftFilter.selectedAircrafts.remove(at: ind)
               } else{
                   self.aircraftFilter.selectedAircrafts.append(self.aircraftFilter.allAircrafts[indexPath.row])
               }
               
        }
        
        aircraftTableView.reloadData()

        self.delegate?.aircraftFilterUpdated(self.aircraftFilter)
        
    }
    
    
    
}
