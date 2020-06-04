//
//  FlightPaymentBookingStatusVC.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightPaymentBookingStatusVC: BaseVC {

    
    @IBOutlet weak var statusTableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var returnHomeButton: UIButton!
    
    var viewModel = FlightPaymentBookingStatusVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func initialSetup() {
        super.initialSetup()
        self.registerCell()
        self.statusTableView.separatorStyle = .none
        self.setupPayButton()
        self.returnHomeButton.addGredient(isVertical: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    private func registerCell(){
        self.statusTableView.registerCell(nibName: FlightCarriersTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: FlightBoardingAndDestinationTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
        self.statusTableView.registerCell(nibName: TravellersPnrStatusTableViewCell.reusableIdentifier)
    }

  private func setupPayButton() {
      self.returnHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
      self.returnHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
      self.returnHomeButton.setTitle("Return Home", for: .normal)
  }
    @IBAction func returnHomeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


extension FlightPaymentBookingStatusVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.itinerary.details.legsWithDetail.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellsForTtavellerSection(indexPath)
    }
    
}
