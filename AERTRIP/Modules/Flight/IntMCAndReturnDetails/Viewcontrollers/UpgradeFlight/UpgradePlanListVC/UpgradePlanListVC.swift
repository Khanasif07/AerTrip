//
//  UpgradePlanListVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 26/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import FlexiblePageControl

protocol  UpgradePlanListVCDelegate:NSObject {
    func updateFareBreakupView(fareAmount: String)
}

class UpgradePlanListVC: BaseVC {

    @IBOutlet weak var journeyPageControl: ISPageControl!
    @IBOutlet weak var planCollectionView: UICollectionView!{
        didSet{
            self.planCollectionView.backgroundColor = AppColors.clear
            self.planCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            self.planCollectionView.isPagingEnabled = false
            self.planCollectionView.decelerationRate = UICollectionView.DecelerationRate.fast
        }
    }
    @IBOutlet weak var noDataFoundView: UIView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var viewModel = UpgradePlanVM()
    var isNewSubPoint = false
    var cellScale:CGFloat = 0.92
    var usedIndexFor = 0
    var isLayoutSet = false
    var isDataFetched = false
    weak var delegate: UpgradePlanListVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        planCollectionView.register( UINib(nibName: "PlansCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "plansCell")
//        self.planCollectionView.isPagingEnabled = true
        self.planCollectionView.delegate = self
        self.planCollectionView.dataSource = self
//        self.setupDisplayView()
        self.setupPageController()
        self.setupIndicator()
        self.setNoDataLabel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shouldStartIndicator(isDataFetched: self.isDataFetched)
    }
    
    private func setupIndicator(){
        self.indicator.style = .white
        self.indicator.color = AppColors.themeWhite
        self.indicator.hidesWhenStopped = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.isLayoutSet{
            self.setupCollection()
        }
    }
    
    func setupPageController(){
        self.journeyPageControl.numberOfPages = 0
//        journeyPageControl.hidesForSinglePage = true
        self.journeyPageControl.currentPage = 0
        self.journeyPageControl.inactiveTransparency = 1.0
        self.journeyPageControl.inactiveTintColor = AppColors.themeGray220
        self.journeyPageControl.currentPageTintColor = AppColors.themeWhite
        self.journeyPageControl.radius = 3.5
        self.journeyPageControl.padding = 5.0

    }
    
    func setupCollection() {
        let layout = self.planCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 4.0)
        layout.scrollDirection = .horizontal
        layout.scrollScalePoint = 1.8
        layout.sideItemScale = 1.0
        layout.sideItemAlpha = 1.0
        //layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 201)
        layout.itemSize = CGSize(width: (UIScreen.width * cellScale), height: planCollectionView.height)
        self.isLayoutSet = true
    }
    
    func shouldStartIndicator(isDataFetched: Bool){
        self.isDataFetched = isDataFetched
        guard self.viewModel.ohterFareData.count > usedIndexFor else {return}
        if self.viewModel.ohterFareData[usedIndexFor] == nil{
            self.indicator?.stopAnimating()
            self.noDataFoundView.isHidden = false
            self.planCollectionView.isHidden = true
        }else{
            if isDataFetched{
                self.indicator?.stopAnimating()
            }else{
                self.indicator?.startAnimating()
            }
            self.journeyPageControl?.numberOfPages = (self.viewModel.ohterFareData[usedIndexFor]?.count ?? 0)
            self.journeyPageControl?.isHidden = ((self.viewModel.ohterFareData[usedIndexFor]?.count ?? 0) < 2)
            self.noDataFoundView?.isHidden = true
            self.planCollectionView?.isHidden = false
            self.planCollectionView?.reloadData()
        }
    }
    
    
    private func setNoDataLabel(){
        let attributedString = NSMutableAttributedString(string: "Oops!\nOther Fares not found for this flight", attributes: [
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: UIColor.white])
        
        attributedString.addAttribute(.font, value: AppFonts.Regular.withSize(22.0), range: NSRange(location: 0, length: 5))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        noDataFoundLabel.attributedText = attributedString
    }

    
}

