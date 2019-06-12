//
//  BookingDocumentsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingDocumentsTableViewCellDelegate: class {
    func  downloadDocument(documentDirectory: String , tableIndex: IndexPath , collectionIndex: IndexPath)
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
//    private var documentsName: [String] = ["Govind.mp4" , "Julian.mp4" , "Delgado.mp4", "Govind1.mp4" , "Julian1.mp4" , "Delgado1.mp4", "Govind2.mp4" , "Julian2.mp4" , "Delgado2.mp4"]
    var documentsData: [DocumentDownloadingModel] = []
    
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
        cell.configCell(name: self.documentsData[indexPath.item].fileName , documentsSize: "293.03 KB", request: documentsData[indexPath.item])
        switch self.documentsData[indexPath.item].downloadingStatus {
        case .notDownloaded:
            cell.notDownloadingStatusSetUp(name: self.documentsData[indexPath.item].fileName)
        case .downloading:
            cell.downloadingStatusSetUp()
        case .downloaded:
            cell.downloadedStatusSetUp(name: self.documentsData[indexPath.item].fileName)
        }
        let currentDocumentFolder = self.checkCreateAndReturnDocumentFolder()
        if self.checkIsFileExist(nameOfFile: self.documentsData[indexPath.item].fileName, path: currentDocumentFolder) || self.documentsData[indexPath.item].downloadingStatus != .notDownloaded {
            cell.downloadingIcon.image = nil
        } else {
            cell.downloadingIcon.image = #imageLiteral(resourceName: "downloadingImage")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let superVw = self.superview as? UITableView , let index = superVw.indexPath(for: self) , let safeDelegate = self.delegate , let cell = collectionView.cellForItem(at: indexPath) as? BookingDocumentsCollectionViewCell {
            let currentDirecotry = self.checkCreateAndReturnDocumentFolder()
            if !self.checkIsFileExist(nameOfFile: self.documentsData[indexPath.item].fileName, path: currentDirecotry) && self.documentsData[indexPath.item].downloadingStatus == .notDownloaded {
                self.documentsData[indexPath.item].downloadingStatus = .downloading
                cell.downloadingStartAnimation()
                safeDelegate.downloadDocument(documentDirectory: currentDirecotry + "/\(self.documentsData[indexPath.item])", tableIndex: index, collectionIndex: indexPath)
            } else {
                printDebug("FILE AVAILABLE")
            }
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
        return CGFloat.zero
    }
}

extension BookingDocumentsTableViewCell: BookingDocumentsCollectionViewCellDelegate {
    func cancelButtonAction(forIndex indexPath: IndexPath) {
        printDebug(indexPath)
        self.delegate?.cancelDownloadDocument(itemIndexPath: indexPath)
        self.documentsData[indexPath.item].downloadingStatus = .notDownloaded
        self.documentsCollectionView.reloadItems(at: indexPath)
    }
}
