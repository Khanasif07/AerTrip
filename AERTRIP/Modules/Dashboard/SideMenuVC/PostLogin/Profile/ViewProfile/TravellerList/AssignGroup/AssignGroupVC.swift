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
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var addNewGroupButton: UIButton!
    
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
        
        
        labelsCountDict = CoreDataManager.shared.fetchData(fromEntity: "TravellerData", forAttribute: "label", usingFunction: "count")
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func setupColors() {
        self.view.backgroundColor = AppColors.themeWhiteDashboard
        self.tableView.backgroundColor = AppColors.themeWhite
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.AssignGroup.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: "  Cancel".localized, selectedTitle: LocalizedString.Cancel.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        
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
            printDebug("Canelled")
        }
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            let groupName = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) ?? "None"
            printDebug("Current group name: \(groupName)")
            
            
            
            if groupName.isEmpty {
                AppToast.default.showToastMessage(message: LocalizedString.GroupNameCanNotEmpty.localized)
                return
            }
            
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
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 100.0))
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
    
    func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelTapped()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewGroupTapped(_ sender: Any) {
        addNewGroupAlertController()
    }
}


extension AssignGroupVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        cancelButtonTapped(sender)
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
         AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
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
        groupCell.contentView.backgroundColor = AppColors.themeBlack26
        return groupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.label = viewModel.groups[indexPath.row]
        viewModel.callAssignGroupAPI()
    }
}
