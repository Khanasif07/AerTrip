//
//  TripsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

class TripsVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    private var previousOffSet = CGPoint.zero
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var comingSoonLabel: UILabel!
    @IBOutlet weak var noteLabel: ActiveLabel!
    @IBOutlet weak var labelStackView: UIStackView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.delegate = self
        // Do any additional setup after loading the view.
        self.initialSetups()
        
        print( UIDevice.modelName)
        
//        UIDevice.modelName//"iPhone SE"
        
        if isSEDevice{
            tripImageView.contentMode = .scaleAspectFit
        }else{
            tripImageView.contentMode = .scaleAspectFill
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.comingSoonLabel.textAlignment = .center
        self.noteLabel.textAlignment = .center
        comingSoonLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.noteLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.comingSoonLabel.textColor = AppColors.themeWhite
        self.noteLabel.textColor = AppColors.themeWhite
        
        self.comingSoonLabel.text = LocalizedString.tripsComingSoon.localized
        self.noteLabel.text = LocalizedString.tripsNote.localized
        
        self.comingSoonLabel.AttributedFontForText(text: "Coming soon…", textFont: AppFonts.SemiBold.withSize(28.0))
        self.linkSetupForTrips(withLabel: noteLabel)
    }
    
    func linkSetupForTrips(withLabel: ActiveLabel) {
        // Commenting fare rules text as It is not required now - discussed with Nitesh.
        
        let trips = ActiveType.custom(pattern: "\\s\(LocalizedString.tripsLink.localized)\\b")
        
        let allTypes: [ActiveType] = [trips]
        let textToDisplay = LocalizedString.tripsNote.localized
        
        withLabel.enabledTypes = allTypes
        withLabel.customize { [unowned self] label in
            label.font = AppFonts.SemiBold.withSize(16.0)
            label.text = textToDisplay
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                return atts
            }
            for item in allTypes {
                label.customColor[item] = AppColors.themeWhite
                label.customSelectedColor[item] = AppColors.themeWhite
            }
            
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 16.0
            
            label.handleCustomTap(for: trips) { _ in
                
                guard let url = URL(string: AppConstants.tripsUrl) else { return }
                AppFlowManager.default.showURLOnATWebView(url, screenTitle: "Trips")
            }
        }
    }
    
    //MARK:- Public
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffSet.y
        
        if let parent = parent as? DashboardVC {
            if difference > 0 {
                // check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height {
                    if scrollView.contentOffset.y > 0.0 {
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            } else {
                if parent.mainScrollView.contentOffset.y > 0.0 {
                    if scrollView.contentOffset.y <= 0.0 {
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        
        self.previousOffSet = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = parent as? DashboardVC else { return }
        parent.innerScrollDidEndDragging(scrollView)
    }
    
    //MARK:- Action
}
