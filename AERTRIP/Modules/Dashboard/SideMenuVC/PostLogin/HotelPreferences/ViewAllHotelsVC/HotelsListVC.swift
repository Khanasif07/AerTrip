//
//  HotelsListVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelsListVCDelegate: class {
    func removeAllForCurrentPage()
}
class HotelsListVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var collectionView: ATCollectionView!
    
    
    //MARK:- Properties
    //MARK:- Public
    var viewModel = HotelsListVM()
    weak var delegate: HotelsListVCDelegate?
    
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
    
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.collectionView.register(UINib(nibName: "HotelCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelCardCollectionViewCell")
        self.collectionView.register(UINib(nibName: "HotelsRemoveAllCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotelsRemoveAllCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundView = self.emptyView
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}


extension HotelsListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = !self.viewModel.hotels.isEmpty
        return self.viewModel.hotels.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item >= self.viewModel.hotels.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelsRemoveAllCollectionViewCell", for: indexPath) as? HotelsRemoveAllCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.titleLabel.text = "Remove all from \(self.viewModel.forCity?.cityName ?? "this city")"
            cell.titleLabel.textColor = AppColors.themeRed
            cell.titleLabel.font = AppFonts.Regular.withSize(18.0)
            cell.contentView.isHidden = indexPath.item >= (self.viewModel.hotels.count+1)
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCardCollectionViewCell", for: indexPath) as? HotelCardCollectionViewCell else {
                fatalError("HotelCardCollectionViewCell not found")
            }
            
            cell.hotelData = self.viewModel.hotels[indexPath.item]
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= self.viewModel.hotels.count {
            let height = indexPath.item >= (self.viewModel.hotels.count+1) ? 65.0 : 55.0
            return CGSize(width: UIDevice.screenWidth - 16, height: CGFloat(height))
        }
        else {
            return CGSize(width: UIDevice.screenWidth - 16, height: 200.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == self.viewModel.hotels.count {
            self.delegate?.removeAllForCurrentPage()
        }
    }
}

extension HotelsListVC: HotelCardCollectionViewCellDelegate {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel) {
//        self.viewModel.updateFavourite(forHotel: forHotel)
    }
}
