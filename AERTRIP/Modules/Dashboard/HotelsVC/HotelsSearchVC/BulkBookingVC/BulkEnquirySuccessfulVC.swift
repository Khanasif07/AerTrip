//
//  BulkEnquirySuccessfulVC.swift
//  AERTRIP
//
//  Created by Admin on 07/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BulkEnquirySuccessfulVCDelegate: class {
    func doneButtonAction()
}

class BulkEnquirySuccessfulVC: BaseVC {
    
    struct ButtonConfiguration {
        
        //all values are the default for all the screens
        var text: String = LocalizedString.search.localized
        var textColor: UIColor = .white
        var textFont: UIFont = AppFonts.SemiBold.withSize(17.0)
        var image: UIImage? = nil
        var width: CGFloat = 150.0
        var isGradient: Bool = true
        var cornerRadius: CGFloat = 0.0
        var spaceFromBottom: CGFloat = 22.5
    }
    
    enum UsingFor {
        case bulkBooking
        case accountDeposit
        case addOnRequest
    }
    
    //Mark:- Variables
    //================
    weak var delegate: BulkEnquirySuccessfulVCDelegate? = nil
    private var bulkLabelBottom: CGFloat = .leastNonzeroMagnitude
    private var customerLabelBottom: CGFloat = .leastNonzeroMagnitude
    private var doneBtnBottom: CGFloat = .leastNonzeroMagnitude
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
//    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    private var tickLayer: CAShapeLayer!
    private var tickImageSize: CGSize {
        let tickImageWidth: CGFloat = 25.0
        return CGSize(width: tickImageWidth, height: tickImageWidth*0.8)
    }
    private var tickLineWidth: CGFloat = 4.0
    
