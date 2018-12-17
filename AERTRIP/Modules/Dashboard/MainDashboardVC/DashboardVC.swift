//
//  DashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class DashboardHeaderCell: UITableViewCell {
    @IBOutlet weak var profileButton: ATNotificationButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class DashboardSegmentCell: UITableViewCell {
    
    @IBOutlet weak var aerinTitleLabel: UILabel!
    @IBOutlet weak var flightsTitleLabel: UILabel!
    @IBOutlet weak var hotelsTitleLabel: UILabel!
    @IBOutlet weak var tripsTitleLabel: UILabel!
    
    @IBOutlet weak var aerinContainerView: UIView!
    @IBOutlet weak var flightsContainerView: UIView!
    @IBOutlet weak var hotelsContainerView: UIView!
    @IBOutlet weak var tripsContainerView: UIView!
    
    @IBOutlet weak var aerinHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var flightHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tripHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


class DashboardBottomScrollCell: UITableViewCell {
    @IBOutlet weak var bottomScrollView: UIScrollView! {
        didSet {
            bottomScrollView.alwaysBounceHorizontal = false
            bottomScrollView.alwaysBounceVertical = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


class DashboardVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var headerView: DashboardSegmentCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension DashboardVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [44.0, UIDevice.screenHeight][indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0.0, 110.0][section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            //return segment header
            if self.headerView == nil {
                self.headerView = tableView.dequeueReusableCell(withIdentifier: "DashboardSegmentCell") as? DashboardSegmentCell
            }

            return self.headerView?.contentView
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //return header
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as? DashboardHeaderCell else {
                return UITableViewCell()
            }
            
            return cell
        }
        else {
            //return scroll cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardBottomScrollCell") as? DashboardBottomScrollCell else {
                return UITableViewCell()
            }
            
            return cell
        }
    }
}

