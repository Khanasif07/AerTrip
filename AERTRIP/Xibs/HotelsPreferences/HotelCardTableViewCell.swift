
//
//  HotelCardTableViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 01/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import FlexiblePageControl
import UIKit

protocol HotelCardTableViewCellDelegate: class {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel)
    func saveButtonActionFromLocalStorage(_ sender: UIButton, forHotel: HotelSearched)
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView)
}

class HotelCardTableViewCell: AppStoreAnimationTableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripLogoImage: UIImageView!
    @IBOutlet weak var greenCircleRatingView: FloatRatingView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingContainerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: HotelCardCollectionViewCellDelegate?
    
    private var gradientLayer: CAGradientLayer!
    //    var scrollSize: CGFloat = 0.0
    //    let numberOfPage: Int = 100
    
    var hotelData: HotelsModel? {
        didSet {
            self.populateData()
        }
    }
    
    var hotelListData: HotelSearched? {
        didSet {
            self.populateHotelData()
            self.setUpInstagramDotGalleryView()
        }
    }
    var isLastCellInSection: Bool = false {
        didSet {
            updateBottomConstraint()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //-------------------------- Golu Change ---------------------
        self.disabledHighlightedAnimation = false
        //-------------------------- End ---------------------
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.gradientView.bounds
        let gradientColor = AppColors.themeBlack
        self.gradientLayer.colors =
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.20).cgColor, gradientColor.withAlphaComponent(0.40).cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        self.gradientView.layer.addSublayer(self.gradientLayer)
        self.gradientView.backgroundColor = AppColors.clear
        
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpOutside)
        self.setupPageControl()
        
        self.bgView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize.zero, opacity: 0.4, shadowRadius: 4.0)
        self.collectionView.cornerRadius = 10.0
        self.gradientView.cornerRadius = 10.0
        self.collectionView.registerCell(nibName: ATGalleryCell.reusableIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.gradientView.bounds
    }
    
    private func setUpInstagramDotGalleryView() {
        guard let thumbnail = hotelListData?.thumbnail else {
            printDebug("thumbnails are  empty")
            return
        }
        
        self.pageControl.numberOfPages = thumbnail.count
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        //        self.scrollView.isUserInteractionEnabled = (thumbnail.count > 1)
        //        self.scrollView.contentSize = CGSize(width: self.scrollSize * CGFloat(thumbnail.count), height: self.hotelImageView.frame.size.height)
        
        printDebug("thumbnail count is \(thumbnail.count)")
        self.pageControl.isHidden = (thumbnail.count <= 1)
        self.collectionView.isScrollEnabled = (thumbnail.count > 1)
        self.collectionView.reloadData()
        //        for index in 0..<thumbnail.count {
        //            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: self.hotelImageView.frame.origin.y, width: hotelImageView.frame.size.width, height: hotelImageView.frame.size.height))
        //            view.contentMode = .scaleAspectFill
        //            view.clipsToBounds = true
        //            view.setImageWithUrl(thumbnail.first ?? "", placeholder: UIImage(named: "hotelCardPlaceHolder") ?? AppPlaceholderImage.frequentFlyer, showIndicator: true)
        //            scrollView.addSubview(view)
        //        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //        self.bgView.cornerRadius = 10.0
    }
    
    private func populateData() {
        self.hotelNameLabel.text = self.hotelData?.name ?? LocalizedString.na.localized
        self.starRatingView.rating = self.hotelData?.stars ?? 0
        self.greenCircleRatingView.rating = self.hotelData?.taRating ?? 0
        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
        //        if let image = UIImage(named: "hotelCardPlaceHolder") {
        //            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: true)
        //        }
    }
    
    
    private func populateHotelData() {
        guard let hotel = self.hotelListData else {
            printDebug("hotel not found")
            return
        }
        
        self.hotelNameLabel.text = hotel.hotelName ?? LocalizedString.na.localized
        
        self.starRatingView.isHidden = true
        self.ratingContainerLeadingConstraint.constant = -10.0
        if hotel.star > 0.0 {
            self.ratingContainerLeadingConstraint.constant = 0.0
            self.starRatingView.isHidden = false
            self.starRatingView.rating = hotel.star
        }
        
        self.greenCircleRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        if hotel.rating > 0.0 {
            self.greenCircleRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.greenCircleRatingView.rating = hotel.rating
        }
        
        self.actualPriceLabel.text = hotel.listPrice == 0 ? "" : "\(String(describing: hotel.listPrice))"
        var price : Double = hotel.price
        if  let filter = UserInfo.hotelFilter, filter.priceType == .PerNight  {
            price = hotel.perNightPrice
        }
        self.discountedPriceLabel.text = price.amountInDelimeterWithSymbol
        self.saveButton.isSelected = hotel.fav == "0" ? false : true
        //        if let image = UIImage(named: "hotelCardPlaceHolder") {
        //            self.hotelImageView.setImageWithUrl(self.hotelListData?.thumbnail?.first ?? "", placeholder: image, showIndicator: true)
        //     }
    }
    
    private func setupPageControl() {
        self.pageControl.pageIndicatorTintColor = AppColors.themeGray220
        self.pageControl.currentPageIndicatorTintColor = AppColors.themeWhite
    }
    
    private func updateBottomConstraint() {
        let valueToSet: CGFloat = isLastCellInSection ? 0 : 16
        if valueToSet != self.containerBottomConstraint.constant {
            self.containerBottomConstraint.constant = valueToSet
            self.contentView.layoutIfNeeded()
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let hotel = self.hotelData {
            self.delegate?.saveButtonAction(sender, forHotel: hotel)
        } else if let hotel = self.hotelListData {
            self.delegate?.saveButtonActionFromLocalStorage(sender, forHotel: hotel)
        }
    }
}

extension HotelCardTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let idxPath = indexPath {
            self.delegate?.pagingScrollEnable(idxPath, scrollView)
        }
    }
}

extension HotelCardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = hotelListData?.thumbnail?.count ?? 1
        return (count > 0) ? count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATGalleryCell.reusableIdentifier, for: indexPath) as? ATGalleryCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor.clear
        cell.imageHeightConstraint.constant = collectionView.height
        cell.indicator.isHidden = true
        if let images = hotelListData?.thumbnail, images.count > indexPath.item {
            //set image from url
            //            cell.imageView.image = #imageLiteral(resourceName: "hotelCardPlaceHolder")
            cell.imageView.setImageWithUrl(images[indexPath.item], placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false)
        }
        else {
            //set thumbnail
            cell.imageView.image = #imageLiteral(resourceName: "hotelCardPlaceHolder")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
