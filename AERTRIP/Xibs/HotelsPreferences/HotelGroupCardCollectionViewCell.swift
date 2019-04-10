//
//  HotelCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import FlexiblePageControl

class HotelGroupCardCollectionViewCell: UICollectionViewCell {
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
    @IBOutlet weak var firstShadowCard: UIView!
    @IBOutlet weak var secondShadowCard: UIView!
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
        self.setupShadowCards()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        let gradientColor = AppColors.themeBlack
        self.gradientLayer.colors =
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.3).cgColor, gradientColor.withAlphaComponent(0.4).cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
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
    
    private func setupShadowCards() {
        self.firstShadowCard.backgroundColor = AppColors.themeGray40
        self.firstShadowCard.layer.cornerRadius = 10.0
        self.firstShadowCard.layer.masksToBounds = true
        
        self.secondShadowCard.backgroundColor = AppColors.themeDarkGreen
        self.secondShadowCard.layer.cornerRadius = 10.0
        self.secondShadowCard.layer.masksToBounds = true
    }
    
    private func setUpInstagramDotGalleryView() {
        guard let thumbnail = hotelListData?.thumbnail else {
            printDebug("thumbnails are  empty")
            return
        }
        
        self.hotelImageView.setImageWithUrl(thumbnail.first ?? "", placeholder: AppPlaceholderImage.hotelCard, showIndicator: true)
        
        self.pageControl.numberOfPages = 5
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.contentSize = CGSize(width: self.scrollSize * CGFloat(5), height: self.hotelImageView.frame.size.height)
      
        printDebug("thumbnail count is \(thumbnail.count)")
        
        for index in 0..<5 {
            let view = UIImageView(frame: CGRect(x: CGFloat(index) * scrollSize, y: self.hotelImageView.frame.origin.y, width: hotelImageView.frame.size.width, height: hotelImageView.frame.size.height))
            view.setImageWithUrl(thumbnail.first ?? "", placeholder: UIImage(named: "hotelCardPlaceHolder") ?? AppPlaceholderImage.frequentFlyer, showIndicator: true)
            // view.image = UIImage(named: "tickIcon")
            scrollView.addSubview(view)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.bgView.cornerRadius = 10.0
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
        self.hotelNameLabel.text = self.hotelListData?.hotelName ?? LocalizedString.na.localized
        
        self.starRatingView.isHidden = true
        self.ratingContainerLeadingConstraint.constant = -10.0
        if let star = self.hotelListData?.star, star > 0.0 {
            self.ratingContainerLeadingConstraint.constant = 0.0
            self.starRatingView.isHidden = false
            self.starRatingView.rating = star
        }
        
        self.greenCircleRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        if let rating = self.hotelListData?.rating, rating > 0.0 {
            self.greenCircleRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.greenCircleRatingView.rating = rating
        }
        
        self.actualPriceLabel.text = self.hotelListData?.listPrice == 0 ? "" : "\(String(describing: self.hotelListData?.listPrice ?? 0.0))"
        var price : String = "\(self.hotelListData?.price.delimiter ?? "")"
        if  let filter = UserInfo.hotelFilter  {
            switch filter.priceType {
            case .Total :
                price = "\(self.hotelListData?.price.delimiter ?? "")"
            case .PerNight:
                price  = "\(self.hotelListData?.perNightPrice.delimiter ?? "")"
            }
        }
        self.discountedPriceLabel.text = AppConstants.kRuppeeSymbol + price
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

extension HotelGroupCardCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let idxPath = indexPath {
            self.delegate?.pagingScrollEnable(idxPath, scrollView)
        }
    }
}
