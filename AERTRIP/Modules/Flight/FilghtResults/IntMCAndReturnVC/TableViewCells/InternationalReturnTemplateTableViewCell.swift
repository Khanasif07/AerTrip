//
//  SingleJourneyResultTableViewCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


class InternationalReturnTemplateTableViewCell: UITableViewCell
{
    //MARK:- Outlets
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var smartIconCollectionView: UICollectionView!
    @IBOutlet weak var multiFlightsTableView: UITableView!
    @IBOutlet weak var multiFlighrsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var samePriceOptionsLabel: UILabel!
    @IBOutlet weak var samePriceOptionButton: UIButton!
    @IBOutlet weak var optionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var baseViewTopConstraint: NSLayoutConstraint!

    
    var pinnedRoundedLayer : CALayer?
    var smartIconsArray : [String]?
    var baggageSuperScript : NSAttributedString?
    var currentJourney : Journey?
   var numberOfLegs = 0
    var isFirstCell: Bool = false {
        didSet {
            updateTopConstraints()
        }
    }
    
    //MARK:- Setup Methods
    fileprivate func setupBaseView() {
        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        self.baseView.layer.cornerRadius = 10
        
        self.baseView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeRed.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        setupBaseView()
        setupGradientView()
        setUpTableView()
        self.addShimmerEffect(to: [self.price] )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpTableView(){
        multiFlightsTableView.register(UINib(nibName: "InternationalReturnJourneyTemplateCell", bundle: nil), forCellReuseIdentifier: "InternationalReturnJourneyTemplateCell")
        multiFlightsTableView.separatorStyle = .none
        multiFlightsTableView.rowHeight = UITableView.automaticDimension
        multiFlightsTableView.separatorStyle = .none
        multiFlightsTableView.isScrollEnabled = false
        multiFlightsTableView.bounces = false
        multiFlightsTableView.dataSource = self
        multiFlightsTableView.delegate = self
    }
    
    fileprivate func setupGradientView( selectedColor : UIColor = UIColor.white)
    {
        let gradient = CAGradientLayer()
        let gradientViewRect = gradientView.bounds
        
        gradient.frame =  gradientViewRect
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [selectedColor.withAlphaComponent(0.0).cgColor,selectedColor.withAlphaComponent(1.0).cgColor,selectedColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.5),NSNumber(value: 1.0)]
        gradientView.layer.backgroundColor = UIColor.clear.cgColor
        
        gradientView.layer.sublayers = nil
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func populateData(){
        multiFlightsTableView.reloadData()
        self.multiFlighrsTableViewHeight.constant = CGFloat(66 * numberOfLegs)
    }
    
    func updateTopConstraints() {
        self.baseViewTopConstraint.constant = isFirstCell ? 10 : 8
        self.contentView.layoutIfNeeded()
    }
    
}

//MARK:- Tableview DataSource , Delegate Methods
extension InternationalReturnTemplateTableViewCell : UITableViewDataSource , UITableViewDelegate {

     func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return numberOfLegs
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Double.leastNonzeroMagnitude)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Double.leastNonzeroMagnitude)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return getSingleJourneyCell(indexPath: indexPath)
    }
    
    func getSingleJourneyCell (indexPath : IndexPath) -> UITableViewCell {
        guard let cell =  multiFlightsTableView.dequeueReusableCell(withIdentifier: "InternationalReturnJourneyTemplateCell") as? InternationalReturnJourneyTemplateCell else {
            return UITableViewCell() }
    
        return cell
    }

}
