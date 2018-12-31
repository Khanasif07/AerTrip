//
//  HotelPreferencesVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelPreferencesVC:  BaseVC {
    
    //MARK:- Properties
    //MARK:-
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var hotelsTableView: UITableView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:- Extension Initial setups
//MARK:-
private extension HotelPreferencesVC {
    
    func initialSetups() {
        
        self.registerXibs()
    }
    
    func registerXibs() {
        
        self.hotelsTableView.dataSource = self
        self.hotelsTableView.delegate      = self
    }
}

//MARK:- Extension Initial setups
//MARK:-
extension HotelPreferencesVC {
    
    @objc func oneStarButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
}

//MARK:- Extension UITableViewDataSource, UITableViewDelegate
//MARK:-
extension HotelPreferencesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreferStarCategoryCell", for: indexPath) as? PreferStarCategoryCell  else {
                fatalError("PreferStarCategoryCell not found")
            }
            
            cell.oneStarButton.addTarget(self, action: #selector(self.oneStarButtonAction(_:)), for: .touchUpInside)
            cell.twoStarButton.addTarget(self, action: #selector(self.oneStarButtonAction(_:)), for: .touchUpInside)
            cell.threeStarButton.addTarget(self, action: #selector(self.oneStarButtonAction(_:)), for: .touchUpInside)
            cell.fourStarButton.addTarget(self, action: #selector(self.oneStarButtonAction(_:)), for: .touchUpInside)
            cell.fiveStarButton.addTarget(self, action: #selector(self.oneStarButtonAction(_:)), for: .touchUpInside)
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFavouriteHotels", for: indexPath) as? AddFavouriteHotels  else {
                fatalError("AddFavouriteHotels not found")
            }
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouriteHotelCell", for: indexPath) as? NoFavouriteHotelCell  else {
                fatalError("NoFavouriteHotelCell not found")
            }
            
            return cell
            
        default:
            fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
