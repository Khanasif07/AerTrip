//
//  FlightFilterAmenitiesViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/02/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightFilterAmenitiesViewController: UIViewController , FilterViewController {
    func initialSetup() {
        
    }
    
    func updateUIPostLatestResults() {
    
    }
    

    @IBOutlet weak var amentiesTableView: UITableView!
  
    var amenityCollectionArray = [AmenityCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAmentiesCollections()
        setupAmentiesTableView()
       
    }

    fileprivate func setupAmentiesTableView() {

        amentiesTableView.separatorStyle = .none
        amentiesTableView.register(UINib(nibName:"RadioButtonTableViewCell" , bundle: nil), forCellReuseIdentifier: "RadioButtonCell")
        
    }

    fileprivate func setupAmentiesCollections() {
    
        // Seats
        let seatAmenities = [ Amenity(name: "Recliner seat", image: "ReclinerSeat", isSelected: false),
                              Amenity(name: "Cradle recliner", image: "CradleRecliner", isSelected: false),
                              Amenity(name: "Below avg. legroom", image: "BelowAvgLegroom", isSelected: false),
                              Amenity(name: "Standard legroom", image: "StandardLegroom", isSelected: false),
                              Amenity(name: "Above avg. legroom", image: "extraLegroom", isSelected: false),
                              Amenity(name: "Private suite", image: "privateSuite", isSelected: false),
                              Amenity(name: "Angle flat seat", image: "angledFlat", isSelected: false),
                              Amenity(name: "Middle seat free", image: "MiddleSeatFree", isSelected: false),
                              Amenity(name: "Full flat pod/Full flat seat", image: "FullFlatSeat", isSelected: false),
                              Amenity(name: "Sky Couch", image: "skyCouch", isSelected: false)]
        
        let seatAmenitiesCollection = AmenityCollection(name: "Seat", items: seatAmenities, collapsed: false)
        amenityCollectionArray.append(seatAmenitiesCollection)
        
        // Meals
       let mealAmenities = [ Amenity(name: "Meal", image: "Meal", isSelected: false),
                             Amenity(name: "Meal (Paid)", image: "Meal", isSelected: false),
                             Amenity(name: "Premium meal", image: "PremiumMeal", isSelected: false),
                             Amenity(name: "Premium meal (Paid)", image: "PremiumMeal", isSelected: false)]
        
        let mealAmenitiesCollection = AmenityCollection(name: "Meal", items: mealAmenities)
        amenityCollectionArray.append(mealAmenitiesCollection)
        
        // Wifi Amenties
        let wifiAmenities = [ Amenity(name: "Free Wi-Fi", image: "Wifi", isSelected: false),
                              Amenity(name: "Paid Wi-Fi", image: "Wifi", isSelected: false)]
        
        let wifiAmenitiesCollection = AmenityCollection(name: "Wi-Fi", items: wifiAmenities)
        amenityCollectionArray.append(wifiAmenitiesCollection)
        
        // Entertainment Amenities
        let entertainmentAmenities = [ Amenity(name: "Personal device entertainment", image: "PersonalDevice", isSelected: false),
                              Amenity(name: "On demand & live TV", image: "OnDemandLiveTv", isSelected: false),
                              Amenity(name: "Entertainment available", image: "EntertainmentAvailable", isSelected: false),
                              Amenity(name: "Overhead entertainment", image: "OverheadEntertainment", isSelected: false)]
        
        let entertainmentAmenitiesCollection = AmenityCollection(name: "Entertainment", items: entertainmentAmenities)
        amenityCollectionArray.append(entertainmentAmenitiesCollection)
        
        // Power Amenities
        let powerAmenities = [ Amenity(name: "Power & USB outlets", image: "Power&USBoutlets", isSelected: false),
                                       Amenity(name: "Power outlet", image: "PowerOutlet", isSelected: false),
                                       Amenity(name: "USB outlet", image: "usbOutlet", isSelected: false),
                                       Amenity(name: "Requires adaptor", image: "requiresAdaptor", isSelected: false)]
        
        let powerAmenitiesCollection = AmenityCollection(name: "Power", items: powerAmenities)
        amenityCollectionArray.append(powerAmenitiesCollection)
        
        // Drink Amenities
        let drinkAmenities = [ Amenity(name: "Alcoholic", image: "AlcoholicDrink", isSelected: false),
                               Amenity(name: "Alcoholic (Paid)", image: "AlcoholicDrink", isSelected: false),
                               Amenity(name: "Premium alcoholic", image: "PremiumAlcohol", isSelected: false),
                               Amenity(name: "Premium alcoholic (Paid)", image: "PremiumAlcohol", isSelected: false),
                                Amenity(name: "Alcoholic & nonalcoholic", image: "beverage", isSelected: false)]
        
        let drinkAmenitiesCollection = AmenityCollection(name: "Drinks", items: drinkAmenities)
        amenityCollectionArray.append(drinkAmenitiesCollection)
        

        // Windows Size
        let windowSizeAmenities = [Amenity(name: "Standard window size", image: "windowSizeSmaller", isSelected: false),
                               Amenity(name: "Bigger window size", image: "windowSizeBigger", isSelected: false)]
        
        let windowSizeAmenitiesCollection = AmenityCollection(name: "Windows Size", items: windowSizeAmenities)
        
        amenityCollectionArray.append(windowSizeAmenitiesCollection)
        
        
        // Cabin Pressure
        let CPAmenities = [Amenity(name: "Air Pressure Enhanced", image: "airPressureEnhanced", isSelected: false),
                           Amenity(name: "Air Pressure Unpressurized", image: "airPressureUnpressurized", isSelected: false)]
        
        let CPCollection = AmenityCollection(name: "Cabin Pressure", items: CPAmenities)
        
        amenityCollectionArray.append(CPCollection)
    }
    
    
    @objc func amenityHeaderTapped(_ button : UIButton)
    {
        
        var amenityCollection = amenityCollectionArray[button.tag]
        
        if (button.isSelected) {
            button.isSelected = false
            amenityCollection.isSelected = false
            amenityCollection.collapsed = true
            
        }else {
            button.isSelected = true
            amenityCollection.isSelected = true
            amenityCollection.collapsed = false
        }
        
        amenityCollection.items = amenityCollection.items.map{
            var amenity = $0
            amenity.isSelected = button.isSelected
            return amenity
        }
        
        amenityCollectionArray[button.tag] = amenityCollection
        
         amentiesTableView.reloadSections(IndexSet(integer:button.tag), with: .fade)
    }
    
    @objc func amenityTapped(_ button : UIButton)
    {
        if (button.isSelected) {
            button.isSelected = false
        }else {
            button.isSelected = true
        }
        
        let tag = button.tag
        let section =  (tag / 1000)
        let row = tag % 1000
        
        var amenityCollection = amenityCollectionArray[section]
        var amenity = amenityCollection.items[row]
        amenity.isSelected = button.isSelected
        
        amenityCollection.items[row] = amenity

        let sectionHeaderSelected = amenityCollection.items.reduce(true) { (result, next) -> Bool in
            return result &&  next.isSelected
        }
        
        amenityCollection.isSelected = sectionHeaderSelected
        amenityCollectionArray[section] = amenityCollection
        amentiesTableView.reloadData()

    }
    
    func resetFilter() {
        
        //        currentTimerFilter
        
    }
    
}

extension FlightFilterAmenitiesViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return amenityCollectionArray[section].collapsed ? 0 : amenityCollectionArray[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonCell") as? RadioButtonTableViewCell {
            
            cell.selectionStyle = .none
            let amenity = amenityCollectionArray[indexPath.section].items[indexPath.row]
            cell.textLabel?.text = amenity.name
            cell.imageView?.image = UIImage(named: amenity.image)
            
            cell.radioButton.isSelected = amenity.isSelected
            cell.radioButton.tag =  indexPath.section * 1000 + indexPath.row
            cell.radioButton.addTarget(self, action: #selector(amenityTapped(_:)) , for: .touchDown)
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return amenityCollectionArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 26.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        let x = self.view.frame.size.width - 50
        let title = UILabel(frame: CGRect(x: 16, y: 0, width: x - 16 , height: 44.0))
        title.font = UIFont(name: "SourceSansPro-Semibold", size: 18)
        title.text = amenityCollectionArray[section].name
        headerView.addSubview(title)
        
        
        let separatorView = UIView(frame:  CGRect(x: 16, y: 43.5, width: self.view.frame.width - 16, height: 0.5))
        separatorView.backgroundColor = UIColor.TWO_ZERO_FOUR_COLOR
        headerView.addSubview(separatorView)
        
        if (section != 0 ) {
            let button = UIButton(frame: CGRect(x: x, y: 0, width: 44, height: 44))
 
            button.setImage(AppImages.UncheckedGreenRadioButton, for: .normal)
            button.setImage(AppImages.CheckedGreenRadioButton, for: .selected)
            button.tag = section
            button.isSelected = amenityCollectionArray[section].isSelected
            button.addTarget(self, action: #selector(amenityHeaderTapped(_:)),  for: .touchDown)
            headerView.addSubview(button)
        }
        
        return headerView
    }
    

}
