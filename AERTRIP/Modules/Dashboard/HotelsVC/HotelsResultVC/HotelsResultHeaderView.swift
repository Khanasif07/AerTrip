//
//  SlideMenuProfileImageHeaderView.swift
//  AERTRIP
//
//  Created by apple on 17/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelsResultHeaderViewDelegate:class {
    func backButtonAction(_ sender: UIButton)
}

class HotelsResultHeaderView: UIView {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var mapImageView: UIImageView!

    @IBOutlet weak var mapView: UIView!
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HotelsResultHeaderViewDelegate?
    
    //MARK:- Private
    
    //MARK:- View Life cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupFontsAndText()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // self.backgroundImageView.frame = self.bounds
    }
    
    //MARK:- Methods
    //MARK:- Public
    class func instanceFromNib(isFamily: Bool = false) -> HotelsResultHeaderView {
        let parentView = UINib(nibName: "HotelsResultHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HotelsResultHeaderView
        
        return parentView
    }
    
    //MARK:- Private
    private func setupFontsAndText() {

    }
}
