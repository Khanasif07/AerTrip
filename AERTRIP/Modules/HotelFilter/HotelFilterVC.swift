//
//  HotelFilterVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelFilteVCDelegate: class {
    func doneButtonTapped()
    func clearAllButtonTapped()
}

class HotelFilterVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var clearAllButton: UIButton!
    @IBOutlet var navigationTitleLabel: UILabel!
    
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet var dataContainerView: UIView!
    @IBOutlet var mainContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var navigationViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private
    
    private var currentIndex: Int = 0 {
        didSet {
            //
        }
    }
    
    fileprivate weak var categoryView: ATCategoryView!
    
    // MARK: - Variables
    
    private let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Range.localized, LocalizedString.Price.localized, LocalizedString.Ratings.localized, LocalizedString.Amenities.localized,LocalizedString.Room.localized]
    private var allTabs: [ATCategoryItem] {
        var temp = [ATCategoryItem]()
        
        for title in self.allTabsStr {
            var obj = ATCategoryItem()
            obj.title = title
            temp.append(obj)
        }
        
        return temp
    }
    
    private var allChildVCs: [UIViewController] = [UIViewController]()
    weak var delegate : HotelFilteVCDelegate?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetups()
        self.setupGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.categoryView?.frame = self.dataContainerView.bounds
        self.categoryView?.layoutIfNeeded()
    }
    
    // MARK: - Overrider methods
    
    override func setupTexts() {
        let navigationTitleText = HotelFilterVM.shared.totalHotelCount > 0 ? " \(HotelFilterVM.shared.filterHotelCount) of \(HotelFilterVM.shared.totalHotelCount) Results" : ""
        self.clearAllButton.setTitle(LocalizedString.ClearAll.localized, for: .normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        self.navigationTitleLabel.text = navigationTitleText
    }
    
    override func setupFonts() {
        self.clearAllButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.navigationTitleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.clearAllButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.navigationTitleLabel.textColor = AppColors.themeGray40
    }
    
    // MARK: - Helper methods
    
   private func initialSetups() {
        self.mainContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 4)
        for i in 0..<self.allTabsStr.count {
            if i == 1 {
                let vc = RangeVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 2 {
                let vc = PriceVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 3 {
                let vc = RatingVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 4 {
                let vc = AmenitiesVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else if i == 5 {
                let vc = RoomVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            } else {
                let vc = SortVC.instantiate(fromAppStoryboard: .Filter)
                self.allChildVCs.append(vc)
            }
        }
        
        let height = UIApplication.shared.statusBarFrame.height
        self.navigationViewTopConstraint.constant = CGFloat(height)
        self.setupPagerView()
        self.hide(animated: false)
        delay(seconds: 0.01) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerViewTopConstraint.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    private func setupPagerView() {
        var style = ATCategoryNavBarStyle()
        style.height = 50.0
        style.interItemSpace = 15.0
        style.itemPadding = 8.0
        style.isScrollable = true
        style.layoutAlignment = .left
        style.isEmbeddedToView = true
        style.showBottomSeparator = true
        style.bottomSeparatorColor = AppColors.themeGray40
        style.defaultFont = AppFonts.Regular.withSize(16.0)
        style.selectedFont = AppFonts.SemiBold.withSize(16.0)
        style.indicatorColor = AppColors.themeGreen
        style.normalColor = AppColors.textFieldTextColor51
        style.selectedColor = AppColors.textFieldTextColor51
        
        let categoryView = ATCategoryView(frame: self.dataContainerView.bounds, categories: self.allTabs, childVCs: self.allChildVCs, parentVC: self, barStyle: style)
        categoryView.interControllerSpacing = 0.0
        categoryView.navBar.internalDelegate = self
        self.dataContainerView.addSubview(categoryView)
        self.categoryView = categoryView
    }
    
    private func setupGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(outsideAreaTapped))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - IB Action
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
        delegate?.clearAllButtonTapped()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
        delegate?.doneButtonTapped()
    }
    
    @objc func  outsideAreaTapped() {
        self.hide(animated: true, shouldRemove: true)
    }
    
    
    
}

// MARK: - ATCategoryNavBarDelegate

extension HotelFilterVC: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.currentIndex = toIndex
    }
}

// MARK: - UIGestureRecognizerDelegate Method

extension HotelFilterVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
