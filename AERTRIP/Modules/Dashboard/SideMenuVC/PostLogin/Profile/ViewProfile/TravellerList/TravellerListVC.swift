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
    
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var assignGroupButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var headerDividerView: ATDividerView!
    @IBOutlet weak var topNavView: TopNavigationView!
    
    // MARK: - Variables
    
    private var shouldHitAPI: Bool = true
    var travellerListHeaderView: TravellerListHeaderView = TravellerListHeaderView()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    let cellIdentifier = "TravellerListTableViewCell"
    let viewModel = TravellerListVM()
    var isSelectMode: Bool = false {
        didSet {
            tableView.setEditing(isSelectMode, animated: true)
        }
    }
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
        
        tableView.sectionIndexColor = AppColors.themeGreen
        
        loadSavedData()
        doInitialSetUp()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.statusBarStyle = .default
        
        setUpTravellerHeader()
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
            setSelectMode()
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.tableView(self.tableView, didSelectRowAt: indexPath)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    private func updateNavView() {
        if self.isSelectMode {
            var title = "Select Traveller"
            if selectedTravller.count == 0 {
                title = "Select Traveller"
            } else {
                title = selectedTravller.count > 1 ? "\(selectedTravller.count) travellers selected" : "\(selectedTravller.count) traveller selected"
            }
            self.topNavView.configureNavBar(title: title, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
            self.topNavView.configureLeftButton(normalTitle: LocalizedString.SelectAll.localized, selectedTitle: LocalizedString.SelectAll.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
            self.topNavView.configureFirstRightButton(normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        }
        else {
            self.topNavView.configureNavBar(title: LocalizedString.TravellerList.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
            self.topNavView.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
            self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
            self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "plusButton"), selectedImage: #imageLiteral(resourceName: "plusButton"))
        }
    }
    // MARK: - IB Action
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func addTravellerTapped() {
        AppFlowManager.default.showEditProfileVC(travelData: nil, usingFor: .addNewTravellerList)
    }
    
    func selectAllTapped() {}
    
    func doneButtonTapped() {
        setTravellerMode()
    }
    
    func popOverOptionTapped() {
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
            AppFlowManager.default.showAssignGroupVC(self, selectedTravller)
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
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .singleLine
        
        travellerListHeaderView = TravellerListHeaderView.instanceFromNib()
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 44)
        travellerListHeaderView.delegate = self
        tableView.tableHeaderView = travellerListHeaderView
        bottomView.isHidden = true
        deleteButton.setTitle(LocalizedString.Delete.localized, for: .normal)
        deleteButton.titleLabel?.textColor  = AppColors.themeGreen
        addFooterView()
        searchBar.delegate = self
        addLongPressOnTableView()
        self.topNavView.delegate = self
        self.updateNavView()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func addLongPressOnTableView() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TravellerListVC.handleLongPress(_:)))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    func setUpTravellerHeader() {
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
            travellerListHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
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

        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "firstName CONTAINS[cd] %@", predicateStr)
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            tableView.reloadData()
            print("Fetch failed")
        }
    }
    
    func searchTraveller(forText: String) {
        printDebug("searching text is \(forText)")
        predicateStr = forText
        loadSavedData()
    }
    
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 60.0))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    func setTravellerMode(shouldReload: Bool = true) {
        isSelectMode = false
        bottomView.isHidden = true
        selectedTravller.removeAll()
        self.updateNavView()
    }
    
    func setSelectMode() {
        bottomView.isHidden = false
        isSelectMode = true
        self.updateNavView()
    }
    
    func resetAllItem() {
        searchBar.endEditing(true)
        predicateStr = ""
        searchBar.text = ""
        loadSavedData()
    }
}

