//
//  PreferencesVC.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import UIKit

protocol PreferencesVCDelegate: class {
    func preferencesUpdated()
    func cancelButtonTapped()
}

class PreferencesVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    let sections = [LocalizedString.SortOrder, LocalizedString.DisplayOrder, LocalizedString.Groups]
    let order = [LocalizedString.FirstLast, LocalizedString.LastFirst]
    let orderCellIdentifier = "OrderTableViewCell"
    let categorisedByGroupsCellIdentifier = "CategorisedByGroupsTableViewCell"
    let emptyCellIdentifier = "EmptyTableViewCell"
    let groupCellIdentifier = "GroupTableViewCell"
    let addActionCellIdentifier = "TableViewAddActionCell"
    weak var delegate: PreferencesVCDelegate?
    let viewModel = PreferencesVM()
    var keyboardHeight : CGFloat = 0.0
    
    var labelsCountDict: [JSONDictionary] = []
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetUp()
        registerXib()
        viewModel.setUpData()
        
        labelsCountDict = CoreDataManager.shared.getCount(fromEntity: "TravellerData", forAttribute: "label")
    }
    
    // MARK: - IB Actions
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.Preferences.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false)
        topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.rawValue, selectedTitle: LocalizedString.Cancel.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Done.rawValue, selectedTitle: LocalizedString.Done.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        topNavView.dividerView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
        
        indicatorView.color = AppColors.themeGreen
        
        stopLoading()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        tableView.register(UINib(nibName: orderCellIdentifier, bundle: nil), forCellReuseIdentifier: orderCellIdentifier)
        tableView.register(UINib(nibName: categorisedByGroupsCellIdentifier, bundle: nil), forCellReuseIdentifier: categorisedByGroupsCellIdentifier)
        tableView.register(UINib(nibName: emptyCellIdentifier, bundle: nil), forCellReuseIdentifier: emptyCellIdentifier)
        tableView.register(UINib(nibName: groupCellIdentifier, bundle: nil), forCellReuseIdentifier: groupCellIdentifier)
        tableView.register(UINib(nibName: addActionCellIdentifier, bundle: nil), forCellReuseIdentifier: addActionCellIdentifier)
    }
    
    func addNewGroupAlertController() {
        let alertController = UIAlertController(title: LocalizedString.EnterAGroupName.localized, message: "", preferredStyle: .alert)
        alertController.view.tintColor = AppColors.themeGreen
        
        alertController.addTextField { textField in
            textField.placeholder = LocalizedString.EnterGroupName.localized
            textField.textAlignment = .left
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            printDebug("Canelled")
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            let groupName = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) ?? "None"
            printDebug("Current group name: \(groupName)")
            
            if groupName.isEmpty {
                AppToast.default.showToastMessage(message: LocalizedString.GroupNameCanNotEmpty.localized)
                return
            }
            
            if !self.viewModel.groups.contains(where: { $0.compare(groupName, options: .caseInsensitive) == .orderedSame }) {
                self.viewModel.groups.append(groupName)
                self.viewModel.modifiedGroups.append((originalGroupName: groupName, modifiedGroupName: groupName))
            } else {
                AppToast.default.showToastMessage(message: LocalizedString.GroupAlreadyExist.localized)
            }
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func setCategorisedByGroupFlag(_ sender: UISwitch) {
        printDebug("\(sender.isOn)")
        viewModel.isCategorizeByGroup = sender.isOn
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    @IBAction func addNewGroupButtonTapped(_ sender: Any) {
        addNewGroupAlertController()
    }
    
    private func getCount(forLabel: String) -> Int {
        var finalCount = 0
        for dict in labelsCountDict {
            if let obj = dict["label"], "\(obj)".lowercased() == forLabel.lowercased(), let count = dict["count"] {
                finalCount = "\(count)".toInt ?? 0
                break
            }
        }
        
        return finalCount
    }
    
    func startLoading() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        topNavView.firstRightButton.isHidden = true
    }
    
    func stopLoading() {
        indicatorView.isHidden = true
        indicatorView.stopAnimating()
        topNavView.firstRightButton.isHidden = false
    }
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            self.keyboardHeight = keyboardSize.height
        }
    }
    
}

extension PreferencesVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        delegate?.cancelButtonTapped()
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        viewModel.callSavePreferencesAPI()
    }
}

// MARK: - UITableViewDataSource AND UITableViewDelegate methods

