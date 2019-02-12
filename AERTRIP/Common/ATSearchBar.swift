//
//  ATSearchBar.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ATSearchBarDelegate: UISearchBarDelegate {
//extension UISearchBarDelegate {

    func searchBarDidTappedMicButton(_ searchBar: ATSearchBar) //{} // called when mic button tapped
}

class ATSearchBar: UISearchBar {
    
    private(set) var micButton: UIButton!
    
    var isMicEnabled: Bool = false {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }

    var mDelegate: ATSearchBarDelegate? {
        didSet {
            self.delegate = self.mDelegate
        }
    }

    private func initialSetup() {
        self.backgroundImage = UIImage()
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = AppColors.themeGray04
            textField.font = AppFonts.Regular.withSize(17.0)
            textField.tintColor = AppColors.themeGreen
        }
        
        self.micButton = UIButton(frame: CGRect(x: (self.width - self.height), y: 0.0, width: self.height, height: self.height))
        self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .normal)
        self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .selected)
        
        self.micButton.addTarget(self, action: #selector(micButtonAction(_:)), for: .touchUpInside)
        self.addSubview(self.micButton)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc private func micButtonAction(_ sender: UIButton) {
        self.mDelegate?.searchBarDidTappedMicButton(self)
    }
    
    //    @objc private func didBeganEditing() {
    //        if self.isMicEnabled {
    //            self.micButton.isHidden = true
    //        }
    //        else {
    //            self.micButton.isHidden = true
    //        }
    //    }
    
    //    @objc private func didEndEditing() {
    //        if self.isMicEnabled, (self.text ?? "").isEmpty {
    //            self.micButton.isHidden = false
    //        }
    //        else {
    //            self.micButton.isHidden = true
    //        }
    //    }
    
    @objc private func textDidChange() {
        if self.isMicEnabled, (self.text ?? "").isEmpty {
            self.micButton.isHidden = false
        }
        else {
            self.micButton.isHidden = true
        }
    }
}
