//
//  HotelFilterImgSlideCell.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var pageControl: UIPageControl!
    
    
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
        self.pageControl.isHidden = !(self.imageUrls.count > 1)
        self.pageControl.numberOfPages = self.imageUrls.count
    }
    
    internal func configCell(hotelData: HotelSearched) {
        if let safeHotelData = hotelData.thumbnail {
            self.imageUrls = safeHotelData
            self.pageControl.isHidden = !(self.imageUrls.count > 1)
            self.pageControl.numberOfPages = self.imageUrls.count
            self.imageCollectionView.reloadData()
        }
    }
    
    internal func configCellForHotelDetail(hotelData: HotelDetails) {
        self.imageUrls = hotelData.photos
        self.pageControl.isHidden = !(self.imageUrls.count > 1)
        self.pageControl.numberOfPages = self.imageUrls.count
        self.imageCollectionView.reloadData()
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
    
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
}
