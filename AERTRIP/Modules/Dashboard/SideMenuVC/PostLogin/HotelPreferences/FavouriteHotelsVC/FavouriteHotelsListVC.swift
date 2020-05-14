//
//  FavouriteHotelsListVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FavouriteHotelsListVCDelegate: class {
    func removeAllForCurrentPage()
    func updatedFavourite(forCity: CityHotels, forHotelAtIndex: Int)
}
class FavouriteHotelsListVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var collectionView: ATCollectionView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    
    //MARK:- Properties
    //MARK:- Public
    var viewModel = FavouriteHotelsListVM()
    weak var delegate: FavouriteHotelsListVCDelegate?
    
    //MARK:- Private
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .hotelPreferences
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.register(UINib(nibName: "HotelsRemoveAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelsRemoveAllCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView = self.emptyView
        self.collectionView.backgroundView?.isHidden = true
        self.dividerView.isHidden = false
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}


extension FavouriteHotelsListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = !self.viewModel.hotels.isEmpty
        return (section == 0) ? self.viewModel.hotels.count : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelsRemoveAllCollectionViewCell", for: indexPath) as? HotelsRemoveAllCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.titleLabel.text = "Remove all from \(self.viewModel.forCity?.cityName ?? "this city")"
            cell.titleLabel.textColor = AppColors.themeRed
            cell.titleLabel.font = AppFonts.Regular.withSize(18.0)
            cell.contentView.isHidden = indexPath.item == 1
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelData = self.viewModel.hotels[indexPath.item]
            cell.containerTopConstraint.constant = (indexPath.item == 0) ? 16.0 : 5.0
            cell.containerBottomConstraint.constant = (indexPath.item == (self.viewModel.hotels.count - 1)) ? 11.0 : 5.0
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            let height = indexPath.item == 0 ? 70.0 : 35.0
            return CGSize(width: UIDevice.screenWidth, height: CGFloat(height))
        }
        else {
            var height = 203.0
            if (indexPath.item == 0) && (indexPath.item == (self.viewModel.hotels.count - 1)) {
                height = 220
            }
            else if (indexPath.item == 0)  {
                height = 214.0
            } else if (indexPath.item == (self.viewModel.hotels.count - 1)) {
               height = 209.0
            }
            return CGSize(width: UIDevice.screenWidth, height: CGFloat(height))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero//UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 1), (indexPath.item == 0) {
            self.delegate?.removeAllForCurrentPage()
        }
    }
}

extension FavouriteHotelsListVC: HotelCardCollectionViewCellDelegate {
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched) {
        //not needed here
    }
    
    func pagingScrollEnable(_ indexPath: IndexPath,_ scrollView:UIScrollView) {
        return
    }
    
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
        self.viewModel.updateFavourite(forHotel: forHotel)
    }
}

extension FavouriteHotelsListVC: FavouriteHotelsListVMDelegate {
    func willUpdateFavourite() {
        
    }
    
    func updateFavouriteSuccess(atIndex: Int, withMessage: String) {
        if let city = self.viewModel.forCity {
            self.delegate?.updatedFavourite(forCity: city, forHotelAtIndex: atIndex)
        }
        
    }
    
    func updateFavouriteFail() {
        
    }
}
