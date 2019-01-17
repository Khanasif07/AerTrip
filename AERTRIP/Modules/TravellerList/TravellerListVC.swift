//
//  TravellerListVC.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import CoreData
import UIKit

class TravellerListVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var navigationTitleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var assignGroupButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var travellerNavigationView: UIView!
    @IBOutlet var selectView: UIView!
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var travellerSelectedCountLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    // MARK: - Variables
    
    var travellerListHeaderView: TravellerListHeaderView = TravellerListHeaderView()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    let cellIdentifier = "TravellerListTableViewCell"
    let viewModel = TravellerListVM()
    var isSelectMode: Bool = false
    private var selectedTravller: [String] = []
    
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var predicateStr: String = ""
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "AERTRIP")
        
        container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error.localizedDescription)")
            }
        }
        
        loadSavedData()
        doInitialSetUp()
        registerXib()
        setUpTravellerHeader()
        viewModel.callSearchTravellerListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - IB Action
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTravellerTapped(_ sender: Any) {
        AppFlowManager.default.presentEditProfileVC()
    }
    
    @IBAction func selectAllTapped(_ sender: Any) {}
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        setTravellerMode()
    }
    
    @IBAction func popOverOptionTapped(_ sender: Any) {
        NSLog("edit buttn tapped")
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Select.localized, LocalizedString.Preferences.localized, LocalizedString.Import.localized], colors: [AppColors.themeGreen, AppColors.themeGreen, AppColors.themeGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            if index == 0 {
                printDebug("select traveller")
                self?.setSelectMode()
            } else if index == 1 {
                printDebug("preferences  traveller")
                AppFlowManager.default.moveToPreferencesVC(self ?? TravellerListVC())
            } else if index == 2 {
                printDebug("import traveller")
                AppFlowManager.default.moveToImportContactVC()
            }
        }
    }
    
    @IBAction func assignGroupTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            AppFlowManager.default.presentAssignGroupVC(self, selectedTravller)
        }
    }
    
    @IBAction func deleteTravellerTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            let str = selectedTravller.count > 1 ? "Delete \(selectedTravller.count) Contacts" : "Delete this Contact"
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [str], colors: [AppColors.themeRed])
            
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.TheseContactsWillBeDeletedFromTravellersList.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    self.viewModel.paxIds = self.selectedTravller
                    self.viewModel.callDeleteTravellerAPI()
                }
            }
        }
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        navigationTitleLabel.text = LocalizedString.TravellerList.localized
        
        tableView.separatorStyle = .none
        travellerListHeaderView = TravellerListHeaderView.instanceFromNib()
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 44)
        tableView.tableHeaderView = travellerListHeaderView
        bottomView.isHidden = true
        addFooterView()
        searchBar.delegate = self
        selectView.isHidden = true
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func setUpTravellerHeader() {
        let string = "\("\(UserInfo.loggedInUser?.firstName ?? "N")") \("\(UserInfo.loggedInUser?.lastName ?? "A")")"
        travellerListHeaderView.userNameLabel.text = string
        if UserInfo.loggedInUser?.profileImage != "" {
            travellerListHeaderView.profileImageView.kf.setImage(with: URL(string: UserInfo.loggedInUser?.profileImage ?? ""))
        } else {
            travellerListHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
    }
    
    func loadSavedData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TravellerData")
        
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: false)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "label", cacheName: nil)
        } else {
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameFirstChar", ascending: false)]
            } else {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameFirstChar", ascending: true)]
            }
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "firstNameFirstChar", cacheName: nil)
        }
        
        if predicateStr == "" {
            fetchedResultsController.fetchRequest.predicate = nil
//            var subPredicates : [NSPredicate] = []
//            for label in UserInfo.loggedInUser?.generalPref?.labels ?? [] {
//                subPredicates.append(NSPredicate(format: "label == %@",label))
//            }
            ////            let predicate1 = NSPredicate(format: "label == 'friends'")
            ////            let predicate2 = NSPredicate(format: "label == 'facebook'")
            ////            let predicate3 = NSPredicate(format:"label == 'ddlsfla'")
            ////              let predicate4 = NSPredicate(format:"label == 'd'")
//            let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates:subPredicates)
//           // fetchedResultsController.fetchRequest.predicate =  NSPredicate(format: "label == 'friends'")
//            fetchedResultsController.fetchRequest.predicate =  predicateCompound
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "firstName CONTAINS[cd] %@", predicateStr)
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func searchTraveller(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(filterDictArrSearch(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc func filterDictArrSearch(_ forText: String) {
        print(forText)
        
        predicateStr = forText
        loadSavedData()
    }
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60.0))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    func setTravellerMode() {
        isSelectMode = false
        selectView.isHidden = true
        travellerNavigationView.isHidden = false
        bottomView.isHidden = true
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        tableView.reloadData()
    }
    
    func setSelectMode() {
        bottomView.isHidden = false
        travellerNavigationView.isHidden = true
        selectView.isHidden = false
        isSelectMode = true
        tableView.reloadData()
    }
}

