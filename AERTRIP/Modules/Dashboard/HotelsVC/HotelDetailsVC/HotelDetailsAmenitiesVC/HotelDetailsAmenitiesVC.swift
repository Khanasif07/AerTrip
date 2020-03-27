//
//  HotelDetailsAmenitiesVC.swift
//  AERTRIP
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsAmenitiesVC: BaseVC {
    // Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsAmenitiesVM()
    private let maxHeaderHeight: CGFloat = 58.0
    var initialTouchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerBottomConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var amenitiesLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var amenitiesTblView: UITableView! {
        didSet {
            self.amenitiesTblView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.amenitiesTblView.delegate = self
            self.amenitiesTblView.dataSource = self
            self.amenitiesTblView.estimatedRowHeight = UITableView.automaticDimension
            self.amenitiesTblView.rowHeight = UITableView.automaticDimension
            self.amenitiesTblView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.amenitiesTblView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    // Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue() 
    }
    
    override func setupColors() {
        self.amenitiesLabel.textColor = AppColors.themeBlack
        self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.amenitiesLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.amenitiesLabel.text = LocalizedString.Amenities.localized
        self.stickyTitleLabel.text = LocalizedString.Amenities.localized
    }
    
    override func initialSetup() {
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        mainContainerView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
        
        self.dividerView.isHidden = true
        self.registerNibs()
        self.viewModel.getAmenitiesSections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    // Mark:- Functions
    //================
    private func registerNibs() {
        self.amenitiesTblView.registerCell(nibName: AmenitiesDetailsTableViewCell.reusableIdentifier)
        self.amenitiesTblView.registerCell(nibName: AmenitiesNameTableViewCell.reusableIdentifier)
        self.amenitiesTblView.register(AmenitiesDescriptionHeaderView.self, forHeaderFooterViewReuseIdentifier: "AmenitiesDescriptionHeaderView")
    }
    
    private func heightForHeader(_ tableView: UITableView, section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        } else {
            return 49.0
        }
    }
    
    private func imageByAmenitiesName(imageName: String) -> UIImage {
        if let confirmedImage = UIImage(named: imageName) {
            return confirmedImage
        } else {
            return #imageLiteral(resourceName: "buildingImage")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Mark:- UITableView Delegate And DataSource
//==========================================

extension HotelDetailsAmenitiesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.viewModel.sections.isEmpty {
            return self.viewModel.sections.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.viewModel.sections.isEmpty ? 0 : self.viewModel.rowsData[section - 1].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = self.getAmenitiesDetailsTableViewCell(tableView, indexPath: indexPath) {
                return cell
            }
        } else {
            if let cell = self.getAmenitiesDetailsRows(tableView, indexPath: indexPath, amenitiesName: self.viewModel.rowsData[indexPath.section - 1]) {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        else {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AmenitiesDescriptionHeaderView") as? AmenitiesDescriptionHeaderView else { return UIView() }
            let image = self.imageByAmenitiesName(imageName: self.viewModel.sections[section - 1])
            headerView.configureView(title: self.viewModel.sections[section - 1], image: image)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeader(tableView, section: section)
    }
}

extension HotelDetailsAmenitiesVC {
    internal func getAmenitiesDetailsTableViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesDetailsTableViewCell", for: indexPath) as? AmenitiesDetailsTableViewCell else { return UITableViewCell() }
        if let safeAmenitiesData = self.viewModel.amenities {
            cell.amenitiesDetails = safeAmenitiesData
        }
        cell.amenitiesCollectionView.reloadData()
        return cell
    }
    
    internal func getAmenitiesDetailsRows(_ tableView: UITableView, indexPath: IndexPath, amenitiesName: [String]) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmenitiesNameTableViewCell.reusableIdentifier, for: indexPath) as? AmenitiesNameTableViewCell else {
            return UITableViewCell()
        }
        cell.facilitiesNameLabel.text = amenitiesName[indexPath.row]
        return cell
    }
}

extension HotelDetailsAmenitiesVC {
    func manageHeaderView(_ scrollView: UIScrollView) {
        let yOffset = (scrollView.contentOffset.y > self.headerContainerView.height) ? self.headerContainerView.height : scrollView.contentOffset.y
        printDebug(yOffset)
        
        self.dividerView.isHidden = yOffset < (self.headerContainerView.height - 5.0)
        
        // header container view height
        let heightToDecrease: CGFloat = 8.0
        let height = self.maxHeaderHeight - (yOffset * (heightToDecrease / self.headerContainerView.height))
        self.containerViewHeigthConstraint.constant = height
        
        // sticky label alpha
        let alpha = (yOffset * (1.0 / self.headerContainerView.height))
        self.stickyTitleLabel.alpha = alpha
        
        // reviews label
        self.amenitiesLabel.alpha = 1.0 - alpha
        self.amenitiesLabelTopConstraints.constant = 23.0 - (yOffset * (23.0 / self.headerContainerView.height))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.manageHeaderView(scrollView)
        printDebug("scrollViewDidScroll")
    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        self.manageHeaderView(scrollView)
    //        printDebug("scrollViewDidEndDecelerating")
    //    }
    //
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        self.manageHeaderView(scrollView)
    //        printDebug("scrollViewDidEndDragging")
    //    }
    //
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        self.manageHeaderView(scrollView)
    //        printDebug("scrollViewDidEndScrollingAnimation")
    //    }
}

extension HotelDetailsAmenitiesVC {
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        guard let direction = sender.direction, direction.isVertical, self.amenitiesTblView.contentOffset.y <= 0
            else {
                initialTouchPoint = CGPoint.zero
                return
        }
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 300 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            initialTouchPoint = CGPoint.zero
            break
        }
    }
    
    
    func setValue() {
        let toDeduct = (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        let finalValue =  (self.view.height - toDeduct)
        self.mainContainerBottomConst.constant = 0.0
        self.mainContainerHeightConst.constant = finalValue
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(1.0)
        self.view.layoutIfNeeded()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
