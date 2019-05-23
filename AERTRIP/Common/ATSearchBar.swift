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
    
    var isMicEnabled: Bool = true {
        didSet {
            self.hideMiceButton(isHidden: !self.isMicEnabled)
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
    
    var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0) {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let xRatio = (self.width - (edgeInset.left + edgeInset.right)) / self.width
        let yRatio = (self.width - (edgeInset.top + edgeInset.bottom)) / self.width
        self.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
        
        var micX = (self.width - self.height) + 15.0
        
        if self.showsCancelButton {
            micX -= 58.0
        }
        self.micButton?.frame = CGRect(x: micX, y: 1.0, width: self.height, height: self.height)
    }
    
    private func initialSetup() {
        self.backgroundImage = UIImage()
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = AppColors.themeGray04
            textField.font = AppFonts.Regular.withSize(18.0)
            textField.tintColor = AppColors.themeGreen
        }
        
        self.tintColor = AppColors.themeGreen
        
        self.micButton = UIButton(frame: CGRect(x: (self.width - self.height) + 15.0, y: 1.0, width: self.height, height: self.height))
        self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .normal)
        self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .selected)
        
        self.micButton.addTarget(self, action: #selector(micButtonAction(_:)), for: .touchUpInside)
        
        self.hideMiceButton(isHidden: !self.isMicEnabled)
        self.addSubview(self.micButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }

    func hideMiceButton(isHidden: Bool) {
        self.micButton.isHidden = isHidden
        self.bringSubviewToFront(self.micButton)
    }
    
    @objc private func micButtonAction(_ sender: UIButton) {
        self.mDelegate?.searchBarDidTappedMicButton(self)
    }
    
    @objc private func textDidChange() {
        if self.isMicEnabled, (self.text ?? "").isEmpty {
            self.hideMiceButton(isHidden: false)
        }
        else {
            self.hideMiceButton(isHidden: true)
        }
    }
}
