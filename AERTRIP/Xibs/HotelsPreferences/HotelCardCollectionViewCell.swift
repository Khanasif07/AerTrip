//
//  HotelCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import FlexiblePageControl

protocol HotelCardCollectionViewCellDelegate: class {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel)
    func saveButtonActionFromLocalStorage(_ sender:UIButton,forHotel : HotelSearched)
    func pagingScrollEnable(_ indexPath: IndexPath, _ scrollView: UIScrollView)
}

//Extened class to highlight on tap
class HotelCardCollectionViewCell: AppStoreAnimationCollectionCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripLogoImage: UIImageView!
    @IBOutlet weak var greenCircleRatingView: FloatRatingView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: FlexiblePageControl!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingContainerLeadingConstraint: NSLayoutConstraint!
    
    
    weak var delegate: HotelCardCollectionViewCellDelegate?
    
    private var gradientLayer: CAGradientLayer!
    var scrollSize: CGFloat = 0.0
    let numberOfPage: Int = 100
    
    var shouldShowMultiPhotos: Bool = true {
        didSet {
            self.updateMutiPhotos()
        }
    }
    
    var hotelData: HotelsModel? {
        didSet {
            self.populateData()
        }
    }
    
    var hotelListData: HotelSearched? {
        didSet {
            self.populateHotelData()
            setUpInstagramDotGalleryView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //-------------------------- Golu Change ---------------------
        self.disabledHighlightedAnimation = false
        self.scrollView.isScrollEnabled = false
        //-------------------------- End ---------------------
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        let gradientColor = AppColors.themeBlack
        self.gradientLayer.colors =
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.20).cgColor, gradientColor.withAlphaComponent(0.40).cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = AppColors.clear
        
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        self.setupPageControl()
        self.scrollSize = self.hotelImageView.frame.size.width
        
        self.bgView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize.zero, opacity: 0.4, shadowRadius: 4.0)
        self.hotelImageView.cornerRadius = 10.0
        self.scrollView.cornerRadius = 10.0
        self.gradientView.cornerRadius = 10.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.gradientView.bounds
        self.scrollSize = self.hotelImageView.frame.size.width
        self.scrollView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    private func setUpInstagramDotGalleryView() {
        guard let thumbnail = hotelListData?.thumbnail else {
            printDebug("thumbnails are  empty")
            return
        }
        
        self.pageControl.numberOfPages = thumbnail.count
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = (thumbnail.count < 1)
        self.scrollView.isUserInteractionEnabled = false//(thumbnail.count > 1)
        self.scrollView.contentSize = CGSize(width: self.scrollSize * CGFloat(thumbnail.count), height: self.hotelImageView.frame.size.height)
        
        printDebug("thumbnail count is \(thumbnail.count)")
        self.pageControl.isHidden = (thumbnail.count <= 1)
        for index in 0..<thumbnail.count {
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: self.hotelImageView.frame.origin.y, width: hotelImageView.frame.size.width, height: hotelImageView.frame.size.height))
            view.setImageWithUrl(thumbnail.first ?? "", placeholder: UIImage(named: "hotelCardPlaceHolder") ?? AppPlaceholderImage.frequentFlyer, showIndicator: false)
            view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            scrollView.addSubview(view)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func populateData() {
        self.hotelNameLabel.text = self.hotelData?.name ?? LocalizedString.na.localized
        
        self.starRatingView.isHidden = true
        self.ratingContainerLeadingConstraint.constant = -10.0
        if let hotel = self.hotelData, hotel.stars > 0.0 {
            self.ratingContainerLeadingConstraint.constant = 0.0
            self.starRatingView.isHidden = false
            self.starRatingView.rating = hotel.stars
        }
        
        self.greenCircleRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        //        if let hotel = self.hotelData, hotel.rating > 0.0 {
        //            self.greenCircleRatingView.isHidden = false
        //            self.tripLogoImage.isHidden = false
        //            self.greenCircleRatingView.rating = hotel.rating
        //        }
        if let hotel = self.hotelData, hotel.taRating > 0.0 {
            self.greenCircleRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.greenCircleRatingView.rating = hotel.taRating
        }
        
        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: false)
        }
    }
    
    private func populateHotelData() {
        self.hotelNameLabel.text = self.hotelListData?.hotelName ?? LocalizedString.na.localized
        
        self.starRatingView.isHidden = true
        self.ratingContainerLeadingConstraint.constant = -10.0
        if let hotel = self.hotelListData, hotel.star > 0.0 {
            self.ratingContainerLeadingConstraint.constant = 0.0
            self.starRatingView.isHidden = false
            self.starRatingView.rating = hotel.star
        }
        
        self.greenCircleRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        if let hotel = self.hotelListData, hotel.rating > 0.0 {
            self.greenCircleRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.greenCircleRatingView.rating = hotel.rating
        }
        
        
        self.actualPriceLabel.text = self.hotelListData?.listPrice == 0 ? "" : "\(String(describing: self.hotelListData?.listPrice ?? 0.0))"
        var price : Double = self.hotelListData?.price ?? 0.0
        if  let filter = UserInfo.hotelFilter, filter.priceType == .PerNight  {
            price  = self.hotelListData?.perNightPrice ?? 0.0
        }
        self.discountedPriceLabel.text = price.amountInDelimeterWithSymbol
        self.saveButton.isSelected = self.hotelListData?.fav == "0" ? false : true
    }
    
    private func setupPageControl() {
        self.pageControl.pageIndicatorTintColor = AppColors.themeGray220
        self.pageControl.currentPageIndicatorTintColor = AppColors.themeWhite
    }
    
    private func updateMutiPhotos() {
        self.scrollView.isHidden = !self.shouldShowMultiPhotos
        self.pageControl.isHidden = !self.shouldShowMultiPhotos
    }
    
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let hotel = self.hotelData {
            self.delegate?.saveButtonAction(sender, forHotel: hotel)
        } else if let hotel = self.hotelListData {
            self.delegate?.saveButtonActionFromLocalStorage(sender, forHotel: hotel)
        }
    }
    
    func updateConstraintForHotelResultMap() {
        self.containerTopConstraint.constant = 10
        self.containerBottomConstraint.constant = 8
        self.contentView.layoutIfNeeded()
    }
}

extension HotelCardCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let idxPath = indexPath {
            self.delegate?.pagingScrollEnable(idxPath, scrollView)
        }
    }
}
