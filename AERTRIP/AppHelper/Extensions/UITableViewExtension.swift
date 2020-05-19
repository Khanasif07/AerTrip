//
//  UITableViewExtension.swift
//
//  Created by Pramod Kumar on 04/04/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UITableView Extension
extension UITableView {
    
   
    
    func registerCell(nibName:String, bundle:Bundle? = Bundle.main, forCellWithReuseIdentifier:String? = nil){
        
        let cellWithReuseIdentifier = forCellWithReuseIdentifier ?? nibName
        self.register(UINib(nibName: nibName , bundle: bundle), forCellReuseIdentifier: cellWithReuseIdentifier)
    }
    
    func cell(forItem: AnyObject) -> UITableViewCell? {
        if let indexPath = self.indexPath(forItem: forItem) {
            return self.cellForRow(at: indexPath)
        }
        return nil
    }
    
    func indexPath(forItem: AnyObject) -> IndexPath? {
        let itemPosition: CGPoint = forItem.convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }
    
    func isRowPresentAt(index: IndexPath) -> Bool {
        if index.section < self.numberOfSections {
            if index.row < self.numberOfRows(inSection: index.section) {
                return true
            }
        }
        return false
    }
    func isSectionPresentAt(section: Int) -> Bool {
        if section < self.numberOfSections {
            return true
        }
        return false
    }
    
    func reloadSection(section: Int, with: UITableView.RowAnimation) {
        if self.isSectionPresentAt(section: section) {
            self.reloadSections(IndexSet(integer: section), with: with)
        }
        else {
            self.reloadData()
        }
    }
    
    func reloadRow(at: IndexPath, with: UITableView.RowAnimation) {
        if self.isRowPresentAt(index: at) {
            self.reloadRows(at: [at], with: with)
        }
        else {
            self.reloadData()
        }
    }
    
    ///pull to refresh
    public func enablePullToRefresh(tintColor: UIColor, target: UIViewController, selector: Selector){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: UIControl.Event.valueChanged)
        refreshControl.tintColor = tintColor
        self.addSubview(refreshControl)
    }
    
}

extension UITableViewCell {
    class var reusableIdentifier: String {
        return "\(self)"
    }
    
    var indexPath: IndexPath? {
        if let tblVw = self.superview as? UITableView {
            return tblVw.indexPath(for: self)
        }
        return nil
    }
    func hideSeparator() {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }
        
    func showSeparator() {
            self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 3, right: 0)
        }
}

// MARK: - UITableViewCell Extension

//extension UITableViewCell {
//    class var reusableIdentifier: String {
//        return "\(self)"
//    }
//
//    var indexPath: IndexPath? {
//        if let tblVw = self.superview as? UITableView {
//            return tblVw.indexPath(for: self)
//        }
//        return nil
//    }
//}


// FLIGHTS

extension UITableView  {
    
    func resourceFor( urlPath : String , forView indetifier : Int) ->UIImage?  {
        
        guard  let urlobj = URL(string: urlPath) else {
            return nil
        }
        
         let urlRequest = URLRequest(url: urlobj)
        
        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
            
            let image = UIImage(data: responseObj.data)
            return image
        }else {
            
            let urlSession = URLSession.shared
          let dataTask =  urlSession.dataTask(with: urlRequest) {[weak self ] ( downloadedData, response, error) in
            
                if (error != nil) {
                    print(error.debugDescription)
                    return
                }
                
                if let data = downloadedData , let response = response {
                    let cacheResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
                      DispatchQueue.main.async {
                        self?.dataDownloadCompletedWith(forViewWithIdentifier: indetifier)
                    }
                }
            }
            
            dataTask.resume()
        }
            return nil
    }
    
    func dataDownloadCompletedWith(forViewWithIdentifier: Int) {
        
        DispatchQueue.main.async {
            
        if let visibleRows = self.indexPathsForVisibleRows {
            self.reloadRows(at: visibleRows, with: .automatic)
            }
        }
    }
    
    func indexPath(forItem item: Any) -> IndexPath? {
        let itemPosition: CGPoint = (item as AnyObject).convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }
}
