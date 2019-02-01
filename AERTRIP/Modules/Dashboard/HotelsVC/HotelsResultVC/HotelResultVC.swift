//
//  ResultVC.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import MXParallaxHeader

class HotelResultVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
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
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.setupParallaxHeader()
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(200.0)
        
        let parallexHeaderMinHeight = CGFloat(0.0)
        
        let header = HotelsResultHeaderView.instanceFromNib()
        
        self.collectionView.parallaxHeader.view = header
        self.collectionView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.collectionView.parallaxHeader.height = parallexHeaderHeight
        self.collectionView.parallaxHeader.mode = MXParallaxHeaderMode.center
        self.collectionView.parallaxHeader.delegate = self
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        AppFlowManager.default.showFilterVC()
    }
}

//MARK:- Collection view datasource and delegate methods
//MARK:-
extension HotelResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

//MARK:- MXParallaxHeaderDelegate methods
extension HotelResultVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        printDebug("progress \(parallaxHeader.progress)")
    }
}
