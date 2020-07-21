//
//  FlightDetailsTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 16/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightDetailsTableViewCell: UITableViewCell
{
    //MARK:- Outlets

    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var flightNameView: UIView!
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classNameLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var onArrivalPerformanceLabel: UILabel!
    @IBOutlet weak var onArrivalPerformanceView: UIView!
    @IBOutlet weak var onArrivalPerformanceViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var departureAirportLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureAirportAddressLabel: UILabel!
    @IBOutlet weak var departureTerminalLabel: UILabel!
    
    @IBOutlet weak var travellingTimeImageView: UIImageView!
    @IBOutlet weak var travelingtimeLabel: UILabel!
    @IBOutlet weak var equipmentsLabel: UILabel!
    
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalAirportAddressLabel: UILabel!
    @IBOutlet weak var arrivalTerminalLabel: UILabel!

    @IBOutlet weak var arrivalPerformaceButton: UIButton!
    @IBOutlet weak var amenitiesDisplayView: UIView!
    @IBOutlet weak var amenitiesDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    @IBOutlet weak var onTimePerformanceSubView: UIView!
    @IBOutlet weak var onTimePerformanceSubViewWidth: NSLayoutConstraint!
    @IBOutlet weak var delayedPerformanceSubView: UIView!
    @IBOutlet weak var delayedPerformanceSubViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cancelledPerformanceSubView: UIView!
    @IBOutlet weak var cancelledPerformanceSubViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var topSeperatorView: UILabel!
    @IBOutlet weak var topSeperatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeperatorView: UILabel!
    @IBOutlet weak var displayViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration

    var amenitiesData = [String]()
    weak var amenitiesDelegate:getSelectedAmenitiesDelegate?
    
    var flightIndex = 0
    var flights : [FlightDetail]?
    var journey: Journey!
    var airportDetailsResult : [String : AirportDetailsWS]!

    var onTimePerformanceInPercent = 0
    var delayedPerformanceInPercent = 0
    var cancelledPerformanceInPercent = 0

    
    //MARK:- Init Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = UIColor.ONE_ZORE_TWO_COLOR.cgColor
        caShapeLayer.lineWidth = 0.5
        caShapeLayer.lineDashPattern = [2,3]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        dashedView.layer.addSublayer(caShapeLayer)
        
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self

        onArrivalPerformanceView.clipsToBounds = true
        onArrivalPerformanceView.layer.cornerRadius = 1.5
        
        self.amenitiesCollectionView.register(UINib.init(nibName: "FlightAmenitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FlightAmenitiesCell")
        
        airlineImageView.layer.cornerRadius = 3

        arrivalDateLabel.layer.cornerRadius = 3
        arrivalAirportLabel.layer.cornerRadius = 3
        arrivalTerminalLabel.layer.cornerRadius = 3

        departureDateLabel.layer.cornerRadius = 3
        departureAirportLabel.layer.cornerRadius = 3
        departureTerminalLabel.layer.cornerRadius = 3
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topSeperatorView.isHidden = true
        topSeperatorViewHeight.constant = 0        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FlightDetailsTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return amenitiesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let amenitiesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightAmenitiesCell", for: indexPath) as! FlightAmenitiesCollectionViewCell
        
//        if amenitiesData[indexPath.row]
        amenitiesCell.amenitiTitleLabel.textColor = AppColors.themeGray60
        amenitiesCell.amenitiTitleLabel.text = amenitiesData[indexPath.row]
        if amenitiesData[indexPath.row].contains(find: "Cabbin"){
            amenitiesCell.amenitiesImageView.image = UIImage(named: "cabinBaggage")
        }else if amenitiesData[indexPath.row].contains(find: "Check-in"){
            amenitiesCell.amenitiesImageView.image = UIImage(named: "checkingBaggageKg")
        }else{
            amenitiesCell.amenitiesImageView.image = nil
        }
        
        return amenitiesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        amenitiesDelegate?.getSelectedAmenities(amenitiesData: ["amenityName":amenitiesData[indexPath.row]], index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width/3-10, height: collectionView.frame.size.height)
    }
}
