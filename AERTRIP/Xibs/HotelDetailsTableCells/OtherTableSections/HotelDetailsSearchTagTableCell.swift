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
    var availableTagsForFilterartion: [String] = [] {
        didSet {
            if  !self.availableTagsForFilterartion.contains(array: initialTagsForFiltration) {
//                var index = 0
                for value in initialTagsForFiltration {
                   availableTagsForFilterartion.remove(object: value)
                }
                self.availableTagsForFilterartion.insert(contentsOf: initialTagsForFiltration, at: 0)
            } else {
                for value in initialTagsForFiltration.reversed() {
                    if availableTagsForFilterartion.contains(value) {
                        availableTagsForFilterartion.remove(object: value)
                        self.availableTagsForFilterartion.insert(value, at: 0)
                    }
                }
            }
        }
    }
    var allTagsForFilteration: [String] = []
//    var initialTagsForFiltration: [String] = ["Breakfast","Refundable"]
    var initialTagsForFiltration: [String] = ["Breakfast","Free Cancellation"]
    
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
            self.tagCollectionView.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 4.0, right: 16.0)
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
        //self.searchBarSetUp()
        searchBar.placeholder = LocalizedString.hotelFilterSearchBar.localized
        self.registerXibs()
    }
    
    ///Search Bar SetUp
    private func searchBarSetUp() {
        //UI
       // self.searchBar.micButton.frame = CGRect(x: UIScreen.main.bounds.width - 36.0 - 15.0 , y: 0.0, width: 36.0, height: 36.0)
        self.searchBar.layer.cornerRadius = 10.0
        self.searchBar.layer.masksToBounds = true
        self.searchBar.backgroundColor = AppColors.themeGray10
        if #available(iOS 13.0, *) {
            let textField = self.searchBar.searchTextField
            //Color
                                textField.borderStyle = .none
                                textField.backgroundColor = .clear
                                //Text
                                textField.attributedPlaceholder = self.attributeLabelSetUp()
                                //Font
                                textField.font = AppFonts.Regular.withSize(18.0)
        } else {
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
        //
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
    
    private func getTypeOfFIlteration(parentVC: HotelDetailsVC, currentTag: String, isAvailableInSource: Bool) {
        if !isAvailableInSource {
            if parentVC.viewModel.filterAppliedData.roomMeal.contains(currentTag) {
                parentVC.viewModel.roomMealDataCopy.append(currentTag)
               // parentVC.viewModel.filterAppliedData.roomMeal.append(currentTag)
            } else if parentVC.viewModel.filterAppliedData.roomOther.contains(currentTag) {
                parentVC.viewModel.roomOtherDataCopy.append(currentTag)
            } else if parentVC.viewModel.filterAppliedData.roomCancelation.contains(currentTag) {
                parentVC.viewModel.roomCancellationDataCopy.append(currentTag)
            } else {
                //parentVC.viewModel.currentlyFilterApplying = .newTag
            }
        } else{
            if parentVC.viewModel.filterAppliedData.roomMeal.contains(currentTag) {
                parentVC.viewModel.roomMealDataCopy.remove(object: currentTag)
            } else if parentVC.viewModel.filterAppliedData.roomOther.contains(currentTag) {
                parentVC.viewModel.roomOtherDataCopy.remove(object: currentTag)
            } else if parentVC.viewModel.filterAppliedData.roomCancelation.contains(currentTag) {
                parentVC.viewModel.roomCancellationDataCopy.remove(object: currentTag)
            } else {
                //            parentVC.viewModel.currentlyFilterApplying = .newTag
            }
        }
    }
    
    @IBAction func searchBarBtnAction(_ sender: Any) {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            printDebug(parentVC.className)
            // Commented because we have to use the roomTags key that is coming empty
            //AppFlowManager.default.presentSearchHotelTagVC(tagButtons: self.allTagsForFilteration, superView: self)
            AppFlowManager.default.presentSearchHotelTagVC(tagButtons: AppConstants.staticRoomTags, superView: self)

        }
    }
}


extension HotelDetailsSearchTagTableCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.availableTagsForFilterartion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelTagCollectionCell.reusableIdentifier, for: indexPath) as? HotelTagCollectionCell else { return UICollectionViewCell() }
        if indexPath.row < initialTagsForFiltration.count{
            cell.cancelButton.isHidden = true
        } else {
            cell.cancelButton.isHidden = false
        }
        cell.delegate = self
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            if parentVC.viewModel.selectedTags.contains(self.availableTagsForFilterartion[indexPath.item]) {
                cell.configureCell(tagTitle: self.availableTagsForFilterartion[indexPath.item], titleColor: AppColors.themeGreen, tagBtnColor: AppColors.iceGreen, isCancelButtonAvailable: false)
            } else {
                cell.configureCell(tagTitle: self.availableTagsForFilterartion[indexPath.item], titleColor: AppColors.themeGray40, tagBtnColor: AppColors.themeGray04, isCancelButtonAvailable: false)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebug(self.availableTagsForFilterartion[indexPath.item])
        if indexPath.row < initialTagsForFiltration.count {
            if let parentVC = self.parentViewController as? HotelDetailsVC {
                if  !parentVC.viewModel.selectedTags.contains(self.availableTagsForFilterartion[indexPath.item]) {
                parentVC.viewModel.selectedTags.append(self.availableTagsForFilterartion[indexPath.item])
                    self.getTypeOfFIlteration(parentVC: parentVC, currentTag: self.availableTagsForFilterartion[indexPath.item], isAvailableInSource: false)
                    parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                } else {
                    self.getTypeOfFIlteration(parentVC: parentVC, currentTag: self.availableTagsForFilterartion[indexPath.item], isAvailableInSource: true)
                    parentVC.viewModel.selectedTags.remove(object: self.availableTagsForFilterartion[indexPath.item])
                     parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                }
                self.tagCollectionView.reloadData()
            }
        } else {
            if let parentVC = self.parentViewController as? HotelDetailsVC {
                if !parentVC.viewModel.selectedTags.contains(self.availableTagsForFilterartion[indexPath.item]) {
                parentVC.viewModel.selectedTags.append(self.availableTagsForFilterartion[indexPath.item])
                    self.getTypeOfFIlteration(parentVC: parentVC, currentTag: self.availableTagsForFilterartion[indexPath.item], isAvailableInSource: false)
                    parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                } else {
                    parentVC.viewModel.selectedTags.remove(object: self.availableTagsForFilterartion[indexPath.item])
                    self.getTypeOfFIlteration(parentVC: parentVC, currentTag: self.availableTagsForFilterartion[indexPath.item], isAvailableInSource: true)
                    parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
                   
                }
                self.tagCollectionView.reloadData()
               
            }
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            var cancelButtonWidth: CGFloat = parentVC.viewModel.permanentTagsForFilteration.contains(self.availableTagsForFilterartion[indexPath.item]) ? 20.0 : 20.0
            if indexPath.item >= 2 { cancelButtonWidth = 36.0}
            let size = availableTagsForFilterartion[indexPath.item].sizeCount(withFont: AppFonts.SemiBold.withSize(16.0), bundingSize: CGSize(width: 10000.0, height: 28.0))
            return CGSize(width: size.width + cancelButtonWidth, height: 28.0)
        }
        return CGSize.zero
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
        if let parentVC = self.parentViewController as? HotelDetailsVC , self.availableTagsForFilterartion.indices.contains(indexPath.item) {
            printDebug("\(self.availableTagsForFilterartion[indexPath.item]) is deleted")
           
//            if parentVC.viewModel.selectedTags.indices.contains(indexPath.item) {
//                parentVC.viewModel.selectedTags.remove(at: indexPath.item)
//            }
            parentVC.viewModel.selectedTags.remove(object: self.availableTagsForFilterartion[indexPath.item])
           
            self.getTypeOfFIlteration(parentVC: parentVC, currentTag: self.availableTagsForFilterartion[indexPath.item], isAvailableInSource: true)
            self.availableTagsForFilterartion.remove(at: indexPath.item)
            parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
            self.tagCollectionView.reloadData()
//            parentVC.hotelTableView.reloadData()
        }
    }
}

extension HotelDetailsSearchTagTableCell: AddTagButtonDelegate {
    
    func addTagButtons(tagName: String) {
        if let parentVC = self.parentViewController as? HotelDetailsVC, !self.availableTagsForFilterartion.contains(tagName) {
            self.availableTagsForFilterartion.append(tagName)
            parentVC.viewModel.selectedTags.append(tagName)
            self.tagCollectionView.reloadData()
            self.getTypeOfFIlteration(parentVC: parentVC, currentTag: tagName, isAvailableInSource: false)
            parentVC.filterdHotelData(tagList: parentVC.viewModel.selectedTags)
            parentVC.hotelTableView.reloadData()
        }
    }
    
}
