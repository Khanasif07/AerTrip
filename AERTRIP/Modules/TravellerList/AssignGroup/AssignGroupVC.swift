//
//  AssignGroupVC.swift
//  AERTRIP
//
//  Created by apple on 14/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AssignGroupVCDelegate: class {
    func groupAssigned()
}

class AssignGroupVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNewGroupButton: UIButton!
    
    // MARK: - Variables
    
    var cellIdentifier = "AssignGroupTableViewCell"
    let viewModel = AssignGroupVM()
    weak var delegate: AssignGroupVCDelegate?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setUpData()
        doInitialSetUp()
        registerXib()
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        addFooterView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
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
            let groupName = alertController.textFields?.first?.text ?? "None"
            printDebug("Current group name: \(groupName)")
            
            if !self.viewModel.groups.contains(groupName) {
                self.viewModel.groups.append(groupName)
            }
            self.tableView.reloadData()
            self.viewModel.callSavePreferencesAPI()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
      
        present(alertController, animated: true, completion: nil)
    }
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100.0))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewGroupTapped(_ sender: Any) {
        addNewGroupAlertController()
    }
}

// MARK: - AssignGroupVMDelegat methods

extension AssignGroupVC: AssignGroupVMDelegate {
    func willSavePreferences() {
        //
    }
    
    func savePreferencesSuccess() {
        //
    }
    
    func savePreferencesFail(errors: ErrorCodes) {
        //
    }
    
    func willAsignGroup() {
        //
    }
    
    func assignGroupSuccess() {
        delegate?.groupAssigned()
        dismiss(animated: true, completion: nil)
    }
    
    func assignGroupFail(errors: ErrorCodes) {
        //
    }
}

// MARK: - UITableViewDataSource methods

extension AssignGroupVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let groupCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AssignGroupTableViewCell else {
            fatalError("GroupTableViewCell not found")
        }
        groupCell.configureCell(viewModel.groups[indexPath.row])
        return groupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.label = viewModel.groups[indexPath.row]
        viewModel.callAssignGroupAPI()
    }
}
