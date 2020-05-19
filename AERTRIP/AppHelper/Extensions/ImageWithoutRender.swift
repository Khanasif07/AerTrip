//
//  File.swift
//  Aertrip
//
//  Created by  hrishikesh on 18/07/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


class ImageWithoutRender: UIImage {
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self
    }
    
}
