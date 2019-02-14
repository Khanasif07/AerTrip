//
//  HotelFilterResultsVC.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private var oldOffset: CGPoint = .zero
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var hotelTableView: UITableView! {
        didSet {
            self.hotelTableView.delegate = self
            self.hotelTableView.dataSource = self
        }
    }
    @IBOutlet weak var headerView: TopNavigationView! {
        didSet{
            self.headerView.roundCornersByClipsToBounds(cornerRadius: 10.0)
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.configUI()
        self.registerNibs()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        guard 105...211 ~= yOffset else {return}

        if yOffset > oldOffset.y {
            //show
            self.headerView.animateBackView(isHidden: false)
            self.headerView.leftButton.setImage(#imageLiteral(resourceName: "save_icon_green"), for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "black_cross"), for: .normal)
        }
        else {
            //hide
            self.headerView.animateBackView(isHidden: true)
            self.headerView.leftButton.setImage(#imageLiteral(resourceName: "saveHotels"), for: .normal)
            self.headerView.firstRightButton.setImage(#imageLiteral(resourceName: "CancelButtonWhite"), for: .normal)
        }
        self.oldOffset = scrollView.contentOffset
    }
    
    //Mark:- Methods
    //==============
    private func configUI() {
        self.view.backgroundColor = .clear
        self.headerView.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.headerView.configureLeftButton(normalImage: #imageLiteral(resourceName: "saveHotels"), selectedImage: #imageLiteral(resourceName: "save_icon_green"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.headerView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "CancelButtonWhite"), selectedImage: #imageLiteral(resourceName: "black_cross"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        
    }
    
    private func registerNibs() {
        let nib = UINib(nibName: "HotelDetailsImgSlideCell", bundle: nil)
        self.hotelTableView.register(nib, forCellReuseIdentifier: "HotelDetailsImgSlideCell")
        let hotelInfoNib = UINib(nibName: "HotelRatingInfoCell", bundle: nil)
        self.hotelTableView.register(hotelInfoNib, forCellReuseIdentifier: "HotelRatingInfoCell")
        let loaderNib = UINib(nibName: "LoaderTableViewCell", bundle: nil)
        self.hotelTableView.register(loaderNib, forCellReuseIdentifier: "LoaderTableViewCell")
        let hotelInfoAddressNib = UINib(nibName: "HotelInfoAddressCell", bundle: nil)
        self.hotelTableView.register(hotelInfoAddressNib, forCellReuseIdentifier: "HotelInfoAddressCell")
        self.hotelTableView.register(HotelFilterResultFooterView.self, forHeaderFooterViewReuseIdentifier: "HotelFilterResultFooterView")
        let amenitiesNib = UINib(nibName: "HotelDetailAmenitiesCell", bundle: nil)
        self.hotelTableView.register(amenitiesNib, forCellReuseIdentifier: "HotelDetailAmenitiesCell")
        let tripAdvisorNib = UINib(nibName: "TripAdvisorTableViewCell", bundle: nil)
        self.hotelTableView.register(tripAdvisorNib, forCellReuseIdentifier: "TripAdvisorTableViewCell")
        self.hotelTableView.register(SearchBarHeaderView.self, forHeaderFooterViewReuseIdentifier: "SearchBarHeaderView")
        let hotelBedsNib = UINib(nibName: "HotelDetailsBedsTableViewCell", bundle: nil)
        self.hotelTableView.register(hotelBedsNib, forCellReuseIdentifier: "HotelDetailsBedsTableViewCell")
        let inclusionNib = UINib(nibName: "HotelDetailsInclusionTableViewCell", bundle: nil)
        self.hotelTableView.register(inclusionNib, forCellReuseIdentifier: "HotelDetailsInclusionTableViewCell")
    }
    
    //Mark:- IBOActions
    //=================
}

//Mark:- UITableView Delegate And Datasource
//==========================================
extension HotelDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsImgSlideCell", for: indexPath) as? HotelDetailsImgSlideCell  else { return UITableViewCell() }
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
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailAmenitiesCell", for: indexPath) as? HotelDetailAmenitiesCell  else { return UITableViewCell() }
                return cell
                
            case 5:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTableViewCell", for: indexPath) as? TripAdvisorTableViewCell  else { return UITableViewCell() }
                return cell
                
            default:
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsBedsTableViewCell", for: indexPath) as? HotelDetailsBedsTableViewCell  else { return UITableViewCell() }
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsInclusionTableViewCell", for: indexPath) as? HotelDetailsInclusionTableViewCell  else { return UITableViewCell() }
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
        case 1:
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchBarHeaderView") as? SearchBarHeaderView  else { return UITableViewHeaderFooterView() }
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
        case IndexPath(row: 5, section: 0):
            return 49.0
        case IndexPath(row: 0, section: 1):
            return 118.0
        case IndexPath(row: 1, section: 1):
            return 60.0
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
        case IndexPath(row: 5, section: 0):
            return 49.0
        case IndexPath(row: 0, section: 1):
            return 118.0
        case IndexPath(row: 1, section: 1):
            return 60.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNonzeroMagnitude
        switch section {
        case 1:
            return 112.0
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNonzeroMagnitude
        switch section {
        case 1:
            return 112.0
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
