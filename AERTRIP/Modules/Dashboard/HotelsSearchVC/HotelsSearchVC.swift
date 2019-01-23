//
//  HotelsSearchVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsSearchVC: BaseVC {
    
    //MARK:- Properties
    //=================
    
    internal var checkInOutView: CheckInOutView?
    private var previousOffSet = CGPoint.zero
    internal var roomData: [String] = ["Room 1","add room"]
    private var collectionViewHeight: CGFloat = 0.0
    private var searchViewHeight: CGFloat = 0.0
    private var containerViewHeight: CGFloat = 0.0
    private var scrollViewContentSize: CGSize = CGSize.zero
    
    //Computed Properties
    private var cellHeight: CGFloat{
        return self.addRoomCollectionView.frame.size.height
    }
    private var cellWidth: CGFloat{
        return self.addRoomCollectionView.frame.size.width / 2.0
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var whereContainerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var addRoomView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var whereBtnOutlet: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var allStarLabel: UILabel!
    @IBOutlet weak var oneStarLabel: UILabel!
    @IBOutlet weak var twoStarLabel: UILabel!
    @IBOutlet weak var threeStarLabel: UILabel!
    @IBOutlet weak var fourStarLabel: UILabel!
    @IBOutlet weak var fiveStarLabel: UILabel!
    @IBOutlet weak var firstStarBtn: UIButton!
    @IBOutlet weak var secondStarBtn: UIButton!
    @IBOutlet weak var thirdStarBtn: UIButton!
    @IBOutlet weak var fourStarBtn: UIButton!
    @IBOutlet weak var fiveStarBtn: UIButton!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var bulkBookingsLbl: UILabel!
    @IBOutlet weak var addRoomHeightMultiplier: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightMultiplier: NSLayoutConstraint!
    
    @IBOutlet weak var addRoomCollectionView: UICollectionView! {
        didSet {
            self.addRoomCollectionView.delegate = self
            self.addRoomCollectionView.dataSource = self
        }
    }
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchViewHeight = self.searchView.frame.size.height
        self.collectionViewHeight = self.addRoomCollectionView.frame.size.height
        self.containerViewHeight = self.containerView.frame.size.height
        self.scrollViewContentSize = self.scrollView.contentSize
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
    }
    
    override func bindViewModel() {
        let AddRoomNib = UINib(nibName: "AddRoomCell", bundle: nil)
        self.addRoomCollectionView.register(AddRoomNib, forCellWithReuseIdentifier: "AddRoomCell")
        let AddRoomPicNib = UINib(nibName: "AddRoomPictureCell", bundle: nil)
        self.addRoomCollectionView.register(AddRoomPicNib, forCellWithReuseIdentifier: "AddRoomPictureCell")
    }
    
    override func setupFonts() {
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.whereBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(20.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(26.0)
        self.stateNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.starRatingLabel.font = regularFontSize16
        self.allStarLabel.font = AppFonts.Regular.withSize(14.0)
        self.oneStarLabel.font = regularFontSize16
        self.twoStarLabel.font = regularFontSize16
        self.threeStarLabel.font = regularFontSize16
        self.fourStarLabel.font = regularFontSize16
        self.fiveStarLabel.font = regularFontSize16
    }
    
    override func setupColors() {
        self.whereBtnOutlet.setTitleColor(AppColors.themeGray40, for: .normal)
        self.cityNameLabel.textColor = AppColors.textFieldTextColor51
        self.stateNameLabel.textColor = AppColors.textFieldTextColor51
        self.firstLineView.backgroundColor = AppColors.themeGray10
        self.secondLineView.backgroundColor = AppColors.themeGray10
        self.thirdLineView.backgroundColor = AppColors.themeGray10
        self.fourthLineView.backgroundColor = AppColors.themeGray10
        self.starRatingLabel.textColor = AppColors.themeGray40
        self.allStarLabel.textColor = AppColors.themeGray40
        self.oneStarLabel.textColor = AppColors.themeGray40
        self.twoStarLabel.textColor = AppColors.themeGray40
        self.threeStarLabel.textColor = AppColors.themeGray40
        self.fourStarLabel.textColor = AppColors.themeGray40
        self.fiveStarLabel.textColor = AppColors.themeGray40
        self.attributeLabelSetUp()
    }
    
    //ScrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffSet.y
        
        if let parent = parent as? DashboardVC{
            if difference > 0{
                //check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height{
                    if scrollView.contentOffset.y > 0.0{
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            }else{
                if parent.mainScrollView.contentOffset.y > 0.0{
                    if scrollView.contentOffset.y <= 0.0{
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        
        previousOffSet = scrollView.contentOffset
        
    }
    
    //MARK:- Methods
    //=============
    
    //MARK:- Private
    ///InitialSetUp
    private func initialSetups() {
        self.cityNameLabel.isHidden = true
        self.stateNameLabel.isHidden = true
        self.containerView.layer.cornerRadius = 10.0
        //self.containerView.layer.masksToBounds = true
        //self.containerView.clipsToBounds = true
        self.containerView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.scrollView.delegate = self
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.configureCheckInOutView()
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            self.datePickerView.addSubview(view)
        }
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greyAttributedString = NSAttributedString(string: "Want more rooms?", attributes: grayAttribute)
        let greenAttributedString = NSAttributedString(string: " Request Bulk Booking", attributes: greenAtrribute)
        attributedString.append(greyAttributedString)
        attributedString.append(greenAttributedString)
        self.bulkBookingsLbl.attributedText = attributedString
    }
    
    ///UpdateCollectionViewFrame
    private func updateCollectionViewFrame() {
        let expandMultiPlier: CGFloat = (86.0 / 544.0)
        //let frame = self.containerView.frame
        if self.roomData.count == 3 {
            UIView.animate(withDuration: 0.3) {
                self.containerView.frame.size.height = self.containerViewHeight + self.collectionViewHeight
                self.scrollView.contentSize.height = self.scrollViewContentSize.height + self.collectionViewHeight
                //self.view.frame.size.height = UIScreen.main.bounds.height + self.collectionViewHeight
                self.addRoomHeightMultiplier = self.addRoomHeightMultiplier.setMultiplier(multiplier: expandMultiPlier * 2.0)
                self.searchViewHeightMultiplier = self.searchViewHeightMultiplier.setMultiplier(multiplier: 129.0 / 544.0)
            }
        } else if self.roomData.count == 2 {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentSize.height = self.scrollViewContentSize.height
                self.containerView.frame.size.height = self.containerViewHeight
                //self.view.frame.size.height = UIScreen.main.bounds.height
                self.addRoomHeightMultiplier = self.addRoomHeightMultiplier.setMultiplier(multiplier: expandMultiPlier)
                self.searchViewHeightMultiplier = self.searchViewHeightMultiplier.setMultiplier(multiplier: 129.0 / 544.0)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    ///ReloadCollectionView
    private func reloadCollectionView() {
        UIView.performWithoutAnimation {
            self.addRoomCollectionView.reloadData()
        }
    }
    
    //MARK:- Public
    
    //MARK:- IBAction
    //===============
    @IBAction func firstStarBtnAction(_ sender: UIButton) {
    }
    @IBAction func secondStarBtnAction(_ sender: UIButton) {
    }
    @IBAction func thirdStarBtnAction(_ sender: UIButton) {
    }
    @IBAction func fourthStarBtnAction(_ sender: UIButton) {
    }
    @IBAction func fiveStarBtnAction(_ sender: UIButton) {
    }
    
}

//Mark:- UICollectionView Delegate and Datasource
//===============================================
extension HotelsSearchVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.roomData.count < 5) ? (self.roomData.count) : (self.roomData.count - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.roomData.count < 5 && self.roomData.count - 1 == indexPath.item {
            guard let addRoomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRoomCell", for: indexPath) as? AddRoomCell else { fatalError("Add Room Picture Cell Not Found") }
            addRoomCell.indexPath = indexPath
            addRoomCell.delegate = self
            return addRoomCell
        } else {
            guard let addRoomPicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRoomPictureCell", for: indexPath) as? AddRoomPictureCell else { fatalError("Add Room Picture Cell Not Found") }
            addRoomPicCell.indexPath = indexPath
            addRoomPicCell.delegate = self
            addRoomPicCell.roomCountLabel.text = "Room \(indexPath.item + 1)"
            if self.roomData.count == 2 {
                addRoomPicCell.cancelBtnOutlet.isHidden = true
                addRoomPicCell.lineView.isHidden = true
                addRoomPicCell.childStackView.isHidden = true
            } else{
                if indexPath.item == 0 || indexPath.item == 1 {
                    addRoomPicCell.childStackView.isHidden = false
                    addRoomPicCell.lineView.isHidden = false
                    if indexPath.item == 0 {
                        addRoomPicCell.lineViewLeadingConstraint.constant = 16.0
                        addRoomPicCell.lineViewTrailingConstraint.constant = 0.0
                    } else {
                        addRoomPicCell.lineViewLeadingConstraint.constant = 0.0
                        addRoomPicCell.lineViewTrailingConstraint.constant = 16.0
                    }
                } else {
                    addRoomPicCell.lineView.isHidden = true
                    addRoomPicCell.lineViewLeadingConstraint.constant = 0.0
                }
                addRoomPicCell.cancelBtnOutlet.isHidden = false
            }
            return addRoomPicCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? AddRoomCell) != nil {
            self.plusButtonTouched(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionViewHeight != 0.0 {
            return CGSize(width: self.cellWidth , height: self.collectionViewHeight)
        } else {
            return CGSize(width: self.cellWidth , height: self.cellHeight)
        }
    }
}

//Mark:- Expanded Cell Delegate
//=============================
extension HotelsSearchVC: ExpandedCellDelegate {
    
    func plusButtonTouched(indexPath: IndexPath) {
        self.roomData.append("Room \(self.roomData.count - 1)")
        if self.roomData.count < 5 {
            UIView.animate(withDuration: 0.3) {
                self.updateCollectionViewFrame()
                self.addRoomCollectionView.performBatchUpdates({ () -> Void in
                    self.addRoomCollectionView.insertItems(at: [indexPath])
                }, completion: { (true) in
                    self.reloadCollectionView()
                })
            }
        } else {
            self.reloadCollectionView()
        }
    }
    
    func cancelButtonTouched(indexPath: IndexPath) {
        if self.roomData.count <= 5 {
            self.roomData.removeLast()
            if self.roomData.count == 4 {
                self.reloadCollectionView()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.addRoomCollectionView.performBatchUpdates({ () -> Void in
                        self.updateCollectionViewFrame()
                        self.addRoomCollectionView.deleteItems(at: [indexPath])
                    }) { (true) in
                        self.reloadCollectionView()
                    }
                }
            }
        }
    }
}

//Mark:- Room Data Delegate
//=========================
extension HotelsSearchVC: RoomDataDelegate {
    func adultAndChildData(adultCount: Int, child: Int) {
    }
}
