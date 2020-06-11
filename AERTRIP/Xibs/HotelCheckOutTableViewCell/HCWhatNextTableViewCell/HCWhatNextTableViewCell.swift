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
    func shareOnLinkdIn()
}

class HCWhatNextTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    var nextPlanString: [String] = []
    internal weak var delegate: HCWhatNextTableViewCellDelegate?
    private let collectionMargin: CGFloat  = 11.0
    private let itemSpacing : CGFloat = 0.0
    private var itemHeight: CGFloat {
        return 154//self.whatNextCollectionView.bounds.height
    }
    private var itemWidth: CGFloat  = 0
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tellYourPlanLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkdInButton: UIButton!
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
            self.pageControl.radius = 3.0
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
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //UI
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.fbButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.fbButtonBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.twitterButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.twitterBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.linkdInButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.linkedinButtonBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        //Image
        self.fbButton.setImage(#imageLiteral(resourceName: "fbIconWhite").withRenderingMode(.alwaysTemplate), for: .normal)
        self.fbButton.tintColor = AppColors.themeWhite
        self.twitterButton.setImage(#imageLiteral(resourceName: "twiterIcon").withRenderingMode(.alwaysTemplate), for: .normal)
        self.twitterButton.tintColor = AppColors.themeWhite
        self.linkdInButton.setImage(#imageLiteral(resourceName: "linkedInIcon"), for: .normal)
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
        self.linkdInButton.backgroundColor = AppColors.linkedinButtonBackgroundColor
        self.whatNextCollectionView.registerCell(nibName: HCWhatNextCollectionViewCell.reusableIdentifier)
        self.flowLayOut()
    }
    
    ///COnfigure Cell
    internal func configCell(whatNextString: [String]) {
        self.nextPlanString = whatNextString
        self.pageControl.numberOfPages = nextPlanString.count
        self.whatNextCollectionView.reloadData()
    }
    
    private func flowLayOut() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  self.whatNextCollectionView.bounds.width - collectionMargin * 2
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
    
    @IBAction func linkedInButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnLinkdIn()
    }
}


extension HCWhatNextTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nextPlanString.count//10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HCWhatNextCollectionViewCell.reusableIdentifier, for: indexPath) as? HCWhatNextCollectionViewCell else { return UICollectionViewCell() }
//        cell.nextPlanLabel.text = self.nextPlanString[indexPath.row]
        return cell
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
