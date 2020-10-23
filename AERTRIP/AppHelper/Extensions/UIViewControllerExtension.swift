//
//  UIViewControllerExtension.swift
//
//  Created by Pramod Kumar on 19/09/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//


import Foundation
import UIKit
import AssetsLibrary
import AVFoundation
import Photos
import PhotosUI
import Contacts

extension UIViewController{
    
    ///Adds Child View Controller to Parent View Controller
    func add(childViewController:UIViewController){
        
        self.addChild(childViewController)
        let frame = self.view.bounds
        
        childViewController.view.frame = frame
        self.view.addSubview(childViewController.view)
        
        childViewController.didMove(toParent: self)
    }
    
    ///Removes Child View Controller From Parent View Controller
    var removeFromParentVC:Void{
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    ///Updates navigation bar according to given values
    func updateNavigationBar(withTitle title:String? = nil, leftButton:UIBarButtonItem? = nil, rightButton:UIBarButtonItem? = nil, tintColor:UIColor? = nil, barTintColor:UIColor? = nil, titleTextAttributes: [NSAttributedString.Key : Any]? = nil){
        
        self.navigationController?.isNavigationBarHidden = false
        if let tColor = barTintColor{
            self.navigationController?.navigationBar.barTintColor = tColor
        }
        if let tColor = tintColor{
            self.navigationController?.navigationBar.tintColor = tColor
        }
        if let button = leftButton{
            self.navigationItem.leftBarButtonItem = button;
        }
        if let button = rightButton{
            self.navigationItem.rightBarButtonItem = button;
        }
        if let ttle = title{
            self.title = ttle
        }
        if let ttleTextAttributes = titleTextAttributes{
            self.navigationController?.navigationBar.titleTextAttributes =   ttleTextAttributes
        }
    }
    
    ///function to push the target from navigation Stack
    func pushToController(_ viewController:UIViewController, animated:Bool = true){
        
        var navigationVC:UINavigationController?
        if let navVC = self as? UINavigationController{
            navigationVC = navVC
        }
        else{
            navigationVC = self.navigationController
        }
        navigationVC?.pushViewController(viewController, animated: animated)
    }
    
    ///function to pop the target from navigation Stack
    
    func popToController(_ viewController:UIViewController? = nil, animated:Bool = true) {
        
        var navigationVC:UINavigationController?
        if let navVC = self as? UINavigationController{
            navigationVC = navVC
        }
        else{
            navigationVC = self.navigationController
        }
        
        if let vc = viewController{
            _ = navigationVC?.popToViewController(vc, animated: animated)
        }
        else{
            _ = navigationVC?.popViewController(animated: animated)
        }
    }
    
    func popToController(atIndex index:Int, animated:Bool = true) {
        
        var navigationVC:UINavigationController?
        if let navVC = self as? UINavigationController{
            navigationVC = navVC
        }
        else{
            navigationVC = self.navigationController
        }
        
        if let navVc = navigationVC, navVc.viewControllers.count > index{
            
            _ = navVc.popToViewController(navVc.viewControllers[index], animated: animated)
        }
    }
    
    func popToRootController(animated:Bool = true) {
        
        var navigationVC:UINavigationController?
        if let navVC = self as? UINavigationController{
            navigationVC = navVC
        }
        else{
            navigationVC = self.navigationController
        }
        _ = navigationVC?.popToRootViewController(animated: animated)
    }
    
    // Take image from gallery or Camera
    func captureImage(delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?,
                      photoGallary:Bool = true,
                      camera:Bool = true,
                      optionsColor:UIColor = AppColors.themeGreen,
                      cameraDevice: UIImagePickerController.CameraDevice = .rear) {
        
        let alertController = UIAlertController(title: "Choose from options", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        if photoGallary {
            
            let alertActionGallery = UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                self.checkAndOpenLibrary(delegate: delegate)
            }
            
            alertActionGallery.setValue(optionsColor, forKey: "titleTextColor")
            alertController.addAction(alertActionGallery)
        }
        
        if camera{
            let alertActionCamera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                
                !UIDevice.isSimulator ? self.checkAndOpenCamera(delegate: delegate, cameraDevice: cameraDevice):self.checkAndOpenLibrary(delegate: delegate)
            }
            
            alertActionCamera.setValue(optionsColor, forKey: "titleTextColor")
            alertController.addAction(alertActionCamera)
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) in
            
        }
        
