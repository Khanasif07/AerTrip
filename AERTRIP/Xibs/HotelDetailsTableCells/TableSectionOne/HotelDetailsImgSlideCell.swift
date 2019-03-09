//
//  HotelFilterImgSlideCell.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
import UIKit
import FlexiblePageControl

protocol HotelDetailsImgSlideCellDelegate: class {
    func hotelImageTapAction(at index: Int)
    func willShowImage(at index: Int, image: UIImage?)
}


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
    @IBOutlet weak var pageControl: ISPageControl! {
        didSet {
            self.pageControl.tintColor = AppColors.themeGray220
            self.pageControl.currentPageTintColor = AppColors.themeWhite
            self.pageControl.radius = 3.0
        }
    }
    weak var delegate: HotelDetailsImgSlideCellDelegate?
    
    
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
        self.pageControl.isHidden = !(imageUrls.count > 1)
        self.pageControl.numberOfPages = imageUrls.count
    }
    
    internal func configCell(imageUrls: [String]) {
        self.pageControl.isHidden = !(imageUrls.count > 1)
        self.pageControl.numberOfPages = imageUrls.count
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
        cell.configCell(imgUrl: imageUrls[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.hotelImageTapAction(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let myCell = cell as? HotelDetailsImageCollectionCell {
            self.delegate?.willShowImage(at: indexPath.item, image: myCell.hotelImageView.image)
        }
    }
}

extension HotelDetailsImgSlideCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
