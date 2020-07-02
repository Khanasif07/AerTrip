//
//  BookingNotesVC.swift
//  AERTRIP
//
//  Created by Admin on 26/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingNotesVC: BaseVC {
    
    //Mark:- Variables
    //================
    let overViewText: String = ""
    let viewModel = BookingNotesVM()
    private let maxHeaderHeight: CGFloat = 58.0
    var initialTouchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var notesTextViewOutlet: UITextView! {
        didSet {
            self.notesTextViewOutlet.contentInset = UIEdgeInsets(top: 10.0, left: 4.0, bottom: 20.0, right: 4.0)
            self.notesTextViewOutlet.delegate = self
            self.notesTextViewOutlet.backgroundColor = AppColors.themeWhite
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var overViewLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerContainerView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setValue()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setValue()
    }
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        //self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.Notes.localized
        self.stickyTitleLabel.text = LocalizedString.Notes.localized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
    }
    
    override func initialSetup() {
        headerContainerView.backgroundColor = .clear
        mainContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.view.backgroundColor = .clear
        
        if #available(iOS 13.0, *) {} else {
            let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            mainContainerView.isUserInteractionEnabled = true
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
            self.view.backgroundColor = .white
        }
        //self.dividerView.isHidden = true
        self.notesTextViewOutlet.attributedText = self.viewModel.noteInfo.htmlToAttributedString(withFontSize: 18.0, fontFamily: AppFonts.Regular.rawValue, fontColor: AppColors.themeBlack)
        
        
        //Heading
        //        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline).withSize(16.0)
        //        // subheadline
        //        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline).withSize(16.0)
        //        // body
        //        self.overViewTextViewOutlet.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).withSize(16.0)
        
        self.titleLabel.alpha = 0.0
        self.stickyTitleLabel.alpha = 1.0
    }
    
    //Mark:- Functions
    //================
    
    
    //Mark:- IBActions
    //================
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension BookingNotesVC {
    
    func setValue() {
        let toDeduct = AppFlowManager.default.safeAreaInsets.top
        var finalValue =  (self.view.height - toDeduct)
        if #available(iOS 13.0, *) {
            finalValue = self.view.height
        }
        self.mainContainerBottomConst.constant = 0.0
        self.mainContainerViewHeightConst.constant = finalValue
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(1.0)
        self.view.layoutIfNeeded()
        
    }
    func manageHeaderView(_ scrollView: UIScrollView) {
        guard mainContainerView.height < scrollView.contentSize.height else {return}
        let yOffset = (scrollView.contentOffset.y > headerContainerView.height) ? headerContainerView.height : scrollView.contentOffset.y
        printDebug(yOffset)
        
        dividerView.isHidden = yOffset < (headerContainerView.height - 5.0)
        
        //header container view height
        let heightToDecrease: CGFloat = 8.0
        let height = (maxHeaderHeight) - (yOffset * (heightToDecrease / headerContainerView.height))
        self.containerViewHeigthConstraint.constant = height
        
        //sticky label alpha
        let alpha = (yOffset * (1.0 / headerContainerView.height))
        self.stickyTitleLabel.alpha = alpha
        
        //reviews label
        self.titleLabel.alpha = 1.0 - alpha
        self.overViewLabelTopConstraints.constant = 23.0 - (yOffset * (23.0 / headerContainerView.height))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //manageHeaderView(scrollView)
        // printDebug("scrollViewDidScroll")
    }
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.notesTextViewOutlet.contentOffset.y <= 0
            else {
                reset()
                return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
