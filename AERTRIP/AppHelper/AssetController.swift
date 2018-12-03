//
//  PickerController.swift
//  
//
//  Created by Pramod Kumar on 24/07/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import Photos

// MARK:- Class Implementation
//===============================
class AssetController: NSObject {
    
    static var main = AssetController()
    
    override init() {
        super.init()
    }
}

// MARK:- Public Functions
//===========================
extension AssetController {
    
    /// Request Permission for PHPhotoLibrary
    public func requestPermissions(completion: @escaping ((_ isAuthorized: Bool) -> Void)) {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            
            switch status {
            case .authorized: completion(true)
            case .restricted, .denied: completion(false)
            case .notDetermined: self?.requestPermissions(completion: completion)
            }
        }
    }
    
    /// Fetch All Images
    public func fetchAllImages(start: Int = 0,
                               limit: Int = 50,
                               quality: PHImageRequestOptionsDeliveryMode = .opportunistic,
                               targetImageSize: CGSize = CGSize(width: 400, height: 400),
                               updateBlock: @escaping (_ newImage: UIImage) -> Void) {
        
        // Request for permission
        self.requestPermissions { (isAuthorized) in
            
            // Checking Authorization
            guard isAuthorized else { return }
            
            // Instantiate PHFetchOptions
            let fetchOptions = PHFetchOptions()
            fetchOptions.includeAllBurstAssets = false
            fetchOptions.includeHiddenAssets = false
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            // Fetching all PHAssets
            let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            allPhotos.enumerateObjects({ (phasset, index, _) in
                
                guard index >= start, index < (start+limit) else { return }
                
                // Instantiate PHImageRequestOptions
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = quality
                requestOptions.isSynchronous = true
                
                // Request UIImage from PHAsset
                PHImageManager.default().requestImage(for: phasset, targetSize: targetImageSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (image, info) in
                    
                    if let extractedImage = image {
                        extractedImage.accessibilityIdentifier = "\(phasset.hashValue)"
                        // Callback to updateBlock
                        updateBlock(extractedImage)
                    }
                })
            })
        }
    }
    
    /// Fetch All Videos
    public func fetchAllVideos(start: Int = 0,
                               limit: Int = 20,
                               quality: PHVideoRequestOptionsDeliveryMode = .automatic,
                               updateBlock: @escaping (_ newAVAsset: AVAsset, _ thumbnail: UIImage) -> Void) {
        
        // Request for permission
        self.requestPermissions { (isAuthorized) in
            
            // Checking Authorization
            guard isAuthorized else { return }
            
            // Instantiate PHFetchOptions
            let fetchOptions = PHFetchOptions()
            fetchOptions.includeAllBurstAssets = false
            fetchOptions.includeHiddenAssets = true
            
            // Fetching all PHAssets
            let allVideos = PHAsset.fetchAssets(with: .video, options: nil)
            allVideos.enumerateObjects({ (phasset, index, _) in
                
                guard index >= start, index < (start+limit) else { return }

                // Instantiate PHVideoRequestOptions
                let requestOptions = PHVideoRequestOptions()
                requestOptions.deliveryMode = quality
                
                // Instantiate PHVideoRequestOptions
                PHImageManager.default().requestAVAsset(forVideo: phasset, options: requestOptions, resultHandler: { (avasset, avAudioMix, info) in
                    
                    if let extractedAVAsset = avasset {
                        extractedAVAsset.accessibilityLabel = "\(phasset.hashValue)"
                        let generator = AVAssetImageGenerator(asset: extractedAVAsset)
                        
                        if let newCGImage = try? generator.copyCGImage(at: CMTimeMakeWithSeconds(1, preferredTimescale: 1), actualTime: nil) {
                            
                            let newUIImage = UIImage(cgImage: newCGImage)

                            // Callback to updateBlock
                            updateBlock(extractedAVAsset, newUIImage)
                            
                        } else {
                            // Callback to updateBlock
                            updateBlock(extractedAVAsset, UIImage())
                        }
                    }
                })
            })
        }
    }
}
