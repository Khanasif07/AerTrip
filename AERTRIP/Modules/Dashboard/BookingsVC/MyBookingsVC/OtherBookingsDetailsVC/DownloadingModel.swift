//
//  DownloadingModel.swift
//  AERTRIP
//
//  Created by Admin on 27/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import Alamofire

class DocumentDownloadingModel {
    enum DownloadingStatus {
        case notDownloaded , downloading , downloaded
    }
    var sourceUrl: String = ""
    var downloadRequest: DownloadRequest? = nil
    var progressUpdate: ProgressUpdate? = nil
    var destinationUrl: String = ""
    var downloadingStatus: DownloadingStatus = .notDownloaded
    
    var path: String = ""
    var fileName: String = ""
    var ext: String = ""
    var size: String = ""
    var type: String = ""
    var icon: String = ""
    
    
//    var previosProgress: Double = 0.0
    
    init() {
        self.sourceUrl = "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"
        self.destinationUrl = ""

    }
    
    init(json: JSONDictionary) {
        if let obj = json["path"] {
            self.path = "\(obj)"
        }
        
        if let obj = json["filename"] {
            self.fileName = "\(obj)"
        }
        
        if let obj = json["ext"] {
            self.ext = "\(obj)"
        }
        
        if let obj = json["size"] {
            self.size = "\(obj)"
        }
        
        if let obj = json["type"] {
            self.type = "\(obj)"
        }
        
        if let obj = json["icon"] {
            self.icon = "\(obj)"
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [DocumentDownloadingModel] {
        return json.map { DocumentDownloadingModel(json: $0) }
    }
}
