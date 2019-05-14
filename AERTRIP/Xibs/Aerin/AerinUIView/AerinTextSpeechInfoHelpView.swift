//
//  AerinTextSpeechInfoHelpView.swift
//  AERTRIP
//
//  Created by apple on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AerinTextSpeechInfoHelpViewDelegate: class  {
    func keyboardButtonTapped()
    func speakerButtonTapped()
    func downArrowTapped()
}

class AerinTextSpeechInfoHelpView: UIView {
    
    //MARK: - IBOutlet
    @IBOutlet weak var infoTableView: ATTableView! {
        didSet {
            self.infoTableView.dataSource = self
            self.infoTableView.delegate = self
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Variables
    weak var delegate: AerinTextSpeechInfoHelpViewDelegate?
    let cellIdenitfier = "AerinInfoTableViewCell"
    let headerCellIdentifier = "AerinInfoSectionHeader"
    
    
    // Test Data
    
    let sections = ["Flight","Hotel"]
    let sectionImages = ["flight","hotelAerinIcon"]
    let sectionsFlight = ["Flight from Mumbai to Delhi", "Flight from Mumbai to Delhi","Bombay to Delhi flight tomorrow","Bombay to Delhi flight tomorrow","Flight on diwali from New York to Mumbai","Flight on diwali from New York to Mumbai"]
    
    let sectionHotel = ["Find hotels near me","Find hotels in Dubai on 30th June","5 star hotels in New York","Hotels with good Wi-Fi in Andheri","Check Taj hotels in Mumbai","Find stay near Shirdi for 6 peoples with 2 rooms on this friday"]
    
    
    
    //MARK:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    
    
    // MARK: - IB Action
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
        delegate?.keyboardButtonTapped()
    }
    
    @IBAction func downArrowTapped(_ sender: Any) {
        delegate?.downArrowTapped()
    }
    
    @IBAction func spearkerIconButtonTapped(_ sender: Any) {
        delegate?.speakerButtonTapped()
    }
    
    
    

    //MARK:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AerinTextSpeechInfoHelpView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
        self.setUpFont()
        self.setUpText()
        self.setUpColor()
    }
    
    
    ///ConfigureUI
    private func configureUI() {
        self.registerXib()
    }
    
     func updateData() {
        self.infoTableView.reloadData()
    }
    
    private func registerXib() {
         self.infoTableView.registerCell(nibName: AerinInfoTableViewCell.reusableIdentifier)
         self.infoTableView.register(UINib(nibName: self.headerCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerCellIdentifier)
    }
    
    
    private func setUpText() {
        self.titleLabel.text = LocalizedString.ThingsYouCanAskMe.localized
    }
    
    private func setUpColor() {
       self.titleLabel.textColor = AppColors.themeTextColor
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(28.0)
    }
    

   
}


// MARK:- UITableViewDataSourc and UITableViewDelegate Methods


extension AerinTextSpeechInfoHelpView : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.sectionsFlight.count
        } else {
            return self.self.sectionHotel.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = infoTableView.dequeueReusableCell(withIdentifier: self.cellIdenitfier, for: indexPath) as? AerinInfoTableViewCell else {
            fatalError("AerinInfoTableViewCell not found")
        }
        if indexPath.section == 0 {
            cell.titleLabel.text = sectionsFlight[indexPath.section]
        } else {
            cell.titleLabel.text = sectionHotel[indexPath.section]
        }
       
        return cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let infoHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AerinInfoSectionHeader") as? AerinInfoSectionHeader else {
            fatalError("AerinInfoSectionHeader not found")
        }
        
        
        infoHeader.sectionTitleLabel.text = self.sections[section]
        infoHeader.sectionImageView.image = #imageLiteral(resourceName: self.sectionImages[section])
        return infoHeader
    }
    
    
}
