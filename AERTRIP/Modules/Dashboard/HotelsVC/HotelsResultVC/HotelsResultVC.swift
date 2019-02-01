//
//  HotelsResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsResultVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var navContainerView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = HotelsResultVM()
    
    //MARK:- Private
    private var gradient: CAGradientLayer!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.descriptionLabel.font = AppFonts.SemiBold.withSize(13.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = "Mumbai"
        self.descriptionLabel.text = "30 Jun - 1 Jul • 2 Rooms"
        self.searchBar.placeholder = LocalizedString.SearchHotelsOrLandmark.localized
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.mainScrollView.keyboardDismissMode = .onDrag
        self.mainScrollView.delegate = self
        
        self.searchBar.isMicEnabled = true
        self.searchBar.mDelegate = self
        
        self.gradientView.addGredient(colors: [AppColors.themeWhite.withAlphaComponent(0.0), AppColors.themeWhite])
        self.gradientView.backgroundColor = AppColors.clear
        
        self.listCollectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.listCollectionView.dataSource = self
        self.listCollectionView.delegate = self
        self.listCollectionView.isScrollEnabled = false
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
    }
}

//MARK:- Search bar delegate
//MARK:-
extension HotelsResultVC: ATSearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchHotel(forText: searchText)
    }
    
    func searchBarDidTappedMicButton(_ searchBar: ATSearchBar) {
        printDebug("searchBarDidTappedMicButton")
    }
}

//MARK:- Collection view datasource and delegate methods
//MARK:-
extension HotelsResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelData = nil
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

//MARK:- Scrollview delegate
//MARK:-
extension HotelsResultVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            self.listCollectionView.isScrollEnabled = (scrollView.contentOffset.y >= 250.0)
        }
    }
}
