//
//  FlightsVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- IBOutlets
    //MARK:-
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.imageView.isHidden = true
        if !AppConstants.isReleasingToClient {
            self.imageView.isHidden = false
            self.imageView.contentMode = .scaleToFill
            self.imageView.clipsToBounds = true
            self.imageView.image = #imageLiteral(resourceName: "gettyimages")
            self.imageView.isUserInteractionEnabled = true
            self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        }
    }
    
    //MARK:- Public
    @objc func imageTapped() {
//        if let topVC = UIApplication.topViewController() {
//            ATGalleryViewController.show(onViewController: topVC, sourceView: self.imageView, datasource: self, delegate: self)
//        }
        
        if let topVC = UIApplication.topViewController() {
            let dataVC = HotelsGroupExpendedVC.instantiate(fromAppStoryboard: .HotelsSearch)
            
            let sheet = PKBottomSheet.instanceFromNib
            sheet.headerHeight = 24.0
            sheet.headerView = dataVC.headerView
            sheet.frame = topVC.view.bounds
            sheet.delegate = dataVC
            topVC.view.addSubview(sheet)
            sheet.present(presentedViewController: dataVC, animated: true)
        }

    }
    
    //MARK:- Action
    @IBAction func ShowHotelResultsVC(_ sender: UIButton) {
        //AppFlowManager.default.showHotelDetailsVC(hotelInfo: HotelSearched)
    }
}

extension FlightsVC: ATGalleryViewDelegate, ATGalleryViewDatasource {

    func numberOfImages(in galleryView: ATGalleryViewController) -> Int {
        return 10
    }
    
    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage {
        var image = ATGalleryImage()
        
        image.image = #imageLiteral(resourceName: "gettyimages")
        
        return image
    }
    
    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int) {
        printDebug("willShow \(index)")
    }
}
