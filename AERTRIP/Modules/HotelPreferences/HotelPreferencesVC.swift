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
    
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    private var shouldBroadCastNewData: Bool = false
    
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
    
    override func dataChanged(_ note: Notification) {
        if note.object == nil {
            self.viewModel.webserviceForGetHotelPreferenceList()
            shouldBroadCastNewData = true
        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreferStarCategoryCell", for: indexPath) as? PreferStarCategoryCell  else {
                fatalError("PreferStarCategoryCell not found")
            }
            
            cell.setPreviousStars(stars: self.viewModel.selectedStars)
            cell.delegate = self
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddFavouriteHotels", for: indexPath) as? AddFavouriteHotels  else {
                fatalError("AddFavouriteHotels not found")
            }
            
            return cell
            
        default:
            
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelCardTableViewCell", for: indexPath) as? HotelCardTableViewCell  else {
                    fatalError("HotelCardTableViewCell not found")
                }
                
                if self.viewModel.hotels.isEmpty {
                    self.emptyView.frame = CGRect(x: 0.0, y: 20.0, width: UIDevice.screenWidth, height: cell.contentView.height)
                    cell.cityLabel.isHidden = true
                    cell.viewAllButton.isHidden = true
                    cell.contentView.addSubview(self.emptyView)
                }
                else {
                    cell.cityLabel.isHidden = false
                    cell.viewAllButton.isHidden = false
                    self.emptyView.removeFromSuperview()
                    cell.cityLabel.text = self.viewModel.hotels[indexPath.row - 2].cityName
                    cell.hotels = self.viewModel.hotels[indexPath.row - 2].holetList
                    cell.hotelCollectionView.reloadData()
                }
                cell.delegate = self
                
                return cell
        }
    }
}

extension HotelPreferencesVC: HotelCardTableViewCellDelegate, PreferStarCategoryCellDelegate {
    func viewAllButtonTapped(_ sender: UIButton) {
        AppFlowManager.default.moveToViewAllHotelsVC(forCities: self.viewModel.hotels)
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        self.viewModel.updateFavourite(forHotel: forHotel)
    }
    
    func starSelectionUpdate(updatedStars: [Int]) {
        self.viewModel.getHotelsByStarPreference(stars: updatedStars)
    }
}

//MARK:- Extension HotelPreferencesDelegate
//MARK:-
extension HotelPreferencesVC : HotelPreferencesDelegate {
    func willUpdateFavourite() {
        AppNetworking.showLoader()
    }
    
    func updateFavouriteSuccess(withMessage: String) {
        AppNetworking.hideLoader()
        AppToast.default.showToastMessage(message: withMessage, vc: self)
        self.viewModel.webserviceForGetHotelPreferenceList()
    }
    
    func updateFavouriteFail() {
        AppNetworking.hideLoader()
    }
    
    
    func willCallApi() {
        if self.viewModel.hotels.isEmpty {
            AppNetworking.showLoader()
        }
    }
    
    func getApiSuccess() {
        AppNetworking.hideLoader()
        self.hotelsTableView.reloadData()
        if shouldBroadCastNewData {
            self.sendDataChangedNotification(data: self.viewModel.hotels)
            shouldBroadCastNewData = false
        }
    }
    
    func getApiFailure(errors: ErrorCodes) {
        AppNetworking.hideLoader()
        AppGlobals.shared.showErrorOnToastView(errors: errors, viewController: self)
    }
}
