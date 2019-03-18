//
//  GuestDetailsVC.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum GuestTableViewType {
    case Searching
    case GuestDetails
}

class GuestDetailsVC: BaseVC {
    // MARK: - IB Outlets
    
    // Guest Detail table view
    @IBOutlet var guestDetailTableView: ATTableView!
    
    // Generic top Nav View
    @IBOutlet var topNavView: TopNavigationView!
    
    // table view for searching traveller from traveller list
    @IBOutlet var travellersTableView: ATTableView!
    
    // Mark: - Properties
    let viewModel = GuestDetailsVM.shared
    var guestTableViewType: GuestTableViewType = .GuestDetails
    var indexPath: IndexPath?
    
    // travellers for managing on table view
    var travellers: [TravellerModel] = []
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerXib()
        self.doInitialSetup()
        self.addFooterViewToGuestDetailTableView()
        self.getRoomDetails()
        self.addFooterViewToTravellerTableView()
        
        // setting delay of 1 sec because table view cell are creating
        
        delay(seconds: 2.0) { [weak self] in
            self?.makeTableViewIndexSelectable()
        }
        self.viewModel.webserviceForGetSalutations()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - Helper methods
    
    // register All Xib file
    
    private func registerXib() {
        self.travellersTableView.registerCell(nibName: TravellerListTableViewCell.reusableIdentifier)
        self.guestDetailTableView.registerCell(nibName: GuestDetailTableViewCell.reusableIdentifier)
        self.guestDetailTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
    
    private func doInitialSetup() {
        self.travellersTableView.separatorStyle = .none
        self.guestDetailTableView.dataSource = self
        self.guestDetailTableView.delegate = self
        
        self.travellersTableView.dataSource = self
        self.travellersTableView.delegate = self
        self.travellersTableView.isHidden = true
        self.setUpNavigationView()
        self.travellers = self.viewModel.travellerList
    }
    
    // configure navigation View
    
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.GuestDetails.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.DoneWithSpace.localized, selectedTitle: LocalizedString.DoneWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    // add Footer to Table view
    
    private func addFooterViewToGuestDetailTableView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 120))
        customView.backgroundColor = AppColors.themeWhite
        
        guestDetailTableView.tableFooterView = customView
    }
    
    private func addFooterViewToTravellerTableView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 400))
        customView.backgroundColor = AppColors.themeWhite
        
        travellersTableView.tableFooterView = customView
    }
    
    // get Room details from User defaults
    
    private func getRoomDetails() {
        self.viewModel.hotelFormData = HotelsSearchVM.hotelFormData
    }
    
    // Make table view particular index selectable or Editable
    private func makeTableViewIndexSelectable() {
        self.guestDetailTableView.scrollToRow(at: self.viewModel.selectedIndexPath, at: .top, animated: false)
        if let cell = guestDetailTableView.cellForRow(at: viewModel.selectedIndexPath) as? GuestDetailTableViewCell {
            cell.firstNameTextField.becomeFirstResponder()
        }
    }
    
    private func editedGuest(_ indexPath: IndexPath?) {
//        if let indexPath = indexPath {
//         //   printDebug(GuestDetailsVM.shared.guests[indexPath.row])
////            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].salutation = self.travellers[indexPath.row].salutation
////            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].firstName = self.travellers[indexPath.row].firstName
////            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].lastName = self.travellers[indexPath.row].lastName
//            
//        }
    }
}

// MARK: - UITableView Data Source and Delegate methods

extension GuestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.guestDetailTableView {
            return self.viewModel.hotelFormData.adultsCount.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.guestDetailTableView {
            return self.viewModel.hotelFormData.adultsCount[section] + self.viewModel.hotelFormData.childrenCounts[section]
        } else {
            return self.travellers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.guestDetailTableView {
            guard let cell = guestDetailTableView.dequeueReusableCell(withIdentifier: GuestDetailTableViewCell.reusableIdentifier, for: indexPath) as? GuestDetailTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.delegate = self
            if indexPath.row < self.viewModel.hotelFormData.adultsCount[indexPath.section] {
                cell.guestTitleLabel.text = "Adult \(indexPath.row + 1)"
            } else {
                cell.guestTitleLabel.text = "Child \((indexPath.row - self.viewModel.hotelFormData.adultsCount[indexPath.section]) + 1)"
            }
            return cell
        } else {
            guard let cell = travellersTableView.dequeueReusableCell(withIdentifier: TravellerListTableViewCell.reusableIdentifier, for: indexPath) as? TravellerListTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.travellerModelData = self.travellers[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === self.guestDetailTableView {
            return 60.0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === self.guestDetailTableView {
            return 95.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === self.guestDetailTableView {
            guard let headerView = guestDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
                fatalError("ViewProfileDetailTableViewSectionView not found")
            }
            headerView.headerLabel.text = "ROOM \(section + 1)"
            headerView.backgroundColor = AppColors.themeGray04
            headerView.containerView.backgroundColor = AppColors.themeGray04
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.travellersTableView {
            self.travellersTableView.isHidden = true
            if let cellindexPath = self.indexPath {
                if let cell = self.guestDetailTableView.cellForRow(at: cellindexPath) as? GuestDetailTableViewCell {
                    cell.salutationTextField.text = self.travellers[indexPath.row].salutation
                    cell.firstNameTextField.text = self.travellers[indexPath.row].firstName
                    cell.lastNameTextField.text = self.travellers[indexPath.row].lastName
                    self.editedGuest(self.indexPath)
                }
            }
        }
    }
}

// MARK: - Top NavigationView Delegate methods

extension GuestDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Done Button tapped")
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension GuestDetailsVC: GuestDetailTableViewCellDelegate {
    func textFieldWhileEditing(_ textField: UITextField) {
        if textField.text != "" {
            self.travellers = self.viewModel.travellerList.filter({ $0.firstName.contains(textField.text ?? "") })
        } else {
            self.travellers = self.viewModel.travellerList
        }
        
        self.travellersTableView.reloadData()
    }
    
    func textField(_ textField: UITextField) {
        self.indexPath = self.guestDetailTableView.indexPath(forItem: textField)
        let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: guestDetailTableView)
        self.guestDetailTableView.setContentOffset(CGPoint(x: self.guestDetailTableView.origin.x, y: itemPosition.y - CGFloat(95)), animated: true)
        travellersTableView.isHidden = false
        travellersTableView.reloadData()
        printDebug("item position is \(itemPosition)")
    }
}

extension GuestDetailsVC: GuestDetailsVMDelegate {
    func getFail(errors: ErrorCodes) {
        printDebug(errors)
    }
    
    func getSalutationResponse(salutations: [String]) {
        //
    }
}
