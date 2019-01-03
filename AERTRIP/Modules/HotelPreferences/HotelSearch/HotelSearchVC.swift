//
//  HotelSearchVC.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelSearchVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = HotelSearchVM()
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.navTitleLabel.textColor = AppColors.themeBlack
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = LocalizedString.searchForHotelsToAdd.localized
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: .selected)
    }
    
    override func bindViewModel() {
        
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.searchBar.delegate = self
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension HotelSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= AppConstants.kSearchTextLimit {
            self.viewModel.searchHotel(forText: searchText)
        }
    }
}
