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
    var sourceUrl: String
    var downloadRequest: DownloadRequest? = nil
    var progressUpdate: ProgressUpdate? = nil
    var destinationUrl: String
    var downloadingStatus: DownloadingStatus = .notDownloaded
//    var previosProgress: Double = 0.0
    
    init() {
        self.sourceUrl = "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"
        self.destinationUrl = ""

    }
}
