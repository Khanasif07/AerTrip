//
//  SocialLoginVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SocialLoginVC: UIViewController {

    //MARK:- Properties
    //MARK:-
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var newRegisterLabel: UILabel!
    @IBOutlet weak var existingUserLabel: UILabel!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- IBActions
    //MARK:-
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func linkedInLoginButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func newRegistrationButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func existingUserButtonAction(_ sender: UIButton) {
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension SocialLoginVC {
    
    func initialSetups() {
        
        let attributedString = NSMutableAttributedString(string: "I’m New\nRegister", attributes: [
            .font: UIFont(name: "SourceSansPro-Regular", size: 14.0)!,
            .foregroundColor: UIColor.black
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!, range: NSRange(location: 0, length: 7))
        self.newRegisterLabel.attributedText = attributedString
        
        let existingUserString = NSMutableAttributedString(string: "Existing User\nSign in", attributes: [
            .font: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!,
            .foregroundColor: UIColor.black
            ])
        existingUserString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)!, range: NSRange(location: 14, length: 7))
        self.existingUserLabel.attributedText = existingUserString
    }
}
