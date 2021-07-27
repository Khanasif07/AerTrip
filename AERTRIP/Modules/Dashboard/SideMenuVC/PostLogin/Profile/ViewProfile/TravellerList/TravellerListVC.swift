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
    
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            tableView.delegate = nil
            tableView.dataSource = nil
        }
    }
    
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSafeAreaView: UIView!
    
    @IBOutlet weak var assignGroupButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var headerDividerView: ATDividerView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var progressView: AppProgressView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var blurView: BlurView!
    
    // MARK: - Variables
    
    private lazy var noTravEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noTravellerWithAddButton
        newEmptyView.delegate = self
        return newEmptyView
    }()
    private lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    private var shouldHitAPI: Bool = true
    var travellerListHeaderView: TravellerListHeaderView = TravellerListHeaderView()
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    //let cellIdentifier = "TravellerListTableViewCell"
    let viewModel = TravellerListVM()
    var isSelectMode: Bool = false {
        didSet {
            tableView.setEditing(isSelectMode, animated: true)
        }
    }
    
    var travellerIdToDelete : String = ""
    
    private var selectedTravller: [TravellerData] = []
    private var tableDataArray: [[TravellerData]] = []
    private var tableSectionArray = [String]()
    
    var container: NSPersistentContainer!
    var fetchedResultsController: NSFetchedResultsController<TravellerData>!
    var predicateStr: String = ""
    var didTapCrossKey: Bool = false
    private var time: Float = 0.0
    private var timer: Timer?
    private var showImportContactView = false
    var tableViewContentInset: CGFloat {
       return  44 + searchBar.height
    }
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = AppColors.themeWhite
        self.view.backgroundColor = AppColors.themeWhite
        self.tableView.backgroundColor = AppColors.themeWhite
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
        self.bottomBackgroundView.backgroundColor = AppColors.travellerHeaderColor
        self.blurView.backgroundColor = AppColors.travellerHeaderColor
        CoreDataManager.shared.deleteData("TravellerData")
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
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = AppColors.blueGray
        tableView.showsVerticalScrollIndicator = true
        //noResultemptyView.mainImageViewTopConstraint.constant = tableView.height/2
        loadSavedData()
        doInitialSetUp()
        registerXib()
        self.tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsMultipleSelectionDuringEditing = true
