//
//  BookingDocumentsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingDocumentsTableViewCellDelegate: class {
    func downloadDocument(documentDirectory: String , tableIndex: IndexPath , collectionIndex: IndexPath)
    func cancelDownloadDocument(itemIndexPath: IndexPath)
}

class BookingDocumentsTableViewCell: UITableViewCell {
    
    //MARK:- Enums
    //MARK:=======  qq
    enum DocumentType {
        case others , flights , hotels
    }
    
    //MARK:- Variables
    //MARK:===========
    weak var delegate: BookingDocumentsTableViewCellDelegate?
    internal var currentDocumentType: DocumentType = .others
    var documentsData: [DocumentDownloadingModel] = [] {
        didSet {
            self.documentsCollectionView.reloadData()
        }
    }
    var actionSheetVisible = false
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var documentsLabel: UILabel!
    @IBOutlet weak var topdividerView: ATDividerView!
    @IBOutlet weak var documentsCollectionView: UICollectionView! {
        didSet {
            self.documentsCollectionView.delegate = self
            self.documentsCollectionView.dataSource = self
            self.documentsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 0.0)
        }
    }
    @IBOutlet weak var dividerView: ATDividerView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        self.documentsLabel.font = AppFonts.Regular.withSize(14.0)
        self.documentsLabel.textColor = AppColors.themeGray40
        self.documentsLabel.text = LocalizedString.Documents.localized
        self.documentsCollectionView.registerCell(nibName: BookingDocumentsCollectionViewCell.reusableIdentifier)
        self.topdividerView.isHidden = true
    }
    
    private func checkCreateAndReturnDocumentFolder() -> String {
        let fileManager = FileManager.default
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        switch self.currentDocumentType {
        case .others:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("others").path) {
                return documentDirectory.appendingPathComponent("others").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("others").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("others").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        case .flights:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("flights").path) {
                return documentDirectory.appendingPathComponent("flights").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("flights").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("flights").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        case .hotels:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("/hotels").path) {
                return documentDirectory.appendingPathComponent("hotels").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("hotels").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("hotels").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        }
    }
    
    private func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    private func checkIsFileExist(nameOfFile: String ,path: String) -> Bool {
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(nameOfFile) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                printDebug("FILE AVAILABLE")
                return true
            } else {
                printDebug("FILE NOT AVAILABLE")
                return false
            }
        } else {
            printDebug("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    //Mark:- IBActions
    //================
    
}

extension BookingDocumentsTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.documentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingDocumentsCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.configCell(name: self.documentsData[indexPath.item].fileName , documentsSize: self.documentsData[indexPath.item].size, request: documentsData[indexPath.item], type: self.documentsData[indexPath.item].type)
        switch self.documentsData[indexPath.item].downloadingStatus {
        case .notDownloaded:
            cell.notDownloadingStatusSetUp(name: self.documentsData[indexPath.item].fileName, type: self.documentsData[indexPath.item].type)
        case .downloading:
            cell.downloadingStatusSetUp()
        case .downloaded:
            cell.downloadedStatusSetUp(name: self.documentsData[indexPath.item].fileName, type: self.documentsData[indexPath.item].type)
        }
        let currentDocumentFolder = self.checkCreateAndReturnDocumentFolder()
        let url = URL(fileURLWithPath: self.documentsData[indexPath.item].sourceUrl)
        if self.checkIsFileExist(nameOfFile: url.lastPathComponent, path: currentDocumentFolder) || self.documentsData[indexPath.item].downloadingStatus != .notDownloaded {
            cell.downloadingIcon.image = nil
            cell.containerView.removeGestureRecognizer(cell.longPressGesture!)
            cell.containerView.addGestureRecognizer(cell.longPressGesture!)
        } else {
            cell.downloadingIcon.image = AppImages.downloadingImage
            cell.containerView.removeGestureRecognizer(cell.longPressGesture!)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let superVw = self.superview as? UITableView , let index = superVw.indexPath(for: self) , let safeDelegate = self.delegate , let cell = collectionView.cellForItem(at: indexPath) as? BookingDocumentsCollectionViewCell {
            let currentDirecotry = self.checkCreateAndReturnDocumentFolder()
            let url = URL(fileURLWithPath: self.documentsData[indexPath.item].sourceUrl)
            if !self.checkIsFileExist(nameOfFile: url.lastPathComponent, path: currentDirecotry) && self.documentsData[indexPath.item].downloadingStatus == .notDownloaded {
                self.documentsData[indexPath.item].downloadingStatus = .downloading
                cell.downloadingStartAnimation()
                safeDelegate.downloadDocument(documentDirectory: currentDirecotry + "/\(url.lastPathComponent)", tableIndex: index, collectionIndex: indexPath)
            }
            else {
                let completeUrlPath = currentDirecotry + "/\(url.lastPathComponent)"
                if FileManager.default.fileExists(atPath: completeUrlPath) {
                    let url = URL(fileURLWithPath: self.documentsData[indexPath.item].sourceUrl)
                    printDebug("FILE AVAILABLE at \( currentDirecotry) /\(url.lastPathComponent)")
                    AppFlowManager.default.openDocument(atURL: URL(fileURLWithPath: completeUrlPath), screenTitle: "Detail")
                }
            }
            self.documentsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 111.0, height: 177.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension BookingDocumentsTableViewCell: BookingDocumentsCollectionViewCellDelegate {
    func cancelButtonAction(forIndex indexPath: IndexPath) {
        printDebug(indexPath)
        self.delegate?.cancelDownloadDocument(itemIndexPath: indexPath)
        self.documentsData[indexPath.item].downloadingStatus = .notDownloaded
        self.documentsCollectionView.reloadItems(at: indexPath)
    }
    
    func longPressButtonAction(forIndex indexPath: IndexPath) {
//        guard !self.actionSheetVisible else {
//            self.actionSheetVisible = false
//            return
//        }
        self.actionSheetVisible = true
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Delete.localized], colors: [AppColors.themeRed])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.contentView, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { [weak self] _, index in
            guard let strongSelf = self else {return}
            strongSelf.actionSheetVisible = false
            if index == 0 {
                printDebug("Email")
                let currentDirecotry = strongSelf.checkCreateAndReturnDocumentFolder()
                let url = URL(fileURLWithPath: strongSelf.documentsData[indexPath.item].sourceUrl)
                let path = currentDirecotry + "/\(url.lastPathComponent)"
                if FileManager.default.fileExists(atPath: path) {
                    printDebug("File exist at path: \(path)")
                    do {
                        try FileManager.default.removeItem(atPath: path)
                        printDebug("File deleted")
                        strongSelf.documentsData[indexPath.item].downloadingStatus = .notDownloaded
                        strongSelf.documentsCollectionView.reloadItems(at: indexPath)
                    }
                    catch {
                        printDebug("Error")
                    }
                }
                
            }
            
        }
    }
}
