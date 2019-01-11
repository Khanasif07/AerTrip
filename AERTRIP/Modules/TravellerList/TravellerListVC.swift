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
    
    @IBOutlet var searchBar: ATSearchBar!
    
    // MARK: - Variables
    
    var travellerListHeaderView: TravellerListHeaderView = TravellerListHeaderView()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    let cellIdentifier = "TravellerListTableViewCell"
    let viewModel = TravellerListVM()
    
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<TravellerData>!
    var predicate: NSPredicate?
    
//    struct Objects {
//        var sectionName: String!
//        var sectionObjects: [TravellerModel]!
//    }
//
//    var objectArray = [Objects]()
    
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
        
        //predicate = NSPredicate(format: "label == 'Others'")
        predicate = NSPredicate(format: "label BEGINSWITH %@", "Others")
        loadSavedData()
        doInitialSetUp()
        registerXib()
        setUpTravellerHeader()
        viewModel.callSearchTravellerListAPI()
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
    
    @IBAction func popOverOptionTapped(_ sender: Any) {
        NSLog("edit buttn tapped")
        _ = AKAlertController.actionSheet(nil, message: nil, sourceView: view, buttons: [LocalizedString.Select.localized, LocalizedString.Preferences.localized, LocalizedString.Import.localized], tapBlock: { [weak self] _, index in
            
            if index == 0 {
                printDebug("select traveller")
            } else if index == 1 {
                printDebug("preferences  traveller")
                AppFlowManager.default.moveToPreferencesVC()
            } else if index == 2 {
                printDebug("import traveller")
                AppFlowManager.default.moveToImportContactVC()
            }
            
        })
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        navigationTitleLabel.text = LocalizedString.TravellerList.localized
        
        tableView.separatorStyle = .none
        travellerListHeaderView = TravellerListHeaderView.instanceFromNib()
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 44)
        tableView.tableHeaderView = travellerListHeaderView
        searchBar.delegate = self
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
        if fetchedResultsController == nil {
            let request = TravellerData.createFetchRequest()
            let sort = NSSortDescriptor(key: "label", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: "label", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        if let prd = predicate {
            fetchedResultsController.fetchRequest.predicate = prd
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }

}

extension TravellerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // return 1
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.viewModel.travelData.count
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravellerListTableViewCell else {
            fatalError("TravellerListTableViewCell not found")
        }
        
        let travelData = self.fetchedResultsController.object(at: indexPath)
//        cell.configureCell(salutation: self.viewModel.travelData[indexPath.row].salutation ?? "", dob: self.viewModel.travelData[indexPath.row].dob ?? "", userName: self.viewModel.travelData[indexPath.row].firstName ?? "")
        cell.configureCell(salutation: travelData.salutation ?? "", dob: travelData.dob ?? "", userName: travelData.firstName ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
//        print("section is \(Array(viewModel.travellersDict.keys)[section])")
//        headerView.configureCell(Array(viewModel.travellersDict.keys)[section])
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        headerView.configureCell(sections[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row) clicked")
    }
}

// MARK: - TravellerListVMDelegate methods

extension TravellerListVC: TravellerListVMDelegate {
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
        viewModel.searchTraveller(forText: searchText)
    }
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TravellerListTableViewCell {
                cell.configureCell(salutation: "", dob: "", userName: "")
            }
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