extension PreferencesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.SortOrder:
            return order.count
        case LocalizedString.DisplayOrder:
            return order.count + 2
        case LocalizedString.Groups:
            return viewModel.groups.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case LocalizedString.SortOrder:
            guard let orderCell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier, for: indexPath) as? OrderTableViewCell else {
                fatalError("OrderTableViewCell not found")
            }
            orderCell.titleLabel.text = order[indexPath.row].rawValue
            orderCell.checkIconImageView.isHidden = true
            if viewModel.sortOrder == "FL", indexPath.row == 0 {
                orderCell.checkIconImageView.isHidden = false
            } else if viewModel.sortOrder == "LF", indexPath.row == 1 {
                orderCell.checkIconImageView.isHidden = false
            }
            orderCell.separatorView.isHidden = indexPath.row == (order.count - 1)
            return orderCell
        case LocalizedString.DisplayOrder:
            if indexPath.row < 2 {
                guard let orderCell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier, for: indexPath) as? OrderTableViewCell else {
                    fatalError("OrderTableViewCell not found")
                }
                orderCell.titleLabel.text = order[indexPath.row].rawValue
                orderCell.checkIconImageView.isHidden = true
                if viewModel.displayOrder == "FL", indexPath.row == 0 {
                    orderCell.checkIconImageView.isHidden = false
                } else if viewModel.displayOrder == "LF", indexPath.row == 1 {
                    orderCell.checkIconImageView.isHidden = false
                }
                orderCell.separatorView.isHidden = indexPath.row == (order.count - 1)
                return orderCell
            } else if indexPath.row == 2 {
                guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as? EmptyTableViewCell else {
                    fatalError("EmptyTableViewCell not found")
                }
                return emptyCell
            } else if indexPath.row == 3 {
                guard let categoryGroupCell = tableView.dequeueReusableCell(withIdentifier: categorisedByGroupsCellIdentifier, for: indexPath) as? CategorisedByGroupsTableViewCell else {
                    fatalError("CategorisedByGroupsTableViewCell not found")
                }
                
                categoryGroupCell.groupSwitch.addTarget(self, action: #selector(setCategorisedByGroupFlag(_:)), for: .valueChanged)
                categoryGroupCell.groupSwitch.isOn = viewModel.isCategorizeByGroup
                
                return categoryGroupCell
            }
        case LocalizedString.Groups:
            guard let groupCell = tableView.dequeueReusableCell(withIdentifier: groupCellIdentifier, for: indexPath) as? GroupTableViewCell else {
                fatalError("GroupTableViewCell not found")
            }
            groupCell.dividerView.isHidden = indexPath.row == viewModel.groups.count - 1
            groupCell.delegate = self
            
            let totalCount = getCount(forLabel: viewModel.groups[indexPath.row])
            groupCell.configureCell(viewModel.groups[indexPath.row], totalCount)
            return groupCell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1, indexPath.row == 2 {
            return 35.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.headerLabel.text = sections[section].rawValue
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case LocalizedString.SortOrder:
            if indexPath.row == 0 {
                viewModel.sortOrder = "FL"
            } else {
                viewModel.sortOrder = "LF"
            }
        case LocalizedString.DisplayOrder:
            if indexPath.row == 0 {
                viewModel.displayOrder = "FL"
            } else {
                viewModel.displayOrder = "LF"
            }
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case LocalizedString.Groups:
            if editingStyle == .delete {
                if indexPath.row != viewModel.groups.count {
                    viewModel.groups.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // get modified Object
        let movedObject = viewModel.groups[sourceIndexPath.row]
        let movedModifiedObject = viewModel.modifiedGroups[sourceIndexPath.row]
        
        // remove element at Particular index
        viewModel.groups.remove(at: sourceIndexPath.row)
        viewModel.modifiedGroups.remove(at: sourceIndexPath.row)
        
        // Insert element at Particular index
        viewModel.groups.insert(movedObject, at: destinationIndexPath.row)
        viewModel.modifiedGroups.insert(movedModifiedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == viewModel.groups.count {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sections[indexPath.section] == LocalizedString.Groups {
            return true
        }
        return false
    }
}

// MARK: - GroupTableViewCellDelegate methods

extension PreferencesVC: GroupTableViewCellDelegate {
    func textField(_ textField: UITextField) {
        // Text field for begin editing
    }
    
    func textFieldWhileEditing(_ textField: UITextField, _ indexPath: IndexPath) {
        if !self.viewModel.groups.contains(where: { $0.compare(textField.text ?? "", options: .caseInsensitive) == .orderedSame }) {
            viewModel.groups[indexPath.row] = textField.text ?? ""
            viewModel.modifiedGroups[indexPath.row].modifiedGroupName = textField.text ?? ""
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.GroupAlreadyExist.localized,spaceFromBottom:self.keyboardHeight)
        }
    }
    
    func deleteCellTapped(_ indexPath: IndexPath) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Delete.localized], colors: [AppColors.themeRed])
        _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                switch self.sections[indexPath.section] {
                case LocalizedString.Groups:
                   self.viewModel.removedGroups.append(self.viewModel.groups.remove(at: indexPath.row))
                    self.viewModel.modifiedGroups.remove(at: indexPath.row)
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        }
    }
}

// MARK: - PreferencesVMDelegate methods

extension PreferencesVC: PreferencesVMDelegate {
    func willSavePreferences() {
        startLoading()
    }
    
    func savePreferencesSuccess() {
        stopLoading()
        dismiss(animated: true, completion: nil)
        delegate?.preferencesUpdated()
    }
    
    func savePreferencesFail(errors: ErrorCodes) {
        stopLoading()
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
}
