//
//  BookingCallVC.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingCallVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavBar: TopNavigationView!
    @IBOutlet var callTableView: ATTableView!
    
    // MARK: - Varibles
    
    let ViewModel = BookingCallVM()
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.callTableView.dataSource = self
        self.callTableView.delegate = self
        self.callTableView.reloadData()
        
        self.setupNavBar()
        self.registerXib()
    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.configureNavBar(title: LocalizedString.Call.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
    }
    
    // MARK: - Helper methods
    
    func registerXib() {
        self.callTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
        self.callTableView.registerCell(nibName: BookingCallTableViewCell.reusableIdentifier)
        self.callTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
    }
    
    func getCellforFirstSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
            fatalError("BookingCallTableViewCell not found")
        }
        
        if indexPath.row == 1 {
            bookingCell.configureCell(image: self.ViewModel.aertripData[indexPath.row].image, title: self.ViewModel.aertripData[indexPath.row].title, phoneLabel: self.ViewModel.aertripData[indexPath.row].number, cellType: .email, email: "alex.gomes@aertrip.com")
            bookingCell.imageViewBottomConstraint.constant = 5
            bookingCell.imageViewCenterConstraint.constant = -4
        } else {
            bookingCell.configureCell(image: self.ViewModel.aertripData[indexPath.row].image
                                      , title: self.ViewModel.aertripData[indexPath.row].title, phoneLabel: self.ViewModel.aertripData[indexPath.row].number)
            bookingCell.imageViewBottomConstraint.constant = 7.5
            bookingCell.imageViewCenterConstraint.constant = 0
        }
        bookingCell.dividerView.isHidden = self.ViewModel.aertripData.count - 1 == indexPath.row
        return bookingCell
    }
    
    func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
            fatalError("BookingCallTableViewCell not found")
        }
        bookingCell.configureCell(image: self.ViewModel.airlineData[indexPath.row].image
                                  , title: self.ViewModel.airlineData[indexPath.row].title, phoneLabel: self.ViewModel.airlineData[indexPath.row].number)
        bookingCell.dividerView.isHidden = self.ViewModel.airlineData.count - 1 == indexPath.row
        return bookingCell
    }
    
    func getCellForThirdSection(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.ViewModel.airportData.count {
            guard let emptyCell = self.callTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        } else {
            guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
                fatalError("BookingCallTableViewCell not found")
            }
            bookingCell.configureCell(image: UIImage(named: "aertripGreenLogo") ?? UIImage(named: "aertripGreenLogo")!
                                      , title: self.ViewModel.airportData[indexPath.row].title, phoneLabel: self.ViewModel.airportData[indexPath.row].number)
            bookingCell.dividerView.isHidden = self.ViewModel.airportData.count - 1 == indexPath.row
            return bookingCell
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
            alert.view.tintColor = AppColors.themeGreen
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
                UIApplication.shared.openURL(phoneURL as URL)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingCallVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ViewModel.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [self.ViewModel.aertripData.count, self.ViewModel.airlineData.count, self.ViewModel.airportData.count + 1][section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let callHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ViewProfileDetailTableViewSectionView") as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        
        callHeader.headerLabel.text = self.ViewModel.section[section]
        return callHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.getCellforFirstSection(indexPath)
        case 1:
            return self.getCellForSecondSection(indexPath)
        case 2:
            return self.getCellForThirdSection(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            self.makePhoneCall(phoneNumber: self.ViewModel.aertripData[indexPath.row].number)
            
        case 1:
            self.makePhoneCall(phoneNumber: self.ViewModel.airlineData[indexPath.row].number)
            
        case 2:
            self.makePhoneCall(phoneNumber: self.ViewModel.airportData[indexPath.row].number)
            
        default:
            printDebug("nothing tapped")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 44.0
            } else {
                return 60.0
            }
        case 1:
            return 44.0
        case 2:
            if indexPath.row == self.ViewModel.airportData.count {
                return 27.0
            } else {
                return 44.0
            }
            
        default:
            return 0
        }
    }
}

extension BookingCallVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
