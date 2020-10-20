//
//  AircraftFilterViewController.swift
//  AERTRIP
//
//  Created by Monika Sonawane on 19/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AircraftFilterViewController: UIViewController
{
    @IBOutlet weak var aircraftTableView: UITableView!
    
    var selectAllAircrafts = false
    var aircraftArray = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    func setupTableView()
    {
        aircraftTableView.separatorStyle = .none
        aircraftTableView.tableFooterView = UIView(frame: .zero)
        aircraftTableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        aircraftTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }

    @objc func aircraftRadioButtonTapped(sender : UIButton)
    {
        if sender.tag == 1{
            if sender.isSelected{
                selectAllAircrafts = false
            }else{
                selectAllAircrafts = true
            }
            
            for i in 0..<aircraftArray.count{
                aircraftArray[i]["isSelected"] = selectAllAircrafts
            }
            
        }else{
            selectAllAircrafts = false
            
            if sender.isSelected{
                sender.isSelected = false
            }else{
                sender.isSelected = true
            }
            
            let index = sender.tag-100
            
            if let isRadioButtonSelected = aircraftArray[index]["isSelected"] as? Bool{
                if  isRadioButtonSelected{
                    aircraftArray[index]["isSelected"] = false
                }else{
                    aircraftArray[index]["isSelected"] = true
                }
            }
            
        }
        
        aircraftTableView.reloadData()

    }
}


extension AircraftFilterViewController : UITableViewDataSource , UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return aircraftArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonTableViewCell {
            cell.radioButton.setImage(#imageLiteral(resourceName: "selectOption"), for: .selected)
            cell.radioButton.setImage(#imageLiteral(resourceName: "UncheckedGreenRadioButton"), for: .normal)
            cell.selectionStyle = .none
            if indexPath.section == 0 {
                cell.textLabel?.text = "All Aircrafts"
                cell.radioButton.tag = 1
                
                if selectAllAircrafts{
                    cell.radioButton.isSelected = true
                }else{
                    cell.radioButton.isSelected = false
                }
                
            }else{
                cell.textLabel?.text = aircraftArray[indexPath.row]["aircraft"] as? String ?? "" //"Aircrafts"
                
                cell.radioButton.tag = 100+indexPath.row
                cell.radioButton.isSelected = aircraftArray[indexPath.row]["isSelected"] as? Bool ?? false
            }

            cell.radioButton.addTarget(self, action: #selector(aircraftRadioButtonTapped(sender:)) , for: .touchDown)
            return cell
        }

        return UITableViewCell()
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
}
