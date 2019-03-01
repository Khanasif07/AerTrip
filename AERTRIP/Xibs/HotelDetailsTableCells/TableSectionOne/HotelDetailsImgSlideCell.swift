//
//  HotelFilterImgSlideCell.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
import UIKit
import FlexiblePageControl


class HotelDetailsImgSlideCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    internal var imageUrls: [String] = []
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            self.imageCollectionView.delegate = self
            self.imageCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var pageControl: FlexiblePageControl! {
        didSet {
            self.pageControl.pageIndicatorTintColor = AppColors.themeGray220
            self.pageControl.currentPageIndicatorTintColor = AppColors.themeWhite
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUps()
    }
    
    //Mark:- Methods
    //==============
    private func initialSetUps() {
        let nib = UINib(nibName: "HotelDetailsImageCollectionCell", bundle: nil)
        self.imageCollectionView.register(nib, forCellWithReuseIdentifier: "HotelDetailsImageCollectionCell")
//        self.pageControl.isHidden = !(self.imageUrls.count > 1)
//        self.pageControl.numberOfPages = self.imageUrls.count
//
    }
    
    private func pageControlSetUp(imageUrls: [String]) {
        self.imageUrls = imageUrls
        self.pageControl.pageIndicatorTintColor = AppColors.themeGray220
        self.pageControl.currentPageIndicatorTintColor = AppColors.themeWhite
//        self.pageControl.isHidden = !(self.imageUrls.count > 1)
        self.pageControl.numberOfPages = 10
        self.pageControl.backgroundColor = AppColors.themeRed
        self.imageCollectionView.reloadData()
    }
    
    internal func configCell(hotelData: HotelSearched) {
        if let imageUrls = hotelData.thumbnail {
            self.pageControlSetUp(imageUrls: imageUrls)
        }
    }
    
    internal func configCellForHotelDetail(hotelData: HotelDetails) {
        self.pageControlSetUp(imageUrls: hotelData.photos)
    }
    
    //Mark:- IBOActions
    //=================
    
}

//Mark:- UICollectionView Delegate And Datasource
//===============================================
extension HotelDetailsImgSlideCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelDetailsImageCollectionCell", for: indexPath) as? HotelDetailsImageCollectionCell else {
            return UICollectionViewCell()
        }
        self.pageControl.isHidden = !(self.imageUrls.count > 1)
        self.pageControl.numberOfPages = self.imageUrls.count
        cell.configCell(imgUrl: imageUrls[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
}

extension HotelDetailsImgSlideCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
}
