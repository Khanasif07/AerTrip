//
//  ImportContactVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ImportContactVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var selectedContactsContainerView: UIView!
    @IBOutlet weak var selectedContactsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var selectedContactsCollectionView: UICollectionView!
    
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private(set) var viewModel = ImportContactVM()
    private var viewPager:PKViewPagerController!
    private var options:PKViewPagerOptions!
    private var currentIndex: Int = 0
    private let allTabs: [PKViewPagerTab] = [PKViewPagerTab(title: LocalizedString.Contacts.localized, image: nil), PKViewPagerTab(title: LocalizedString.Facebook.localized, image: nil), PKViewPagerTab(title: LocalizedString.Google.localized, image: nil)]
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.importButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .selected)
        
        self.importButton.setTitle(LocalizedString.Import.localized, for: .normal)
        self.importButton.setTitle(LocalizedString.Import.localized, for: .selected)
        
        self.navTitleLabel.text = "Select Contacts"
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        self.importButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.importButton.setTitleColor(AppColors.themeGreen, for: .selected)
        
        self.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.selectedContactsContainerHeightConstraint.constant = 0.0
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        options = PKViewPagerOptions(viewPagerWithFrame: listContainerView.bounds)
        options.tabType = PKViewPagerTabType.basic
        options.tabViewImageSize = CGSize.zero
        options.tabViewTextFont = AppFonts.Regular.withSize(16.0)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.tabViewBackgroundDefaultColor = AppColors.themeWhite
        options.tabViewBackgroundHighlightColor = AppColors.themeWhite
        options.tabViewTextDefaultColor = AppColors.themeBlack
        options.tabViewTextHighlightColor = AppColors.themeBlack
        options.tabIndicatorViewHeight = 2.0
        options.tabIndicatorViewBackgroundColor = AppColors.themeGreen
        
        viewPager = PKViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.listContainerView.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importButtonAction(_ sender: UIButton) {
    }
}

extension ImportContactVC: PKViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return self.allTabs.count
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        let vc = ContactListVC.instantiate(fromAppStoryboard: .TravellerList)
        vc.currentlyUsingFor = ContactListVC.UsingFor(rawValue: position) ?? .contacts
        return vc
    }
    
    func tabsForPages() -> [PKViewPagerTab] {
        return self.allTabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension ImportContactVC: PKViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        self.currentIndex = index
        print("Moved to page \(index)")
    }
}
