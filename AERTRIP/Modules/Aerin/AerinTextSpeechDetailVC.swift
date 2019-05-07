//
//  AerinTextSpeechDetailVC.swift
//  AERTRIP
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinTextSpeechDetailVC: BaseVC {
    
    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var aerinTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var aerinInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var aerinInfoContainerView: UIView!
    
    
    let images = ["flightIcon","ic_acc_hotels","flightIcon","flightIcon","ic_acc_hotels","flightIcon","flightIcon","ic_acc_hotels","flightIcon"]
    let text = ["BOM","Goa","Goa","BOM","Goa","Goa","BOM","Goa","Goa"]
    
    
    
    // MARK: - Variables
     var aerinInfoView: AerinTextSpeechInfoHelpView?
    
    var isAerinInfoViewOpen: Bool = false
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    //MARK: - Cell Identifier
    let cellIdentifier = "AerinSuggestionCollectionViewCell"
    
    
    override func initialSetup() {
        self.registerXib()
        self.configurationNavBar()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
       
      self.configureAerinInfoView()
      self.aerinTableView.separatorStyle = .none
        self.aerinTableView.dataSource = self
        self.aerinTableView.delegate = self
        self.aerinTableView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let aerinInfoContainerView = self.aerinInfoContainerView {
            aerinInfoContainerView.frame = CGRect(x: 0.0, y: AppFlowManager.default.safeAreaInsets.top, width: bottomView.width, height: 667)
        }
        updateAerinInfoView()
        
    }
    
    //MARK: - IB Action
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
    }
    
    @IBAction func speakerIconTapped(_ sender: Any) {
    }
    
    
    @IBAction func infoIconTappped(_ sender: Any) {
            bottomView.isHidden = true
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.aerinInfoHeightConstraint.constant = self?.view.height ?? 0 - (self?.bottomView.height ?? 0 + AppFlowManager.default.safeAreaInsets.top)
            self?.view.layoutIfNeeded()
        }
    }
        
    
    
    //MARK: - Helper Methods
    private func registerXib() {
          self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            self.aerinTableView.registerCell(nibName: AerinCurrentStateTableViewCell.reusableIdentifier)
    }
    
    private func configurationNavBar() {
      self.topNavigationView.configureNavBar(title: "", isDivider: false)
        self.topNavigationView.delegate = self
        
    }
    
    private func configureAerinInfoView() {
        aerinInfoView = AerinTextSpeechInfoHelpView(frame: CGRect(x: 0.0, y: AppFlowManager.default.safeAreaInsets.top, width: bottomView.width, height: bottomView.bounds.height - AppFlowManager.default.safeAreaInsets.top))
        if let aerinInfoView = self.aerinInfoView {
            aerinInfoView.delegate = self
            aerinInfoContainerView.addSubview(aerinInfoView)
        }
        updateAerinInfoView()
    }
    
    private func updateAerinInfoView() {
        if let aerinInfoView = self.aerinInfoView {
            aerinInfoView.updateData()
        }
    }

}


// MARK: - Top Navigation  View Delegate method

extension AerinTextSpeechDetailVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension AerinTextSpeechDetailVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 35.0)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AerinSuggestionCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        cell.suggestionImageView.image = UIImage(named: images[indexPath.row])
        cell.suggestionTitleLabel.text = text[indexPath.row]
        
        return cell
    }
    
    
}


extension AerinTextSpeechDetailVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = aerinTableView.dequeueReusableCell(withIdentifier: "AerinCurrentStateTableViewCell", for: indexPath) as? AerinCurrentStateTableViewCell else {
            printDebug("AerinCurrentStateTableViewCell not found")
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

extension AerinTextSpeechDetailVC: AerinTextSpeechInfoHelpViewDelegate {
    func keyboardButtonTapped() {
        printDebug("keyboard button Tapped")
    }
    
    func speakerButtonTapped() {
        printDebug("speaker button tapped")
    }
    
    func downArrowTapped() {
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.aerinInfoHeightConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }) { [weak self] _ in
            guard let sSelf = self else { return }
            sSelf.isAerinInfoViewOpen = false
            sSelf.bottomView.isHidden = false
        }
        printDebug("down arrow tapped")
    }
    
    
}
