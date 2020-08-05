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

protocol ImageDeletionDelegate:NSObjectProtocol {
    func shouldRemoveImage(_ image: UIImage?, for urlString:String?)
}


class HotelDetailsImgSlideCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    internal var imageUrls: [String] = []
    var images = [ATGalleryImage]()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            delay(seconds: 0.005) {
                self.imageCollectionView.delegate = self
                self.imageCollectionView.dataSource = self
            }
            
        }
    }
    @IBOutlet weak var pageControl: ISPageControl! {
        didSet {
            self.pageControl.inactiveTransparency = 1.0
            self.pageControl.inactiveTintColor = AppColors.themeGray220
            self.pageControl.currentPageTintColor = AppColors.themeWhite
            self.pageControl.radius = 3.5
            self.pageControl.padding = 5.0
        }
    }
    weak var delegate: HotelDetailsImgSlideCellDelegate?
    weak var imgDelegate: ImageDeletionDelegate?
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUps()
        let nib = UINib(nibName: "HotelDetailsImageCollectionCell", bundle: nil)
        self.imageCollectionView.register(nib, forCellWithReuseIdentifier: "HotelDetailsImageCollectionCell")
    }
    
    //Mark:- Methods
    //==============
    private func initialSetUps() {
        self.pageControl.isHidden = (!(imageUrls.count > 1) ||  !(self.images.count == 0))
        self.pageControl.numberOfPages = (self.images.count == 0) ? imageUrls.count : images.count
    }
    
    internal func configCell(imageUrls: [String]) {
        self.initialSetUps()
        self.pageControl.isHidden = !(imageUrls.count > 1)
        self.pageControl.numberOfPages = imageUrls.count
        self.imageCollectionView.reloadData()
    }

    func configureCell(with images:[ATGalleryImage]){
        self.initialSetUps()
        self.images = images
        self.pageControl.isHidden = !(images.count > 1)
        self.imageCollectionView.reloadData()
    }
    
}

//Mark:- UICollectionView Delegate And Datasource
//===============================================
extension HotelDetailsImgSlideCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.images.count == 0) ? self.imageUrls.count : self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelDetailsImageCollectionCell", for: indexPath) as? HotelDetailsImageCollectionCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self.imgDelegate
        if (self.images.count == 0){
            cell.configCell(imgUrl: imageUrls[indexPath.item], cornerRadius: 0.0)
        }else{
            cell.configureCell(with: images[indexPath.item], cornerRadius: 0.0)
        }
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
        if self.imageUrls.count == 0{
            pageControl.currentPage = (Int(pageNumber) < self.images.count) ? Int(pageNumber) : (self.images.count - 1)
        }else{
            pageControl.currentPage = Int(pageNumber)
        }
        
    }
}
