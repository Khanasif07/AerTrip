//
//  ContactListVC.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ContactListVC: BaseVC {
    
    enum UsingFor: Int {
        case contacts = 0
        case facebook = 1
        case google = 2
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    
    
    //MARK:- Properties
    //MARK:- Public
    var currentlyUsingFor = UsingFor.contacts
    
    //MARK:- Private
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()

        if self.currentlyUsingFor == .contacts {
            newEmptyView.vType = .importPhoneContacts
        }
        else if self.currentlyUsingFor == .facebook {
            newEmptyView.vType = .importFacebookContacts
        }
        else if self.currentlyUsingFor == .google {
            newEmptyView.vType = .importGoogleContacts
        }
        
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupColors() {
        self.selectAllButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.selectAllButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    override func setupTexts() {
        self.selectAllButton.setTitle(LocalizedString.SelectAll.localized, for: .normal)
        self.selectAllButton.setTitle(LocalizedString.SelectAll.localized, for: .selected)
    }
    
    override func setupFonts() {
        self.selectAllButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.tableView.backgroundView = self.emptyView
        self.selectAllButton.isHidden = true
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func selectAllButtonAction(_ sender: UIButton) {
    }
}
