//
//  BaggageTermsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AcceptOrDeclineTerms : class {
    func isAccepted(value : Bool)
}

class BaggageTermsVC : BaseVC {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var baggageTermsTableView: UITableView!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var tableHeaderView: UIView!
    
    let baggageTermsVM = BaggageTermsVM()
    weak var delegate : AcceptOrDeclineTerms?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func setupFonts() {
        super.setupFonts()
        self.headingLabel.font = AppFonts.SemiBold.withSize(22)
        self.descriptionLabel.font = AppFonts.Regular.withSize(16)
        agreeButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        declineButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func setupTexts() {
        super.setupTexts()
        self.descriptionLabel.text = LocalizedString.Baggage_Terms_Desc.localized
    }
    
    @IBAction func agreeButtonTapped(_ sender: UIButton) {
//        self.delegate?.isAccepted(value: true)
        self.dismiss(animated: true) {
            self.baggageTermsVM.agreeComplition(true)
        }
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
//        self.delegate?.isAccepted(value: false)
        self.dismiss(animated: true) {
                   self.baggageTermsVM.agreeComplition(false)
               }    }
    
}

extension BaggageTermsVC {
    
    private func configureTableView(){
              self.baggageTermsTableView.register(UINib(nibName: "LabelWithBulletCell", bundle: nil), forCellReuseIdentifier: "LabelWithBulletCell")
              self.baggageTermsTableView.separatorStyle = .none
              self.baggageTermsTableView.estimatedRowHeight = 200
              self.baggageTermsTableView.rowHeight = UITableView.automaticDimension
              self.baggageTermsTableView.dataSource = self
              self.baggageTermsTableView.delegate = self
              let spacing : CGFloat = 22 + 20
              self.tableHeaderView.frame.size.height = self.headingLabel.height + self.descriptionLabel.height + spacing
        
//              self.tableHeaderView.backgroundColor = UIColor.yellow
          }
    
}

extension BaggageTermsVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baggageTermsVM.baggageTermsPoints.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithBulletCell", for: indexPath) as? LabelWithBulletCell else { fatalError("LabelWithBulletCell not found") }
        cell.descriptionLabel.text = self.baggageTermsVM.baggageTermsPoints[indexPath.row]
        return cell
        }
        

}

