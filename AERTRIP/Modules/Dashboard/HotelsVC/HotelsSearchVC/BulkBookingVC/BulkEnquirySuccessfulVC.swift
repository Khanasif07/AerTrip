//
//  BulkEnquirySuccessfulVC.swift
//  AERTRIP
//
//  Created by Admin on 07/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

@objc protocol BulkEnquirySuccessfulVCDelegate: AnyObject {
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
        var buttonHeight: CGFloat = 50.0
    }
    
    enum UsingFor {
        case bulkBooking
        case accountDeposit
        case addOnRequest
        case cancellationRequest
        case cancellationProcessed
        case reschedulingRequest
        case specialRequest
        case addOnRequestPayment
        case bookingPayment
        case accountDepositOnline
        
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
    @IBOutlet weak var searchButtonHeightConstraint: NSLayoutConstraint!
    
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
        self.mainTitleLabel.font = AppFonts.c.withSize(31.0)
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
        switch self.currentUsingAs {
        case .bulkBooking:
            self.mainTitleLabel.text = LocalizedString.BulkEnquirySent.localized
            self.subTitleLabel.text = LocalizedString.CustomerServicesShallConnect.localized
            self.searchButtonWidthConstraint.constant = 150.0
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 15.0)
            self.mainTitleLabel.font = AppFonts.c.withSize(31.0)
        case .accountDeposit:
            self.mainTitleLabel.text = LocalizedString.PaymentRegisteredSuccesfully.localized
            self.subTitleLabel.text = LocalizedString.WeShallCreditYourAccount.localized
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .cancellationRequest :
            self.searchBtnOutlet.setTitle("", for: .normal)
            self.mainTitleLabel.text = LocalizedString.CancellationRequestSent.localized
            self.subTitleLabel.text = LocalizedString.CancellationRequestMessage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .addOnRequest:
            self.mainTitleLabel.text = LocalizedString.AddOnRequestSent.localized
            self.subTitleLabel.text = LocalizedString.AddOnRequestMesage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .reschedulingRequest:
            
            self.searchBtnOutlet.setTitle("", for: .normal)
            self.mainTitleLabel.text = LocalizedString.ReschedulingRequestHasBeenSent.localized
            self.subTitleLabel.text = LocalizedString.OurCustomerServiceRepresenstativeWillContact.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
            
        case .cancellationProcessed:
            self.searchBtnOutlet.setTitle("", for: .normal)
            self.mainTitleLabel.text = LocalizedString.CancellationHasBeenProcessed.localized
            self.subTitleLabel.text = ""
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .specialRequest:
            self.searchBtnOutlet.setTitle("", for: .normal)
            self.mainTitleLabel.text = LocalizedString.SpecialRequestHasBeenSent.localized
            self.subTitleLabel.text = LocalizedString.OurCustomerServiceRepresenstativeWillContact.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .addOnRequestPayment:
            self.mainTitleLabel.text = LocalizedString.AddOnRequestPayment.localized
            self.subTitleLabel.text = LocalizedString.AddOnRequestPaymentMessage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .bookingPayment:
            self.mainTitleLabel.text = LocalizedString.BookingPayment.localized
            self.subTitleLabel.text = LocalizedString.BookingPaymentMessage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        case .accountDepositOnline:
            self.mainTitleLabel.text = LocalizedString.BookingPayment.localized
            self.subTitleLabel.text = LocalizedString.BookingPaymentMessage.localized
            self.searchButtonWidthConstraint.constant = UIDevice.screenWidth
            self.mainContainerViewHeightConstraint.constant = self.view.height
            self.containerView.roundTopCorners(cornerRadius: 0.0)
        }
        
        self.searchBtnOutlet.isUserInteractionEnabled = false
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        self.mainTitleLabel.alpha = 0.0
        self.subTitleLabel.alpha = 0.0
        self.doneBtnOutlet.alpha = 0.0
        self.mainTitleLabel.isHidden = true
        self.subTitleLabel.isHidden = true
        self.doneBtnOutlet.isHidden = true
    }
    //    "AddOnRequestPayment" = "Payment Successful";
    //    "AddOnRequestPaymentMessage" = "Thank you for your payment. We will book your add-ons and send you a confirmation shortly.";
    //    "BookingPayment" = "Payment Successful";
    //    "BookingPaymentMessage" = "Thank you for your payment.";
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
        
        print(self.containerView.height - searchButtonConfiguration.spaceFromBottom - self.searchBtnOutlet.y)
        let y = self.view.height - searchButtonConfiguration.spaceFromBottom - self.searchBtnOutlet.y - self.searchBtnOutlet.height
        self.searchBtnOutlet.transform = CGAffineTransform(translationX:  0, y: y)
    }
    
    //Mark:- Methods
    //==============
    //Private
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        let height = self.containerView.height
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            self?.mainContainerBottomConstraint.constant = -(height + 100)
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] (isDone) in
                if shouldRemove {
                    self?.removeFromParentVC
                    if self?.currentUsingAs == .bulkBooking {
                        NotificationCenter.default.post(name: .bulkEnquirySent, object: nil)
                    }
                }
        })
    }
    
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
        self.doneBtnOutlet.isHidden = false
        UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
            self.updateTickPath()
            self.searchBtnOutlet.myCornerRadius = self.searchBtnOutlet.width / 2.0
            self.searchBtnOutlet.transform = .identity
            self.mainTitleLabel.alpha = 1.0
            self.subTitleLabel.alpha = 1.0
            self.doneBtnOutlet.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (isCompleted) in
            self.tickLayer.frame = CGRect(x: (self.searchBtnOutlet.frame.width - self.tickImageSize.width) / 2.0, y: ((self.searchBtnOutlet.frame.height - self.tickImageSize.height) / 2.0) + 2, width: self.tickImageSize.width, height: self.tickImageSize.height)
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
    
    @IBAction func doneBtnAction(_ sender: Any) {
        self.hide(animated: true, shouldRemove: true)
        self.delegate?.doneButtonAction()
    }
}

extension BulkEnquirySuccessfulVC {
    
    @objc func setConfigForFlightsBulkBooking() {
        
    }
    
}