//        addTwoFingerSwipeGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarStyle = .default
        setUpTravellerHeader()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldHitAPI {
            viewModel.callSearchTravellerListAPI(isShowLoader: true)
        }
        self.tableView.contentInset = UIEdgeInsets(top: tableViewContentInset, left: 0, bottom: bottomSafeAreaView.height + 20, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        statusBarStyle = .default
        self.view.endEditing(true)
        
        
        if  self.isMovingFromParent {
            self.topNavView.backgroundType = .clear
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
    
    deinit {
        self.timer?.invalidate()
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        
        if let noti = note.object as? ATNotification {
            switch noti {
            case .profileSavedOnServer:
                // Clear the DB
                CoreDataManager.shared.deleteData("TravellerData")
                //re-hit the details API
                viewModel.callSearchTravellerListAPI(isShowLoader: false)
                
            case .preferenceUpdated:
                // Clear the DB
                CoreDataManager.shared.deleteData("TravellerData")
                //re-hit the details API
                self.viewModel.callSearchTravellerListAPI(isShowLoader: false)
                
            case .travellerDeleted:
                // Clear the DB
                CoreDataManager.shared.deleteData("TravellerData", predicate: "id == '\(travellerIdToDelete)'")
                //re-hit the details API
                loadSavedData()
                
            default:
                break
            }
            
        } else if let noti = note.object as? ImportContactVM.Notification, noti == .contactSavedSuccess {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -tableViewContentInset), animated: false)
            self.shouldHitAPI = false
            self.showImportContactView = true
            manageImportContactHeaderView()
            // Clear the DB
            CoreDataManager.shared.deleteData("TravellerData")
            //re-hit the details API
            self.viewModel.callSearchTravellerListAPI(isShowLoader: false)
        }
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            func updateTableView() {
                let touchPoint = longPressGestureRecognizer.location(in: tableView)
                if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                    self.tableView.reloadData()
                    tableView.separatorStyle = .singleLine
                    tableView(tableView, didSelectRowAt: indexPath)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
            
            tableView.performBatchUpdates {
                self.viewModel.logEventsForFirebase(with: .EnterSelectModeByLongPressing)
                self.setSelectMode(isNeedToReload: false)
            } completion: { (_) in
                delay(seconds: 0.15) {
                    updateTableView()
                }
            }
        }
    }
    
    private func updateNavView() {
        if isSelectMode {
            var title = "Select Travellers"
            if selectedTravller.count == 0 {
                title = "Select Travellers"
            } else {
                title = selectedTravller.count > 1 ? "\(selectedTravller.count) travellers selected" : "\(selectedTravller.count) traveller selected"
            }
            topNavView.leftButton.setTitle(LocalizedString.SelectAll.localized, for: .normal)
            topNavView.leftButton.setTitle(LocalizedString.DeselectAll.localized, for: .selected)
            topNavView.configureNavBar(title: title, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
            topNavView.configureLeftButton(normalTitle: LocalizedString.SelectAll.localized, selectedTitle: LocalizedString.DeselectAll.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
            topNavView.configureFirstRightButton(normalTitle: LocalizedString.Done.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
            topNavView.firstRightButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        } else {
            topNavView.configureNavBar(title: LocalizedString.Travellers.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
            topNavView.configureLeftButton(normalImage:  AppImages.backGreen, selectedImage:  AppImages.backGreen)
            topNavView.configureFirstRightButton(normalImage:  AppImages.greenPopOverButton, selectedImage:  AppImages.greenPopOverButton)
            topNavView.configureSecondRightButton(normalImage:  AppImages.greenAdd, selectedImage:  AppImages.greenAdd)
        }
    }
    
    func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        self.progressView?.isHidden = false
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView?.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer?.invalidate()
            delay(seconds: 0.5) {
                self.timer?.invalidate()
                self.progressView?.isHidden = true
            }
        }
    }
    func stopProgress() {
        printDebug(self.time)
        self.time += 1
        if self.time <= 8  {
            self.time = 9
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    // MARK: - IB Action
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        //AppFlowManager.default.popViewController(animated: true)
    }
    
    func addTravellerTapped() {
        AppFlowManager.default.showEditProfileVC(travelData: nil, usingFor: .addNewTravellerList)
    }
    
    func selectAllTapped() {
        let allTravellers = fetchedResultsController.fetchedObjects ?? []
        if predicateStr.isEmpty {
            selectedTravller.removeAll()
            selectedTravller.append(contentsOf: allTravellers)
        } else {
            for model in allTravellers {
                if !selectedTravller.contains(model) {
                    selectedTravller.append(model)
                }
            }
        }
        
        tableView.reloadData()
        updateNavView()
    }
    
    func deselectAllTapped() {
        let allTravellers = fetchedResultsController.fetchedObjects ?? []
        for model in allTravellers {
            if let index = selectedTravller.firstIndex(where: { ($0.id ?? "") == (model.id ?? "") }) {
                selectedTravller.remove(at: index)
                topNavView.leftButton.isSelected = false
            }
        }
        tableView.reloadData()
        updateNavView()
    }
    
    func doneButtonTapped() {
        shouldHitAPI = true
        setTravellerMode {
            delay(seconds: 0.15) {
                self.tableView.reloadData()
            }
        }
    }
    
    func popOverOptionTapped() {
        printDebug("edit buttn tapped")
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Select.localized, LocalizedString.Preferences.localized, LocalizedString.Import.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            
            guard let sSelf = self else { return }
            if index == 0 {
                printDebug("select traveller")
                sSelf.viewModel.logEventsForFirebase(with: .EnterSelectModeFromMenu)
                sSelf.setSelectMode()
            } else if index == 1 {
                printDebug("preferences traveller")
                sSelf.viewModel.logEventsForFirebase(with: .EnterPreferencesFromMenu)
                AppFlowManager.default.moveToPreferencesVC(sSelf)
            } else if index == 2 {
                printDebug("import traveller")
                sSelf.viewModel.logEventsForFirebase(with: .EnterImportFromMenu)
                self?.shouldHitAPI = false
                AppFlowManager.default.moveToImportContactVC()
            }
        }
    }
    
    func getSelectedPaxIds() -> [String] {
        return selectedTravller.compactMap({ $0.id })
    }
    
    func manageImportContactHeaderView() {
        let height: CGFloat = self.showImportContactView ? (44 + 60) : 44
        self.tableView.sectionHeaderHeight = height
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: height)
        travellerListHeaderView.isImportContactViewVisible = self.showImportContactView
        self.tableView.reloadData()
    }
    
    @IBAction func assignGroupTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            self.viewModel.logEventsForFirebase(with: .SelectTravellersAndAssignGroup)
            AppFlowManager.default.showAssignGroupVC(self, getSelectedPaxIds())
        }
    }
    
    @IBAction func deleteTravellerTapped(_ sender: Any) {
        if selectedTravller.count > 0 {
            let str = selectedTravller.count > 1 ? "Delete \(selectedTravller.count) Contacts" : "Delete this Contact"
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [str], colors: [AppColors.themeRed])
            
            let alertView = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.TheseContactsWillBeDeletedFromTravellersList.localized, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    self.viewModel.logEventsForFirebase(with: .SelectTravellersAndDelete)
                    self.viewModel.paxIds = self.getSelectedPaxIds()
                    self.viewModel.callDeleteTravellerAPI()
                }
            }
            alertView?.view.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Helper methods
    
    func doInitialSetUp() {
        tableView.allowsMultipleSelectionDuringEditing = true
        //        tableView.separatorStyle = .singleLine
        
        travellerListHeaderView = TravellerListHeaderView.instanceFromNib()
        travellerListHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 44)
        travellerListHeaderView.backgroundColor = AppColors.themeBlack26
        travellerListHeaderView.delegate = self
        travellerListHeaderView.bottomView.isHidden = true
        
        if let sections = self.fetchedResultsController.sections {
            travellerListHeaderView.bottomView.isHidden = sections.count == 0 ? false : true
        }
        tableView.tableHeaderView = travellerListHeaderView
        bottomView.isHidden = true
        toggleBottomView(hidden: true)
        bottomBackgroundView.isHidden = true
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
        if let sections =  self.fetchedResultsController.sections {
            travellerListHeaderView.bottomView.isHidden = sections.count == 0 ? false : true
        }
    }
    
    private func toggleBottomView(hidden: Bool) {
        bottomSafeAreaView.isHidden = hidden
        if hidden {
            UIView.animate(withDuration: 0.3) {
                self.bottomViewHeight.constant = 0
            } completion: { (_) in
                
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.bottomViewHeight.constant = 44
            } completion: { (_) in
                
            }
        }
    }
    
    private func getAttributedBoldText(text: String, boldText: String,color: UIColor = AppColors.themeBlack) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: color])
        
        attString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: (text as NSString).range(of: boldText))
        return attString
    }
    
    
    private func getAttributedText(firstName: String, lastName: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "")
        let boldFont = AppFonts.SemiBold.withSize(18.0)//:[NSAttributedString.Key : Any]
        let lightFont = AppFonts.Regular.withSize(18.0)
        let color = AppColors.themeBlack
        
        if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
            if (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF"){
                attString.append(NSAttributedString(string: lastName, attributes: [.font: boldFont, .foregroundColor: color]))
                if !lastName.isEmpty{
                    attString.append(NSAttributedString(string: " \(firstName)", attributes: [.font: lightFont, .foregroundColor: color]))
                }else{
                    attString.append(NSAttributedString(string: "\(firstName)", attributes: [.font: boldFont, .foregroundColor: color]))
                }
            }else{
                attString.append(NSAttributedString(string: lastName, attributes: [.font: lightFont, .foregroundColor: color]))
                let fName = lastName.isEmpty ? "\(firstName)" : " \(firstName)"
                attString.append(NSAttributedString(string: fName, attributes: [.font: boldFont, .foregroundColor: color]))
            }
            
        } else {
            if (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF"){
                if !lastName.isEmpty{
                    attString.append(NSAttributedString(string: "\(firstName) ", attributes: [.font: lightFont, .foregroundColor: color]))
                }else{
                    attString.append(NSAttributedString(string: "\(firstName)", attributes: [.font: boldFont, .foregroundColor: color]))
                }
                attString.append(NSAttributedString(string: "\(lastName)", attributes: [.font: boldFont, .foregroundColor: color]))
            }else{
                attString.append(NSAttributedString(string: firstName, attributes: [.font: boldFont, .foregroundColor: color]))
                let lName = firstName.isEmpty ? "\(lastName)" : " \(lastName)"
                attString.append(NSAttributedString(string: lName, attributes: [.font: lightFont, .foregroundColor: color]))
            }
        }
           
        return attString
    }
    
    // create label Predicate
    
    func labelPredicate() -> NSPredicate? {
        var labelPredicates:[NSPredicate] = []
        if let generalPref = UserInfo.loggedInUser?.generalPref {
            for group in generalPref.labels {
                labelPredicates.append(NSPredicate(format: "label == '\(group)'"))
            }
        }
        
        if !labelPredicates.isEmpty {
            return NSCompoundPredicate(orPredicateWithSubpredicates: labelPredicates)
        }
        //MARK:- Change Asif
        return NSCompoundPredicate(orPredicateWithSubpredicates: labelPredicates)
    }
    
    func charactersPredicate() -> NSPredicate? {
        var labelPredicates:[NSPredicate] = []
        let charactersPriority = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
        let isFirstNamePredicate = UserInfo.loggedInUser?.generalPref?.sortOrder == "LF"
        for group in charactersPriority {
            if isFirstNamePredicate {
                labelPredicates.append(NSPredicate(format: "lastNameFirstChar == '\(group.lowercased())'"))
            } else {
                labelPredicates.append(NSPredicate(format: "firstNameFirstChar == '\(group.lowercased())'"))
            }
        }
        if !labelPredicates.isEmpty {
            return NSCompoundPredicate(orPredicateWithSubpredicates: labelPredicates)
        }
        //MARK:- Change Asif
        return NSCompoundPredicate(orPredicateWithSubpredicates: labelPredicates)
    }
    
    func loadSavedData() {
        let fetchRequest = TravellerData.createFetchRequest()//NSFetchRequest<NSFetchRequestResult>(entityName: "TravellerData")
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            var sortDes = [NSSortDescriptor(key: "labelLocPrio", ascending: true)]
            
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
//                sortDes.append(NSSortDescriptor(key: "firstNameSorting", ascending: false))
                sortDes.append(NSSortDescriptor(key: "lastNameSorting", ascending: true))
                
            } else {
                sortDes.append(NSSortDescriptor(key: "firstNameSorting", ascending: true))
            }
            fetchRequest.sortDescriptors = sortDes
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "labelLocPrio", cacheName: nil)
            
        } else {
            if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastNameSorting", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)),NSSortDescriptor(key: "firstNameSorting", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "lastNameFirstChar", cacheName: nil)
            } else {
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstNameSorting", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)),NSSortDescriptor(key: "lastNameSorting", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: "firstNameFirstChar", cacheName: nil)
            }
            
        }
        fetchedResultsController.delegate = self
        
        if predicateStr.isEmpty {
            if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
                fetchedResultsController.fetchRequest.predicate = labelPredicate()
            } else {
                fetchedResultsController.fetchRequest.predicate = nil//charactersPredicate()
            }
        } else {
            if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false,  labelPredicate() != nil{
                fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [labelPredicate()!,getSearchPredicates()])
            } else {
                fetchedResultsController.fetchRequest.predicate = getSearchPredicates()
            }
        }
        
        do {
            try fetchedResultsController.performFetch()
            tableDataArray.removeAll()
            tableSectionArray.removeAll()
            for section in fetchedResultsController.sections ?? [] {
                if section.numberOfObjects > 0 {
                    tableDataArray.append(section.objects as? [TravellerData] ?? [])
                    tableSectionArray.append(section.name )
                    printDebug("indexTitle: \(section.name)")
                }
            }
            if tableSectionArray.contains("#") {
                if let index = tableSectionArray.firstIndex(of: "#") {
                    let title = tableSectionArray[index]
                    tableSectionArray.remove(at: index)
                    tableSectionArray.append(title)
                    
                    let data = tableDataArray[index]
                    tableDataArray.remove(at: index)
                    tableDataArray.append(data)
                }
            }
            reloadList()
        } catch {
            reloadList()
            printDebug("Fetch failed")
        }
    }
    
    private func getSearchPredicates() -> NSPredicate {
        //        let firstName = NSPredicate(format: "firstName CONTAINS[c] '\(predicateStr)'")
        //        let lastName = NSPredicate(format: "lastName CONTAINS[c] '\(predicateStr)'")
        let lastName = NSPredicate(format: "fullName CONTAINS[c] '\(predicateStr)'")
        
        
        // return NSCompoundPredicate(orPredicateWithSubpredicates: [firstName, lastName])
        return lastName
    }
    
    
    func reloadList() {//self.tableSectionArray
        if self.tableSectionArray.count == 0 && (!predicateStr.isEmpty){
            self.viewModel.logEventsForFirebase(with: .SearchTravellerFindNoResults, value: predicateStr)
        }
        tableView.reloadData()
        var counter = 0
        for result in selectedTravller {
            if let indexPath = self.fetchedResultsController.indexPath(forObject: result) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                counter += 1
            }
        }
        if let array = fetchedResultsController.fetchedObjects, !array.isEmpty {
            topNavView.leftButton.isSelected = array.count == counter
        }
    }
    
    func searchTraveller(forText: String) {
        printDebug("searching text is \(forText)")
        self.viewModel.logEventsForFirebase(with: .SearchTraveller)
        predicateStr = forText
        loadSavedData()
        noResultemptyView.messageLabel.attributedText = self.getAttributedTextForEmptyView(with: forText)//"\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(forText)'"
    }
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 60.0))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    func setTravellerMode(shouldReload: Bool = true, completion: (() -> ())? = nil) {
        tableView.performBatchUpdates {
            self.isSelectMode = false
        } completion: { (_) in
            completion?()
        }
        bottomView.isHidden = true
        toggleBottomView(hidden: true)
        bottomBackgroundView.isHidden = true
        topNavView.leftButton.isSelected = false
        selectedTravller.removeAll()
        updateNavView()
        
    }
    
    func setSelectMode(isNeedToReload:Bool = true) {
        bottomView.isHidden = false
        toggleBottomView(hidden: false)
        bottomBackgroundView.isHidden = false
        isSelectMode = true
        updateNavView()
        if isNeedToReload{
            tableView.reloadData()
        }
    }
    
    func resetAllItem() {
        searchBar.endEditing(true)
        predicateStr = ""
        searchBar.text = ""
        loadSavedData()
    }
    
    func getAttributedTextForEmptyView(with searchText: String)->NSAttributedString?{
        let txt = "\(LocalizedString.noResults.localized + "\n" + LocalizedString.For.localized.capitalized) '\(searchText)'"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        let attTxt = NSMutableAttributedString(string: txt, attributes: [.foregroundColor: AppColors.themeBlack, .font: AppFonts.Regular.withSize(22.0), .paragraphStyle: paragraphStyle])
        let range = NSString(string: txt).range(of: "\(LocalizedString.For.localized.capitalized) '\(searchText)'")
        attTxt.addAttributes([.foregroundColor: AppColors.themeGray60, .font:AppFonts.Regular.withSize(18.0)], range: range)
        return attTxt
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
        if !isSelectMode,AppGlobals.shared.isNetworkRechable() {
            shouldHitAPI = false
            addTravellerTapped()
        }
    }
}

