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
    
    @IBOutlet var tableView: ATTableView! {
        didSet {
            tableView.delegate = nil
            tableView.dataSource = nil
        }
    }
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var assignGroupButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var searchBar: ATSearchBar!
    @IBOutlet var headerDividerView: ATDividerView!
    @IBOutlet var topNavView: TopNavigationView!
    
    // MARK: - Variables
    
    private lazy var noTravEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noTravellerWithAddButton
        newEmptyView.delegate = self
        return newEmptyView
    }()
    
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
    
    private var selectedTravller: [TravellerData] = []
    
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<TravellerData>!
    var predicateStr: String = ""
    var didTapCrossKey: Bool = false
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "AERTRIP")
        
        container.loadPersistentStores { _, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                printDebug("Unresolved error \(error.localizedDescription)")
            }
        }
        
        tableView.sectionIndexColor = AppColors.themeGreen
        tableView.backgroundView = noTravEmptyView
        tableView.backgroundView?.isHidden = true
        
        loadSavedData()
        doInitialSetUp()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarStyle = .default
        
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
                tableView(tableView, didSelectRowAt: indexPath)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    private func updateNavView() {
        if isSelectMode {
            var title = "Select Traveller"
            if selectedTravller.count == 0 {
                title = "Select Traveller"
            } else {
                title = selectedTravller.count > 1 ? "\(selectedTravller.count) travellers selected" : "\(selectedTravller.count) traveller selected"
            }
            topNavView.leftButton.setTitle(LocalizedString.SelectAll.localized, for: .normal)
            topNavView.leftButton.setTitle(LocalizedString.DeselectAll.localized, for: .selected)
            topNavView.configureNavBar(title: title, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
            topNavView.configureLeftButton(normalTitle: LocalizedString.SelectAll.localized, selectedTitle: LocalizedString.SelectAll.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
            topNavView.configureFirstRightButton(normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        } else {
            topNavView.configureNavBar(title: LocalizedString.TravellerList.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
            topNavView.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
            topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
            topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "plusButton"), selectedImage: #imageLiteral(resourceName: "plusButton"))
        }
    }
    
    // MARK: - IB Action
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func addTravellerTapped() {
        AppFlowManager.default.showEditProfileVC(travelData: nil, usingFor: .addNewTravellerList)
    }
    
    func selectAllTapped() {
        let allTravellers = fetchedResultsController.fetchedObjects ?? []
        selectedTravller.removeAll()
        selectedTravller.append(contentsOf: allTravellers)
        tableView.reloadData()
    }
    
    func deselectAllTapped() {
        selectedTravller.removeAll()
        tableView.reloadData()
    }
    
    func doneButtonTapped() {
        setTravellerMode()
    }
    
    func popOverOptionTapped() {
        printDebug("edit buttn tapped")
        
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
    
    func getSelectedPaxIds() -> [String] {
        return selectedTravller.map { (result) -> String in
            (result as? TravellerData)?.id ?? ""
        }
    }
    
    @IBAction func assignGroupTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            AppFlowManager.default.showAssignGroupVC(self, getSelectedPaxIds())
        }
    }
    
    @IBAction func deleteTravellerTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            let str = selectedTravller.count > 1 ? "Delete \(selectedTravller.count) Contacts" : "Delete this Contact"
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [str], colors: [AppColors.themeRed])
            
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.TheseContactsWillBeDeletedFromTravellersList.localized, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    self.viewModel.paxIds = self.getSelectedPaxIds()
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
        deleteButton.titleLabel?.textColor = AppColors.themeGreen
        addFooterView()
        searchBar.delegate = self
        addLongPressOnTableView()
        topNavView.delegate = self
        updateNavView()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
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
    
    // create label Predicate
    
    func labelPredicate() -> NSPredicate? {
        var labelPredicate: NSPredicate?
        var labelPredicates = [AnyHashable]()
        if let generalPref = UserInfo.loggedInUser?.generalPref {
            for group in generalPref.labels {
                labelPredicates.append(NSPredicate(format: "label == '\(group.removeAllWhiteSpacesAndNewLines)'"))
            }
        }
        if labelPredicates.count > 0 {
            if let labelPredicates = labelPredicates as? [NSPredicate] {
                labelPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: labelPredicates)
            }
        }
        return labelPredicate
    }
    
    func loadSavedData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TravellerData")
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "label", cacheName: nil) as? NSFetchedResultsController<TravellerData>
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
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "firstNameFirstChar", cacheName: nil) as? NSFetchedResultsController<TravellerData>
        }
        fetchedResultsController.delegate = self
        if predicateStr.isEmpty {
            if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
                fetchedResultsController.fetchRequest.predicate = labelPredicate()
            } else {
                fetchedResultsController.fetchRequest.predicate = nil
            }
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "firstName CONTAINS[cd] %@", predicateStr)
        }
        
        do {
            try fetchedResultsController.performFetch()
            reloadList()
        } catch {
            reloadList()
            printDebug("Fetch failed")
        }
    }
    
    func reloadList() {
        tableView.reloadData()
        
        for result in selectedTravller {
            if let indexPath = self.fetchedResultsController.indexPath(forObject: result) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            }
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
        updateNavView()
    }
    
    func setSelectMode() {
        bottomView.isHidden = false
        isSelectMode = true
        updateNavView()
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
        if isSelectMode {
            // select all
            if !sender.isSelected {
                sender.isSelected = true
                selectAllTapped()
            } else {
                sender.isSelected = false
                deselectAllTapped()
            }
        } else {
            // back button
            backButtonTapped()
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if isSelectMode {
            // done action
            doneButtonTapped()
        } else {
            // pop more
            popOverOptionTapped()
        }
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        if isSelectMode {
            // no action needed
        } else {
            // add new
            addTravellerTapped()
        }
    }
}

