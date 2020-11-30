//
//  OnlinePaymentLimitVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 27/11/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class OnlinePaymentLimitVC: BaseVC {
    
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
        var buttonHeight: CGFloat = 50.0
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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
//    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var returnToHomeButton: UIButton!
    
    private var tickLayer: CAShapeLayer!
    private var tickImageSize: CGSize {
        let tickImageWidth: CGFloat = 25.0
        return CGSize(width: tickImageWidth, height: tickImageWidth*0.8)
    }
    private var tickLineWidth: CGFloat = 4.0
    
    var searchButtonConfiguration: ButtonConfiguration = ButtonConfiguration()
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bulkLabelBottom = self.mainTitleLabel.bottom
        self.customerLabelBottom = self.subTitleLabel.bottom
//        self.doneBtnBottom = self.doneBtnOutlet.bottom
        delay(seconds: 0.2) {
            self.setupViewForSuccessAnimation()
        }
    }
    
    override func setupFonts() {
        self.mainTitleLabel.font = AppFonts.c.withSize(31.0)
        self.subTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.returnToHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bottomGradientView.addGredient(isVertical: false)
    }
    
    override func setupColors() {
        self.mainTitleLabel.textColor = AppColors.themeBlack
        self.subTitleLabel.textColor = AppColors.themeBlack
        self.returnToHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    override func setupTexts() {
        self.returnToHomeButton.setTitle(LocalizedString.ReturnHome.localized, for: .normal)
        self.returnToHomeButton.setTitle(LocalizedString.ReturnHome.localized, for: .selected)
    }
    
    override func initialSetup() {
        self.mainTitleLabel.adjustsFontSizeToFitWidth = true
        self.subTitleLabel.adjustsFontSizeToFitWidth = true
        self.setupSearchButton()
        self.mainTitleLabel.text = LocalizedString.requestNoted.localized
        self.subTitleLabel.text = LocalizedString.maximumOnlineLimit.localized
        self.mainContainerViewHeightConstraint.constant = self.view.height
        self.containerView.roundTopCorners(cornerRadius: 0.0)
        self.searchBtnOutlet.isUserInteractionEnabled = false
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        self.mainTitleLabel.alpha = 0.0
        self.subTitleLabel.alpha = 0.0
        self.bottomGradientView.addGredient(isVertical: false)
        self.bottomGradientView.isHidden = true
        self.returnToHomeButton.isHidden = true
        self.mainTitleLabel.isHidden = true
        self.subTitleLabel.isHidden = true
//        self.doneBtnOutlet.isHidden = true
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
        self.searchButtonHeightConstraint.constant = searchButtonConfiguration.buttonHeight
        
        printDebug(self.containerView.height - searchButtonConfiguration.spaceFromBottom - self.searchBtnOutlet.y)
        let y = self.view.height - searchButtonConfiguration.spaceFromBottom - self.searchBtnOutlet.y - self.searchBtnOutlet.height
        self.searchBtnOutlet.transform = CGAffineTransform(translationX:  0, y: y)
    }
    
    //Mark:- Methods
    //==============
    //Private
//    private func hide(animated: Bool, shouldRemove: Bool = false) {
//        let height = self.containerView.height
//        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
//            self?.mainContainerBottomConstraint.constant = -(height + 100)
//            self?.view.layoutIfNeeded()
//            }, completion: { [weak self] (isDone) in
//                if shouldRemove {
//                    self?.removeFromParentVC
//                    if self?.currentUsingAs == .bulkBooking {
//                        NotificationCenter.default.post(name: .bulkEnquirySent, object: nil)
//                    }
//                }
//        })
//    }
    
    ///SetUpViewForSuccess
    private func setupViewForSuccessAnimation() {
        self.searchBtnOutlet.setTitle(nil, for: .normal)
        self.searchBtnOutlet.setImage(nil, for: .normal)
        
        // self.searchBtnOutlet.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.searchButtonHeightConstraint.constant = 62
            self.searchButtonWidthConstraint.constant = 62
            self.searchBtnOutlet.myCornerRadius = 62 / 2.0
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            
            let tY: CGFloat
            tY = ((self.containerView.height) / 2.0) - self.searchBtnOutlet.height/2 - 115
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.searchBtnOutlet.transform = t
                self.containerView.alpha = 1.0
            }) { (isCompleted) in
                self.animatingCheckMark()
                delay(seconds: AppConstants.kAnimationDuration + 0.1, completion: {
                    self.finalTransFormation()
                })
            }
        }
    }
    
    private func finalTransFormation() {
        
        self.mainTitleLabel.isHidden = false
        self.subTitleLabel.isHidden = false
//        self.doneBtnOutlet.isHidden = false
        UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
            self.updateTickPath()
            self.searchBtnOutlet.myCornerRadius = self.searchBtnOutlet.width / 2.0
            self.searchBtnOutlet.transform = .identity
            self.mainTitleLabel.alpha = 1.0
            self.subTitleLabel.alpha = 1.0
//            self.doneBtnOutlet.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (isCompleted) in
            self.tickLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - self.tickImageSize.width) / 2.0, y: ((self.searchBtnOutlet.frame.height - self.tickImageSize.height) / 2.0) + 2, width: self.tickImageSize.width, height: self.tickImageSize.height)
            self.bottomGradientView.isHidden = false
            self.returnToHomeButton.isHidden = false
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
        self.tickLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - tickImageSize.width) / 2.0, y: ((self.searchBtnOutlet.frame.height - tickImageSize.height) / 2.0) + 2, width: tickImageSize.width, height: tickImageSize.height)
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
    
    @IBAction func returnToHomeButtonTapped(_ sender: Any) {
        AppFlowManager.default.flightReturnToHomefrom(self)
    }
}
