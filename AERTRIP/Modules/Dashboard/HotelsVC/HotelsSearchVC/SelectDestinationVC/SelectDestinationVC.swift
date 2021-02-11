//
//  SelectDestinationVC.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectDestinationVCDelegate: class {
    func didSelectedDestination(hotel: SearchedDestination)
}

class SelectDestinationVC: BaseVC {
    
    enum CurrentlyUsingFor {
        case hotelForm, bulkBooking
    }
    
    var currentlyUsingFor: CurrentlyUsingFor = .hotelForm
    var initialTouchPoint : CGPoint = CGPoint(x: 0.0, y: 0.0)
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainCintainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rectangleView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!
    
    
    
    //MARK:- Properties
    
    
    //MARK:- Public
    private(set) var viewModel = SelectDestinationVM()
    weak var delegate: SelectDestinationVCDelegate?
    
    //MARK:- Private
    private let headerCellId = "TravellerListTableViewSectionView"
    private let myLocationCellId = "DestinationMyLocationTableCell"
    private let searchedCellId = "DestinationSearchedTableCell"
    
    private var isInSearchMode: Bool = false
    private let maxItemInCategory: Int = 4
    
    private lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyboardManagerVisible(false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardManagerVisible(true)
    }
    
    override func setupFonts() {
        cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        
        searchBar.placeholder = LocalizedString.CityAreaOrHotels.localized
    }
    
    override func setupColors() {
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        tableView.contentInset = UIEdgeInsets(top: headerView.height, left: 0.0, bottom: 0.0, right: 0.0)

        registerXib()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        mainContainerView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        if #available(iOS 13.0, *) {} else {
            self.mainContainerView.addGestureRecognizer(swipeGesture)
        }
        
        self.view.alpha = 1.0
        self.view.backgroundColor = AppColors.clear//AppColors.themeBlack.withAlphaComponent(0.3)
        self.bottomViewHeightConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        
        //self.headerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        if #available(iOS 13.0, *) {
            self.rectangleView.cornerradius = 10.0
        } else {
            self.rectangleView.cornerradius = 15.0
        }
        
        self.rectangleView.layer.masksToBounds = true
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
        
        self.viewModel.getAllPopularHotels()
        self.addFooterForBottom()
        self.tableView.backgroundView = self.noResultemptyView
    }
    
    private func registerXib() {
        
        tableView.register(UINib(nibName: headerCellId, bundle: nil), forHeaderFooterViewReuseIdentifier: headerCellId)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //Handle Swipe Gesture
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.tableView.contentOffset.y <= 0
            else {
            reset()
            return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    
    ///Call to use Pan Gesture Final Animation
    private func panGestureFinalAnimation(velocity: CGPoint,touchPoint: CGPoint) {
        //Down Direction
        if velocity.y < 0 {
            if velocity.y < -300 {
                self.openBottomSheet()
            } else {
                if touchPoint.y <= (UIScreen.main.bounds.height - 62.0)/2 {
                    self.openBottomSheet()
                } else {
                    self.closeBottomSheet()
                }
            }
        }
            //Up Direction
        else {
            if velocity.y > 300 {
                self.closeBottomSheet()
            } else {
                if touchPoint.y <= (UIScreen.main.bounds.height - 62.0)/2 {
                    self.openBottomSheet()
                } else {
                    self.closeBottomSheet()
                }
            }
        }
        printDebug(velocity.y)
    }
    
    func openBottomSheet() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func closeBottomSheet() {
        func setValue() {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.height + 100)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
            setValue()
        }
        animater.addCompletion { (position) in
            self.removeFromParentVC
        }
        //animater.startAnimation()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func show(animated: Bool) {
        self.bottomView.isHidden = false
        let toDeduct = (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        var finalValue = (self.currentlyUsingFor == .hotelForm) ? (self.view.height - toDeduct) : (self.view.height - (15.0 + toDeduct))
        if #available(iOS 13.0, *) {
            finalValue = (self.view.height - AppFlowManager.default.safeAreaInsets.bottom)
        }
        
        func setValue() {
            self.mainCintainerBottomConstraint.constant = 0.0
            self.mainContainerViewHeightConstraint.constant = finalValue
            if #available(iOS 13.0, *) {} else {
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            }
            self.view.layoutIfNeeded()
        }
        
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            
            animater.addCompletion { (position) in
                self.reloadData()
            }
            
            animater.startAnimation()
        }
        else {
            setValue()
        }
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        
        func setValue() {
            self.mainCintainerBottomConstraint.constant = -(self.mainContainerView.height + 100)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        
        self.bottomView.isHidden = true
        if animated {
            let animater = UIViewPropertyAnimator(duration: AppConstants.kAnimationDuration, curve: .linear) {
                setValue()
            }
            
            animater.addCompletion { (position) in
                if shouldRemove {
                    self.removeFromParentVC
                }
            }
            //animater.startAnimation()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            setValue()
        }
    }
    
    private func addFooterForBottom(){
        let footerView = UIView()
        footerView.frame.size.height = 35
        footerView.backgroundColor = AppColors.clear
        self.tableView.tableFooterView = footerView
    }
    
    private func reloadData(){
        self.tableView.reloadData()
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}

