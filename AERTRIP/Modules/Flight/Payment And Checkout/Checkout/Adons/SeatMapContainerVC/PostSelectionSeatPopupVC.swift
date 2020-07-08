//
//  PostSelectionSeatPopupVC.swift
//  AERTRIP
//
//  Created by Rishabh on 06/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PostSelectionSeatPopupVC: UIViewController {
    
    // MARK: Properties
    
    private var titleText = ""
    private var descText = ""
    
    var onDismissTap: (() -> ())?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var seatTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPresentAnimation()
        
    }
    
    // MARK: IBActions
    
    @IBAction func cancelAndDismissBtnAction(_ sender: UIButton) {
        startDismissAnimation()
    }
    
    // MARK: Functions
    
    func setTexts(_ title: String, _ desc: String) {
        titleText = title
        descText = desc
    }
    
    private func initialSetup() {
        descriptionView.roundedCorners(cornerRadius: 13)
        cancelBtn.roundedCorners(cornerRadius: 13)
        
        seatTitleLbl.font = AppFonts.SemiBold.withSize(18)
        descLbl.font = AppFonts.Regular.withSize(14)
        statusLbl.font = AppFonts.SemiBold.withSize(14)
        cancelBtn.titleLabel?.font = AppFonts.SemiBold.withSize(20)
        
        descLbl.textColor = AppColors.themeGray40
        statusLbl.textColor = AppColors.themeOrange
        cancelBtn.setTitleColor(AppColors.themeDarkGreen, for: .normal)
        
        statusLbl.text = LocalizedString.seatAvailablePostBooking.localized
        cancelBtn.setTitle(LocalizedString.Cancel.localized, for: .normal)
        seatTitleLbl.text = titleText
        descLbl.text = descText
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.height + view.safeAreaInsets.bottom)
        addDismissGesture()
    }
    
    private func startPresentAnimation() {
        UIView.animate(withDuration: 0.33) {
            self.view.backgroundColor = AppColors.blackWith40PerAlpha
            self.containerView.transform = .identity
        }
    }
    
    private func startDismissAnimation(_ animationDuration: TimeInterval = 0.33) {
        onDismissTap?()
        UIView.animate(withDuration: animationDuration, animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.containerView.transform = CGAffineTransform(scaleX: 0, y: self.containerView.height + self.view.safeAreaInsets.bottom)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

// MARK: Popver dismiss animation
extension PostSelectionSeatPopupVC {
    
    private func addDismissGesture() {
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewToDismiss(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func didPanViewToDismiss(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
                
        switch sender.state {
        case .ended:
            let popopverMaxHeight = containerView.height + view.safeAreaInsets.bottom
            let yVelocity = sender.velocity(in: view).y
            if (yVelocity > 500) && (yTranslation > popopverMaxHeight/4) && (yTranslation < popopverMaxHeight) {
                startDismissAnimation()
            } else if yTranslation >= popopverMaxHeight {
                startDismissAnimation(0.0)
            } else {
                startPresentAnimation()
            }
        default:
            transformViewBy(yTranslation)
        }
    }
    
    private func transformViewBy(_ yTranslation: CGFloat) {
        guard yTranslation >= 0 else { return }
        containerView.transform = CGAffineTransform(translationX: 0, y: yTranslation)
        let maxViewColorAlpha: CGFloat = 0.4,
        popopverMaxHeight = containerView.height + view.safeAreaInsets.bottom
        
        let fractionForAlpha = maxViewColorAlpha - ((yTranslation/popopverMaxHeight) * maxViewColorAlpha)
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: fractionForAlpha)
    }
}
