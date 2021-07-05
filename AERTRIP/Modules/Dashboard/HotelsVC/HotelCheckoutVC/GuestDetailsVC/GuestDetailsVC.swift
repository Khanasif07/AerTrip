//
//  GuestDetailsVC.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Contacts

enum GuestTableViewType {
    case Searching
    case GuestDetails
}

protocol GuestDetailsVCDelegate: class {
    func doneButtonTapped()
}

class GuestDetailsVC: BaseVC {
    // MARK: - IB Outlets
    
    // Guest Detail table view
    @IBOutlet weak var guestDetailTableView: ATTableView!
    
    // Generic top Nav View
    @IBOutlet weak var topNavView: TopNavigationView!
    
    // table view for searching traveller from traveller list
    @IBOutlet weak var travellersTableView: ATTableView!
    
    // Mark: - Properties
    let viewModel = GuestDetailsVM.shared
    var indexPath: IndexPath?
    weak var vcDelegate: GuestDetailsVCDelegate?
    var searchText: String = ""
    
    // travellers for managing on table view
    //var travellers: [TravellerModel] = []
    var keyboardHeight: CGFloat = 0.0
    private let oldGuestState = GuestDetailsVM.shared.guests

    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guestDetailTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: 0, right: 0)
        self.viewModel.resetData()
        self.registerXib()
        self.doInitialSetup()
        //self.addFooterViewToGuestDetailTableView()
        self.getRoomDetails()
        self.addFooterViewToTravellerTableView()
        self.view.backgroundColor = AppColors.themeWhite
        self.viewModel.webserviceForGetSalutations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        delay(seconds: 1.3) { [weak self] in
        //              self?.makeTableViewIndexSelectable()
        //        }
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        IQKeyboardManager.shared().isEnabled = false
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - Helper methods
    
    // register All Xib file
    
    private func registerXib() {
        self.travellersTableView.registerCell(nibName: TravellerListTableViewCell.reusableIdentifier)
        self.guestDetailTableView.registerCell(nibName: GuestHotelDetailTableViewCell.reusableIdentifier)
        self.guestDetailTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
    
    private func doInitialSetup() {
        self.travellersTableView.separatorStyle = .none
        self.guestDetailTableView.dataSource = self
        self.guestDetailTableView.delegate = self
        
        self.travellersTableView.dataSource = self
        self.travellersTableView.delegate = self
        self.guestDetailTableView.isScrollEnabled = true
        self.travellersTableView.isHidden = true
        self.setUpNavigationView()
        self.viewModel.resetData()//self.viewModel.travellerList
        self.travellersTableView.keyboardDismissMode = .none
        self.guestDetailTableView.backgroundColor = AppColors.themeGray04
        
        if HCSelectGuestsVM.shared._phoneContacts.isEmpty, CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            HCSelectGuestsVM.shared.fetchPhoneContacts(forVC: self)
        }
    }
    
    // configure navigation View
    
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.firstLeftButtonLeadingConst.constant = 5
        self.topNavView.configureNavBar(title: LocalizedString.GuestDetails.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        //        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // super.touchesBegan(touches, with: event) commented this line to stop the keyboard dismissing
    }
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            self.keyboardHeight = keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notification: Notification) {
        self.guestDetailTableView.isScrollEnabled = true
        self.viewModel.resetData()//self.viewModel.travellerList
        self.travellersTableView.reloadData()
        self.travellersTableView.isHidden = self.viewModel.isDataEmpty
    }
    
    // Make table view particular index selectable or Editable
    private func makeTableViewIndexSelectable() {
        self.guestDetailTableView.scrollToRow(at: self.viewModel.selectedIndexPath, at: .top, animated: false)
        if let cell = guestDetailTableView.cellForRow(at: viewModel.selectedIndexPath) as? GuestHotelDetailTableViewCell {
            let guest = GuestDetailsVM.shared.guests[self.viewModel.selectedIndexPath.section][self.viewModel.selectedIndexPath.row]
            if self.viewModel.isDataEmpty {
                self.travellersTableView.isHidden = true
            } else {
                self.travellersTableView.isHidden = !guest.firstName.isEmpty
            }
            delay(seconds: 0.2) { [weak cell] in
                if guest.firstName.isEmpty {
                    cell?.firstNameTextField.becomeFirstResponder()
                }
                else if guest.lastName.isEmpty {
                    cell?.lastNameTextField.becomeFirstResponder()
                }
            }
            
            
        }
    }
    
    
    private func makeTextFieldResponder() {
        if let cell = guestDetailTableView.cellForRow(at: viewModel.selectedIndexPath) as? GuestHotelDetailTableViewCell {
            let guest = GuestDetailsVM.shared.guests[self.viewModel.selectedIndexPath.section][self.viewModel.selectedIndexPath.row]
            if self.viewModel.isDataEmpty {
                self.travellersTableView.isHidden = true
            } else {
                self.travellersTableView.isHidden = !guest.firstName.isEmpty
            }
            if guest.firstName.isEmpty {
                cell.firstNameTextField.becomeFirstResponder()
            }
            
        }
    }
    
    private func editedGuest(_ travellerIndexPath: IndexPath) {
        if let indexPath = self.indexPath, let object = self.viewModel.objectForIndexPath(indexPath: travellerIndexPath) {
            var shouldAddContact = true
            let allContact = GuestDetailsVM.shared.guests.flatMap({ $0})
            for guest in allContact {
                if guest.firstName.lowercased() == object.firstName.lowercased() && guest.lastName.lowercased() == object.lastName.lowercased() {
                    shouldAddContact = false
                    break
                }
            }
            
            printDebug(" before updating guest : \(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            if shouldAddContact {
                GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].salutation = object.salutation
                GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].firstName = object.firstName
                GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].lastName = object.lastName
                GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].apiId = object.id
            }
            printDebug("after updating guest : \(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            
            printDebug("=====guest \(indexPath.section) \(indexPath.row)\(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            self.guestDetailTableView.reloadData()
        }
    }
}