extension TravellerListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //        guard let sections = self.fetchedResultsController.sections else {
        //            fatalError("No sections in fetchedResultsController")
        //        }
        if isSelectMode {
            bottomView.isHidden = self.tableSectionArray.isEmpty
            toggleBottomView(hidden: self.tableSectionArray.isEmpty)
            bottomBackgroundView.isHidden = self.tableSectionArray.isEmpty
        }
        travellerListHeaderView.bottomView.isHidden = !self.tableSectionArray.isEmpty
        tableView.backgroundView?.isHidden = !self.tableSectionArray.isEmpty
        tableView.isScrollEnabled = !self.tableSectionArray.isEmpty
        return self.tableSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard let sections = self.fetchedResultsController.sections else {
        //            fatalError("No sections in fetchedResultsController")
        //        }
        let sectionInfo = tableDataArray[section]
        return sectionInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() // oldCell!
        //cell.selectionStyle = .default
        let section = tableDataArray[indexPath.section]
        let data = section[indexPath.row]
        //let data = fetchedResultsController.object(at: indexPath)
        configureCell(cell: cell, travellerData: data)
        cell.tintColor = AppColors.themeGreen
        
//        let backView = UIView(frame: cell.contentView.bounds)
//        backView.tag = 1
//        backView.backgroundColor = .clear//AppColors.themeWhite
        //cell.selectedBackgroundView = backView
       // cell.backgroundColor = .clear
        
//        if #available(iOS 14.0, *) {
//            if isSelectMode {
//            var bgConfig = UIBackgroundConfiguration.listPlainCell()
//            bgConfig.backgroundColor = UIColor.clear
//            cell.backgroundConfiguration = bgConfig
//            } else {
//                cell.backgroundConfiguration = nil
//            }
//        }
        cell.contentView.backgroundColor = AppColors.themeBlack26
        cell.backgroundColor = AppColors.themeBlack26
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, travellerData: TravellerData?) {
        cell.imageView?.image = travellerData?.salutationImage
        cell.imageView?.image = AppGlobals.shared.getEmojiIcon(dob: travellerData?.dob ?? "", salutation: travellerData?.salutation ?? "", dateFormatter: "yyyy-MM-dd")
        
        
        // Get age str based on date of birth
        let dateStr = AppGlobals.shared.getAgeLastString(dob: travellerData?.dob ?? "", formatter: "yyyy-MM-dd")
        // get attributed date str
        let attributedDateStr = AppGlobals.shared.getAttributedBoldText(text: dateStr, boldText: dateStr,color: AppColors.themeGray40)
        
        let firstName = travellerData?.firstName ?? ""
        let lastName = travellerData?.lastName ?? ""
        //        guard  let firstName = travellerData?.firstName, let lastName = travellerData?.lastName else {
        //            return
        //        }
        
        
        // add a UILabel for Age string
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
//        label.textAlignment = .right
//        label.attributedText = attributedDateStr
//        cell.accessoryView = label
        
//        let lastNameToBold = lastName.isEmpty ? firstName : lastName
        let boldTextAttributed = self.getAttributedText(firstName: firstName, lastName: lastName)
        boldTextAttributed.append(attributedDateStr)
        cell.textLabel?.attributedText = boldTextAttributed
        
//        if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
//            let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastNameToBold)" : "\(firstName)"
//            let  boldTextAttributed = getAttributedBoldText(text: "\(lastName) \(firstName)", boldText: boldText)
//            boldTextAttributed.append(attributedDateStr)
//
//            cell.textLabel?.attributedText = boldTextAttributed
//
//        } else {
//            let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastNameToBold)" : "\(firstName)"
//            let boldTextAttributed = getAttributedBoldText(text: "\(firstName) \(lastName)", boldText: boldText)
//            boldTextAttributed.append(attributedDateStr)
//
//            cell.textLabel?.attributedText = boldTextAttributed
//        }
        if isSelectMode {
            if let trav = travellerData, self.selectedTravller.contains(where: { ($0.id ?? "") == (trav.id ?? "") }) {
                cell.setSelected(true, animated: false)
                
            } else {
                cell.setSelected(false, animated: false)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSelectMode {
            //        let trav = fetchedResultsController.object(at: indexPath)
            let section = tableDataArray[indexPath.section]
            let trav = section[indexPath.row]
            if self.selectedTravller.contains(where: { ($0.id ?? "") == (trav.id ?? "") }) {
                cell.setSelected(true, animated: false)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let str = "Delete this Contact"
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [str], colors: [AppColors.themeRed])
            
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.TheseContactsWillBeDeletedFromTravellersList.localized, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] (_, index) in
                guard let weakSelf = self else {return}
                //                let traveller = weakSelf.fetchedResultsController.object(at: indexPath)
                let section = weakSelf.tableDataArray[indexPath.section]
                let traveller = section[indexPath.row]
                weakSelf.viewModel.logEventsForFirebase(with: .SwipeToDelete)
                weakSelf.viewModel.paxIds.append(traveller.id ?? "")
                weakSelf.selectedTravller.append(traveller)
                weakSelf.viewModel.callDeleteTravellerAPI()
            }
            
            
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            return []
        } else {
            //            guard let sections = self.fetchedResultsController.sections else {
            //                return []
            //            }
            //
            //            let all = ["#","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            return self.tableSectionArray//sections.isEmpty ? [] : all
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderCellIdentifier) as? TravellerListTableViewSectionView else {
            return nil
        }
        //        guard let sections = fetchedResultsController.sections else {
        //            return nil
        //        }
        if UserInfo.loggedInUser?.generalPref?.categorizeByGroup ?? false {
            
            if let prio = self.tableSectionArray[section].toInt, let title = UserInfo.loggedInUser?.generalPref?.labelsWithPriority.someKey(forValue: prio) {
                headerView.configureCell(title)
            }
        } else {
            headerView.configureCell(self.tableSectionArray[section])
        }
        headerView.containerView.backgroundColor = AppColors.themeGray04
        if isSelectMode {
            headerView.headerLabel.textColor = AppColors.baggageTypeTitleColor
        }else{
            headerView.headerLabel.textColor = AppColors.themeBlack
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing && !isSelectMode {
            tableView.setEditing(false, animated: false)
            setSelectMode(isNeedToReload: false)
            return
        }
        dismissKeyboard()
        self.view.endEditing(true)
        let section = tableDataArray[indexPath.section]
        let current = section[indexPath.row]
        if isSelectMode {
            tableView.separatorStyle = .singleLine
            //            let current = fetchedResultsController.object(at: indexPath)
            if !selectedTravller.contains(where: { ($0.id ?? "") == (current.id ?? "") }) {
                selectedTravller.append(current)
                if let sections = self.fetchedResultsController.sections {
                    var totalCount = 0
                    for section in sections {
                        totalCount += section.numberOfObjects
                    }
                    topNavView.leftButton.isSelected = selectedTravller.count == totalCount
                }
            }
            updateNavView()
        } else {
            //tableView.reloadSection(section: indexPath.section, with: .none)
            AppFlowManager.default.moveToViewProfileDetailVC(current.travellerDetailModel, usingFor: .travellerList)
            tableView.deselectRow(at: indexPath, animated: true)
            self.viewModel.logEventsForFirebase(with: .OpenTraveller)
        }
        shouldHitAPI = false
        self.travellerIdToDelete = current.id ?? ""
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if isSelectMode {
            //            let current = fetchedResultsController.object(at: indexPath)
            let section = tableDataArray[indexPath.section]
            let current = section[indexPath.row]
            if let index = selectedTravller.firstIndex(where: { ($0.id ?? "") == (current.id ?? "") }) {
                selectedTravller.remove(at: index)
                topNavView.leftButton.isSelected = false
            }
            
            updateNavView()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //printDebug("content scroll offset \(scrollView.contentOffset.y)")
        headerDividerView.isHidden = scrollView.contentOffset.y >= 44.0
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        if bottomView.isHidden {
            self.setSelectMode(isNeedToReload: false)
        }
        return true
    }
}

// MARK: - TravellerListVMDelegate methods

extension TravellerListVC: TravellerListVMDelegate {
    func willSearchForTraveller(_ isShowLoader: Bool = false) {
        if isShowLoader {
            //AppGlobals.shared.startLoading(loaderBgColor: AppColors.themeWhite)
            startProgress()
        }
        if self.showImportContactView {
        }
    }
    
    func willCallDeleteTravellerAPI() {
        //
    }
    
    func deleteTravellerAPISuccess() {
        bottomView.isHidden = true
        toggleBottomView(hidden: true)
        bottomBackgroundView.isHidden =  true
        isSelectMode = false
        deleteAllSelectedTravllers()
        updateNavView()
    }
    
    private func deleteAllSelectedTravllers() {
        for traveller in selectedTravller {
            if let id = traveller.id, !id.isEmpty {
                CoreDataManager.shared.deleteData("TravellerData", predicate: "id == '\(id)'")
            }
        }
        shouldHitAPI = true
        selectedTravller.removeAll()
        loadSavedData()
    }
    
    func deleteTravellerAPIFailure(errors: ErrorCodes) {
        bottomView.isHidden = true
        toggleBottomView(hidden: true)
        bottomBackgroundView.isHidden =  true
        isSelectMode = false
        reloadList()
        updateNavView()
        selectedTravller.removeAll()
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        shouldHitAPI = true
    }
    
    func searchTravellerFail(errors: ErrorCodes, _ isShowLoader: Bool = false) {
        printDebug(errors)
        //AppGlobals.shared.stopLoading()
        
        if self.showImportContactView {
            self.showImportContactView = false
            manageImportContactHeaderView()
        }
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        if isShowLoader {
            stopProgress()
        }
    }
    
    
    
    func searchTravellerSuccess(_ isShowLoader: Bool = false) {
        //AppGlobals.shared.stopLoading()
        
        if self.showImportContactView {
            self.showImportContactView = false
            manageImportContactHeaderView()
        }
        tableView.delegate = self
        tableView.dataSource = self
        shouldHitAPI = true
        loadSavedData()
        if isShowLoader {
            stopProgress()
        }
    }
}

// MARK: - UISearchBarDelegate methods

extension TravellerListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableView.backgroundView = noTravEmptyView
            predicateStr = ""
            loadSavedData()
        } else {
            tableView.backgroundView = noResultemptyView
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
    
    func checkForAllSelected() {
        guard let array = fetchedResultsController.fetchedObjects, !array.isEmpty else {return}
        var counter = 0
        for object in array {
            if self.selectedTravller.contains(where: { ($0.id ?? "") == (object.id ?? "") }) {
                counter += 1
            }
            for result in selectedTravller {
                if let indexPath = self.fetchedResultsController.indexPath(forObject: result) {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                }
            }
        }
        topNavView.leftButton.isSelected = array.count == counter
        
        
        
        
    }
}

