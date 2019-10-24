//
//  GuestDetailsVC.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

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
    
    // travellers for managing on table view
    var travellers: [TravellerModel] = []
    var keyboardHeight: CGFloat = 0.0
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerXib()
        self.doInitialSetup()
        self.addFooterViewToGuestDetailTableView()
        self.getRoomDetails()
        self.addFooterViewToTravellerTableView()
        
        
      
        self.viewModel.webserviceForGetSalutations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delay(seconds: 1.3) { [weak self] in
              self?.makeTableViewIndexSelectable()
        }
        
        IQKeyboardManager.shared().isEnabled = false
      
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         IQKeyboardManager.shared().isEnabled = true
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
        self.guestDetailTableView.isScrollEnabled = true
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
    
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
           self.keyboardHeight = keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notification: Notification) {
        self.guestDetailTableView.isScrollEnabled = true
        self.travellers = self.viewModel.travellerList
    }
    
    // Make table view particular index selectable or Editable
    private func makeTableViewIndexSelectable() {
        self.guestDetailTableView.scrollToRow(at: self.viewModel.selectedIndexPath, at: .top, animated: false)
        if let cell = guestDetailTableView.cellForRow(at: viewModel.selectedIndexPath) as? GuestDetailTableViewCell {
            let guest = GuestDetailsVM.shared.guests[self.viewModel.selectedIndexPath.section][self.viewModel.selectedIndexPath.row]
            if self.travellers.count == 0 {
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
        if let cell = guestDetailTableView.cellForRow(at: viewModel.selectedIndexPath) as? GuestDetailTableViewCell {
            let guest = GuestDetailsVM.shared.guests[self.viewModel.selectedIndexPath.section][self.viewModel.selectedIndexPath.row]
            if self.travellers.count == 0 {
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
        if let indexPath = self.indexPath {
            printDebug(" before updating guest : \(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].salutation = self.travellers[travellerIndexPath.row].salutation
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].firstName = self.travellers[travellerIndexPath.row].firstName
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].lastName = self.travellers[travellerIndexPath.row].lastName
            
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.guestDetailTableView {
            return GuestDetailsVM.shared.guests[section].count
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
            printDebug("=====guest==== \(indexPath.section) \(indexPath.row)\(GuestDetailsVM.shared.guests[indexPath.section][indexPath.row])")
            cell.guestDetail = GuestDetailsVM.shared.guests[indexPath.section][indexPath.row]
            return cell
        } else {
            guard let cell = travellersTableView.dequeueReusableCell(withIdentifier: TravellerListTableViewCell.reusableIdentifier, for: indexPath) as? TravellerListTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.separatorView.isHidden = indexPath.row == 0
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
            headerView.headerLabel.text = "\(LocalizedString.Room.localized) \(section + 1)"
            headerView.backgroundColor = AppColors.themeGray04
            headerView.containerView.backgroundColor = AppColors.themeGray04
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.travellersTableView {
            self.guestDetailTableView.isScrollEnabled = true
            self.travellersTableView.isHidden = true
            if let cellindexPath = self.indexPath {
                if let cell = self.guestDetailTableView.cellForRow(at: cellindexPath) as? GuestDetailTableViewCell {
                    //cell.salutationTextField.text = self.travellers[indexPath.row].salutation
                    cell.firstNameTextField.text = self.travellers[indexPath.row].firstName
                    cell.lastNameTextField.text = self.travellers[indexPath.row].lastName
                }
            }
            self.editedGuest(indexPath)
            self.travellers = self.viewModel.travellerList
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
        self.vcDelegate?.doneButtonTapped()
    }
}

extension GuestDetailsVC: GuestDetailTableViewCellDelegate {    
    func textFieldWhileEditing(_ textField: UITextField) {
        self.indexPath = self.guestDetailTableView.indexPath(forItem: textField)
        if textField.text != "" {
            self.travellers = self.viewModel.travellerList.filter({ $0.firstName.lowercased().contains(textField.text?.lowercased() ?? "") })
            
        } else {
            self.travellers = self.viewModel.travellerList
        }
        self.travellersTableView.isHidden = self.travellers.count == 0
        self.travellersTableView.reloadData()
        if let cell = self.guestDetailTableView.cell(forItem: textField) as? GuestDetailTableViewCell {
            switch textField {
            case cell.firstNameTextField:
                if let indexPath = self.indexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].firstName = textField.text?.removeSpaceAsSentence ?? ""
                    } else {
                        AppToast.default.showToastMessage(message: "First Name should be less than 30 characters", spaceFromBottom : keyboardHeight)
                        return
                    }
                }
                
            case cell.lastNameTextField:
                if let indexPath = self.indexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].lastName = textField.text?.removeSpaceAsSentence ?? ""
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
        
        self.travellersTableView.isHidden = self.travellers.count == 0
        self.travellersTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.indexPath = self.guestDetailTableView.indexPath(forItem: textField)
        if let _ = self.guestDetailTableView.cell(forItem: textField) as? GuestDetailTableViewCell {
           //  get item position
            let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: guestDetailTableView)
            
            self.guestDetailTableView.setContentOffset(CGPoint(x: self.guestDetailTableView.origin.x, y: itemPosition.y - CGFloat(104)), animated: true)
         
            self.guestDetailTableView.isScrollEnabled = (self.travellers.count == 0)
            //false            travellersTableView.reloadData()
            printDebug("item position is \(itemPosition)")
        } else {
            travellersTableView.isHidden = true
        }
 
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