        alertActionCancel.setValue(optionsColor, forKey: "titleTextColor")
        alertController.addAction(alertActionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, cameraDevice: UIImagePickerController.CameraDevice = .rear) {
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == AVAuthorizationStatus.authorized {
            let image_picker = UIImagePickerController()
            image_picker.modalPresentationStyle = .fullScreen
            image_picker.delegate = delegate
            let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                image_picker.sourceType = sourceType
                if image_picker.sourceType == UIImagePickerController.SourceType.camera {
                    image_picker.allowsEditing = true
                    image_picker.showsCameraControls = true
                }
                
                if UIImagePickerController.isCameraDeviceAvailable(cameraDevice) {
                    image_picker.cameraDevice = cameraDevice
                }
                else {
                    image_picker.cameraDevice = .rear
                }
                self.present(image_picker, animated: true, completion: nil)
            }
            else if !UIDevice.isSimulator{
                
                self.showAlert(title: "", message: "Camera not available", buttonTitle: "OK", onCompletion: nil)
            }
        }
        else {
            if authStatus == AVAuthorizationStatus.notDetermined {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted: Bool) in                DispatchQueue.main.async(execute: {                    if granted {
                    let image_picker = UIImagePickerController()
                    image_picker.delegate = delegate
                    image_picker.modalPresentationStyle = .fullScreen
                    let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
                    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                        image_picker.sourceType = sourceType
                        if image_picker.sourceType == UIImagePickerController.SourceType.camera {
                            image_picker.allowsEditing = true
                            image_picker.showsCameraControls = true
                        }
                        self.present(image_picker, animated: true, completion: nil)
                    }
                    else if !UIDevice.isSimulator{
                        self.showAlert(title: "", message: "Camera not available", buttonTitle: "OK", onCompletion: nil)
                    }
                    }
                    
                })
                    
                })
            }
            else {
                if authStatus == AVAuthorizationStatus.restricted {
                    
                    let alertController = UIAlertController(title: "", message: "You have been restricted from using the camera on this device Without camera access this feature wont work", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                        UIApplication.openSettingsApp
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(alertActionSettings)
                    alertController.addAction(alertActionCancel)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    
                    let alertController = UIAlertController(title: "", message: "Please change your privacy setting from the Settings app and allow access to camera", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                        UIApplication.openSettingsApp
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                    }
                    alertController.addAction(alertActionSettings)
                    alertController.addAction(alertActionCancel)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkAndOpenLibrary(delegate:(UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            
            let image_picker = UIImagePickerController()
            image_picker.delegate = delegate
            image_picker.modalPresentationStyle = .fullScreen
            let sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
            image_picker.sourceType = sourceType
            image_picker.allowsEditing=true
            self.present(image_picker, animated: true, completion: nil)
            
        //handle authorized status
        case .denied:
            
            let alertController = UIAlertController(title: "", message: "Please change your privacy setting from the Settings app and allow access to library", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                UIApplication.openSettingsApp
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            }
            alertController.addAction(alertActionSettings)
            alertController.addAction(alertActionCancel)
            self.present(alertController, animated: true, completion: nil)
            
        case .restricted :
            
            let alertController = UIAlertController(title: "", message: "You have been restricted from using the library on this device Without camera access this feature wont work", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                UIApplication.openSettingsApp
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            }
            alertController.addAction(alertActionSettings)
            alertController.addAction(alertActionCancel)
            self.present(alertController, animated: true, completion: nil)
            
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                self.checkAndOpenLibrary(delegate: delegate)
            }
        @unknown default: break
        }
    }
    
    func showAlert(title:String, message: String , successButtonTitle:String, cancelButtonTitle:String , onCompletion completion: @escaping (Bool)->Void){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title:successButtonTitle, style: .default) { (_) -> Void in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .destructive) { (_) in
            completion(false)
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil);
    }
    
    func showAlert(title:String, message: String , buttonTitle:String, onCompletion completion: (()->Void)?){
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title:buttonTitle, style: .cancel) { (_) -> Void in
            completion?()
        }
        alertController.view.tintColor = AppColors.themeGreen
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil);
    }
    
    func showActionSheet(title: String, btnTitleArray: [String], completion: @escaping (_ btnTag: Int) -> ()) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        for titleString in btnTitleArray {
            
            let alertAction = UIAlertAction.init(title: titleString, style: .default, handler: { (action) in
                
                for i in 0..<btnTitleArray.count {
                    
                    if titleString == btnTitleArray[i] {
                        completion(i)
                    }
                }
            })
            
            alert.addAction(alertAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func addBlurViewOnStatusBar() {
        
        let blurView = UIView()
        let height = UIApplication.shared.statusBarFrame.height
        blurView.frame = CGRect(x: 0.0, y: 0.0, width: Double(UIDevice.screenWidth), height: Double(height))
        blurView.backgroundColor = AppColors.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        blurView.addSubview(blurEffectView)
        
        self.view.addSubview(blurView)
    }
    
    func makePhoneCall(phoneNumber: String) {
        var uc = URLComponents()
        uc.scheme = "tel"
        uc.path = phoneNumber
        
        if let phoneURL = uc.url {
            let alert = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .alert)
            alert.view.tintColor = AppColors.themeGreen
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
                if UIApplication.shared.canOpenURL(phoneURL){
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }else{
                    AppToast.default.showToastMessage(message: LocalizedString.callingNotAvailable.localized)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension UINavigationController {
    func viewController(atIndex: Int) -> UIViewController? {
        guard self.viewControllers.count > atIndex else  {
            return nil
        }
        return self.viewControllers[atIndex]
    }
}


//MARK:- Contacts Fetching
extension UIViewController {
    func isContactsAuthorized(canceled: (() -> Void)? = nil) -> Bool {
        var flag: Bool = true
        
        if CNContactStore.authorizationStatus(for: .contacts) == .denied {
            flag = false
            let alertController = UIAlertController(title: "", message: "Please change your privacy setting from the Settings app and allow access to Contacts", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                UIApplication.openSettingsApp
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                printDebug("Cancel tapped")
                canceled?()
            }
            alertController.addAction(alertActionSettings)
            alertController.addAction(alertActionCancel)
            self.present(alertController, animated: true, completion: nil)
        }
        else if CNContactStore.authorizationStatus(for: .contacts) == .restricted {
            flag = false
            let alertController = UIAlertController(title: "", message: "You have been restricted from accessing the contacts on this device without contacts access this feature wont work", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                UIApplication.openSettingsApp
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                printDebug("Cancel tapped")
                canceled?()
            }
            alertController.addAction(alertActionSettings)
            alertController.addAction(alertActionCancel)
            self.present(alertController, animated: true, completion: nil)
        }
        else if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            flag = false
        }
        
        return flag
    }
    
    func fetchContacts(complition: @escaping ((_ contacts: [CNContact]) -> Void), canceled: (() -> Void)? = nil) {
        
        func retrieveContactsWithStore(_ store: CNContactStore) {
            
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataKey,CNContactBirthdayKey,CNContactPostalAddressesKey] as [Any]
            // CNContactNoteKey
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                printDebug("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    printDebug("Error fetching results for container")
                }
            }
            
            complition(results)
        }
        
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            
            store.requestAccess(for: .contacts) { (authorized, error) in
                if authorized {
                    retrieveContactsWithStore(store)
                }
                else {
                    printDebug("Error in fetching contacts: \(String(describing: error))")
                    DispatchQueue.mainAsync {
                        canceled?()
                    }
                }
            }
        } else if self.isContactsAuthorized(canceled: {
            canceled?()
        }) {
            retrieveContactsWithStore(store)
        }
    }
}

extension UIViewController {
    
    func presentAsPushAnimation(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        viewControllerToPresent.view.isHidden = true
        DispatchQueue.main.async {
            self.present(viewControllerToPresent, animated: false){
                viewControllerToPresent.view.isHidden = false
                viewControllerToPresent.view.layer.add(transition, forKey: kCATransition)
            }
        }
    }
    
    func dismissAsPopAnimation(complition: (()->())? = nil) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: complition)
    }
    
    func dismissAsPopAnimationWithReveal(complition: (()->())? = nil) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: complition)
    }
    
    
    func openUrl(_ urlString: String) {
        if let url = URL(string: urlString)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        }
    }
}


// MARK: Added by Rishabh
extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = true
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
}