// MARK: - UITableView Data Source and Delegate methods

extension GuestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === self.guestDetailTableView {
            return GuestDetailsVM.shared.guests.count
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.guestDetailTableView {
            return GuestDetailsVM.shared.guests[section].count
        } else {
            return self.viewModel.numberOfRowsInSection(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.guestDetailTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestHotelDetailTableViewCell.reusableIdentifier, for: indexPath) as? GuestHotelDetailTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.canShowSalutationError = GuestDetailsVM.shared.canShowSalutationError
            printDebug("=====guest==== \(indexPath.section) \(indexPath.row)\(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            cell.guestDetail = GuestDetailsVM.shared.guests[indexPath.section][indexPath.row]
            if indexPath.section ==  GuestDetailsVM.shared.guests[indexPath.section].count - 1  {
                cell.firstNameTextField.isHiddenBottomLine = false
                cell.lastNameTextField.isHiddenBottomLine = false
            }
            if indexPath.row ==  GuestDetailsVM.shared.guests[indexPath.section].count - 1{
                cell.firstNameTextField.isHiddenBottomLine = true
                cell.lastNameTextField.isHiddenBottomLine = true
            }
            //            if indexPath.section == GuestDetailsVM.shared.guests.count - 1 {
            //                cell.firstNameTextField.isHiddenBottomLine = false
            //                cell.lastNameTextField.isHiddenBottomLine = false
            //            }
            printDebug("cell frame: \(cell.frame)")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellerListTableViewCell.reusableIdentifier, for: indexPath) as? TravellerListTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.separatorView.isHidden = indexPath.row == 0
            cell.bottomSeperatorView.isHidden = !self.viewModel.isLastIndexOfTable(indexPath: indexPath)
            cell.searchedText = self.searchText
            //            if indexPath.row < self.travellers.count {
            cell.travellerModelData = self.viewModel.objectForIndexPath(indexPath: indexPath)
            //            }
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === self.guestDetailTableView {
            return 60.0
        } else {
            return self.viewModel.numberOfRowsInSection(section: section) > 0 ? 28.0 : CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === self.guestDetailTableView {
            return UITableView.automaticDimension//96
        } else {
            return 43.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === self.guestDetailTableView {
            guard let headerView = guestDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
                fatalError("ViewProfileDetailTableViewSectionView not found")
            }
            headerView.headerLabel.text = "\(LocalizedString.Room.localized) \(section + 1)".uppercased()
            headerView.backgroundColor = AppColors.themeGray04
            headerView.containerView.backgroundColor = AppColors.themeGray04
            headerView.topDividerHeightConstraint.constant = 0.5
            headerView.topSeparatorView.isHidden = section == 0 ? true : false
            headerView.bottomSeparatorView.isHidden = false
            
            return headerView
        } else {
            guard let headerView = guestDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
                fatalError("ViewProfileDetailTableViewSectionView not found")
            }
            headerView.headerLabel.text = self.viewModel.titleForSection(section: section).uppercased()
            headerView.backgroundColor = AppColors.miniPlaneBack
            headerView.containerView.backgroundColor = AppColors.miniPlaneBack
            headerView.topDividerHeightConstraint.constant = 0.5
            //headerView.topSeparatorView.isHidden = section == 0 ? true : false
            headerView.bottomSeparatorView.isHidden = false
            headerView.clipsToBounds = true
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView === self.guestDetailTableView {
            if GuestDetailsVM.shared.guests.count - 1 == section {
                return 35
            }
            return CGFloat.leastNonzeroMagnitude
        } else {
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView === self.guestDetailTableView {
            guard let headerView = guestDetailTableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
                fatalError("ViewProfileDetailTableViewSectionView not found")
            }
            headerView.headerLabel.text = ""
            headerView.backgroundColor = AppColors.themeGray04
            headerView.containerView.backgroundColor = AppColors.themeGray04
            headerView.topDividerHeightConstraint.constant = 0.5
            headerView.topSeparatorView.isHidden = false
            headerView.bottomSeparatorView.isHidden = true
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.travellersTableView {
            self.guestDetailTableView.isScrollEnabled = true
            self.travellersTableView.isHidden = true
            //            let object = self.viewModel.objectForIndexPath(indexPath: indexPath)
            //            if let cellindexPath = self.indexPath, let obj = object {
            //                if let cell = self.guestDetailTableView.cellForRow(at: cellindexPath) as? GuestDetailTableViewCell {
            //                    //cell.salutationTextField.text = self.travellers[indexPath.row].salutation
            //                    cell.firstNameTextField.text = obj.firstName
            //                    cell.lastNameTextField.text = obj.lastName
            //                }
            //            }
            self.editedGuest(indexPath)
            self.viewModel.resetData()
            self.viewModel.search(forText: "")
        }
    }
    
}

// MARK: - Top NavigationView Delegate methods

extension GuestDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        GuestDetailsVM.shared.guests = self.oldGuestState
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.viewModel.checkForDoneValidation() {
            printDebug("Done Button tapped")
            AppFlowManager.default.popViewController(animated: true)
            self.vcDelegate?.doneButtonTapped()
            GuestDetailsVM.shared.canShowSalutationError = true
        }
    }
}

