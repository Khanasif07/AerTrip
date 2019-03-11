//
//  SearchTagTableCell.swift
//  AERTRIP
//
//  Created by Admin on 07/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsSearchTagTableCell: UITableViewCell {
    
    //Mark:- Variables
    //===============
    var permanentTagsForFilteration: [String] = []
    var availableTagsForFilterartion: [String] = []
    var allTagsForFilteration: [String] = []
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var tagCollectionView: UICollectionView! {
        didSet {
            self.tagCollectionView.delegate = self
            self.tagCollectionView.dataSource = self
            self.tagCollectionView.backgroundColor = AppColors.screensBackground.color
            self.tagCollectionView.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        }
    }
    
    //Mark:- LifeCycle
    //================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        //Color
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.searchBarSetUp()
        self.registerXibs()
    }
    
    ///Search Bar SetUp
    private func searchBarSetUp() {
        //UI
        self.searchBar.layer.cornerRadius = 10.0
        self.searchBar.layer.masksToBounds = true
        self.searchBar.backgroundColor = AppColors.themeGray10
        
        if let textField = self.searchBar.value(forKey: "_searchField") as? UITextField {
            //Color
            textField.borderStyle = .none
            textField.backgroundColor = .clear
            //Text
            textField.attributedPlaceholder = self.attributeLabelSetUp()
            //Font
            textField.font = AppFonts.Regular.withSize(18.0)
        }
    }
    
    private func registerXibs() {
        self.tagCollectionView.registerCell(nibName: HotelTagCollectionCell.reusableIdentifier)
    }
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greyAttributedString = NSAttributedString(string: "  " + LocalizedString.hotelFilterSearchBar.localized, attributes: grayAttribute)
        attributedString.append(greyAttributedString)
        return attributedString
    }
    
    @IBAction func searchBarBtnAction(_ sender: Any) {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            printDebug(parentVC.className)
            AppFlowManager.default.presentSearchHotelTagVC(tagButtons: self.allTagsForFilteration, superView: self)
        }
    }
}


extension HotelDetailsSearchTagTableCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableTagsForFilterartion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelTagCollectionCell.reusableIdentifier, for: indexPath) as? HotelTagCollectionCell else { return UICollectionViewCell() }
        cell.delegate = self
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            let isCancelButtonAvailable: Bool = self.permanentTagsForFilteration.contains(self.availableTagsForFilterartion[indexPath.item]) ? false : true
            if parentVC.viewModel.selectedTags.contains(self.availableTagsForFilterartion[indexPath.item]) {
                cell.configureCell(tagTitle: self.availableTagsForFilterartion[indexPath.item], titleColor: AppColors.themeGreen, tagBtnColor: AppColors.iceGreen, isCancelButtonAvailable: isCancelButtonAvailable)
            } else {
                cell.configureCell(tagTitle: self.availableTagsForFilterartion[indexPath.item], titleColor: AppColors.themeGray40, tagBtnColor: AppColors.themeGray04, isCancelButtonAvailable: isCancelButtonAvailable)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebug(self.availableTagsForFilterartion[indexPath.item])
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            if !parentVC.viewModel.selectedTags.contains(self.availableTagsForFilterartion[indexPath.item]) {
                parentVC.viewModel.selectedTags.append(self.availableTagsForFilterartion[indexPath.item])
                parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                self.tagCollectionView.reloadData()
                parentVC.hotelTableView.reloadData()
            } else {
                parentVC.viewModel.selectedTags.remove(object: self.availableTagsForFilterartion[indexPath.item])
                parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                self.tagCollectionView.reloadData()
                parentVC.hotelTableView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cancelButtonWidth: CGFloat = self.permanentTagsForFilteration.contains(self.availableTagsForFilterartion[indexPath.item]) ? 20.0 : 40.0
        let size = availableTagsForFilterartion[indexPath.item].sizeCount(withFont: AppFonts.SemiBold.withSize(16.0), bundingSize: CGSize(width: 10000.0, height: 10000.0))
        return CGSize(width: size.width + cancelButtonWidth, height: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}


extension HotelDetailsSearchTagTableCell: DeleteTagButtonDelegate {
    
    func deleteTagButton(indexPath: IndexPath) {
        if let parentVC = self.parentViewController as? HotelDetailsVC , parentVC.viewModel.tagsForFilteration.indices.contains(indexPath.item) {
            printDebug("\(self.allTagsForFilteration[indexPath.item]) is deleted")
            parentVC.viewModel.tagsForFilteration.remove(at: indexPath.item)
            if parentVC.viewModel.selectedTags.indices.contains(indexPath.item) {
                parentVC.viewModel.selectedTags.remove(at: indexPath.item)
            }
            self.tagCollectionView.reloadData()
            parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
            parentVC.hotelTableView.reloadData()
        }
    }
}

extension HotelDetailsSearchTagTableCell: AddTagButtonDelegate {
    
    func addTagButtons(tagName: String) {
        if let parentVC = self.parentViewController as? HotelDetailsVC, !parentVC.viewModel.tagsForFilteration.contains(tagName) {
            parentVC.viewModel.tagsForFilteration.append(tagName)
            parentVC.viewModel.selectedTags.append(tagName)
            self.tagCollectionView.reloadData()
            parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
            parentVC.hotelTableView.reloadData()
//            let indexPath = IndexPath(row: self.allTagsForFilteration.count - 1, section: 0)
//            if indexPath.item > 3 {
//                self.tagCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
//            }
        }
    }
    
}


//class HotelDetailsSearchTagTableCell: UITableViewCell {
//
//    //Mark:- Variables
//    //===============
//    var permanentTags: [String] = ["Breakfast"]
//    var tagButtons: [String] = ["Breakfast"]
//    internal var availableTags = [String]()
//
//    //Mark:- IBOutlets
//    //================
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var searchBar: ATSearchBar!
//    @IBOutlet weak var searchBarButton: UIButton!
//    @IBOutlet weak var tagCollectionView: UICollectionView! {
//        didSet {
//            self.tagCollectionView.delegate = self
//            self.tagCollectionView.dataSource = self
//            self.tagCollectionView.backgroundColor = AppColors.screensBackground.color
//            self.tagCollectionView.contentInset = UIEdgeInsets(top: 16.0, left: 10.0, bottom: 16.0, right: 16.0)
//        }
//    }
//
//    //Mark:- LifeCycle
//    //================
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.configureUI()
//    }
//
//    ///ConfigureUI
//    private func configureUI() {
//        //Color
//        self.containerView.backgroundColor = AppColors.screensBackground.color
//        self.searchBarSetUp()
//        self.registerXibs()
//    }
//
//    ///Search Bar SetUp
//    private func searchBarSetUp() {
//        //UI
//        self.searchBar.layer.cornerRadius = 10.0
//        self.searchBar.layer.masksToBounds = true
//        self.searchBar.backgroundColor = AppColors.themeGray10
//
//        if let textField = self.searchBar.value(forKey: "_searchField") as? UITextField {
//            //Color
//            textField.borderStyle = .none
//            textField.backgroundColor = .clear
//            //Text
//            textField.attributedPlaceholder = self.attributeLabelSetUp()
//            //Font
//            textField.font = AppFonts.Regular.withSize(18.0)
//        }
//    }
//
//    private func registerXibs() {
//        self.tagCollectionView.registerCell(nibName: HotelTagCollectionCell.reusableIdentifier)
//    }
//
//    ///AttributeLabelSetup
//    private func attributeLabelSetUp() -> NSMutableAttributedString {
//        let attributedString = NSMutableAttributedString()
//        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
//        let greyAttributedString = NSAttributedString(string: "  " + LocalizedString.hotelFilterSearchBar.localized, attributes: grayAttribute)
//        attributedString.append(greyAttributedString)
//        return attributedString
//    }
//
////    internal func configureCell(hotelData: Amenities) {
////
////    }
//
//    @IBAction func searchBarBtnAction(_ sender: Any) {
//        if let parentVC = self.parentViewController as? HotelDetailsVC {
//            printDebug(parentVC.className)
//            AppFlowManager.default.presentSearchHotelTagVC(tagButtons: self.availableTags, superView: self)
//        }
//    }
//}
//
//
//extension HotelDetailsSearchTagTableCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.tagButtons.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelTagCollectionCell.reusableIdentifier, for: indexPath) as? HotelTagCollectionCell else { return UICollectionViewCell() }
//        cell.delegate = self
//        let isCancelButtonAvailable: Bool = self.permanentTags.contains(self.tagButtons[indexPath.item]) ? false : true
//        if let parentVC = self.parentViewController as? HotelDetailsVC , !parentVC.viewModel.filteredTags.contains(self.tagButtons[indexPath.item]) {
//            cell.configureCell(tagTitle: tagButtons[indexPath.item], titleColor: AppColors.themeGray40, tagBtnColor: AppColors.themeGray04, isCancelButtonAvailable: isCancelButtonAvailable)
//        } else {
//            cell.configureCell(tagTitle: tagButtons[indexPath.item], titleColor: AppColors.themeGreen, tagBtnColor: AppColors.iceGreen, isCancelButtonAvailable: isCancelButtonAvailable)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        printDebug(self.tagButtons[indexPath.item])
//        if let parentVC = self.parentViewController as? HotelDetailsVC {
//            if !parentVC.viewModel.filteredTags.contains(self.tagButtons[indexPath.item]) {
//                parentVC.viewModel.filteredTags.append(self.tagButtons[indexPath.item])
//                parentVC.filterdHotelData(tagList: parentVC.viewModel.filteredTags)
//                self.tagCollectionView.reloadData()
//                parentVC.hotelTableView.reloadData()
//            } else {
//                parentVC.viewModel.filteredTags.remove(object: self.tagButtons[indexPath.item])
//                parentVC.filterdHotelData(tagList: parentVC.viewModel.filteredTags)
//                self.tagCollectionView.reloadData()
//                parentVC.hotelTableView.reloadData()
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cancelButtonWidth: CGFloat = self.permanentTags.contains(self.tagButtons[indexPath.item]) ? 20.0 : 40.0
//        let size = tagButtons[indexPath.item].sizeCount(withFont: AppFonts.SemiBold.withSize(16.0), bundingSize: CGSize(width: 10000.0, height: 10000.0))
//        return CGSize(width: size.width + cancelButtonWidth, height: 30.0)
////        return CGSize(width: size.width + 40.0, height: 30.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8.0
//    }
//}
//
//
//extension HotelDetailsSearchTagTableCell: DeleteTagButtonDelegate {
//
//    func deleteTagButton(indexPath: IndexPath) {
//        if let parentVC = self.parentViewController as? HotelDetailsVC , self.tagButtons.indices.contains(indexPath.item) {
//            printDebug("\(self.tagButtons[indexPath.item]) is deleted")
//            self.tagButtons.remove(at: indexPath.item)
//            self.tagCollectionView.reloadData()
//            parentVC.filterdHotelData(tagList: self.tagButtons)
//            parentVC.hotelTableView.reloadData()
////            let indexPath = IndexPath(row: self.tagButtons.count - 1, section: 0)
////            self.tagCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
//        }
//    }
//}
//
//extension HotelDetailsSearchTagTableCell: AddTagButtonDelegate {
//
//    func addTagButtons(tagName: String) {
//        if let parentVC = self.parentViewController as? HotelDetailsVC {
//            self.tagButtons.append(tagName)
//            self.tagCollectionView.reloadData()
//            parentVC.filterdHotelData(tagList: self.tagButtons)
//            parentVC.hotelTableView.reloadData()
//            let indexPath = IndexPath(row: self.tagButtons.count - 1, section: 0)
//            self.tagCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
//        }
//    }
//
//}
