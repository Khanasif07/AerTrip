//
//  ATGalleryViewController.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATGalleryViewController: UIViewController {
    
    enum ViewMode {
        case horizontal
        case vertical
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var verticalCollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var modeChangeButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var verticalCollectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalCollectionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: ISPageControl! {
        didSet {
            self.pageControl.tintColor = AppColors.themeGray220
            self.pageControl.currentPageTintColor = AppColors.themeWhite
            self.pageControl.radius = 3.0
        }
    }
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint! //default 20.0
    @IBOutlet weak var modeChangeButtonTraillingConstraint: NSLayoutConstraint! //default 30.0
    @IBOutlet weak var pageControllerBottomConstraint: NSLayoutConstraint! //default 20.0
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var parentVC: UIViewController!
    private var sourceView: UIView!
    private let scrollCellIdentifier = "ATGalleryScrollCell"
    private let cellIdentifier = "ATGalleryCell"
    private var originalImageFrame = CGRect.zero
    weak var datasource: ATGalleryViewDatasource?
    weak var delegate: ATGalleryViewDelegate?
    var startShowingFrom: Int = 0
    
    private var numberOfImages: Int = 0
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.frame = self.parentVC?.view.bounds ?? UIScreen.main.bounds
    }

    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        //setup close button
        self.setupCloseButton()
        
        self.setupChangeModeButton()
        
        //setup collection view
        self.setupCollectionView()
        
        self.setupPageDots()
        
        self.addTapGesture()
    }
    
    private func addTapGesture() {
        self.horizontalCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHandeler(_:))))
        self.verticalCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHandeler(_:))))
    }
    
    @objc private func tapHandeler(_ sender: UIGestureRecognizer) {
        self.toggleControls(animated: true)
    }
    
    private func setupChangeModeButton() {
        self.modeChangeButton.backgroundColor = AppColors.clear
        self.modeChangeButton.tintColor = AppColors.clear
        
        self.modeChangeButton.setImage(ATGalleryViewConfiguration.changeModeNormalImage, for: .normal)
        self.modeChangeButton.setImage(ATGalleryViewConfiguration.changeModeSelectedImage, for: .selected)
    }
    
    private func setupCloseButton() {
        self.closeButton.backgroundColor = AppColors.clear
        self.closeButton.tintColor = AppColors.clear
        
        self.closeButton.setImage(ATGalleryViewConfiguration.closeButtonImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.closeButton.setImage(ATGalleryViewConfiguration.closeButtonImage.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private func setupCollectionView() {
        
        self.horizontalCollectionView.register(UINib(nibName: scrollCellIdentifier, bundle: nil), forCellWithReuseIdentifier: scrollCellIdentifier)
        
        self.verticalCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        //set datasource and delegate
        self.horizontalCollectionView.dataSource = self
        self.horizontalCollectionView.delegate = self
        
        self.verticalCollectionView.dataSource = self
        self.verticalCollectionView.delegate = self
        
        self.horizontalCollectionView.isPagingEnabled = true
        self.verticalCollectionView.isPagingEnabled = false
        
        self.verticalCollectionTopConstraint.constant = ((UIDevice.screenHeight - ATGalleryViewConfiguration.imageViewHeight)/2.0)
        self.verticalCollectionBottomConstraint.constant = -((UIDevice.screenHeight - ATGalleryViewConfiguration.imageViewHeight)/2.0)
        
        self.changeViewMode()
    }
    
    private func showMe() {
        self.parentVC.addChild(self)
        self.view.frame = self.parentVC.view.bounds
        self.parentVC.view.addSubview(self.view)
        self.didMove(toParent: self.parentVC)
        
        UIApplication.shared.isStatusBarHidden = ATGalleryViewConfiguration.isStatusBarHidden
        
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = true
        self.mainImageView.frame = self.parentVC.view.convert(self.sourceView.frame, from: self.sourceView.superview)
        self.mainImageView.contentMode = ATGalleryViewConfiguration.imageContentMode
        self.mainImageView.clipsToBounds = true

        
        //showing animation
        self.originalImageFrame = self.parentVC.view.convert(self.sourceView.frame, from: self.sourceView.superview)
        var newFrame = CGRect(x: 0.0, y: (UIDevice.screenHeight - ATGalleryViewConfiguration.imageViewHeight)/2.0, width: UIDevice.screenWidth, height: ATGalleryViewConfiguration.imageViewHeight)
        if ATGalleryViewConfiguration.viewMode == .vertical {
            newFrame = self.originalImageFrame
        }
        
        self.mainImageView.image = ATGalleryViewConfiguration.placeholderImage
        if let simg = self.sourceView as? UIImageView {
            self.mainImageView.image = simg.image
        }
        
        self.scrollCollectionView(toIndex: self.startShowingFrom)
        
        self.pageControl.isHidden = ATGalleryViewConfiguration.viewMode == .vertical
        self.modeChangeButton.isHidden = true
        self.closeButton.isHidden = true
        
        self.horizontalCollectionView.alpha = 0.0
        self.verticalCollectionView.alpha = 0.0
        self.mainImageView.alpha = 1.0
        self.horizontalCollectionView.isHidden = !(ATGalleryViewConfiguration.viewMode == .horizontal)
        self.verticalCollectionView.isHidden = (ATGalleryViewConfiguration.viewMode == .horizontal)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.mainImageView.frame = newFrame
            sSelf.mainImageView.alpha = 0.0
            sSelf.horizontalCollectionView.alpha = 1.0
            sSelf.verticalCollectionView.alpha = 1.0
            
            sSelf.view.layoutIfNeeded()
            }, completion: { (isDone) in
                self.pageControl.isHidden = ATGalleryViewConfiguration.viewMode == .vertical
                self.modeChangeButton.isHidden = false
                self.closeButton.isHidden = false
                self.mainImageView.isHidden = true
        })
    }
    
    private func scrollCollectionView(toIndex: Int) {
        if toIndex != 0, toIndex < numberOfImages {
            self.horizontalCollectionView.scrollToItem(at: IndexPath(item: toIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            self.verticalCollectionView.scrollToItem(at: IndexPath(item: toIndex, section: 0), at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
        }
    }
    
    private func hideMe() {
        
        //closing animation
        let newFrame = self.originalImageFrame
        
        self.mainImageView.isHidden = false
        self.mainImageView.alpha = 1.0
        self.horizontalCollectionView.isHidden = !(ATGalleryViewConfiguration.viewMode == .horizontal)
        self.verticalCollectionView.isHidden = (ATGalleryViewConfiguration.viewMode == .horizontal)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.mainImageView.frame = newFrame
            sSelf.horizontalCollectionView.alpha = 0.0
            sSelf.verticalCollectionView.alpha = 0.0
            
            sSelf.view.layoutIfNeeded()
            }, completion: { (isDone) in
                UIApplication.shared.isStatusBarHidden = false
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    private func changeViewMode() {
        
        self.pageControl.isHidden = ATGalleryViewConfiguration.viewMode == .vertical

        if ATGalleryViewConfiguration.viewMode == .vertical {
            //show vertical collection
            self.verticalCollectionView.reloadData()
            
            self.horizontalCollectionView.isHidden = false
            self.horizontalCollectionView.alpha = 1.0
            self.verticalCollectionView.isHidden = false
            self.verticalCollectionView.alpha = 0.0
            self.mainImageView.isHidden = false
            self.mainImageView.alpha = 1.0
            let newFrame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: ATGalleryViewConfiguration.imageViewHeight)
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
                guard let sSelf = self else {return}
                sSelf.mainImageView.frame = newFrame
                sSelf.mainImageView.alpha = 0.0
                sSelf.horizontalCollectionView.alpha = 0.0
                sSelf.verticalCollectionView.alpha = 1.0
                sSelf.verticalCollectionTopConstraint.constant = 0
                sSelf.verticalCollectionBottomConstraint.constant = 0
                
                sSelf.view.layoutIfNeeded()
                }, completion: { (isDone) in
                    self.mainImageView.isHidden = true
                    self.horizontalCollectionView.isHidden = true
                    self.verticalCollectionView.isHidden = false
            })
        }
        else {
            //show horizontal collection
            self.horizontalCollectionView.reloadData()
            
            self.horizontalCollectionView.isHidden = false
            self.horizontalCollectionView.alpha = 0.0
            self.verticalCollectionView.isHidden = false
            self.verticalCollectionView.alpha = 1.0
            self.mainImageView.isHidden = false
            self.mainImageView.alpha = 1.0
            
            let newFrame = CGRect(x: 0.0, y: (UIDevice.screenHeight - ATGalleryViewConfiguration.imageViewHeight)/2.0, width: UIDevice.screenWidth, height: ATGalleryViewConfiguration.imageViewHeight)
            
            UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
                guard let sSelf = self else {return}
                sSelf.mainImageView.frame = newFrame
                sSelf.mainImageView.alpha = 0.0
                sSelf.horizontalCollectionView.alpha = 1.0
                sSelf.verticalCollectionView.alpha = 0.0
                sSelf.verticalCollectionTopConstraint.constant = newFrame.origin.y
                sSelf.verticalCollectionBottomConstraint.constant = -(newFrame.origin.y)
                
                sSelf.view.layoutIfNeeded()
                }, completion: { (isDone) in
                    
                    self.mainImageView.isHidden = true
                    self.horizontalCollectionView.isHidden = false
                    self.verticalCollectionView.isHidden = true
            })
        }
        
        self.modeChangeButton.isSelected = ATGalleryViewConfiguration.viewMode != .vertical
    }
    
    private func setupPageDots(){
        DispatchQueue.mainAsync { [weak self] in
            
            guard let sSelf = self else {return}
            
            sSelf.pageControl.backgroundColor = AppColors.clear
            sSelf.pageControl.isHidden = ATGalleryViewConfiguration.viewMode == .vertical
            sSelf.pageControl.numberOfPages = sSelf.numberOfImages
        }
    }
    
    private func toggleControls(animated: Bool) {
        if self.closeButtonTopConstraint.constant < 0 {
            //show
            self.hideControls(isHidden: false, animated: animated)
        }
        else {
            //hide
            self.hideControls(isHidden: true, animated: animated)
        }
    }
    
    private func hideControls(isHidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            
            guard let sSelf = self else {return}
            
            sSelf.closeButtonTopConstraint.constant = isHidden ? -70.0 : 20.0
            sSelf.pageControllerBottomConstraint.constant = isHidden ? -70.0 : 20.0
            sSelf.modeChangeButtonTraillingConstraint.constant = isHidden ? -70.0 : 15.0
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { (isDone) in
        })
    }
    
    //MARK:- Public
    public class func show(onViewController: UIViewController, sourceView: UIView?, startShowingFrom: Int = 0, datasource: ATGalleryViewDatasource, delegate: ATGalleryViewDelegate) {
        
        ATGalleryViewConfiguration.viewMode = .vertical
        let gVC = ATGalleryViewController.instantiate(fromAppStoryboard: .Dashboard)
        gVC.parentVC = onViewController
        gVC.sourceView = sourceView ?? onViewController.view
        
        gVC.startShowingFrom = startShowingFrom
        
        gVC.datasource = datasource
        gVC.delegate = delegate
        
        gVC.showMe()
    }
    
    //MARK:- Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.hideMe()
    }
    @IBAction func modeChangeButtonAction(_ sender: UIButton) {
        ATGalleryViewConfiguration.viewMode = sender.isSelected ? .vertical : .horizontal
        self.changeViewMode()
    }
}

