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
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var predicateStr: String = "A"
    
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TravellerData")
        
        if (UserInfo.loggedInUser?.generalPref?.categorizeByGroup)! {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "label", cacheName: nil)
        } else {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameFirstChar", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "firstNameFirstChar", cacheName: nil)
        }
        
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
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "firstName CONTAINS[cd] %@", predicateStr)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravellerListTableViewCell else {
            fatalError("TravellerListTableViewCell not found")
        }
        
        cell.travellerData = fetchedResultsController.object(at: indexPath) as? TravellerData
        
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
        searchTraveller(forText: searchText)
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