extension UpgradePlanListVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.viewModel.ohterFareData.count > usedIndexFor{
            return self.viewModel.ohterFareData[usedIndexFor]?.count ?? 0
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plansCell", for: indexPath) as! PlansCollectionViewCell
        let upgardeResult = self.viewModel.ohterFareData[usedIndexFor] ?? []
        if upgardeResult.count > 0{
            if !cell.isAnimated {
                UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1.5, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                    
                    self.viewSlideInFromRight(toLeft: cell)
                    
                }, completion: { (done) in
                    cell.isAnimated = true
                })
            }
            
            cell.titleLabel.text = upgardeResult[indexPath.item].cellTitle
            cell.titleLabel.numberOfLines = 2
            
            
            
            let attributedStr = NSMutableAttributedString(string: upgardeResult[indexPath.item].descriptionShown)
            
            var checkMarkImgName = ""
            
            let farepr = upgardeResult[indexPath.row].farepr
            let oldFarepr = viewModel.selectedOhterFareData[usedIndexFor]?.farepr ?? 0
            let priceDifferent = (farepr - oldFarepr)
            cell.selectButtonClick.tag = indexPath.row
            
            if upgardeResult[indexPath.row].isDefault{
                cell.priceLabel.text = ""
                cell.selectButton.backgroundColor = AppColors.themeGreen
                cell.selectButton.setTitleColor(AppColors.themeWhite, for: .normal)
                cell.selectButton.setTitle("Selected", for: .normal)
                cell.newPriceLabel.text = getPrice(price: Double(farepr))
                checkMarkImgName = "Green_Copy.png"
            }else{
                if priceDifferent < 0{
                    cell.newPriceLabel.text = "- "+getPrice(price: Double(priceDifferent)).replacingOccurrences(of: "-", with: "")
                }else{
                    cell.newPriceLabel.text = "+ "+getPrice(price: Double(priceDifferent))
                }
                cell.priceLabel.text = getPrice(price: Double(farepr))
                cell.selectButton.backgroundColor = AppColors.quaternarySystemFillColor
                cell.selectButton.setTitleColor(AppColors.themeGreen, for: .normal)
                cell.selectButton.setTitle("Select", for: .normal)
                checkMarkImgName = "blackCheckmark.png"
            }
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: checkMarkImgName)
            
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            let mutableAttributedString = attributedStr.mutableCopy()
            let mutableString = (mutableAttributedString as AnyObject).mutableString
            
            while mutableString!.contains("•"){
                let rangeOfStringToBeReplaced = mutableString!.range(of: "•")
                (mutableAttributedString as AnyObject).replaceCharacters(in: rangeOfStringToBeReplaced, with: image1String)
            }
            
            while mutableString!.contains("◦") {
                isNewSubPoint = true
                let rangeOfStringToBeReplaced = mutableString!.range(of: "◦")
                (mutableAttributedString as AnyObject).replaceCharacters(in: rangeOfStringToBeReplaced, with: "－")
            }
            
            let updatedStr = NSMutableAttributedString(attributedString: mutableAttributedString as! NSAttributedString)
            
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            if isNewSubPoint{
                style.headIndent = 56
            }else{
                style.headIndent = 25
            }
            style.paragraphSpacingBefore = 12
            
            let range = (upgardeResult[indexPath.item].descriptionShown as NSString).range(of: upgardeResult[indexPath.item].descriptionShown)
            
            updatedStr.addAttribute(NSAttributedString.Key.font, value: AppFonts.Regular.withSize(16.0) , range: range)
            updatedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
            
            let newRange = (upgardeResult[indexPath.item].descriptionShown as NSString).range(of: upgardeResult[indexPath.item].descriptionTitle)
            let newStyle = NSMutableParagraphStyle()
            newStyle.headIndent = 0
            newStyle.paragraphSpacingBefore = 12
            updatedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: newStyle, range: newRange)
            cell.txtView.attributedText = updatedStr
            cell.txtView.layoutIfNeeded()
            cell.handler = {[weak self] in
                self?.updateSelected(at: indexPath)
            }
            
            //For showing upgrade Seat
            if upgardeResult[indexPath.item].flightResult.seats != "" && upgardeResult[indexPath.item].flightResult.fsr == 1{
                cell.fewSeatsLeftView.isHidden = false
                cell.fewSeatsLeftViewHeight.constant = 35
                cell.fewSeatsLeftCountLabel.text = upgardeResult[indexPath.item].flightResult.seats
                if (upgardeResult[indexPath.item].flightResult.seats.toInt ?? 0) > 1{
                    cell.fewSeatsLeftLabel.text = "Seats left at this price. Hurry up!"
                }else{
                    cell.fewSeatsLeftLabel.text = "Seat left at this price. Hurry up!"
                }
                 
            }else{
                cell.fewSeatsLeftView.isHidden = true
                cell.fewSeatsLeftViewHeight.constant = 0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.width * cellScale, height: collectionView.height)
//    }
    
    
    func updateSelected(at indexPath: IndexPath){
        for i in 0..<(self.viewModel.ohterFareData[usedIndexFor]?.count ?? 0){
            self.viewModel.ohterFareData[usedIndexFor]?[i].isDefault = (i == indexPath.item)
        }
        self.viewModel.selectedOhterFareData[usedIndexFor] = self.viewModel.ohterFareData[usedIndexFor]?[indexPath.item]
        let amount = getPrice(price: Double(self.viewModel.updateFareTaxes()))
        if self.viewModel.isInternational, let journey = self.viewModel.ohterFareData[usedIndexFor]?[indexPath.item]{
            self.viewModel.oldIntJourney?[usedIndexFor].farepr = journey.farepr
            self.viewModel.oldIntJourney?[usedIndexFor].fare = journey.fare
        }
        self.delegate?.updateFareBreakupView(fareAmount: amount)
        self.planCollectionView.reloadData()
    }
    
    
    func viewSlideInFromRight(toLeft views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = 0.4
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromRight
        views.layer.add(transition!, forKey: nil)
    }
    
    //MARK:- Scroll View Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == planCollectionView{
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = planCollectionView.indexPathForItem(at: center) {
                self.journeyPageControl.currentPage = ip.row
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if scrollView == planCollectionView{
            if let layout = self.planCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                let cellWidthIncludingSpaces = layout.itemSize.width + layout.minimumLineSpacing
                
                var offset = targetContentOffset.pointee
                let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpaces
                let roundedIndex = round(index)
                
                offset = CGPoint(x: roundedIndex * cellWidthIncludingSpaces - scrollView.contentInset.left, y: scrollView.contentInset.top)
                targetContentOffset.pointee = offset
                
            }
        }
    }
    
    
    //MARK:- Format Price
    func getPrice(price:Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        var result = formatter.string(from: NSNumber(value: price))
        
        if result!.contains(find: ".00"){
            result = result?.replacingOccurrences(of: ".00", with: "", options: .caseInsensitive, range: Range(NSRange(location:result!.count-3,length:3), in: result!) )
        }
        return result!
    }
    
}