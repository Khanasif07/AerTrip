//
//  PreferencesVC.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PreferencesVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    let sections = [LocalizedString.SortOrder, LocalizedString.DisplayOrder, LocalizedString.Groups]
    let order = [LocalizedString.FirstLast, LocalizedString.LastFirst]
    var groups: [String] = []
    let orderCellIdentifier = "OrderTableViewCell"
    let categorisedByGroupsCellIdentifier = "CategorisedByGroupsTableViewCell"
    let emptyCellIdentifier = "EmptyTableViewCell"
    let groupCellIdentifier = "GroupTableViewCell"
    let addActionCellIdentifier = "TableViewAddActionCell"
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetUp()
        registerXib()
        setUpData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {}
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        headerTitleLabel.text = LocalizedString.Preferences.localized
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        tableView.register(UINib(nibName: orderCellIdentifier, bundle: nil), forCellReuseIdentifier: orderCellIdentifier)
        tableView.register(UINib(nibName: categorisedByGroupsCellIdentifier, bundle: nil), forCellReuseIdentifier: categorisedByGroupsCellIdentifier)
        tableView.register(UINib(nibName: emptyCellIdentifier, bundle: nil), forCellReuseIdentifier: emptyCellIdentifier)
        tableView.register(UINib(nibName: groupCellIdentifier, bundle: nil), forCellReuseIdentifier: groupCellIdentifier)
        tableView.register(UINib(nibName: addActionCellIdentifier, bundle: nil), forCellReuseIdentifier: addActionCellIdentifier)
    }
    
    func setUpData() {
        if let group = UserInfo.loggedInUser?.generalPref?.labels {
            groups = group
        }
    }
    
    func addNewGroupAlertController() {
        let alertController = UIAlertController(title: LocalizedString.EnterAGroupName.localized, message: "", preferredStyle: .alert)
        alertController.view.tintColor = AppColors.themeGreen
        
        alertController.addTextField { textField in
            textField.placeholder = LocalizedString.EnterGroupName.localized
            textField.textAlignment = .left
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            print("Current group name: \(alertController.textFields?.first?.text ?? "None")")
            self.groups.append(alertController.textFields?.first?.text ?? "None")
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func setCategorisedByGroupFlag(_ sender: UISwitch) {
        NSLog("\(sender.isOn)")
        
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
            return groups.count + 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderCell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier, for: indexPath) as? OrderTableViewCell else {
            fatalError("OrderTableViewCell not found")
        }
        switch sections[indexPath.section] {
        case LocalizedString.SortOrder:
            orderCell.titleLabel.text = order[indexPath.row].rawValue
            orderCell.separatorView.isHidden = indexPath.row == 1 ? true : false
            return orderCell
        case LocalizedString.DisplayOrder:
            if indexPath.row < 2 {
                orderCell.titleLabel.text = order[indexPath.row].rawValue
                orderCell.separatorView.isHidden = indexPath.row == 1 ? true : false
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

                return categoryGroupCell
            }
        case LocalizedString.Groups:
            
            if indexPath.row == groups.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: addActionCellIdentifier, for: indexPath) as? TableViewAddActionCell else {
                    fatalError("TableViewAddActionCell not found")
                }
                cell.cellBackgroundView.backgroundColor = UIColor.white
                cell.configureCell(LocalizedString.AddNewGroup.localized)
                return cell
            } else {
                guard let groupCell = tableView.dequeueReusableCell(withIdentifier: groupCellIdentifier, for: indexPath) as? GroupTableViewCell else {
                    fatalError("GroupTableViewCell not found")
                }
                groupCell.delegate = self
                groupCell.configureCell(indexPath, groups[indexPath.row])
                return groupCell
            }
            
        default:
            break
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       switch sections[indexPath.section] {
//        case LocalizedString.DisplayOrder:
//            if indexPath.row == 2 {
//                return 35
//            }
//        default:
//            return 44.0
//        }
//        return 44.0
//    }
    
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
        case LocalizedString.Groups:
            if indexPath.row == groups.count {
                NSLog("add new group tapped")
                addNewGroupAlertController()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case LocalizedString.Groups:
            if editingStyle == .delete {
                if indexPath.row != groups.count {
                    groups.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - GroupTableViewCellDelegate methods

extension PreferencesVC: GroupTableViewCellDelegate {
    func deleteCellTapped(_ indexPath: IndexPath) {
        _ = AKAlertController.actionSheet(nil, message: LocalizedString.WouldYouLikeToDelete.localized, sourceView: view, buttons: [LocalizedString.Delete.localized], tapBlock: { _, index in
            if index == 0 {
                switch self.sections[indexPath.section] {
                case LocalizedString.Groups:
                    self.groups.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                default:
                    break
                }
            }
            
        })
    }
}
