//
//  AerinVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinVC: BaseVC {
    
    //MARK:- Properties
    //MARK:- Private
    private var pulsAnimation = PKPulseAnimation()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var aerinButton: UIButton!
    @IBOutlet weak var commandHintLabel: UILabel!
    @IBOutlet weak var aerinContainer: UIView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialSetup() {
        
        self.pulsAnimation.numPulse = 5
        self.pulsAnimation.radius = 100.0
        self.pulsAnimation.backgroundColor = AppColors.themeGray60.cgColor
        self.aerinContainer.layer.insertSublayer(self.pulsAnimation, below: self.aerinButton.layer)
        self.pulsAnimation.start()
    }
    
    override func setupFonts() {
        self.messageLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.pulsAnimation.position = CGPoint(x: self.aerinContainer.frame.width/2.0, y: self.aerinContainer.frame.height/2.0)
    }
    
    override func setupTexts() {
        let greetingAttrTxt = NSMutableAttributedString(string: LocalizedString.hiImAerin.localized, attributes: [.font: AppFonts.ExtraLight.withSize(28.0), .foregroundColor: AppColors.themeTextColor])
        greetingAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(28.0), range: (greetingAttrTxt.string as NSString).range(of: "Aerin"))
        self.greetingLabel.attributedText = greetingAttrTxt
        
        self.messageLabel.text = LocalizedString.yourPersonalTravelAssistant.localized
        
        let commandAttrTxt = NSMutableAttributedString(string: LocalizedString.tryAskingForFlightsFromMumbai.localized, attributes: [.font: AppFonts.ExtraLight.withSize(16.0), .foregroundColor: AppColors.themeTextColor])
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Flights"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Mumbai"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Delhi"))
        commandAttrTxt.addAttribute(.font, value: AppFonts.Regular.withSize(16.0), range: (commandAttrTxt.string as NSString).range(of: "Christmas"))
        self.commandHintLabel.attributedText = commandAttrTxt
    }
    
    override func setupColors() {
        self.messageLabel.textColor = AppColors.themeTextColor
    }
    
    //MARK:- Methods
    //MARK:- Private

    //MARK:- Public
    
    
    //MARK:- Action
}
