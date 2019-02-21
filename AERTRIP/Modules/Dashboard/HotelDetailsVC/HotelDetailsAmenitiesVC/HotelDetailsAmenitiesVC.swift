//
//  HotelDetailsAmenitiesVC.swift
//  AERTRIP
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsAmenitiesVC: BaseVC {
    
    //Mark:- Variables
    //================
    //internal var aminitiesScreenType: HotelDetailsVC.AminitiesScreenType = .hotelDetailsVC
    private(set) var viewModel = HotelDetailsAmenitiesVM()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var amenitiesTblView: UITableView! {
        didSet {
            self.amenitiesTblView.delegate = self
            self.amenitiesTblView.dataSource = self
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func setupColors() {
//        <#code#>
//    }
//    
//    override func setupFonts() {
//        <#code#>
//    }
//    
//    override func setupTexts() {
//        <#code#>
//    }
    
    override func initialSetup() {
        self.setUpNavigationBar(title: LocalizedString.Amenities.rawValue, buttonImage: #imageLiteral(resourceName: "black_cross"))
        self.registerNibs()
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        let amenitiesNib = UINib(nibName: "AmenitiesDetailsTableViewCell", bundle: nil)
        self.amenitiesTblView.register(amenitiesNib, forCellReuseIdentifier: "AmenitiesDetailsTableViewCell")
    }
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

//Mark:- UITableView Delegate And DataSource
//==========================================

extension HotelDetailsAmenitiesVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesDetailsTableViewCell", for: indexPath) as? AmenitiesDetailsTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 249
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 249
        default:
            return UITableView.automaticDimension
        }
    }
}
