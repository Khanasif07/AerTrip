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

class HotelCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bgView: UIView!
    @IBOutlet var hotelImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var discountedPriceLabel: UILabel!
    @IBOutlet var actualPriceLabel: UILabel!
    @IBOutlet var starRatingView: FloatRatingView!
    @IBOutlet var tripLogoImage: UIImageView!
    @IBOutlet var greenCircleRatingView: FloatRatingView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: FlexiblePageControl!
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

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors =
            [AppColors.clear.cgColor, AppColors.themeBlack.withAlphaComponent(0.7).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = AppColors.clear
        
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        self.setupPageControl()
        self.scrollSize = self.hotelImageView.frame.size.width
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
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = (thumbnail.count < 1)
        self.scrollView.isUserInteractionEnabled = (thumbnail.count > 1)
        self.scrollView.contentSize = CGSize(width: self.scrollSize * CGFloat(thumbnail.count), height: self.hotelImageView.frame.size.height)
        
        printDebug("thumbnail count is \(thumbnail.count)")
        self.pageControl.isHidden = (thumbnail.count <= 1)
        for index in 0..<thumbnail.count {
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: self.hotelImageView.frame.origin.y, width: hotelImageView.frame.size.width, height: hotelImageView.frame.size.height))
            view.setImageWithUrl(thumbnail.first ?? "", placeholder: UIImage(named: "hotelCardPlaceHolder") ?? AppPlaceholderImage.frequentFlyer, showIndicator: true)
            scrollView.addSubview(view)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.bgView.cornerRadius = 10.0
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
        if let hotel = self.hotelData, hotel.rating > 0.0 {
            self.greenCircleRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.greenCircleRatingView.rating = hotel.rating
        }

        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: true)
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
        self.discountedPriceLabel.text = "\(String(describing: self.hotelListData?.price ?? 0.0))"
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
}

extension HotelCardCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let idxPath = indexPath {
            self.delegate?.pagingScrollEnable(idxPath, scrollView)
        }
    }
}
