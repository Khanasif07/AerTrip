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
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var assignGroupButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var travellerNavigationView: UIView!
    @IBOutlet var selectView: UIView!
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var travellerSelectedCountLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var headerDividerView: UIView!
    
    // MARK: - Variables
    
    private var shouldHitAPI: Bool = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldHitAPI {
            viewModel.callSearchTravellerListAPI()
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        CoreDataManager.shared.deleteCompleteDB()
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let cell = tableView.cellForRow(at: indexPath) as? TravellerListTableViewCell, let data = cell.travellerData, let pId = data.id, !pId.isEmpty {
                    if selectedTravller.contains(pId) {
                        selectedTravller.remove(at: selectedTravller.firstIndex(of: pId)!)
                    } else {
                        selectedTravller.append(pId)
                    }
                    if selectedTravller.count == 0 {
                        travellerSelectedCountLabel.text = "Select Traveller"
                    } else {
                        travellerSelectedCountLabel.text = selectedTravller.count > 1 ? "\(selectedTravller.count) travellers selected" : "\(selectedTravller.count) traveller selected"
                    }
                }
            }
            setSelectMode()
        }
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
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            guard let sSelf = self else { return }
            if index == 0 {
                printDebug("select traveller")
                sSelf.setSelectMode()
            } else if index == 1 {
                printDebug("preferences  traveller")
                AppFlowManager.default.moveToPreferencesVC(sSelf)
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
            
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.TheseContactsWillBeDeletedFromTravellersList.localized, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
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
        travellerListHeaderView.delegate = self
        tableView.tableHeaderView = travellerListHeaderView
        bottomView.isHidden = true
        addFooterView()
        searchBar.delegate = self
        selectView.isHidden = true
        addLongPressOnTableView()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func addLongPressOnTableView() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TravellerListVC.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    func setUpTravellerHeader() {
//        let string = "\("\(UserInfo.loggedInUser?.firstName ?? "N")") \("\(UserInfo.loggedInUser?.lastName ?? "A")")"
//        travellerListHeaderView.userNameLabel.text = string
        if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
            let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? UserInfo.loggedInUser?.lastName ?? "A" : UserInfo.loggedInUser?.firstName ?? "N"
            travellerListHeaderView.userNameLabel.attributedText = getAttributedBoldText(text: "\("\(UserInfo.loggedInUser?.lastName ?? "A")") \("\(UserInfo.loggedInUser?.firstName ?? "N")")", boldText: boldText)
            
        } else {
            let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? UserInfo.loggedInUser?.lastName ?? "A" : UserInfo.loggedInUser?.firstName ?? "N"
            travellerListHeaderView.userNameLabel.attributedText = getAttributedBoldText(text: "\("\(UserInfo.loggedInUser?.firstName ?? "N")") \("\(UserInfo.loggedInUser?.lastName ?? "A")")", boldText: boldText)
        }
        if UserInfo.loggedInUser?.profileImage != "" {
            travellerListHeaderView.profileImageView.kf.setImage(with: URL(string: UserInfo.loggedInUser?.profileImage ?? ""))
        } else {
            travellerListHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: UIColor.black])
        
        attString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: (text as NSString).range(of: boldText))
        return attString
    }
    
    func loadSavedData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TravellerData")
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "label", cacheName: nil)
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "firstName", ascending: false))
                
            } else {
                fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "firstName", ascending: true))
            }
        } else {
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameFirstChar", ascending: true)]
            } else {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameFirstChar", ascending: true)]
            }
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "firstNameFirstChar", cacheName: nil)
        }
        fetchedResultsController.delegate = self
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
//            fetchedResultsController.fetchRequest.predicate =  predicateCompou
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
    
    func setTravellerMode(shouldReload: Bool = true) {
        isSelectMode = false
        selectView.isHidden = true
        travellerNavigationView.isHidden = false
        bottomView.isHidden = true
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        if shouldReload {
            tableView.reloadData()
        }
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
        cell.edgeToEdgeBottomSeparatorView.isHidden = indexPath.row == sectionInfo.numberOfObjects ? false : true
        cell.edgeToEdgeTopSeparatorView.isHidden = indexPath.row == 0 ? false : true
        let tData = fetchedResultsController.object(at: indexPath) as? TravellerData
        cell.travellerData = tData
        cell.selectTravellerButton.isHidden = isSelectMode ? false : true
        cell.leadingConstraint.constant = isSelectMode ? 10.0 : 16.0
        cell.selectTravellerButton.isSelected = selectedTravller.contains(tData?.id ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let traveller = fetchedResultsController.object(at: indexPath)
            CoreDataManager.shared.managedObjectContext.delete(traveller as! TravellerData)
            CoreDataManager.shared.saveContext()
        }
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
        } else if let tData = fetchedResultsController.object(at: indexPath) as? TravellerData {
            AppFlowManager.default.moveToViewProfileDetailVC(tData.travellerDetailModel, true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printDebug("content scroll offset \(scrollView.contentOffset.y)")
        headerDividerView.isHidden = scrollView.contentOffset.y >= 44.0 ? true : false
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
        deleteAllSelectedTravllers()
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
        shouldHitAPI = true
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
            
            tableView.deleteRows(at: [indexPath ?? IndexPath()], with: .fade)
            
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
        setUpTravellerHeader()
    }
}

extension TravellerListVC: AssignGroupVCDelegate {
    func cancelTapped() {
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI()
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
    }
    
    func groupAssigned() {
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI()
        travellerSelectedCountLabel.text = "Select Traveller"
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
    }
}

// MARK: - TravellerListHeaderViewDelegate Methods

extension TravellerListVC: TravellerListHeaderViewDelegate {
    func headerViewTapped() {
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.travellerDetailModel ?? TravelDetailModel(), true)
    }
}
