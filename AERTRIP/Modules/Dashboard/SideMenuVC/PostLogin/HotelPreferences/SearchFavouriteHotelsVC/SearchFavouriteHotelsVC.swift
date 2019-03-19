//
//  SearchFavouriteHotelsVC.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SearchFavouriteHotelsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var collectionView: ATCollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = SearchFavouriteHotelsVM()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            emptyView.mainImageViewTopConstraint.constant = -keyboardSize.height
        }
    }
    
    override func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            printDebug("notificatin:Keyboard will hide")
            emptyView.mainImageViewTopConstraint.constant =  UIScreen.main.bounds.origin.y
            
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.searchForHotelsToAdd.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Done.rawValue, selectedTitle: LocalizedString.Done.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = LocalizedString.searchHotelName.localized
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView = self.emptyView
        
        //setup indicator view
        indicatorView.color = AppColors.themeGreen
        self.stopLoading()
    }
    
    private func startLoading() {
        // commented because , we need to end keyboard editing
       // self.searchBar.isUserInteractionEnabled = false
        indicatorView.isHidden = false
    }
    
    private func stopLoading() {
        // commented because , we need to end keyboard editing
       // self.searchBar.isUserInteractionEnabled = true
        indicatorView.isHidden = true
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

extension SearchFavouriteHotelsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }

    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchFavouriteHotelsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = !self.viewModel.hotels.isEmpty
        return self.viewModel.hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
            fatalError("HotelCardCollectionViewCell not found")
        }
        
        cell.hotelData = self.viewModel.hotels[indexPath.item]
        cell.containerTopConstraint.constant = (indexPath.item == 0) ? 10.0 : 5.0
        cell.containerBottomConstraint.constant = 5.0

        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (indexPath.item == 0) ? 208.0 : 203.0
        return CGSize(width: UIDevice.screenWidth, height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension SearchFavouriteHotelsVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        //Not Required here
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath,_ scrollView: UIScrollView) {
        return
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        self.viewModel.updateFavourite(forHotel: forHotel)
    }
}

extension SearchFavouriteHotelsVC: SearchFavouriteHotelsVMDelegate {
    func willUpdateFavourite() {
        self.startLoading()
    }
    
    func updateFavouriteSuccess(withMessage: String) {
        self.stopLoading()
     //   AppToast.default.showToastMessage(message: withMessage, vc: self)
        self.collectionView.reloadData()
        self.sendDataChangedNotification(data: self)
    }
    
    func updateFavouriteFail() {
        self.stopLoading()
    }
    
    func willSearchForHotels() {
        self.startLoading()
    }
    
    func searchHotelsSuccess() {
        self.stopLoading()
        self.collectionView.backgroundView = noResultemptyView
        self.collectionView.reloadData()
    }
    
    func searchHotelsFail() {
        self.stopLoading()
    }
}

extension SearchFavouriteHotelsVC: UISearchBarDelegate {
    func search(forText: String) {
        if forText.isEmpty {
            self.viewModel.hotels.removeAll()
            self.collectionView.backgroundView = self.emptyView
            self.collectionView.reloadData()
        } else if forText.count >= AppConstants.kSearchTextLimit {
            noResultemptyView.searchTextLabel.isHidden = false
            noResultemptyView.searchTextLabel.text = "for \(forText.quoted)"
            self.viewModel.searchHotel(forText: forText)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(forText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        self.search(forText: searchText)
    }
}
