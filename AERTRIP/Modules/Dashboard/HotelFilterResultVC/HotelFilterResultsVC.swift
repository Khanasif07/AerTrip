//
//  HotelFilterResultsVC.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelFilterResultsVC: BaseVC {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            self.hotelTableView.delegate = self
            self.hotelTableView.dataSource = self
        }
    }
    @IBOutlet weak var hotelTableViewHeightConstraint: NSLayoutConstraint!

    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.registerNibs()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.transform = CGAffineTransform(translationX: 0.0, y: scrollView.contentOffset.y)
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        self.hotelTableViewHeightConstraint.constant = self.hotelTableView.contentSize.height
//    }
    
    //Mark:- Methods
    //==============
    private func registerNibs() {
        let nib = UINib(nibName: "HotelFilterImgSlideCell", bundle: nil)
        self.hotelTableView.register(nib, forCellReuseIdentifier: "HotelFilterImgSlideCell")
        let hotelInfoNib = UINib(nibName: "HotelRatingInfoCell", bundle: nil)
        self.hotelTableView.register(hotelInfoNib, forCellReuseIdentifier: "HotelRatingInfoCell")
        let loaderNib = UINib(nibName: "LoaderTableViewCell", bundle: nil)
        self.hotelTableView.register(loaderNib, forCellReuseIdentifier: "LoaderTableViewCell")
        let hotelInfoAddressNib = UINib(nibName: "HotelInfoAddressCell", bundle: nil)
        self.hotelTableView.register(hotelInfoAddressNib, forCellReuseIdentifier: "HotelInfoAddressCell")
        self.hotelTableView.register(HotelFilterResultHeaderView.self, forHeaderFooterViewReuseIdentifier: "HotelFilterResultHeaderView")
        self.hotelTableView.register(HotelFilterResultFooterView.self, forHeaderFooterViewReuseIdentifier: "HotelFilterResultFooterView")
        let amenitiesNib = UINib(nibName: "AmenitiesTableViewCell", bundle: nil)
        self.hotelTableView.register(amenitiesNib, forCellReuseIdentifier: "AmenitiesTableViewCell")
    }
    
    //Mark:- IBOActions
    //=================
}

//Mark:- UITableView Delegate And Datasource
//==========================================
extension HotelFilterResultsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        switch section {
//        case 0:
//            return 4
//        default:
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelFilterImgSlideCell", for: indexPath) as? HotelFilterImgSlideCell  else { return UITableViewCell() }
                return cell
                
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRatingInfoCell", for: indexPath) as? HotelRatingInfoCell  else { return UITableViewCell() }
                return cell
                
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                cell.configureAddressCell()
                return cell
                
            case 3:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelInfoAddressCell", for: indexPath) as? HotelInfoAddressCell  else { return UITableViewCell() }
                cell.configureOverviewCell()
                return cell
               
            case 4:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AmenitiesTableViewCell", for: indexPath) as? AmenitiesTableViewCell  else { return UITableViewCell() }
                return cell
                
            default:
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelFilterResultHeaderView") as? HotelFilterResultHeaderView  else { return UITableViewHeaderFooterView() }
            
            return headerView
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HotelFilterResultFooterView") as? HotelFilterResultFooterView  else { return UITableViewHeaderFooterView()
            }
            return footerView

        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return 211.0
        case IndexPath(row: 1, section: 0):
            return 126.5
        case IndexPath(row: 2, section: 0):
            return 137.0
        case IndexPath(row: 3, section: 0):
            return 137.0
        case IndexPath(row: 4, section: 0):
            return 144.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return 211.0
        case IndexPath(row: 1, section: 0):
            return 126.5
        case IndexPath(row: 2, section: 0):
            return 137.0
        case IndexPath(row: 3, section: 0):
            return 137.0
        case IndexPath(row: 4, section: 0):
            return 144.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
}
