//
//  TripAdvisorDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripAdvisorDetailsVC: BaseVC {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var tripAdviserTblView: UITableView! {
        didSet{
            self.tripAdviserTblView.delegate = self
            self.tripAdviserTblView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


extension TripAdvisorDetailsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdviserReviewsCell", for: indexPath) as? TripAdviserReviewsCell else { return UITableViewCell() }
        return cell
    }
}
