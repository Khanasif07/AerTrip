//
//  FareInfoCombineCell.swift
//  AERTRIP
//
//  Created by Admin on 03/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FareInfoCombineCell: UITableViewCell {
    
    @IBOutlet weak var combineFareTableView: UITableView!
    @IBOutlet weak var noInfoView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var model: BookingFeeDetail?
    var isForPassenger : Bool = false
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        combineFareTableView.register(UINib(nibName: "FareInfoCommonCell", bundle: nil), forCellReuseIdentifier: "FareInfoCommonCell")
        combineFareTableView.estimatedRowHeight = 85
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(model: BookingFeeDetail) {
        self.model = model
        combineFareTableView.reloadData()
    }
    
}
extension FareInfoCombineCell:UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            if section == 0{
                //            if airlineCancellationFees.count > 0{
                if let airlineCancellationSlabCount = model?.aerlineCanCharges?.adult?.count
                                {
                                    return airlineCancellationSlabCount
                                }else{
                                    return 0
                                }
                //            }else{
                //                return 0
                //            }
            }else{
                //            if airlineReschedulingFees.count > 0{
                if let airlineReschedulingSlabCount = model?.aerlineResCharges?.adult?.count{
                                    return airlineReschedulingSlabCount
                                }else{
                                    return 0
                                }
                //            }else{
                //                return 0
                //            }
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: FareInfoCommonCell.reusableIdentifier, for: indexPath) as? FareInfoCommonCell else {
            return UITableViewCell()
        }
        cell.flightAdultCount = self.flightAdultCount
        cell.flightChildrenCount = self.flightChildrenCount
        cell.flightInfantCount = self.flightInfantCount
        if let object = model {
        cell.configureView(model: object, indexPath: indexPath)
        }
        self.combineFareTableView.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    //
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//    {
//        if section == 1{
//            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
//            footerView.backgroundColor = .white
//
//            let innerView = UIView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height:45))
//            innerView.backgroundColor = UIColor(displayP3Red: (246.0/255.0), green: (246.0/255.0), blue: (246.0/255.0), alpha: 1.0)
//            footerView.addSubview(innerView)
//
//
//            let seperatorView = UIView(frame:CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 0.6))
//            seperatorView.backgroundColor = UIColor(displayP3Red: (204.0/255.0), green: (204.0/255.0), blue: (204.0/255.0), alpha: 1.0)
//            footerView.addSubview(seperatorView)
//
//            return footerView
//        }else{
//            return UIView()
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
//        if section == 1{
//            return 55
//        }else{
//            return CGFloat.leastNormalMagnitude
//        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
                tableView.layoutIfNeeded()
                tableView.layoutSubviews()
                tableView.setNeedsDisplay()
    }
    
    func minutesToHoursMinutes (seconds : Int) -> (Int) {
        return (seconds / 3600)
    }
    
    //MARK:- Format Price
    func getPrice(price:Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_IN")
        if var result = formatter.string(from: NSNumber(value: price)){
            if result.contains(find: ".00"){
                result = result.replacingOccurrences(of: ".00", with: "", options: .caseInsensitive, range: Range(NSRange(location:result.count-3,length:3), in: result) )
            }
            return result
        }else{
            return "\(price)"
        }
        
        
    }
}
