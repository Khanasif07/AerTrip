//
//  BaseVC.swift
//
//
//  Created by Pramod Kumar on 10/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.


import UIKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(_:)), name: .dataChanged, object: nil)

        self.initialSetup()
        self.setupFonts()
        self.setupTexts()
        self.setupColors()
    
        self.bindViewModel()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        delay(seconds: 0.1) {
            self.setupLayout()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpNagigationBarUI()
        self.registerLogoutNotification()
        
        UIView.appearance().semanticContentAttribute = LanguageEnum.isLanguageEnglish ? .forceLeftToRight : .forceRightToLeft

        self.navigationController?.isNavigationBarHidden = self.hideNavigaitonBar()
        self.navigationController?.navigationBar.tintColor = self.navigationBarTint()

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = self.statusBarColorDefault ?  .default : .lightContent
        
        if let nav = self.navigationController {
            AppFlowManager.default.setCurrentTabbarNavigationController(navigation: nav)
        }
    }
    
    func setUpNagigationBarUI() {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        self.deRegisterLogoutNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    var statusBarColorDefault: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: Overrideabel functions
    
    func onBackPress() {
        self.navigationController?.popViewController(animated: true);
    }
    
    func hideNavigaitonBar() -> Bool {
        return false
    }
    
    func navigationBarTint() -> UIColor {
        return .white
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
    
    final func showLoaderOnView(view:UIView, show:Bool) {
        let indicator = UIActivityIndicatorView(style: .gray)
        if show {
            view.addSubview(indicator)
            indicator.startAnimating()
            indicator.isHidden = !show
            
        } else {
            indicator.stopAnimating()
            indicator.isHidden = !show
        }
    }
    
    @objc final func sessionExpired() {
        self.resetUser()
        self.showMessage()
    }

    @objc func dataChanged(_ note: Notification) {
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
    }
}


extension BaseVC {
    
    /// Initial Setup
    @objc func initialSetup() {
        self.automaticallyAdjustsScrollViewInsets = false
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
    @objc func setupLayout() {
        
    }
}

//MARK: UITextField delegate methods

extension BaseVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder();
    }
}

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    open override var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
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
