//
//  PhotoGalleryVC.swift
//  AERTRIP
//
//  Created by Apple  on 27.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PhotoGalleryVC: BaseVC {

    @IBOutlet weak var galleryCollection: UICollectionView!
    @IBOutlet weak var verticalCollectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalCollectionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint!
    var imageNames = [String]()
    var parentVC = UIViewController()
    var startShowingFrom:Int = 0
    var index: Int = 0
    var isTAAvailable = false
    var hid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCloseButton()
        self.galleryCollection.delegate = self
        self.galleryCollection.dataSource = self
        self.galleryCollection.backgroundColor = .black
    }
    
    override func initialSetup() {
        super.initialSetup()
        self.galleryCollection.register(UINib(nibName: "PhotoGalleryFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PhotoGalleryFooterView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.galleryCollection.delegate = self
    }
    
    @IBAction func tapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCloseButton() {
        self.closeButton.backgroundColor = AppColors.clear
        self.closeButton.tintColor = AppColors.clear
        
        self.closeButton.setImage(ATGalleryViewConfiguration.closeButtonImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.closeButton.setImage(ATGalleryViewConfiguration.closeButtonImage.withRenderingMode(.alwaysOriginal), for: .selected)
        
        if #available(iOS 13.0, *) {
            self.closeButtonTopConstraint.constant = 10
        }
    }
    
}

extension PhotoGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGalleryCell", for: indexPath) as? PhotoGalleryCell else {return UICollectionViewCell()}
        var imgData = ATGalleryImage()
        imgData.imagePath = self.imageNames[indexPath.row]
        cell.cellWidth.constant = UIScreen.main.bounds.width
        cell.configureData(with : imgData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath.item
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .custom
        gallery.transitioningDelegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        present(gallery, animated: true, completion: { () -> Void in
            gallery.currentPage = self.index
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: ATGalleryViewConfiguration.imageViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PhotoGalleryFooterView", for: indexPath) as? PhotoGalleryFooterView, isTAAvailable, self.imageNames.count != 0 else {
                return UICollectionReusableView()
            }
            footer.handeler = {[weak self] in
                guard let self = self else {return}
                if self.hid == TAViewModel.shared.hotelId, let data = TAViewModel.shared.hotelTripAdvisorDetails{
                    let urlString = "https:\(data.seeAllPhotos)"
                    let screenTitle = LocalizedString.Photos.localized
                    AppFlowManager.default.showURLOnATWebView(URL(string: urlString)!, screenTitle: screenTitle)
                }
            }
            return footer
        default: return UICollectionReusableView()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isTAAvailable && self.imageNames.count != 0{
            return CGSize(width: UIScreen.width, height: 97)
        }else{
            return .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
//    private func showMe() {
//            self.parentVC.addChild(self)
//            self.view.frame = self.parentVC.view.bounds
//            self.parentVC.view.addSubview(self.view)
//            self.didMove(toParent: self.parentVC)
//            UIView.animate(withDuration: AppConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: { [weak self] in
//                guard let sSelf = self else {return}
//                sSelf.view.layoutIfNeeded()
//                }, completion: { (isDone) in
//                    self.galleryCollection.scrollToItem(at: IndexPath(item: self.startShowingFrom, section: 0), at: .centeredVertically, animated: true)
//            })
//        }

//    public class func show(onViewController: UIViewController, sourceView: UIView?, startShowingFrom: Int = 0, imageArray:[String]) {
//
//        let gVC = PhotoGalleryVC.instantiate(fromAppStoryboard: .Dashboard)
//        gVC.parentVC = onViewController
//        gVC.imageNames = imageArray
//        gVC.startShowingFrom = startShowingFrom
//        gVC.showMe()
//    }
    
}

// MARK: SwiftPhotoGalleryDataSource Methods
extension PhotoGalleryVC: SwiftPhotoGalleryDataSource {
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> ATGalleryImage? {
        var image = ATGalleryImage()
        image.imagePath = imageNames[forIndex]
        return image
    }
}


// MARK: SwiftPhotoGalleryDelegate Methods
extension PhotoGalleryVC: SwiftPhotoGalleryDelegate {

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        self.index = gallery.currentPage
        UIApplication.shared.statusBarStyle = .default
        dismiss(animated: true, completion: nil)
    }
    
    func galleryDidScrollToIndex(index: Int) {
        self.index = index
        self.galleryCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
    }
}


// MARK: UIViewControllerTransitioningDelegate Methods
extension PhotoGalleryVC: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let cell = self.galleryCollection.cellForItem(at: IndexPath(item: index, section: 0)) else { return nil }
        let currentFrame = self.returnCellFrameWithViewController(cell: cell)
        
        return GalleryPresentingAnimator(pageIndex: index, originFrame: currentFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let returnCellFrame = self.galleryCollection.cellForItem(at: IndexPath(item: index, section: 0)) else { return nil }
        let cardFrame = returnCellFrameWithViewController(cell:returnCellFrame)
        return GalleryImageDismissAnimator(pageIndex: index, finalFrame: cardFrame)
    }
    
    
    func returnCellFrameWithViewController(cell: UICollectionViewCell)-> CGRect{
        let currentCellFrame = cell.layer.presentation()!.frame
        let cardFrame = cell.superview!.convert(currentCellFrame, to: nil)
        return cardFrame
    }
    
}
