//
//  ATGalleryViewConfiguration.swift
//
//  Created by Pramod Kumar on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct ATGalleryViewConfiguration {
    
    /* placeholderImage
     * - used to show while image is downloading from web.
     */
    static var placeholderImage: UIImage = #imageLiteral(resourceName: "hotelCardPlaceHolder")
    
    /* placeholderImage
     * - used in close button
     */
    static var closeButtonImage: UIImage = #imageLiteral(resourceName: "ic_close_gallery")
    
    /* changeModeNormalImage
     * - used in change scrolldirection mode button button
     */
    static var changeModeNormalImage: UIImage = #imageLiteral(resourceName: "ic_gallery_horizontal_view")
    
    /* changeModeSelectedImage
     * - used in change scrolldirection mode button button
     */
    static var changeModeSelectedImage: UIImage = #imageLiteral(resourceName: "ic_gallery_vertical_view")
    
    /* placeholderImage
     * - used to show while image is downloading from web.
     */
    static var shouldShowLoader: Bool = true
    
    /* placeholderImage
     * - used to show while image is downloading from web.
     */
    static var viewMode: ATGalleryViewController.ViewMode = .vertical
    
    /* imageViewHeight
     * - used to give the height for the image view
     */
    static var imageViewHeight: CGFloat = 210.0
    
    /* isStatusBarHidden
     * - used to hide/show status bar
     */
    static var isStatusBarHidden: Bool = true
    
    /* imageContentMode
     * - used to set the filling mode of image view
     */
    static var imageContentMode: UIView.ContentMode = .scaleToFill
    
    /* minimumZoomScale
     * - used to set the minimum zoom scale
     */
    static var minimumZoomScale: CGFloat = 0.1
    
    /* maximumZoomScale
     * - used to set the maximum zoom scale
     */
    static var maximumZoomScale: CGFloat = 4.0
    
}


protocol ATGalleryViewDatasource: class {
    func numberOfImages(in galleryView: ATGalleryViewController) -> Int
    func galleryView(galleryView: ATGalleryViewController, galleryImageAt index: Int) -> ATGalleryImage
}

protocol ATGalleryViewDelegate: class {
    func galleryView(galleryView: ATGalleryViewController, willShow image: ATGalleryImage, for index: Int)
}