extension TravellerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravellerListTableViewCell else {
            fatalError("TravellerListTableViewCell not found")
        }
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[indexPath.section]
        cell.separatorView.isHidden = indexPath.row == sectionInfo.numberOfObjects - 1 ? true : false
        let tData = fetchedResultsController.object(at: indexPath) as? TravellerData
        cell.travellerData = tData
        cell.selectTravellerButton.isHidden = isSelectMode ? false : true
        cell.selectTravellerButton.isSelected = selectedTravller.contains(tData?.id ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        headerView.configureCell(sections[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectMode {
            if let cell = tableView.cellForRow(at: indexPath) as? TravellerListTableViewCell, let data = cell.travellerData, let pId = data.id, !pId.isEmpty {
                if selectedTravller.contains(pId) {
                    selectedTravller.remove(at: selectedTravller.firstIndex(of: pId)!)
                } else {
                    selectedTravller.append(pId)
                }
                tableView.reloadData()
                if selectedTravller.count == 0 {
                    travellerSelectedCountLabel.text = "Select Traveller"
                } else {
                    travellerSelectedCountLabel.text = selectedTravller.count > 1 ? "\(selectedTravller.count) travellers selected" : "\(selectedTravller.count) traveller selected"
                }
            }
        } else {
            let tData = fetchedResultsController.object(at: indexPath) as? TravellerData
            AppFlowManager.default.moveToViewProfileDetailVC(tData?.id ?? "", true)
        }
    }
}

// MARK: - TravellerListVMDelegate methods

extension TravellerListVC: TravellerListVMDelegate {
    func willCallDeleteTravellerAPI() {
        //
    }
    
    func deleteTravellerAPISuccess() {
        selectView.isHidden = true
        travellerNavigationView.isHidden = false
        bottomView.isHidden = true
        isSelectMode = false
        self.deleteAllSelectedTravllers()
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        loadSavedData()
    }
    
    private func deleteAllSelectedTravllers() {
        for travellerId in selectedTravller {
            _ = CoreDataManager.shared.deleteData("TravellerData", predicate: "id BEGINSWITH '\(travellerId)'")
        }
    }
    
    func deleteTravellerAPIFailure() {
        selectView.isHidden = true
        travellerNavigationView.isHidden = false
        bottomView.isHidden = true
        isSelectMode = false
        tableView.reloadData()
    }
    
    func searchTravellerFail(errors: ErrorCodes) {
        printDebug(errors)
    }
    
    func willSearchForTraveller() {}
    
    func searchTravellerSuccess() {
        for (key, value) in viewModel.travellersDict {
            print("\(key) -> \(value)")
            // objectArray.append(Objects(sectionName: key, sectionObjects: (value as! [TravellerModel])))
        }
        
        loadSavedData()
    }
}

// MARK: - UISearchBarDelegate methods

extension TravellerListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            predicateStr = ""
            loadSavedData()
        } else {
            searchTraveller(forText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
}

// MARK: - NSFetchedResultsControllerDelegate Methods

extension TravellerListVC: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        // TODO: - Need to update
        case .update:
//            if let indexPath = indexPath, let _ = tableView.cellForRow(at: indexPath) as? TravellerListTableViewCell {}
            break
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension TravellerListVC: PreferencesVCDelegate {
    func preferencesUpdated() {
        loadSavedData()
    }
}

extension TravellerListVC: AssignGroupVCDelegate {
    func groupAssigned() {
        setTravellerMode()
        self.deleteAllSelectedTravllers()
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        viewModel.callSearchTravellerListAPI()
    }
}
