//
//  BaseVC.swift
//
//
//  Created by Pramod Kumar on 10/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.


import UIKit
import IQKeyboardManager

class BaseVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    private let indicator = UIActivityIndicatorView(style: .medium)
    private let indicatorContainer = UIView()
    
    var statusBarColor: UIColor = AppColors.themeWhite {
        didSet{
            UIApplication.shared.statusBarView?.backgroundColor = statusBarColor
        }
    }
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet{
            /*HINT:
             Open your info.plist and insert a new key named "View controller-based status bar appearance" to NO
             */
            UIApplication.shared.statusBarStyle = statusBarStyle
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //
    //        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
    //            updateStatusBarColor()
    //        }
    //    }
    //
    //    func updateStatusBarColor() {
    //        switch traitCollection.userInterfaceStyle {
    //        case .unspecified: statusBarStyle = .default
    //        case .light:       statusBarStyle = .darkContent
    //        case .dark:        statusBarStyle = .lightContent
    //        @unknown default:  statusBarStyle = .default
    //        }
    //    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //self.registerDataChangeNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.registerDataChangeNotification()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutSubviews()
        
        self.registerDataChangeNotification()
        
        indicatorContainer.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        indicatorContainer.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.2)
        indicator.center = indicatorContainer.center
        indicator.color = AppColors.themeGreen
        indicator.startAnimating()
        indicatorContainer.addSubview(indicator)
        
        self.bindViewModel()
        
        self.initialSetup()
        self.setupFonts()
        self.setupTexts()
        self.setupColors()
        self.setupNavBar()
        self.bindViewModel()
        
        if !AppConstants.isStatusBarBlured, let backV = UIApplication.shared.statusBarView {
            AppConstants.isStatusBarBlured = true
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backV.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.9
            backV.insertSubview(blurEffectView, at: 0)
            backV.sendSubviewToBack(blurEffectView)
        }
        
        //        delay(seconds: 0.1) {
        //            self.setupLayout()
        //        }
        IQKeyboardManager.shared().toolbarTintColor = AppColors.themeGreen
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkForReachability(_:)), name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // self.setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerLogoutNotification()
                
        if let nav = self.navigationController, !nav.navigationBar.isHidden {
            //nav.isNavigationBarHidden = true
            nav.isNavigationBarHidden = true
            nav.navigationBar.isHidden = true
            nav.setNavigationBarHidden(true, animated: false)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.deRegisterLogoutNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: Overrideabel functions
    private func registerDataChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(_:)), name: .dataChanged, object: nil)
    }
    
    func bindViewModel() {
        
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    //MARK: Private functions
    private func registerLogoutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(sessionExpired), name: .sessionExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutDone), name: .logOut, object: nil)
    }
    
    private func deRegisterLogoutNotification() {
        NotificationCenter.default.removeObserver(self, name: .sessionExpired, object: nil)
        NotificationCenter.default.removeObserver(self, name: .logOut, object: nil)
    }
    
    final func addTapGestureOnView(view:UIView) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        AppDelegate.shared.window?.endEditing(true)
        UIApplication.topViewController()?.view.endEditing(true)
    }
    
    final func showLoaderOnView(view:UIView, show:Bool, backgroundColor: UIColor = .clear, padding: UIEdgeInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 2.0, right: 1.0)) {
        if show {
            indicatorContainer.frame = CGRect(x: view.bounds.origin.x+padding.left, y: view.bounds.origin.y+padding.top, width: view.bounds.size.width-(padding.left + padding.right), height: view.bounds.size.height-(padding.top + padding.bottom))
            indicatorContainer.layoutIfNeeded()
            indicatorContainer.backgroundColor = backgroundColor
            indicator.center = indicatorContainer.center
            view.addSubview(indicatorContainer)
        } else {
            indicatorContainer.removeFromSuperview()
        }
    }
    
    @objc final func sessionExpired() {
        self.resetUser()
        self.showMessage()
    }
    
    @objc func dataChanged(_ note: Notification) {
        //function intended to override
    }
    
    @objc func statusBarTapped(_ note: Notification) {
        //function intended to override
    }
    
    final func sendDataChangedNotification(data: Any?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataChanged, object: data)
        }
    }
    
    @objc final func logoutDone() {
        self.resetUser()
    }
    
    @objc func roleChanged() {
    }
    
    private func showMessage(msg: String = LocalizedString.error.localized) {
        //show tost message with msg
    }
    
    private func resetUser() {
        UserInfo.loggedInUserId = nil
        AppFlowManager.default.moveToLogoutNavigation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        printDebug("BaseVC deinit")
    }
}



extension BaseVC {
    
    /// Initial Setup
    @objc func initialSetup() {
    }
    
    /// Setup Fonts
    @objc func setupFonts() {
        
    }
    
    /// Setup Colors
    @objc func setupColors() {
        
    }
    
    /// Setup Texts
    @objc func setupTexts() {
        
    }
    
    /// Setup Layout
    //    @objc func setupLayout() {
    //
    //    }
    
    /// Setup up Nav Bar
    
    @objc func setupNavBar() {
        
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
    }
    
    @objc func keyboardWillHide(notification: Notification) {
    }
    
    func keyboardManagerVisible(_ state: Bool) {
        IQKeyboardManager.shared().isEnableAutoToolbar = state
    }
}

extension BaseVC {
    func setUpNavigationBar (title: String , buttonImage: UIImage) {
        guard let navigationBar = self.navigationController?.navigationBar else
        {
            return
        }
        let navigationBarAppearence = UINavigationBar.appearance()
        navigationBarAppearence.backgroundColor = AppColors.themeWhite
        //        navigationBarAppearence.barStyle
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = title
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = true
        let cancelButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem  = cancelButton
        //        self.contentInsetAdjustmentBehavior = .automatic
        self.extendedLayoutIncludesOpaqueBars = true
        navigationBar.shadowImage = UIImage(color: .clear)
    }
    
    @objc private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkForReachability(_ notification: Notification) {
        
    }
}

//MARK: UITextField delegate methods

extension BaseVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder();
    }
}

extension UITabBarController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
    }
}


///Price currency convertor
extension BaseVC{
    ///Price convertor for booking and Account Section
    func getConvertedPrice(for amount: Double, with rate:CurrencyConversionRate?, using font: UIFont, isForCancellation: Bool) -> NSMutableAttributedString{
        
        if let rate = rate{
            if isForCancellation{
                return amount.convertCancellationAmount(with: rate, using: font)
            }else{
                return amount.convertAmount(with: rate, using: font)
            }
        }else{
            return amount.amountInDelimeterWithSymbol.asStylizedPrice(using: font)
        }
    }
    
}
