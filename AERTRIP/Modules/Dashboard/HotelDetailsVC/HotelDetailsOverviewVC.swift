//
//  HotelDetailsOverviewVC.swift
//  AERTRIP
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class HotelDetailsOverviewVC: BaseVC {

    //Mark:- Variables
    //================
    let overViewText: String = ""
    let viewModel = HotelDetailsOverviewVM()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var overViewTextViewOutlet: UITextView! {
        didSet {
            self.overViewTextViewOutlet.contentInset = UIEdgeInsets(top: 28.0, left: 16.0, bottom: 20.0, right: 16.0)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
//        let text = self.viewModel.overViewInfo.htmlToAttributedString
        self.overViewTextViewOutlet.attributedText = self.viewModel.overViewInfo.htmlToAttributedString
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