extension TravellerListVC: PreferencesVCDelegate {
    func cancelButtonTapped() {
        shouldHitAPI = false
    }
    
    func preferencesUpdated() {
        shouldHitAPI = false
        resetAllItem()
        setUpTravellerHeader()
    }
}

extension TravellerListVC: AssignGroupVCDelegate {
    func cancelTapped() {
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI(isShowLoader: false)
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
        updateNavView()
    }
    
    func groupAssigned() {
        predicateStr = ""
        shouldHitAPI = false
        viewModel.callSearchTravellerListAPI(isShowLoader: false)
        selectedTravller.removeAll()
        setTravellerMode(shouldReload: false)
        updateNavView()
    }
}

// MARK: - TravellerListHeaderViewDelegate Methods

extension TravellerListVC: TravellerListHeaderViewDelegate {
    func headerViewTapped() {
        self.viewModel.logEventsForFirebase(with: .OpenMainUser)
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

extension TravellerListVC {
    private func addTwoFingerSwipeGesture() {
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(twoFingersSwiped(_:)))
        swipeGest.direction = .right
        swipeGest.numberOfTouchesRequired = 2
        tableView.addGestureRecognizer(swipeGest)
    }
    
    @objc private func twoFingersSwiped(_ recognizer: UISwipeGestureRecognizer) {
        if bottomView.isHidden {
            
            func updateTableView() {
                func updateTouchPoint(_ point: CGPoint) {
                    if let indexPath = tableView.indexPathForRow(at: point) {
                        self.tableView.reloadData()
                        tableView.separatorStyle = .singleLine
                        tableView(tableView, didSelectRowAt: indexPath)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
                let touchPoint1 = recognizer.location(ofTouch: 0, in: tableView)
                let touchPoint2 = recognizer.location(ofTouch: 1, in: tableView)
                updateTouchPoint(touchPoint1)
                updateTouchPoint(touchPoint2)
                
                
            }
            
            tableView.performBatchUpdates {
                self.setSelectMode(isNeedToReload: false)
            } completion: { (_) in
                delay(seconds: 0.15) {
                    updateTableView()
                }
            }
        }
    }
}