    var currentUsingAs = UsingFor.bulkBooking
    var searchButtonConfiguration: ButtonConfiguration = ButtonConfiguration()
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bulkLabelBottom = self.mainTitleLabel.bottom
        self.customerLabelBottom = self.subTitleLabel.bottom
        self.doneBtnBottom = self.doneBtnOutlet.bottom
        delay(seconds: 0.2) {
            self.setupViewForSuccessAnimation()
        }
    }
    
    override func setupFonts() {
        self.mainTitleLabel.font = AppFonts.Bold.withSize(31.0)
        self.subTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.doneBtnOutlet.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupColors() {
        self.mainTitleLabel.textColor = AppColors.themeBlack
        self.subTitleLabel.textColor = AppColors.themeBlack
        self.doneBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func setupTexts() {
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .normal)
        self.doneBtnOutlet.setTitle(LocalizedString.Done.localized, for: .selected)
    }
    
    override func initialSetup() {
        self.setupSearchButton()
        if self.currentUsingAs == .bulkBooking {
            self.mainTitleLabel.text = LocalizedString.BulkEnquirySent.localized
            self.subTitleLabel.text = LocalizedString.CustomerServicesShallConnect.localized
            self.searchButtonWidthConstraint.constant = 150.0
            
            self.mainContainerViewHeightConstraint.constant = self.view.height - (AppFlowManager.default.safeAreaInsets.top)
            self.containerView.roundTopCorners(cornerRadius: 15.0)
        }
        else if self.currentUsingAs == .accountDeposit {
            self.mainTitleLabel.text = LocalizedString.PaymentRegisteredSuccesfully.localized
            self.subTitleLabel.text = LocalizedString.WeShallCreditYourAccount.localized
            
            
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        } else {
            self.mainTitleLabel.text = LocalizedString.AddOnRequestSent.localized
            self.subTitleLabel.text = LocalizedString.AddOnRequestMesage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        }
        
        self.searchBtnOutlet.isUserInteractionEnabled = false
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        //self.headerView.cornerRadius = 15.0
        self.mainTitleLabel.alpha = 0.0
        self.subTitleLabel.alpha = 0.0
        self.doneBtnOutlet.alpha = 0.0
        self.mainTitleLabel.isHidden = true
        self.subTitleLabel.isHidden = true
        self.doneBtnOutlet.isHidden = true
    }
    
    private func setupSearchButton() {
        
        self.searchBtnOutlet.setTitle(searchButtonConfiguration.text, for: .normal)
        self.searchBtnOutlet.setTitle(searchButtonConfiguration.text, for: .selected)
        
        self.searchBtnOutlet.setImage(searchButtonConfiguration.image, for: .normal)
        self.searchBtnOutlet.setImage(searchButtonConfiguration.image, for: .selected)
        
        self.searchBtnOutlet.setTitleColor(searchButtonConfiguration.textColor, for: .normal)
        self.searchBtnOutlet.setTitleColor(searchButtonConfiguration.textColor, for: .selected)

        self.searchBtnOutlet.myCornerRadius = searchButtonConfiguration.cornerRadius
        
        self.searchBtnOutlet.titleLabel?.font = searchButtonConfiguration.textFont
        
        self.searchButtonWidthConstraint.constant = searchButtonConfiguration.width
        self.searchButtonBottomConstraint.constant = searchButtonConfiguration.spaceFromBottom
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
                NotificationCenter.default.post(name: .bulkEnquirySent, object: nil)
            }
        })
    }
    
    ///SetUpViewForSuccess
    private func setupViewForSuccessAnimation() {
        self.searchBtnOutlet.setTitle(nil, for: .normal)
        self.searchBtnOutlet.setImage(nil, for: .normal)
        let reScaleFrame = CGRect(x: (self.containerView.width - 74.0) / 2.0, y: self.searchBtnOutlet.y, width: 74.0, height: 74.0)
        self.searchBtnOutlet.translatesAutoresizingMaskIntoConstraints = true
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.searchBtnOutlet.frame = reScaleFrame
            self.searchBtnOutlet.myCornerRadius = reScaleFrame.height / 2.0
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            self.searchBtnOutlet.layer.cornerRadius = reScaleFrame.height / 2.0
            let yPerSafeArea = self.mainTitleLabel.frame.origin.y + self.view.safeAreaInsets.bottom //+ 26.0
            let tY: CGFloat
            if UIDevice.isIPhoneX {
                tY = (((self.view.frame.height - reScaleFrame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y)
            } else {
                tY = (((self.view.frame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y + 15.0)
            }
            //- yPerSafeArea
            //            let tY = ((self.view.frame.height - reScaleFrame.height) / 2.0) - self.searchBtnOutlet.frame.origin.y //- yPerSafeArea
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.searchBtnOutlet.transform = t
                self.containerView.alpha = 1.0
            }) { (isCompleted) in
                self.mainTitleLabel.bottom = self.searchBtnOutlet.bottom + 26.0
                self.subTitleLabel.bottom = self.mainTitleLabel.bottom + 16.0
                self.doneBtnOutlet.bottom = self.subTitleLabel.bottom + 120.0
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
        self.mainTitleLabel.isHidden = false
        self.subTitleLabel.isHidden = false
        self.doneBtnOutlet.isHidden = false
        UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
            self.searchBtnOutlet.frame = newReScaleFrame
            self.updateTickPath()
            self.searchBtnOutlet.myCornerRadius = newReScaleFrame.height / 2.0
            self.searchBtnOutlet.transform = t
            self.mainTitleLabel.bottom = self.bulkLabelBottom
            self.subTitleLabel.bottom = self.customerLabelBottom
            self.doneBtnOutlet.bottom = self.doneBtnBottom
            self.mainTitleLabel.alpha = 1.0
            self.subTitleLabel.alpha = 1.0
            self.doneBtnOutlet.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (isCompleted) in
            self.tickLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - self.tickImageSize.width) / 2.0, y: ((self.searchBtnOutlet.frame.height - self.tickImageSize.height) / 2.0), width: self.tickImageSize.width, height: self.tickImageSize.height)
        })
    }
    
    ///CheckMark
    private func animatingCheckMark() {
        
        // Shape layer for Check mark path
        let shapeLayer = CAShapeLayer()
        self.tickLayer = shapeLayer
        shapeLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - tickImageSize.width) / 2.0, y: ((self.searchBtnOutlet.frame.height - tickImageSize.height) / 2.0), width: tickImageSize.width, height: tickImageSize.height)
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
        self.delegate?.doneButtonAction()
    }
}
