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
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var callTableView: ATTableView!
    
    // MARK: - Varibles
    
    let viewModel = BookingCallVM()
  
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.callTableView.dataSource = self
        self.callTableView.delegate = self
        self.callTableView.reloadData()
        
        self.viewModel.getIntialData()
        
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
        
        if !self.viewModel.aertripData[indexPath.row].email.isEmpty {
            bookingCell.configureCell(title: self.viewModel.aertripData[indexPath.row].key, phoneLabel: self.viewModel.aertripData[indexPath.row].value, cellType: .email, email: self.viewModel.aertripData[indexPath.row].email)
            bookingCell.imageViewBottomConstraint.constant = 5
            bookingCell.imageViewCenterConstraint.constant = -4
        } else {
            bookingCell.configureCell(title: self.viewModel.aertripData[indexPath.row].key, phoneLabel: self.viewModel.aertripData[indexPath.row].value)
            bookingCell.imageViewBottomConstraint.constant = 7.5
            bookingCell.imageViewCenterConstraint.constant = 0
        }
        
        bookingCell.dividerView.isHidden = self.viewModel.aertripData.count - 1 == indexPath.row
        
        return bookingCell
    }
    
    func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
            fatalError("BookingCallTableViewCell not found")
        }
        bookingCell.configureCell(code: self.viewModel.airlineData[indexPath.row].airlineCode, title: self.viewModel.airlineData[indexPath.row].airlineName, phoneLabel: self.viewModel.airlineData[indexPath.row].phone, cellType: .airlines)
        bookingCell.dividerView.isHidden = self.viewModel.airlineData.count - 1 == indexPath.row
        return bookingCell
    }
    
    func getCellForThirdSection(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.viewModel.airportData.count {
            guard let emptyCell = self.callTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        } else {
            guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
                fatalError("BookingCallTableViewCell not found")
            }
            let title = self.viewModel.airportData[indexPath.row].city + "," + self.viewModel.airportData[indexPath.row].countryCode
            bookingCell.configureCell(code: self.viewModel.airportData[indexPath.row].ataCode, title: title, phoneLabel: self.viewModel.airportData[indexPath.row].phone, cellType: .airports)
            bookingCell.dividerView.isHidden = false//self.viewModel.airportData.count - 1 == indexPath.row
            bookingCell.dividerViewLeadingConst.constant = self.viewModel.airportData.count - 1 == indexPath.row ? 0.0 : 43.0

            return bookingCell
        }
    }
    
    
    func getCellForHotelSection(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.viewModel.hotelData.count {
            
            guard let emptyCell = self.callTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyCell
        } else {
            guard let bookingCell = self.callTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
                fatalError("BookingCallTableViewCell not found")
            }
            bookingCell.imageViewWidthConstraint.constant = 0
            bookingCell.imageViewTrailingConstraing.constant = 0
            bookingCell.airportCodeLabelLeadingConstraint.constant = 0
            bookingCell.configureCell(code: "", title: self.viewModel.hotelName, phoneLabel: self.viewModel.hotelData[indexPath.row].phone, cellType: .none)
            bookingCell.dividerView.isHidden = self.viewModel.hotelData.count - 1 == indexPath.row
            bookingCell.dividerView.isHidden = indexPath.section == self.viewModel.section.count - 1 ? false : true
            bookingCell.dividerViewLeadingConst.constant = indexPath.section == self.viewModel.section.count - 1 ? 0.0 : 43.0
            return bookingCell
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        var uc = URLComponents()
        uc.scheme = "tel"
        uc.path = phoneNumber
        
        if let phoneURL = uc.url {
//            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
//            alert.view.tintColor = AppColors.themeGreen
//            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
//
//            }))
        
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
           
              //  UIApplication.shared.openURL(phoneURL as URL)
            //
            //   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingCallVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.usingFor == .flight {
            return [self.viewModel.contactInfo?.aertrip.count, self.viewModel.contactInfo?.airlines.count, self.viewModel.airportData.count][section] ?? 0
        } else {
           return[self.viewModel.aertripData.count,self.viewModel.hotelData.count + 1][section]
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let callHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ViewProfileDetailTableViewSectionView") as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        
        callHeader.headerLabel.text = self.viewModel.section[section]
        return callHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if self.viewModel.usingFor == .flight {
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
        } else {
            switch indexPath.section {
            case 0:
                return self.getCellforFirstSection(indexPath)
            case 1:
                return self.getCellForHotelSection(indexPath)
            default:
                return UITableViewCell()
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.usingFor == .flight {
            switch indexPath.section {
            case 0:
                
                self.makePhoneCall(phoneNumber: self.viewModel.aertripData[indexPath.row].value)
                
            case 1:
                self.makePhoneCall(phoneNumber: self.viewModel.airlineData[indexPath.row].phone)
                
            case 2:
                self.makePhoneCall(phoneNumber: self.viewModel.airportData[indexPath.row].phone)
                
            default:
                printDebug("nothing tapped")
            }

        } else {
            switch indexPath.section {
            case 0:
                
                self.makePhoneCall(phoneNumber: self.viewModel.aertripData[indexPath.row].value)
                
            case 1:
                self.makePhoneCall(phoneNumber: self.viewModel.hotelData[indexPath.row].phone)
                
            default:
                printDebug("nothing tapped")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.viewModel.usingFor == .flight {
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
                if indexPath.row == self.viewModel.airportData.count {
                    return self.viewModel.hotelData.count == 1 ? 0 :  27.0
                } else {
                    return 44.0
                }
                
            default:
                return 0
            }
        } else {
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    return 44.0
                } else {
                    return 60.0
                }
            case 1:
                if indexPath.row == self.viewModel.hotelData.count {
                    return self.viewModel.hotelData.count == 1 ? 0 : 27.0
                } else {
                    return 44.0
                }
                
            default:
                return 0
            }
        }
        
    }
}

extension BookingCallVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