//MARK:- Collection View Datasource methods
//MARK:-
extension ATGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfImages = self.datasource?.numberOfImages(in: self) ?? 0
        self.setupPageDots()
        return self.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === horizontalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scrollCellIdentifier, for: indexPath) as? ATGalleryScrollCell else {
                return UICollectionViewCell()
            }
            
            cell.imageData = self.datasource?.galleryView(galleryView: self, galleryImageAt: indexPath.item)
            cell.makeImageInCenter()
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ATGalleryCell else {
                return UICollectionViewCell()
            }
            
            cell.imageData = self.datasource?.galleryView(galleryView: self, galleryImageAt: indexPath.item)
            cell.imageHeightConstraint.constant = ATGalleryViewConfiguration.imageViewHeight
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView === self.verticalCollectionView ? CGSize(width: collectionView.frame.width, height: ATGalleryViewConfiguration.imageViewHeight) : collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView === self.verticalCollectionView ? 10.0 : 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return collectionView === self.verticalCollectionView ? UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0) : UIEdgeInsets.zero
    }
}


//MARK:- Collection View Delegate methods
//MARK:-
extension ATGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let myCell = cell as? ATGalleryScrollCell, let img = myCell.imageData {
            self.delegate?.galleryView(galleryView: self, willShow: img, for: indexPath.item)
        }
    }
}

extension ATGalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === horizontalCollectionView {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
}