//MARK:- View Model Delegate
//MARK:-
extension SelectDestinationVC: SelectDestinationVMDelegate {
    
    func getAllPopularHotelsSuccess() {
        self.reloadData()
    }
    
    func getAllPopularHotelsFail() {
        self.reloadData()
    }
    
    func willSearchDestination() {
        self.tableView.backgroundView?.isHidden = true
    }
    
    func searchDestinationSuccess() {
        if isInSearchMode {
            self.tableView.backgroundView?.isHidden = !self.viewModel.allTypes.isEmpty
        }
        else {
            self.noResultemptyView.searchTextLabel.text = ""
            self.tableView.backgroundView?.isHidden = true
        }
        self.reloadData()
    }
    
    func searchDestinationFail() {
        self.reloadData()
    }
    
    func getMyLocationSuccess(selected: SearchedDestination) {
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
        var location = selected
        location.isHotelNearMeSelected = true
        self.delegate?.didSelectedDestination(hotel: location)
    }
    
    func getMyLocationFail() {
        printDebug("Error in searching Location")
    }
    
}

//MARK:- Search bar delegate
//MARK:-
extension SelectDestinationVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //clear all data and reload to initial view
            self.noResultemptyView.searchTextLabel.text = ""
            self.isInSearchMode = false
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            //search text
            self.noResultemptyView.searchTextLabel.isHidden = false
            self.noResultemptyView.searchTextLabel.text = "\( LocalizedString.For.localized) '\(searchText)'"
            self.isInSearchMode = true
            self.viewModel.searchDestination(forText: searchText)
        }
        
        self.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

