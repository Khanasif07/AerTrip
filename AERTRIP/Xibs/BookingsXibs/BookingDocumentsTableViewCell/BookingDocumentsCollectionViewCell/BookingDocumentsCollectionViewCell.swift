//
//  BookingDocumentsCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingDocumentsCollectionViewCellDelegate: class {
    func cancelButtonAction(forIndex indexPath: IndexPath)
    func longPressButtonAction(forIndex indexPath: IndexPath)
}

class BookingDocumentsCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variables
    //MARK:===========
    
    weak var delegate: BookingDocumentsCollectionViewCellDelegate?
    private var topConstraintForDownloading: CGFloat {
        return 16.0
    }
    private var normalTopConstraint: CGFloat {
        return 10.0
    }
    private var widthConstraintForDownloading: CGFloat {
        return 66.0
    }
    private var normalWidthConstraint: CGFloat {
        return 73.0
    }
    private var heightConstraintForDownloading: CGFloat {
        return 82.0
    }
    private var normalHeightConstraint: CGFloat {
        return 91.0
    }
    private var normalBottomConstraint: CGFloat {
        return 6.0
    }
    private var bottomConstraintForDownloading: CGFloat {
        return 9.0
    }
    var longPressGesture:UILongPressGestureRecognizer?
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentsSizeLabel: UILabel!
    @IBOutlet weak var documentsImageView: UIImageView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var cancelDownloadBtn: UIButton!
    @IBOutlet weak var imageContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadingIcon: UIImageView!
    @IBOutlet weak var dowloadingPlaceHolderImgView: UIImageView!
    @IBOutlet weak var imageContainerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        self.nameLabel.font = AppFonts.Regular.withSize(16.0)
        self.nameLabel.textColor = AppColors.themeBlack
        self.documentsSizeLabel.font = AppFonts.Regular.withSize(14.0)
        self.documentsSizeLabel.textColor = AppColors.themeGray40
        self.documentsImageView.image = AppImages.pdf
        self.imageContainerViewTopConstraint.constant = self.normalTopConstraint
        self.imageContainerViewWidthConstraint.constant = self.normalWidthConstraint
        self.imageContainerViewHeightConstraint.constant = self.normalHeightConstraint
        self.imageContainerViewBottomConstraint.constant = self.normalBottomConstraint
        self.dowloadingPlaceHolderImgView.image = nil
        self.loaderSetUp()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
        longPressGesture?.minimumPressDuration = 0.5 // 1 second press
        //longPressGesture?.delaysTouchesEnded = true
    }
    
    internal func configCell(name: String , documentsSize: String , request: DocumentDownloadingModel, type:String = "") {
        if type.isEmpty{
            self.nameLabel.text = name
        }else{
            self.nameLabel.text = "\(name).\(type)"
        }
        
        self.documentsSizeLabel.text = documentsSize
        var previousProgress: Float = 0.0
        request.progressUpdate = { [weak self] progress in
            guard let sSelf = self else { return }
            sSelf.progressView.setProgressWithAnimation(duration: 0.05, fromValue: Float(previousProgress), toValue: Float(progress))
            previousProgress = Float(progress)
            printDebug("Downloading progress of \(name) is \(progress)")
            if progress == 1.0 {
                sSelf.downloadingStopAnimation()
            }
        }
        if !request.path.isEmpty {
             self.documentsImageView.image = request.path.fileIcon
        }
        if request.downloadingStatus == .notDownloaded {
            previousProgress = 0.0
        }
    }
    
    private func loaderSetUp() {
        self.progressView.progressColor = AppColors.themeWhite
        self.progressView.trackColor = AppColors.themeWhite.withAlphaComponent(0.7)
        self.progressView.isHidden = true
    }
    
    internal func downloadingStartAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.downloadingStatusSetUp()
            self.layoutIfNeeded()
        }
    }
    
    private func downloadingStopAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.downloadedStatusSetUp(name: LocalizedString.Downloading.localized)
            self.layoutIfNeeded()
        }
    }
    
    internal func notDownloadingStatusSetUp(name: String , type: String = "") {
        self.downloadingIcon.isHidden = false
        self.progressView.isHidden = true
        self.nameLabel.textColor = AppColors.themeBlack
        if type.isEmpty{
            self.nameLabel.text = name
        }else{
            self.nameLabel.text = "\(name).\(type)"
        }
        self.imageContainerViewTopConstraint.constant = self.normalTopConstraint
        self.imageContainerViewWidthConstraint.constant = self.normalWidthConstraint
        self.imageContainerViewHeightConstraint.constant = self.normalHeightConstraint
        self.imageContainerViewBottomConstraint.constant = self.normalBottomConstraint
        self.dowloadingPlaceHolderImgView.image = nil
    }
    
    internal func downloadingStatusSetUp() {
        self.nameLabel.textColor = AppColors.themeGray40
        self.downloadingIcon.isHidden = true
        self.progressView.isHidden = false
        self.nameLabel.text = LocalizedString.Downloading.localized
        self.imageContainerViewTopConstraint.constant = self.topConstraintForDownloading
        self.imageContainerViewWidthConstraint.constant = self.widthConstraintForDownloading
        self.imageContainerViewHeightConstraint.constant = self.heightConstraintForDownloading
        self.imageContainerViewBottomConstraint.constant = self.bottomConstraintForDownloading
        self.dowloadingPlaceHolderImgView.image = AppImages.DownloadingPlaceHolder
    }
    
    internal func downloadedStatusSetUp(name: String, type: String = "") {
        self.nameLabel.textColor = AppColors.themeBlack
        self.downloadingIcon.isHidden = true
        self.progressView.isHidden = true
        if type.isEmpty{
            self.nameLabel.text = name
        }else{
            self.nameLabel.text = "\(name).\(type)"
        }
        self.imageContainerViewTopConstraint.constant = self.normalTopConstraint
        self.imageContainerViewWidthConstraint.constant = self.normalWidthConstraint
        self.imageContainerViewHeightConstraint.constant = self.normalHeightConstraint
        self.imageContainerViewBottomConstraint.constant = self.normalBottomConstraint
        self.dowloadingPlaceHolderImgView.image = nil
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func cancelDownloading(_ sender: UIButton) {
        if let superVw = self.superview as? UICollectionView , let indexPath = superVw.indexPath(for: self), let safeDelegate = self.delegate {
            safeDelegate.cancelButtonAction(forIndex: indexPath)
            self.progressView.setProgressWithAnimation(duration: 0.0, toValue: 0.0)
        }
    }
    
    @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began{
        if let superVw = self.superview as? UICollectionView , let indexPath = superVw.indexPath(for: self), let safeDelegate = self.delegate {
        safeDelegate.longPressButtonAction(forIndex: indexPath)
        }
        }
    }
}
