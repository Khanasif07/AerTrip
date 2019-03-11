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
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var amenitiesLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var amenitiesTitleBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var amenitiesTblView: UITableView! {
        didSet {
            self.amenitiesTblView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.amenitiesTblView.delegate = self
            self.amenitiesTblView.dataSource = self
            self.amenitiesTblView.estimatedRowHeight = UITableView.automaticDimension
            self.amenitiesTblView.rowHeight = UITableView.automaticDimension
            self.amenitiesTblView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.amenitiesTblView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
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
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.amenitiesLabel.text = LocalizedString.Amenities.localized
        self.stickyTitleLabel.text = LocalizedString.Amenities.localized
    }
    
    override func initialSetup() {
        self.dividerView.isHidden = true
        self.registerNibs()
        self.viewModel.getAmenitiesSections()
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.amenitiesTblView.registerCell(nibName: AmenitiesDetailsTableViewCell.reusableIdentifier)
        self.amenitiesTblView.registerCell(nibName: AmenitiesNameTableViewCell.reusableIdentifier)
        self.amenitiesTblView.register(AmenitiesDescriptionHeaderView.self, forHeaderFooterViewReuseIdentifier: "AmenitiesDescriptionHeaderView")
    }
    
    private func heightForHeader(_ tableView: UITableView, section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        } else {
            return 49.0
        }
    }
    
    private func imageByAmenitiesName(imageName: String) -> UIImage {
        if let confirmedImage = UIImage(named: imageName) {
            return confirmedImage
        } else {
            return #imageLiteral(resourceName: "buildingImage")
        }
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
            return self.viewModel.sections.isEmpty ? 0 : self.viewModel.rowsData[section - 1].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = self.getAmenitiesDetailsTableViewCell(tableView, indexPath: indexPath) {
                return cell
            }
        }
        else {
            if let cell = self.getAmenitiesDetailsRows(tableView, indexPath: indexPath, amenitiesName: self.viewModel.rowsData[indexPath.section - 1]) {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        else {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AmenitiesDescriptionHeaderView") as? AmenitiesDescriptionHeaderView else { return UIView() }
            let image = self.imageByAmenitiesName(imageName: self.viewModel.sections[section - 1])
            headerView.configureView(title: self.viewModel.sections[section - 1], image: image)
            return headerView
        }
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

extension HotelDetailsAmenitiesVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printDebug(scrollView.contentOffset.y)
        guard scrollView.contentOffset.y >= 0 || scrollView.contentOffset.y <= 20 else { return }
        if scrollView.contentOffset.y > 10.0 {
            self.dividerView.isHidden = false
            self.stickyTitleLabel.alpha = scrollView.contentOffset.y/100.0
            self.amenitiesLabel.alpha = 1.0 - scrollView.contentOffset.y/50.0
            self.stickyTitleLabel.isHidden = false
            self.amenitiesLabelTopConstraints.constant -= scrollView.contentOffset.y/10 + 6.0
            self.containerViewHeigthConstraint.constant = 44.0
        }
        else  {
            if scrollView.contentOffset.y <= 6.0 {
                self.amenitiesLabelTopConstraints.constant = 6.0
            } else {
                self.amenitiesLabelTopConstraints.constant += scrollView.contentOffset.y/10 - 6.0
            }
            self.dividerView.isHidden = false
            self.stickyTitleLabel.isHidden = false
            self.amenitiesLabel.alpha = 1.0 - scrollView.contentOffset.y/50.0
            self.stickyTitleLabel.alpha = scrollView.contentOffset.y/100.0
            self.containerViewHeigthConstraint.constant = 58.0
        }
    }
}
