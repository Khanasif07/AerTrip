//
//  ATGalleryImage.swift
//
//  Created by Pramod Kumar on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct ATGalleryImage {
    var image: UIImage?
    var imageUrl: URL? {
        return imagePath?.toUrl
    }
    var imagePath: String?
    var retryCount = 0
}
