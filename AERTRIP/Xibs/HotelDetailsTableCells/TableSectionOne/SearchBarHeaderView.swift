//
//  SearchBarHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UITableViewHeaderFooterView {
    
    //Mark:- Variables
    //===============
    let tagButtons = ["Breakfast","Refundable","Breakfast","Refundable","Breakfast","Refundable","Breakfast","Refundable","Breakfast","Refundable"]
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            self.tagCollectionView.delegate = self
            self.tagCollectionView.dataSource = self
            self.tagCollectionView.backgroundColor = AppColors.screensBackground.color
            self.tagCollectionView.contentInset = UIEdgeInsets(top: 16.0, left: 10.0, bottom: 16.0, right: 16.0)
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchBarHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        //Color
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.searchBarSetUp()
        self.registerXibs()
    }
    
    ///Search Bar SetUp
    private func searchBarSetUp() {
        //UI
        self.searchBar.layer.cornerRadius = 10.0
        self.searchBar.layer.masksToBounds = true
        self.searchBar.backgroundColor = AppColors.themeGray10
        
        if let textField = self.searchBar.value(forKey: "_searchField") as? UITextField {
            //Color
            textField.borderStyle = .none
            textField.backgroundColor = .clear
            //Text
            textField.attributedPlaceholder = self.attributeLabelSetUp()
            //Font
            textField.font = AppFonts.Regular.withSize(18.0)
        }
    }
    
    private func registerXibs() {
        self.tagCollectionView.registerCell(nibName: "HotelTagCollectionCell")
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greyAttributedString = NSAttributedString(string: "  " + LocalizedString.hotelFilterSearchBar.localized, attributes: grayAttribute)
        attributedString.append(greyAttributedString)
        return attributedString
    }
    
}


extension SearchBarHeaderView: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelTagCollectionCell", for: indexPath) as? HotelTagCollectionCell else { return UICollectionViewCell() }
        cell.configureCell(tagTitle: tagButtons[indexPath.item], titleColor: AppColors.themeGreen, tagBtnColor: AppColors.iceGreen)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebug(self.tagButtons[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = tagButtons[indexPath.item].sizeCount(withFont: AppFonts.SemiBold.withSize(16.0), bundingSize: CGSize(width: 10000.0, height: 10000.0))
        return CGSize(width: size.width + 40.0, height: 30.0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}


