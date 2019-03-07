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
    private(set) var viewModel = HotelDetailsAmenitiesVM()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var amenitiesTblView: UITableView! {
        didSet {
            self.amenitiesTblView.contentInset = UIEdgeInsets(top: 28.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.amenitiesTblView.delegate = self
            self.amenitiesTblView.dataSource = self
            self.amenitiesTblView.estimatedRowHeight = UITableView.automaticDimension
            self.amenitiesTblView.rowHeight = UITableView.automaticDimension
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupColors() {
        self.amenitiesLabel.textColor = AppColors.themeBlack
        self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.amenitiesLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.amenitiesLabel.text = LocalizedString.Amenities.localized
        self.stickyTitleLabel.text = LocalizedString.Amenities.localized
    }
    
    override func initialSetup() {
        self.registerNibs()
        self.viewModel.getAmenitiesSections()
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.amenitiesTblView.registerCell(nibName: AmenitiesDetailsTableViewCell.reusableIdentifier)
        self.amenitiesTblView.registerCell(nibName: AmenitiesDescriptionTableViewCell.reusableIdentifier)
        self.amenitiesTblView.registerCell(nibName: AmenitiesNameTableViewCell.reusableIdentifier)
        self.amenitiesTblView.register(AmenitiesDescriptionHeaderView.self, forHeaderFooterViewReuseIdentifier: "AmenitiesDescriptionHeaderView")

    }
    
    private func heightForHeader(_ tableView: UITableView, section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//Mark:- UITableView Delegate And DataSource
//==========================================

extension HotelDetailsAmenitiesVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.viewModel.sections.isEmpty {
            return self.viewModel.sections.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.viewModel.sections.isEmpty ? 0 : self.viewModel.rowsData[section - 1].count//(self.viewModel.rowData[section - 1] as AnyObject).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = self.getAmenitiesDetailsTableViewCell(tableView, indexPath: indexPath) {
                return cell
            } else {
                if let cell = self.getAmenitiesDetailsRows(tableView, indexPath: indexPath, amenitiesName: self.viewModel.rowsData[indexPath.section - 1]) {
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AmenitiesDescriptionHeaderView") as? AmenitiesDescriptionHeaderView else { return UIView() }
            headerView.configureView(title: self.viewModel.sections[section - 1], image: #imageLiteral(resourceName: "About the Property"))
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader(tableView, section: section)
    }
}

extension HotelDetailsAmenitiesVC {
    
    internal func getAmenitiesDetailsTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesDetailsTableViewCell", for: indexPath) as? AmenitiesDetailsTableViewCell else { return UITableViewCell() }
        if let safeAmenitiesData = self.viewModel.hotelDetails?.amenities {
            cell.amenitiesDetails = safeAmenitiesData
        }
        return cell
    }
    
    internal func getAmenitiesDetailsRows(_ tableView: UITableView, indexPath: IndexPath, amenitiesName: [String]) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmenitiesNameTableViewCell.reusableIdentifier, for: indexPath) as? AmenitiesNameTableViewCell else {
            return UITableViewCell() }
        cell.facilitiesNameLabel.text = amenitiesName[indexPath.row]
        return cell
    }
    
}
