//
//  HCWhatNextTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCWhatNextTableViewCellDelegate: class {
    func shareOnFaceBook()
    func shareOnTwitter()
    func shareOnInstagram()
}

class HCWhatNextTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    var nextPlanString: [String] = []
    private(set) var whatNextdata: [WhatNext] = []
    internal weak var delegate: HCWhatNextTableViewCellDelegate?
    private let collectionMargin: CGFloat  = 11.0
    private let itemSpacing : CGFloat = 0.0
    private var itemHeight: CGFloat {
        return 172//self.whatNextCollectionView.bounds.height
    }
    private var itemWidth: CGFloat  = 0
    
    var suggetionImage = #imageLiteral(resourceName: "flightIcon")//hotel_green_icon
    var selectedWhatNext: ((_ index:Int)->())?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tellYourPlanLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: ATButton!
    @IBOutlet weak var whatNext: UILabel!
    @IBOutlet weak var whatNextCollectionView: UICollectionView! {
        didSet {
            self.whatNextCollectionView.delegate = self
            self.whatNextCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var pageControl: ISPageControl! {
        didSet {
            self.pageControl.tintColor = AppColors.themeGray220
            self.pageControl.currentPageTintColor = AppColors.themeGreen
            self.pageControl.radius = 3.5
            self.pageControl.padding = 5.0
        }
    }
    @IBOutlet weak var whatNextStackView: UIStackView!

    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //UI
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.fbButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.fbButtonBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.twitterButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.twitterBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.instagramButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: UIColor(red: 251/255, green: 57/255, blue: 88/255, alpha: 1.0).withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        //Image
        self.fbButton.setImage(#imageLiteral(resourceName: "fbIconWhite").withRenderingMode(.alwaysTemplate), for: .normal)
        self.fbButton.tintColor = AppColors.themeWhite
        self.twitterButton.setImage(#imageLiteral(resourceName: "twiterIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        self.twitterButton.tintColor = AppColors.themeWhite
        self.instagramButton.setImage(#imageLiteral(resourceName: "socialInstagram"), for: .normal)
//        self.instagramButton.tintColor = AppColors.themeWhite

        //Font
        self.tellYourPlanLabel.font = AppFonts.Regular.withSize(16.0)
        self.whatNext.font = AppFonts.SemiBold.withSize(28.0)
        //Text
        self.tellYourPlanLabel.text = LocalizedString.TellYourFriendsAboutYourPlan.localized
        self.whatNext.text = LocalizedString.WhatNext.localized
        //Color
        self.tellYourPlanLabel.textColor = AppColors.themeGray40
        self.whatNext.textColor = AppColors.themeGray40
        self.fbButton.backgroundColor = AppColors.fbButtonBackgroundColor
        self.twitterButton.backgroundColor = AppColors.twitterBackgroundColor
//        self.instagramButton.backgroundColor = AppColors.clear
        self.whatNextCollectionView.registerCell(nibName: HCWhatNextCollectionViewCell.reusableIdentifier)
        self.flowLayOut()
        
        self.contentView.layoutIfNeeded()
    }

    ///COnfigure Cell
    internal func configCell(whatNextString: [String]) {
        self.nextPlanString = whatNextString
        self.pageControl.numberOfPages = nextPlanString.count
        self.whatNextCollectionView.reloadData()
    }
    
    internal func configCellwith(_ whtnxt: [WhatNext], usedFor:String, isNeedToAdd:Bool) {
        self.whatNextdata = whtnxt
        if isNeedToAdd{
            var wtNext = WhatNext(isFor: "Booking")
            wtNext.product = "Booking"
            wtNext.settingFor = usedFor
            self.whatNextdata.insert(wtNext, at: whatNextdata.count)
        }
        self.pageControl.numberOfPages = self.whatNextdata.count
        self.whatNextCollectionView.reloadData()
    }
    
    private func flowLayOut() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  UIScreen.width - collectionMargin * 2//self.whatNextCollectionView.bounds.width - collectionMargin * 2
        layout.sectionInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0.0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0.0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        self.whatNextCollectionView.collectionViewLayout = layout
        self.whatNextCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    //Mark:- IBActions
    //================
    @IBAction func fbButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnFaceBook()
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnTwitter()
    }
    
    @IBAction func instagramButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnInstagram()
    }
}


extension HCWhatNextTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.whatNextdata.count//10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCWhatNextCollectionViewCell.reusableIdentifier, for: indexPath) as? HCWhatNextCollectionViewCell else { return UICollectionViewCell() }
        cell.nextPlanLabel.text = self.whatNextdata[indexPath.item].whatNextStringValue//hotelsCopy2
        switch self.whatNextdata[indexPath.item].productType {
        case .hotel: cell.flightImageView.image = #imageLiteral(resourceName: "hotel_green_icon")
        case .flight: cell.flightImageView.image = #imageLiteral(resourceName: "flight_blue_icon")
        default: cell.flightImageView.image = #imageLiteral(resourceName: "hotelsCopy2")
        }
        
        cell.flightImageView.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedWhatNext?(indexPath.item)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //collectionView.frame.width - 12.0
//        let size = CGSize(width: 363.0, height: collectionView.frame.height)
//        return size
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }

}

extension HCWhatNextTableViewCell: UIScrollViewDelegate {
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.whatNextCollectionView.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
