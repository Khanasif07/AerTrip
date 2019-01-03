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
    let viewModel = HotelPreferencesVM()
    
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
    
    override func bindViewModel() {
        self.viewModel.delegate = self
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
        self.viewModel.webserviceForGetHotelPreferenceList()
    }
    
    func registerXibs() {
        
        self.hotelsTableView.register(UINib(nibName: "HotelCardTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelCardTableViewCell")
        self.hotelsTableView.dataSource = self
        self.hotelsTableView.delegate      = self
    }
}

//MARK:- Extension UITableViewDataSource, UITableViewDelegate
//MARK:-
extension HotelPreferencesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel.hotels.isEmpty {
            return 3
        } else {
            return self.viewModel.hotels.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreferStarCategoryCell", for: indexPath) as? PreferStarCategoryCell  else {
                fatalError("PreferStarCategoryCell not found")
            }
            
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFavouriteHotels", for: indexPath) as? AddFavouriteHotels  else {
                fatalError("AddFavouriteHotels not found")
            }
            
            return cell
            
            
            
            
            
        default:
            
            if self.viewModel.hotels.isEmpty {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouriteHotelCell", for: indexPath) as? NoFavouriteHotelCell  else {
                    fatalError("NoFavouriteHotelCell not found")
                }
                
                return cell
                
            } else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell", for: indexPath) as? HotelCardTableViewCell  else {
                    fatalError("HotelCardTableViewCell not found")
                }
                
                cell.cityLabel.text = self.viewModel.hotels[indexPath.row - 2].cityName
                cell.hotels = self.viewModel.hotels[indexPath.row - 2].holetList
                cell.hotelCollectionView.reloadData()
                
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK:- Extension HotelPreferencesDelegate
//MARK:-
extension HotelPreferencesVC : HotelPreferencesDelegate {
    
    func willCallApi() {
        
    }
    
    func getApiSuccess() {
        
        self.hotelsTableView.reloadData()
    }
    
    func getApiFailure(errors: ErrorCodes) {
        
        AppGlobals.shared.showErrorOnToastView(errors: errors, viewController: self)
    }
    
    
}
