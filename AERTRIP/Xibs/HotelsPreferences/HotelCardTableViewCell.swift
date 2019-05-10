
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

class HotelCardTableViewCell: UITableViewCell {
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
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingContainerLeadingConstraint: NSLayoutConstraint!
    
    weak var delegate: HotelCardCollectionViewCellDelegate?
    
    private var gradientLayer: CAGradientLayer!
    var scrollSize: CGFloat = 0.0
    let numberOfPage: Int = 100
    
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
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.gradientView.bounds
        let gradientColor = AppColors.themeBlack
        self.gradientLayer.colors =
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.3).cgColor, gradientColor.withAlphaComponent(0.4).cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        self.gradientView.layer.addSublayer(self.gradientLayer)
        self.gradientView.backgroundColor = AppColors.clear
        
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpOutside)
        self.setupPageControl()
        self.scrollSize = self.hotelImageView.frame.size.width
        
        self.bgView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.8), offset: CGSize.zero, opacity: 0.7, shadowRadius: 2.0)
        self.hotelImageView.cornerRadius = 10.0
        self.scrollView.cornerRadius = 10.0
        self.gradientView.cornerRadius = 10.0
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
        
//        self.bgView.cornerRadius = 10.0
    }
    
    private func populateData() {
        self.hotelNameLabel.text = self.hotelData?.name ?? LocalizedString.na.localized
        self.starRatingView.rating = self.hotelData?.stars ?? 0
        self.greenCircleRatingView.rating = self.hotelData?.taRating ?? 0
        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: true)
        }
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