extension TravellerListVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        if self.isSelectMode {
            //select all
            self.selectAllTapped()
        }
        else {
            //back button
            self.backButtonTapped()
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if self.isSelectMode {
            //done action
            self.doneButtonTapped()
        }
        else {
            //pop more
            self.popOverOptionTapped()
        }
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        if self.isSelectMode {
            //no action needed
        }
        else {
            //add new
            self.addTravellerTapped()
        }
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
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TravellerListTableViewCell else {
        //            fatalError("TravellerListTableViewCell not found")
        //        }
        
        let cell = UITableViewCell()
        self.configureCell(cell: cell, travellerData: fetchedResultsController.object(at: indexPath) as? TravellerData)
        cell.tintColor = AppColors.themeGreen
        let backView = UIView(frame: cell.contentView.bounds)
        backView.backgroundColor = AppColors.themeWhite
        cell.selectedBackgroundView = backView
        
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, travellerData: TravellerData?) {
        cell.imageView?.image = travellerData?.salutationImage
        if let firstName = travellerData?.firstName, let lastName = travellerData?.lastName, let salutation = travellerData?.salutation {
            if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                cell.textLabel?.attributedText = getAttributedBoldText(text: "\(salutation) \(lastName) \(firstName)", boldText: boldText)
                
            } else {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                cell.textLabel?.attributedText = getAttributedBoldText(text: "\(salutation) \(firstName) \(lastName)", boldText: boldText)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let traveller = fetchedResultsController.object(at: indexPath) as? TravellerData
            self.viewModel.paxIds.append(traveller?.id ?? "")
            self.selectedTravller.append(traveller?.id ?? "")
            self.viewModel.callDeleteTravellerAPI()
        }
    }
        
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            return []
        }
        else {
            return ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            return nil
        }
        guard let sections = fetchedResultsController.sections else {
            return nil
        }
        headerView.configureCell(sections[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectMode {
            if let data = fetchedResultsController.object(at: indexPath) as? TravellerData, let pId = data.id, !pId.isEmpty {
                if !selectedTravller.contains(pId) {
                    selectedTravller.append(pId)
                }
                self.updateNavView()
            }
        } else if let tData = fetchedResultsController.object(at: indexPath) as? TravellerData {
            AppFlowManager.default.moveToViewProfileDetailVC(tData.travellerDetailModel, usingFor: .travellerList)
        }
        
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.backgroundColor = AppColors.themeWhite
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isSelectMode {
            if let data = fetchedResultsController.object(at: indexPath) as? TravellerData, let pId = data.id, !pId.isEmpty {
                if selectedTravller.contains(pId) {
                    selectedTravller.remove(at: selectedTravller.firstIndex(of: pId)!)
                }
                self.updateNavView()
            }
        }
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.backgroundColor = AppColors.themeWhite
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printDebug("content scroll offset \(scrollView.contentOffset.y)")
        headerDividerView.isHidden = scrollView.contentOffset.y >= 44.0
    }
}

// MARK: - TravellerListVMDelegate methods

extension TravellerListVC: TravellerListVMDelegate {
    func willCallDeleteTravellerAPI() {
        //
    }
    
    func deleteTravellerAPISuccess() {
        bottomView.isHidden = true
        isSelectMode = false
        deleteAllSelectedTravllers()
        selectedTravller.removeAll()
        loadSavedData()
        updateNavView()
    }
    
    private func deleteAllSelectedTravllers() {
        for travellerId in selectedTravller {
            _ = CoreDataManager.shared.deleteData("TravellerData", predicate: "id BEGINSWITH '\(travellerId)'")
        }
    }
    
    func deleteTravellerAPIFailure() {
        bottomView.isHidden = true
        isSelectMode = false
        tableView.reloadData()
        updateNavView()
    }
    
    func searchTravellerFail(errors: ErrorCodes) {
        printDebug(errors)
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
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
        tableView.reloadData()
    }
}

extension TravellerListVC: PreferencesVCDelegate {
    func cancelButtonTapped() {
        resetAllItem()
    }
    
    func preferencesUpdated() {
        resetAllItem()
        setUpTravellerHeader()
        
    }
}

extension TravellerListVC: AssignGroupVCDelegate {
    func cancelTapped() {
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI()
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
        self.updateNavView()
    }
    
    func groupAssigned() {
        predicateStr = ""
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI()
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
        self.updateNavView()
    }
}

// MARK: - TravellerListHeaderViewDelegate Methods

extension TravellerListVC: TravellerListHeaderViewDelegate {
    func headerViewTapped() {
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.travellerDetailModel ?? TravelDetailModel(), usingFor: .viewProfile)
    }
}
