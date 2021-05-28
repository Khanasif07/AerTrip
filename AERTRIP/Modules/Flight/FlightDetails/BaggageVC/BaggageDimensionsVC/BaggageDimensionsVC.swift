//
//  BaggageDimensionsVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class BaggageDimensionsVC: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pageTitleView: UIView!
    @IBOutlet weak var dividerView: UILabel!
    @IBOutlet weak var baggageScrollView: UIScrollView!
    @IBOutlet weak var dimensionInfoLabel: UILabel!
    
    @IBOutlet weak var dividerLabel: UILabel!
    @IBOutlet weak var dimensionDetailsInfoLabel: UILabel!
    
    @IBOutlet weak var baggageImgView: UIImageView!
    @IBOutlet weak var weightImg: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightLabelKG: UILabel!
    
    @IBOutlet weak var heightImg: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightLabelCM: UILabel!
    
    @IBOutlet weak var widthImg: UIImageView!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var widthLabelCM: UILabel!
    
    @IBOutlet weak var breadthImg: UIImageView!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var breadthLabelCM: UILabel!
    
    var weight = ""
    var dimensions = JSONDictionary()
    var dimensions_inch = JSONDictionary()
    var dimesionsObj:Dimension?
    var settingForBookingDetails = false
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
        if settingForBookingDetails{
            self.setDataFromDimesion()
        }else{
            self.setDataWithDictionary()
        }

    }
    
    private func setDataFromDimesion(){
        
        if let dimestion = self.dimesionsObj{
            baggageScrollView.isScrollEnabled = true

            baggageImgView.image = AppImages.group4
            self.hideUnhindContent(isHidden: false)
            weightLabel.text = self.weight.lowercased().removeAllWhitespaces.replacingLastOccurrenceOfString("kg", with: "")
            heightLabel.text = "\(dimestion.cm?.height ?? 0)"
            widthLabel.text = "\(dimestion.cm?.width ?? 0)"
            breadthLabel.text = "\(dimestion.cm?.depth ?? 0)"
            
            let cm = (dimestion.cm?.height ?? 0) + (dimestion.cm?.width ?? 0) + (dimestion.cm?.depth ?? 0)
            if let inch = dimestion.inch{
                let height_inch = inch.height
                let width_inch = inch.width
                let depth_inch = inch.depth

                let inch = height_inch + width_inch + depth_inch

                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(inch) inches or \(cm) centimeters for each piece."
            }else{
                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(cm) centimeters for each piece."
            }
            
        }else{
            self.clearData()
        }
        
    }
    
    private func setDataWithDictionary(){
        dimensionDetailsInfoLabel.text = note
        if dimensions.count > 0{
            baggageScrollView.isScrollEnabled = true

            baggageImgView.image = AppImages.group4
            hideUnhindContent(isHidden: false)

            let weights = weight.components(separatedBy: " ")
            weightLabel.text = weights[0]

            let height = dimensions["height"] as? String ?? ""
            let height_double = Double(height)
            heightLabel.text = "\(String(describing: Int(height_double ?? 0)))"
            
            let width = dimensions["width"] as? String ?? ""
            let width_double = Double(width)
            widthLabel.text = "\(String(describing: Int(width_double ?? 0)))"
            
            let depth = dimensions["depth"] as? String ?? ""
            let depth_double = Double(depth)
            breadthLabel.text = "\(String(describing: Int(depth_double ?? 0)))"
            
            let cm = Int(height_double ?? 0) + Int(width_double ?? 0) + Int(depth_double ?? 0)
            
            if dimensions_inch.count > 0{
                let height_inch = dimensions_inch["height"] as? String ?? ""
                let width_inch = dimensions_inch["width"] as? String ?? ""
                let depth_inch = dimensions_inch["depth"] as? String ?? ""

                let inch = (Double(height_inch) ?? 0.0) + (Double(width_inch) ?? 0.0) + (Double(depth_inch) ?? 0.0)

                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(inch) inches or \(cm) centimeters for each piece."
            }else{
                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(cm) centimeters for each piece."
            }
        }else{
            self.clearData()
        }
        
        
    }
    
    private func clearData(){
        baggageScrollView.isScrollEnabled = false
        dimensionInfoLabel.text = ""
        baggageImgView.image = AppImages.Group_4_1
        heightLabel.text = ""
        widthLabel.text = ""
        breadthLabel.text = ""
        weightLabel.text = ""
        
        hideUnhindContent(isHidden: true)
        
    }
    
    private func hideUnhindContent(isHidden: Bool){
        
        baggageScrollView.isScrollEnabled = !isHidden
        heightLabelCM.isHidden = isHidden
        widthLabelCM.isHidden = isHidden
        breadthLabelCM.isHidden = isHidden
        weightLabelKG.isHidden = isHidden

        heightImg.isHidden = isHidden
        widthImg.isHidden = isHidden
        breadthImg.isHidden = isHidden
        weightImg.isHidden = isHidden
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    }

    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
