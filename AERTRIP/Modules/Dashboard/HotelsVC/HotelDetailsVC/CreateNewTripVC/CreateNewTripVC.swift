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
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripImageShadowView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var createButton: ATButton!
    @IBOutlet weak var inputContainerShadowView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stickyLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = CreateNewTripVM()
    weak var delegate: CreateNewTripVCDelegate?
    var initialTouchPoint = CGPoint.zero
    var initailContainerYPosition: CGFloat?
    var viewTranslation = CGPoint(x: 0, y: 0)
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        createButton.layer.cornerRadius = createButton.height / 2
        editButton.cornerradius = editButton.height / 2.0
//        createButton.layer.masksToBounds = true
        
       // popUpContainerView.roundTopCorners(cornerRadius: 10.0)
        inputContainerView.cornerradius = 10.0
        let shadowProp = AppShadowProperties(self.isLightTheme())
        self.inputContainerShadowView.addShadow(cornerRadius: shadowProp.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)
//        inputContainerShadowView.addShadow(cornerRadius: inputContainerView.cornerradius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        inputContainerShadowView.clipsToBounds = false
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
//        if #available(iOS 13.0, *) {} else {
//        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
//        swipeGesture.delegate = self
//        self.popUpContainerView.addGestureRecognizer(swipeGesture)
//        }
        
        headerView.backgroundColor = .clear
        popUpContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.view.backgroundColor = .clear
        
        
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
        createButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        editButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        titleTextField.font = AppFonts.Regular.withSize(18.0)
        self.stickyLabel.font = AppFonts.SemiBold.withSize(18.0)

    }
    
    override func setupTexts() {
        createButton.setTitle(LocalizedString.Create.localized, for: .normal)
        
        editButton.setTitle(LocalizedString.Edit.localized, for: .normal)
        titleTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.NameYourTrip.localized, with: "")
        self.stickyLabel.text = LocalizedString.CreateNewTrip.localized

    }
    
    override func setupColors() {
        if #available(iOS 13.0, *) {} else {
            view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.5)
        }
        createButton.isSocial = false
        createButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        editButton.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.3)
        editButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        tripImageShadowView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.5)
        
        self.stickyLabel.textColor = AppColors.themeBlack
        self.headerView.backgroundColor = AppColors.flightsNavBackViewColor
        self.inputContainerView?.backgroundColor = AppColors.themeWhiteDashboard
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
    @IBAction func closeBtnTapped(_ sender: Any) {
        //cross button
        ((self.presentingViewController as? SelectTripVC)?.parentController as? HotelDetailsVC)?.viewModel.logEvents(with: .CancelCreateNewTrip)
        self.dismiss(animated: true)
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
        if tripImageView.image != nil{
            ((self.presentingViewController as? SelectTripVC)?.parentController as? HotelDetailsVC)?.viewModel.logEvents(with: .SetATripPhoto)
        }
        self.delegate?.createNewTripVC(sender: self, didCreated: trip)
        self.dismiss(animated: true)
    }
    
    func saveTripFail() {
    }
}

extension CreateNewTripVC {

}
