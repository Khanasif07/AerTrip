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
    var dimensions = NSDictionary()
    var dimensions_inch = NSDictionary()

    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baggageScrollView.delegate = self
        dividerView.isHidden = true
        
        if note == ""{
            dividerLabel.isHidden = true
        }
        
        dimensionDetailsInfoLabel.text = note
  
        if dimensions.count > 0{
            baggageScrollView.isScrollEnabled = true

            baggageImgView.image = UIImage(named: "group4")
            heightLabelCM.isHidden = false
            widthLabelCM.isHidden = false
            breadthLabelCM.isHidden = false
            weightLabelKG.isHidden = false

            heightImg.isHidden = false
            widthImg.isHidden = false
            breadthImg.isHidden = false
            weightImg.isHidden = false

            let weights = weight.components(separatedBy: " ")
            weightLabel.text = weights[0]

            let height = dimensions.value(forKey: "height") as! String
            let height_double = Double(height)
            heightLabel.text = "\(String(describing: Int(height_double!)))"
            
            let width = dimensions.value(forKey: "width") as! String
            let width_double = Double(width)
            widthLabel.text = "\(String(describing: Int(width_double!)))"
            
            let depth = dimensions.value(forKey: "depth") as! String
            let depth_double = Double(depth)
            breadthLabel.text = "\(String(describing: Int(depth_double!)))"
            
            let cm = Int(height_double!) + Int(width_double!) + Int(depth_double!)
            
            if dimensions_inch.count > 0{
                //Crash
                let height_inch = dimensions_inch.value(forKey: "height") as! String
                let width_inch = dimensions_inch.value(forKey: "width") as! String
                let depth_inch = dimensions_inch.value(forKey: "depth") as! String

                let inch = Double(height_inch)! + Double(width_inch)! + Double(depth_inch)!

                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(inch) inches or \(cm) centimeters for each piece."
            }else{
                dimensionInfoLabel.text = "The sum of the 3 dimensions (length + breadth + height) of each piece must not exceed \(cm) centimeters for each piece."
            }
        }else{
            baggageScrollView.isScrollEnabled = false
            
            dimensionInfoLabel.text = ""
            
            baggageImgView.image = UIImage(named: "Group 4.1")
            heightLabel.text = ""
            widthLabel.text = ""
            breadthLabel.text = ""
            weightLabel.text = ""
            
            heightLabelCM.isHidden = true
            widthLabelCM.isHidden = true
            breadthLabelCM.isHidden = true
            weightLabelKG.isHidden = true

            heightImg.isHidden = true
            widthImg.isHidden = true
            breadthImg.isHidden = true
            weightImg.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y > 0{
            dividerView.isHidden = false
        }else{
            dividerView.isHidden = true
        }
    }

    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
