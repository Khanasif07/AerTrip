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
    @IBOutlet weak var firstShadowCard: UIView!
    @IBOutlet weak var secondShadowCard: UIView!
    @IBOutlet weak var ratingContainerLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var thirdHotelImageview: UIImageView!
    @IBOutlet weak var secondHotelImageView: UIImageView!
    @IBOutlet weak var secondViewBottomConstataints: NSLayoutConstraint!
    
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
    var hotelList: [HotelSearched]? {
        didSet {
            self.setupOtherHotelImages()
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
            [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(0.20).cgColor, gradientColor.withAlphaComponent(0.40).cgColor]
        self.gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = AppColors.clear
        
        saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        self.setupPageControl()
        self.scrollSize = self.hotelImageView.frame.size.width
        
//        self.bgView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.bgView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        
//        self.firstShadowCard.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)

        self.firstShadowCard.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        
//        self.secondShadowCard.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        
        self.secondShadowCard.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)

        self.hotelImageView.cornerradius = 10.0
        self.scrollView.cornerradius = 10.0
        self.gradientView.cornerradius = 10.0
        self.secondHotelImageView.cornerradius = 10.0
        self.thirdHotelImageview.cornerradius = 10.0

        self.hotelImageView.contentMode = .scaleAspectFill
        self.secondHotelImageView.contentMode = .scaleAspectFill
        self.thirdHotelImageview.contentMode = .scaleAspectFill

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.gradientView.bounds
    }
    
    private func setupShadowCards() {
        self.firstShadowCard.backgroundColor = AppColors.themeGray40
//        self.firstShadowCard.layer.cornerRadius = 10.0
//        self.firstShadowCard.layer.masksToBounds = true
        
        self.secondShadowCard.backgroundColor = AppColors.themeGray40
//        self.secondShadowCard.layer.cornerRadius = 10.0
//        self.secondShadowCard.layer.masksToBounds = true
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
            view.contentMode = .scaleAspectFill
            //view.setImageWithUrl(thumbnail.first ?? "", placeholder: UIImage(named: "hotelCardPlaceHolder") ?? AppPlaceholderImage.frequentFlyer, showIndicator: true)
            view.setImageWithUrl(imageUrl: self.hotelListData?.thumbnail?.first ?? "", placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false) { [unowned self] (image, error) in
                if let downloadedImage = image {
                    view.image = downloadedImage
                } else {
                     view.image = #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder")
                }
            }
            
            // view.image = UIImage(named: "CheckedGreenRadioButton")
            scrollView.addSubview(view)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    private func populateData() {
        self.hotelNameLabel.text = self.hotelData?.name ?? LocalizedString.na.localized
        self.starRatingView.rating = self.hotelData?.stars ?? 0
        self.greenCircleRatingView.rating = self.hotelData?.taRating ?? 0
        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
//        if let image = UIImage(named: "hotelCardPlaceHolder") {
//            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: true)
//        }
        self.hotelImageView.cancelImageDownloading()
        self.hotelImageView.setImageWithUrl(imageUrl: self.hotelData?.photo ?? "", placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false) { [weak self] (image, error) in
            if let downloadedImage = image {
                self?.hotelImageView.image = downloadedImage
            } else {
                 self?.hotelImageView.image = #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder")
            }
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
        
//        self.actualPriceLabel.text = self.hotelListData?.listPrice == 0 ? "" : "\(String(describing: self.hotelListData?.listPrice ?? 0.0))"
        
        var listPrice = self.hotelListData?.perNightListPrice
        var price : Double? = self.hotelListData?.perNightPrice
        
        
        if  let filter = UserInfo.hotelFilter, filter.priceType == .Total  {
            price = self.hotelListData?.listPrice == 0 ? self.hotelListData?.price : self.hotelListData?.listPrice
            listPrice = self.hotelListData?.price
        }

        if listPrice == 0{
            self.actualPriceLabel.text = ""
            self.actualPriceLabel.attributedText = nil
        }else{
            let attributeString: NSMutableAttributedString =   (listPrice ?? 0.0).getConvertedAmount(using: AppFonts.Regular.withSize(16))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            self.actualPriceLabel.attributedText = attributeString
            self.actualPriceLabel.AttributedFontForText(text: (price ?? 0.0).getPreferredCurrency, textFont: AppFonts.Regular.withSize(12))
            actualPriceLabel.isHidden = price == listPrice
        }
        self.discountedPriceLabel.attributedText = (price ?? 0.0).getConvertedAmount(using: AppFonts.SemiBold.withSize(22))
        self.discountedPriceLabel.AttributedFontForText(text: (price ?? 0.0).getPreferredCurrency, textFont: AppFonts.SemiBold.withSize(16))
        
        self.saveButton.isSelected = self.hotelListData?.fav == "0" ? false : true
        
        self.hotelImageView.cancelImageDownloading()
        self.hotelImageView.setImageWithUrl(imageUrl: self.hotelListData?.thumbnail?.first ?? "", placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false) { [weak self] (image, error) in
            if let downloadedImage = image {
                self?.hotelImageView.image = downloadedImage
            } else {
                 self?.hotelImageView.image = #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder")
            }
        }
    }
    
    private func setupOtherHotelImages() {
        self.secondHotelImageView.cancelImageDownloading()
        self.thirdHotelImageview.cancelImageDownloading()
        self.secondHotelImageView.image = nil
        self.thirdHotelImageview.image = nil
        
        if self.hotelList?.indices.contains(1) ?? false, let hotel =  self.hotelList?[1] {
            self.secondHotelImageView.setImageWithUrl(imageUrl: hotel.thumbnail?.first ?? "", placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false) { [weak self] (image, error) in
            if let downloadedImage = image {
                self?.secondHotelImageView.image = downloadedImage
            } else {
                 self?.secondHotelImageView.image = #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder")
            }
        }
        }
        if self.hotelList?.indices.contains(2) ?? false, let hotel =  self.hotelList?[2] {
            self.thirdHotelImageview.setImageWithUrl(imageUrl: hotel.thumbnail?.first ?? "", placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: false) { [weak self] (image, error) in
            if let downloadedImage = image {
                self?.thirdHotelImageview.image = downloadedImage
            } else {
                 self?.thirdHotelImageview.image = #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder")
            }
        }
        }
    }
    
    private func setupPageControl() {
        self.pageControl.pageIndicatorTintColor = AppColors.themeGray220
        self.pageControl.currentPageIndicatorTintColor = AppColors.themeWhite
    }
    
    private func updateMutiPhotos() {
        self.scrollView.isHidden = self.shouldShowMultiPhotos
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
