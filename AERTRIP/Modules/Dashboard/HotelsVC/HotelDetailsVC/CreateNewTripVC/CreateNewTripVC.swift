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
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        createButton.layer.cornerRadius = createButton.height / 2
        editButton.cornerRadius = editButton.height / 2.0
        
        popUpContainerView.roundTopCorners(cornerRadius: 10.0)
        inputContainerView.cornerRadius = 10.0
        inputContainerShadowView.addShadow(cornerRadius: inputContainerView.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack, offset: CGSize(width: 0.0, height: 0.0), opacity: 0.5, shadowRadius: 5.0)
    }
    
    override func initialSetup() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.CreateNewTrip.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"))
        
        titleTextField.becomeFirstResponder()
        titleTextField.autocorrectionType = .no
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func setupFonts() {
        createButton.titleLabel?.font = AppFonts.SemiBold.withSize(17.0)
        
        editButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        titleTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        createButton.setTitle(LocalizedString.Create.localized, for: .normal)
        
        editButton.setTitle(LocalizedString.Edit.localized, for: .normal)
        titleTextField.placeholder = LocalizedString.NameYourTrip.localized
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
