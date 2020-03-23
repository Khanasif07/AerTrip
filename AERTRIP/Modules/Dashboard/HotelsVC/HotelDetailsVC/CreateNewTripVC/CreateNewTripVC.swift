//
//  CreateNewTripVC.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol CreateNewTripVCDelegate: class {
    func createNewTripVC(sender: CreateNewTripVC, didCreated trip: TripModel)
}

class CreateNewTripVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var popUpContainerView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripImageShadowView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var createButton: ATButton!
    @IBOutlet weak var inputContainerShadowView: UIView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = CreateNewTripVM()
    weak var delegate: CreateNewTripVCDelegate?
    var initialTouchPoint = CGPoint.zero
    var initailContainerYPosition: CGFloat?
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        createButton.layer.cornerRadius = createButton.height / 2
        editButton.cornerRadius = editButton.height / 2.0
//        createButton.layer.masksToBounds = true
        
        popUpContainerView.roundTopCorners(cornerRadius: 10.0)
        inputContainerView.cornerRadius = 10.0
        inputContainerShadowView.addShadow(cornerRadius: inputContainerView.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.1), offset: CGSize(width: 0.0, height: 0.0), opacity: 0.5, shadowRadius: 5.0)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if initailContainerYPosition == nil {
            initailContainerYPosition = popUpContainerView.y
        }
    }
    
    override func initialSetup() {
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeGesture.delegate = self
        self.popUpContainerView.addGestureRecognizer(swipeGesture)
        
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.CreateNewTrip.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"))
        
        titleTextField.becomeFirstResponder()
        titleTextField.autocorrectionType = .no
        
        self.createButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.createButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func setupFonts() {
        createButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        createButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        editButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        titleTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        createButton.setTitle(LocalizedString.Create.localized, for: .normal)
        
        editButton.setTitle(LocalizedString.Edit.localized, for: .normal)
        titleTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.NameYourTrip.localized)
    }
    
    override func setupColors() {
        
        view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.5)
        createButton.isSocial = false
        createButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        editButton.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.3)
        editButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        tripImageShadowView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.5)
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func dismiss(animated: Bool) {
        self.view.endEditing(true)
        self.dismiss(animated: animated, completion: nil)
    }
    
    //MARK:- Public

    //MARK:- Action
    @IBAction func editButtonAction(_ sender: UIButton) {
        self.captureImage(delegate: self)
    }
    @IBAction func createButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if (titleTextField.text ?? "").isEmpty {
            AppToast.default.showToastMessage(message: "Please enter trip name.")
        }
        else {
            var trip = TripModel()
            trip.name = titleTextField.text ?? ""
            trip.image = tripImageView.image
            viewModel.add(trip: trip)
        }
    }
}


//MARK:- Image picker controller delegate methods
//MARK:-
extension CreateNewTripVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        tripImageView.image = selectedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Navigation View delegat methods
//MARK:-
extension CreateNewTripVC: CreateNewTripVMDelegate {
    func willSaveTrip() {
    }
    
    func saveTripSuccess(trip: TripModel) {
        self.delegate?.createNewTripVC(sender: self, didCreated: trip)
        self.dismiss(animated: true)
    }
    
    func saveTripFail() {
    }
}

//MARK:- Navigation View delegat methods
//MARK:-
extension CreateNewTripVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        // no need to implement
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //cross button
        self.dismiss(animated: true)
    }
}

extension CreateNewTripVC {
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        
        guard let direction = sender.direction, direction.isVertical
            else {
            initialTouchPoint = CGPoint.zero
            return
        }
        
        let touchPoint = sender.location(in: view?.window)
        print(touchPoint)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                popUpContainerView.frame.origin.y = touchPoint.y - (self.initailContainerYPosition ?? 0)  //initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 300 {
                dismiss(animated: false, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.popUpContainerView.frame = CGRect(x: 0,
                                                           y: self.initailContainerYPosition ?? 0,
                                             width: self.popUpContainerView.frame.size.width,
                                             height: self.popUpContainerView.frame.size.height)
                })
            }
        case .failed, .possible:
            initialTouchPoint = CGPoint.zero
            break
        }
    }
}