//MARK:- Table view datasource and delegate methods
//MARK:-
extension SelectDestinationVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isInSearchMode {
            return self.viewModel.allTypes.count
        }
        else {
            tableView.backgroundView?.isHidden = true
            return (self.viewModel.recentSearchLimit > 0) ? 3 : 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInSearchMode {
            let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[section].rawValue] as? [SearchedDestination] ?? []
            return min(hotelsForSection.count, maxItemInCategory)
        }
        else {
            
            return [1, self.viewModel.recentSearchLimit, self.viewModel.popularDestinationLimit][section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isInSearchMode {
            return 28.0
        }
        else {
            switch section {
            case 0:
                //my location
                return CGFloat.leastNonzeroMagnitude
                
            case 1:
                //recent search,
                if (self.viewModel.recentSearchLimit > 0) //let userId = UserInfo.loggedInUser?.userId ,!userId.isEmpty
                {
                    return 28.0
                } else {
                    return CGFloat.leastNonzeroMagnitude
                }
                
            //popular destination
            case 2:
                return 28.0
            default:
                return CGFloat.leastNonzeroMagnitude
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as? TravellerListTableViewSectionView else {
            return UIView()
        }
        
        if isInSearchMode {
            view.headerLabel.font = AppFonts.Regular.withSize(14.0)
            view.headerLabel.textColor = AppColors.themeGray60
            view.configureCell(self.viewModel.allTypes[section].title.uppercased())
        }
        else {
            
            var titleText = ""
            if section == 0 {
                return nil
            }
            else if (section == 1) {
                titleText = LocalizedString.RecentlySearchedDestinations.localized
                if self.viewModel.recentSearchLimit <= 0 {
                    return nil
                }
            }
            else {
                titleText = LocalizedString.PopularDestinations.localized
            }
            
            view.headerLabel.font = AppFonts.Regular.withSize(14.0)
            view.headerLabel.textColor = AppColors.themeGray60
            view.configureCell(titleText.uppercased())
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isInSearchMode {
            return 65.0
        }
        else {
            switch indexPath.section {
            case 0:
                //my location
                return 44.5//50.0
                
            case 1:
                //recent search
                //                if let userId = UserInfo.loggedInUser?.userId , !userId.isEmpty {
                return 65.0
                //                } else {
                //                    return 0
            //                }
            case 2: // popular destination
                return 65.0
                
            default:
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInSearchMode {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: searchedCellId) as? DestinationSearchedTableCell else {
                return UITableViewCell()
            }
            
            let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[indexPath.section].rawValue] as? [SearchedDestination] ?? []
            cell.configureData(data: hotelsForSection[indexPath.row], forText: self.searchBar.text ?? "")
            cell.dividerView.isHidden = (min(hotelsForSection.count, maxItemInCategory) - 1) == indexPath.row
            let section = self.numberOfSections(in: self.tableView)
            let numOfRow = self.tableView(self.tableView, numberOfRowsInSection: indexPath.section)
            if (section - 1) == indexPath.section  && (numOfRow - 1) == indexPath.row {
               cell.dividerView.isHidden = false
            }
            return cell
        }
        else {
            switch indexPath.section {
            case 0:
                //my location
                guard let cell = tableView.dequeueReusableCell(withIdentifier: myLocationCellId) as? DestinationMyLocationTableCell else {
                    return UITableViewCell()
                }
                cell.configure(title: LocalizedString.HotelsNearMe.localized)
                return cell
                
            case 1, 2:
                //recent search, popular destination
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: searchedCellId) as? DestinationSearchedTableCell else {
                    return UITableViewCell()
                }
                cell.dividerView.isHidden = false
                
                if (self.viewModel.recentSearchLimit > 0), indexPath.section == 1 {
                    cell.configureData(data: self.viewModel.recentSearches[indexPath.row], forText: "")
                    cell.dividerView.isHidden = (self.viewModel.recentSearchLimit - 1) == indexPath.row
                }
                else {
                    cell.configureData(data: self.viewModel.popularHotels[indexPath.row], forText: "")
                }
                
                return cell
                
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && !isInSearchMode {
            LocationManager.shared.startUpdatingLocationWithCompletionHandler { [weak self] (location, error) in
                LocationManager.shared.locationUpdate = nil
                self?.viewModel.hotelsNearByMe()
            }
        } else {
            var selected = SearchedDestination(json: [:])
            if isInSearchMode {
                let hotelsForSection = self.viewModel.searchedHotels[self.viewModel.allTypes[indexPath.section].rawValue] as? [SearchedDestination] ?? []
                selected = hotelsForSection[indexPath.row]
            } else {
                if (self.viewModel.recentSearchLimit > 0), indexPath.section == 1 {
                    selected = self.viewModel.recentSearches[indexPath.row]
                }
                else {
                    selected = self.viewModel.popularHotels[indexPath.row]
                }
            }
            self.viewModel.updateRecentSearch(hotel: selected)
            self.view.endEditing(true)
            self.hide(animated: true, shouldRemove: true)
            self.delegate?.didSelectedDestination(hotel: selected)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printDebug("content offset is \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y == -160 {
            dismissKeyboard()
            self.cancelButtonAction(self.cancelButton)
        }
    }
}
