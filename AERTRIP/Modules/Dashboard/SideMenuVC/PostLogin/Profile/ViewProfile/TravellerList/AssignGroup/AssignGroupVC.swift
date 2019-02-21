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
    func cancelTapped()
}

class AssignGroupVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var addNewGroupButton: UIButton!
    
    // MARK: - Variables
    
    var cellIdentifier = "AssignGroupTableViewCell"
    let viewModel = AssignGroupVM()
    weak var delegate: AssignGroupVCDelegate?
    var labelsCountDict: [JSONDictionary] = []
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setUpData()
        doInitialSetUp()
        registerXib()
        
        labelsCountDict = CoreDataManager.shared.getCount(fromEntity: "TravellerData", forAttribute: "label")
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
            
            if !self.viewModel.groups.contains(where: {$0.compare(groupName, options: .caseInsensitive) == .orderedSame}) {
                self.viewModel.groups.append(groupName)
            } else {
                AppToast.default.showToastMessage(message: LocalizedString.GroupAlreadyExist.localized)
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
    
    
    private func getCount(forLabel: String) -> Int {
        var finalCount = 0
        for dict in self.labelsCountDict {
            if let obj = dict["label"], "\(obj)".lowercased() == forLabel.lowercased(), let count = dict["count"] {
                finalCount = "\(count)".toInt ?? 0
                break
            }
        }
        
        return finalCount
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelTapped()
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
         let totalCount = self.getCount(forLabel: viewModel.groups[indexPath.row])
        groupCell.configureCell(viewModel.groups[indexPath.row],totalCount)
        return groupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.label = viewModel.groups[indexPath.row]
        viewModel.callAssignGroupAPI()
    }
}
