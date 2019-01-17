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
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    private lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    var isFirstTime:Bool = true

    
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
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.searchHotelName.localized
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView = self.emptyView
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension HotelSearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = !self.viewModel.hotels.isEmpty
        return self.viewModel.hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        cell.hotelData = self.viewModel.hotels[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: UIDevice.screenHeight * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

extension HotelSearchVC: HotelCardCollectionViewCellDelegate {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        self.viewModel.updateFavourite(forHotel: forHotel)
    }
}

extension HotelSearchVC: HotelSearchVMDelegate {
    func willUpdateFavourite() {
        AppNetworking.showLoader()
    }
    
    func updateFavouriteSuccess(withMessage: String) {
        AppNetworking.hideLoader()
        AppToast.default.showToastMessage(message: withMessage, vc: self)
        self.collectionView.reloadData()
        self.sendDataChangedNotification(data: self)
    }
    
    func updateFavouriteFail() {
        AppNetworking.hideLoader()
    }
    
    func willSearchForHotels() {
        AppNetworking.showLoader()
    }
    
    func searchHotelsSuccess() {
        AppNetworking.hideLoader()
        self.collectionView.backgroundView = noResultemptyView
        self.collectionView.reloadData()
    }
    
    func searchHotelsFail() {
        AppNetworking.hideLoader()
    }
}

extension HotelSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel.hotels.removeAll()
            self.collectionView.reloadData()
        } else if searchText.count >= AppConstants.kSearchTextLimit {
            self.viewModel.searchHotel(forText: searchText)
        }
    }
}
