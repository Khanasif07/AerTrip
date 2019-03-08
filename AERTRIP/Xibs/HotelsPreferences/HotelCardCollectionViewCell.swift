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
        self.starRatingView.rating = self.hotelListData?.star ?? 0.0
        self.greenCircleRatingView.rating = self.hotelListData?.rating ?? 0.0
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
