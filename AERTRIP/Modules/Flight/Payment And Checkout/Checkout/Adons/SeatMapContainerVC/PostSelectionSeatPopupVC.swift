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
        
        view.backgroundColor = .clear
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.height + 100)
    }
    
    private func startPresentAnimation() {
        UIView.animate(withDuration: 0.33) {
            self.view.backgroundColor = AppColors.blackWith40PerAlpha
            self.containerView.transform = .identity
        }
    }
    
    private func startDismissAnimation() {
        onDismissTap?()
        UIView.animate(withDuration: 0.33, animations:  {
            self.view.backgroundColor = .clear
            self.containerView.transform = CGAffineTransform(scaleX: 0, y: self.containerView.height + 100)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
