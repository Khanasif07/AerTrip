//
//  BulkEnquirySuccessfulVC.swift
//  AERTRIP
//
//  Created by Admin on 07/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BulkEnquirySuccessfulVC: BaseVC {
    
    //Mark:- Variables
    //================
    private var bulkLabelBottom: CGFloat = .leastNonzeroMagnitude
    private var customerLabelBottom: CGFloat = .leastNonzeroMagnitude
    private var doneBtnBottom: CGFloat = .leastNonzeroMagnitude
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bulkEnquiryLabel: UILabel!
    @IBOutlet weak var customerServiceLabel: UILabel!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    
    private var tickLayer: CAShapeLayer!
    private var tickImageSize: CGSize {
        let tickImageWidth: CGFloat = 25.0
        return CGSize(width: tickImageWidth, height: tickImageWidth*0.8)
    }
    private var tickLineWidth: CGFloat = 4.0
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bulkLabelBottom = self.bulkEnquiryLabel.bottom
        self.customerLabelBottom = self.customerServiceLabel.bottom
        self.doneBtnBottom = self.doneBtnOutlet.bottom
        delay(seconds: 0.2) {
            self.setupViewForSuccessAnimation()
        }
    }
    
    override func setupFonts() {
        self.bulkEnquiryLabel.font = AppFonts.Bold.withSize(31.0)
        self.customerServiceLabel.font = AppFonts.Regular.withSize(15.0)
        self.doneBtnOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupColors() {
        self.bulkEnquiryLabel.textColor = AppColors.themeBlack
        self.customerServiceLabel.textColor = AppColors.themeBlack
        self.doneBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func setupTexts() {
        self.bulkEnquiryLabel.text = LocalizedString.BulkEnquirySent.localized
        self.customerServiceLabel.text = LocalizedString.CustomerServicesShallConnect.localized
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .normal)
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .selected)
        self.searchBtnOutlet.setTitle(LocalizedString.Submit.localized, for: .normal)
    }
    
    override func initialSetup() {
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        //self.headerView.cornerRadius = 15.0
        self.containerView.roundTopCorners(cornerRadius: 15.0)
        self.bulkEnquiryLabel.alpha = 0.0
        self.customerServiceLabel.alpha = 0.0
        self.doneBtnOutlet.alpha = 0.0
        self.bulkEnquiryLabel.isHidden = true
        self.customerServiceLabel.isHidden = true
        self.doneBtnOutlet.isHidden = true
        
    }
    //Mark:- Methods
    //==============
    //Private
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraint.constant = -(self.containerView.height + 100)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    ///SetUpViewForSuccess
    private func setupViewForSuccessAnimation() {
        self.searchBtnOutlet.setTitle(nil, for: .normal)
        self.searchBtnOutlet.setImage(nil, for: .normal)
        let reScaleFrame = CGRect(x: (self.containerView.width - 74.0) / 2.0, y: self.searchBtnOutlet.y, width: 74.0, height: 74.0)
        self.searchBtnOutlet.translatesAutoresizingMaskIntoConstraints = true
        
        let myLayer = CALayer()
        myLayer.backgroundColor = UIColor.clear.cgColor
        myLayer.frame = CGRect(x: (reScaleFrame.width - 20.0) / 2.0, y: (reScaleFrame.height - 20.0) / 2.0, width: 20.0, height: 20.0)
//        self.searchBtnOutlet.layer.addSublayer(myLayer)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.searchBtnOutlet.frame = reScaleFrame
            self.searchBtnOutlet.myCornerRadius = reScaleFrame.height / 2.0
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            self.searchBtnOutlet.layer.cornerRadius = reScaleFrame.height / 2.0
            let yPerSafeArea = self.bulkEnquiryLabel.frame.origin.y + self.view.safeAreaInsets.bottom //+ 26.0
            let tY = ((self.view.frame.height - reScaleFrame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y //- yPerSafeArea
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.searchBtnOutlet.transform = t
                self.containerView.alpha = 1.0
            }) { (isCompleted) in
                self.bulkEnquiryLabel.bottom = self.searchBtnOutlet.bottom + 26.0
                self.customerServiceLabel.bottom = self.bulkEnquiryLabel.bottom + 16.0
                self.doneBtnOutlet.bottom = self.customerServiceLabel.bottom + 120.0
                self.animatingCheckMark()
                delay(seconds: AppConstants.kAnimationDuration + 0.1, completion: {
                    self.finalTransFormation(tY: tY - yPerSafeArea)
                })
            }
        }
    }
    
    private func finalTransFormation(tY: CGFloat) {
        
        let newReScaleFrame = CGRect(x: (self.containerView.width - 62.0) / 2.0, y: self.searchBtnOutlet.y, width: 62.0, height: 62.0)
        var t = CGAffineTransform.identity
        t = t.translatedBy(x: 0.0, y: tY )
        self.bulkEnquiryLabel.isHidden = false
        self.customerServiceLabel.isHidden = false
        self.doneBtnOutlet.isHidden = false
        UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
            self.searchBtnOutlet.frame = newReScaleFrame
            self.updateTickPath()
            self.searchBtnOutlet.myCornerRadius = newReScaleFrame.height / 2.0
            self.searchBtnOutlet.transform = t
            self.bulkEnquiryLabel.bottom = self.bulkLabelBottom
            self.customerServiceLabel.bottom = self.customerLabelBottom
            self.doneBtnOutlet.bottom = self.doneBtnBottom
            self.bulkEnquiryLabel.alpha = 1.0
            self.customerServiceLabel.alpha = 1.0
            self.doneBtnOutlet.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    ///CheckMark
    private func animatingCheckMark() {
        
        // Shape layer for Check mark path
        let shapeLayer = CAShapeLayer()
        self.tickLayer = shapeLayer
        shapeLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - tickImageSize.width) / 2.0, y: (self.searchBtnOutlet.frame.height - tickImageSize.height) / 2.0, width: tickImageSize.width, height: tickImageSize.height)
        shapeLayer.fillColor = AppColors.clear.cgColor
        shapeLayer.strokeColor = AppColors.themeWhite.cgColor
        shapeLayer.lineWidth = tickLineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.path = self.getTickMarkPath()

        // Animation
        self.searchBtnOutlet.layer.addSublayer(shapeLayer)

        // Animation
        self.searchBtnOutlet.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = AppConstants.kAnimationDuration
        shapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    func updateTickPath() {
        self.tickLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - tickImageSize.width) / 2.0, y: (self.searchBtnOutlet.frame.height - tickImageSize.height) / 2.0, width: tickImageSize.width, height: tickImageSize.height)
    }
    
    private func getTickMarkPath() -> CGPath {

        let size: CGSize = tickImageSize
        let path = CGMutablePath()
        path.move(to: CGPoint(x: tickLineWidth / 2.0, y: size.height / 2.0), transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(ceilf(Float(size.width * 0.3))), y: size.height - tickLineWidth / 1.0), transform: .identity)
        path.addLine(to: CGPoint(x: size.width - tickLineWidth / 3.0, y: tickLineWidth / 3.0), transform: .identity)
        return UIBezierPath(cgPath: path).cgPath
    }
    
    //Mark:- IBActions
    //================
    
    @IBAction func doneBtnAction(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
    }
}