extension GuestDetailsVC: GuestDetailTableViewCellDelegate {
    
    private func serachData(textField: UITextField) {
        if  let indexPath = self.guestDetailTableView.indexPath(forItem: textField) {
            self.viewModel.selectedGuest = GuestDetailsVM.shared.guests[indexPath.section][indexPath.row]
        }
        if let cell = self.guestDetailTableView.cell(forItem: textField) as? GuestHotelDetailTableViewCell {
            switch textField {
            case cell.firstNameTextField: self.viewModel.isFirstNameTextField = true
            case cell.lastNameTextField: self.viewModel.isFirstNameTextField = false
            default: break
            }
        }
        
        self.searchText = textField.text ?? ""
        self.viewModel.search(forText: self.searchText)
        if self.searchText.isEmpty {
            self.viewModel.resetData()
        }
        self.travellersTableView.isHidden = self.viewModel.isDataEmpty
        self.travellersTableView.reloadData()
    }
    
    func textFieldWhileEditing(_ textField: UITextField) {
        self.indexPath = self.guestDetailTableView.indexPath(forItem: textField)
        serachData(textField: textField)
        if let cell = self.guestDetailTableView.cell(forItem: textField) as? GuestHotelDetailTableViewCell {
            switch textField {
            case cell.firstNameTextField:
                if let indexPath = self.indexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].firstName = textField.text?.removeSpaceAsSentence ?? ""
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].apiId = ""
                    } else {
                        AppToast.default.showToastMessage(message: "First Name should be less than 30 characters", spaceFromBottom : keyboardHeight)
                        return
                    }
                }
                
            case cell.lastNameTextField:
                if let indexPath = self.indexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].lastName = textField.text?.removeSpaceAsSentence ?? ""
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].apiId = ""
                    } else {
                        AppToast.default.showToastMessage(message: "Last Name should be less than 30 characters", spaceFromBottom: keyboardHeight)
                        return
                    }
                    
                }
                
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField) {
        
        self.travellersTableView.isHidden = self.viewModel.isDataEmpty
        self.travellersTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.indexPath = self.guestDetailTableView.indexPath(forItem: textField)
        if let _ = self.guestDetailTableView.cell(forItem: textField) as? GuestHotelDetailTableViewCell {
            //  get item position
            let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: guestDetailTableView)
            var  yValue = 80
            if let index = self.indexPath {
                yValue = index.row ==  GuestDetailsVM.shared.guests[index.section].count - 1 ? 81 : 83
            }
            let offsetYValue = itemPosition.y - CGFloat(CGFloat(yValue) + self.guestDetailTableView.contentInset.top)
            
            printDebug("self.guestDetailTableView.contentOffset: \(self.guestDetailTableView.contentOffset)")
            printDebug("itemPosition.y - CGFloat(yValue): \(offsetYValue)")
            if self.guestDetailTableView.contentOffset.y != offsetYValue {
                self.guestDetailTableView.setContentOffset(CGPoint(x: self.guestDetailTableView.origin.x, y: offsetYValue), animated: true)
            }
            self.guestDetailTableView.isScrollEnabled = self.viewModel.isDataEmpty
            //false            travellersTableView.reloadData()
            //printDebug("item position is \(itemPosition)")
        } else {
            travellersTableView.isHidden = true
        }
        
    }
    
    func textFieldEndEditing(_ textField: UITextField) {
        self.viewModel.resetData()
        self.travellersTableView.isHidden = self.viewModel.isDataEmpty
        self.travellersTableView.reloadData()
    }
}

extension GuestDetailsVC: GuestDetailsVMDelegate {
    func searchDidComplete() {
        self.travellersTableView.isHidden = self.viewModel.isDataEmpty
        self.travellersTableView.reloadData()
    }
    
    func getFail(errors: ErrorCodes) {
        printDebug(errors)
    }
    
    
    func getSalutationResponse(salutations: [String]) {
        //
    }
}