extension TravellerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        
        tableView.backgroundView?.isHidden = !sections.isEmpty
        tableView.isScrollEnabled = !sections.isEmpty
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
//        var oldCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
//        if oldCell == nil {
//            oldCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
//        }
        let cell = UITableViewCell() // oldCell!
        let data = fetchedResultsController.object(at: indexPath)
        configureCell(cell: cell, travellerData: data)
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
        
        if let trav = travellerData, self.selectedTravller.contains(where: { ($0.id ?? "") == (trav.id ?? "") }) {
            cell.setSelected(true, animated: false)
        } else {
            cell.setSelected(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let traveller = fetchedResultsController.object(at: indexPath)
            viewModel.paxIds.append(traveller.id ?? "")
            selectedTravller.append(traveller)
            viewModel.callDeleteTravellerAPI()
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            return []
        } else {
            guard let sections = self.fetchedResultsController.sections else {
                return []
            }
            
            let all = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            return sections.isEmpty ? [] : all
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
            let current = fetchedResultsController.object(at: indexPath) as? TravellerData
          
            if !selectedTravller.contains(where: { (result) -> Bool in
                ((result as? TravellerData)?.id ?? "") == (current?.id ?? "")
            }) {
                selectedTravller.append(fetchedResultsController.object(at: indexPath))
            }
            updateNavView()
        } else if let tData = fetchedResultsController.object(at: indexPath) as? TravellerData {
            AppFlowManager.default.moveToViewProfileDetailVC(tData.travellerDetailModel, usingFor: .travellerList)
        }
        
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.backgroundColor = AppColors.themeWhite
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isSelectMode {
            let current = fetchedResultsController.object(at: indexPath) as? TravellerData
            if let index = selectedTravller.firstIndex(where: { (result) -> Bool in
                ((result as? TravellerData)?.id ?? "") == (current?.id ?? "")
            }) {
                selectedTravller.remove(at: index)
            }
            
            updateNavView()
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
        for traveller in selectedTravller {
            if let id = traveller.id, !id.isEmpty {
                _ = CoreDataManager.shared.deleteData("TravellerData", predicate: "id BEGINSWITH '\(id)'")
            }
        }
    }
    
    func deleteTravellerAPIFailure() {
        bottomView.isHidden = true
        isSelectMode = false
        reloadList()
        updateNavView()
    }
    
    func searchTravellerFail(errors: ErrorCodes) {
        printDebug(errors)
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
    
    func willSearchForTraveller() {}
    
    func searchTravellerSuccess() {
        tableView.delegate = self
        tableView.dataSource = self
        shouldHitAPI = true
        loadSavedData()
    }
}

// MARK: - UISearchBarDelegate methods

extension TravellerListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            predicateStr = ""
            loadSavedData()
        } else {
            searchTraveller(forText: searchText)
        }
        if !didTapCrossKey, searchText.isEmpty {
            self.searchBar.isMicEnabled = true
        }
        
        didTapCrossKey = false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        didTapCrossKey = text.isEmpty
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate Methods

extension TravellerListVC: NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadList()
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
        updateNavView()
    }
    
    func groupAssigned() {
        predicateStr = ""
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI()
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
        updateNavView()
    }
}

// MARK: - TravellerListHeaderViewDelegate Methods

extension TravellerListVC: TravellerListHeaderViewDelegate {
    func headerViewTapped() {
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.travellerDetailModel ?? TravelDetailModel(), usingFor: .viewProfile)
    }
}

extension TravellerListVC: EmptyScreenViewDelegate {
    func firstButtonAction(sender: ATButton) {
        // not required
    }
    
    func bottomButtonAction(sender: UIButton) {
        topNavBarSecondRightButtonAction(sender)
    }
}
