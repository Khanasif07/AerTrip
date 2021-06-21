//
//  AertripRangeSlider.swift
//  Aertrip
//
//  Created by  hrishikesh on 05/02/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class AertripRangeSlider : UIControl {
  
    
    var minimumValue: CGFloat = 0
    var leftValue : CGFloat = 0.0
    var maximumValue: CGFloat = 1
    var rightValue : CGFloat = 1.0
    var markerPositions : [CGFloat]?
    
    var knobRadius  : CGFloat = 15
    let leftImageView  = UIImageView()
    let rightImageView = UIImageView()
    let trackerView = UIView()
    let selectedTrackView = UIView()
    let spacing : CGFloat = 15.0
    var spacingBetweenKnobs : CGFloat {
        return knobRadius * 2 + spacing
    }
    
    private var addedMarkers = [UIView]()
        
//    UIColor(displayP3Red: (230.0 / 255.0), green: (230.0 / 255.0), blue: (230.0 / 255.0), alpha: 1.0)
    var trackColor : UIColor  = AppColors.sliderTrackColor{
        willSet(newColor) {
            trackerView.backgroundColor = newColor
        }
    }
    
    var selectedTrackColor = AppColors.themeGreen//UIColor(displayP3Red: 0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.bounds
        frame.size.height = 3.0
        frame.origin.x = knobRadius
        frame.origin.y = knobRadius - 1.0
        frame.size.width = frame.size.width - 2 * knobRadius
        trackerView.frame = frame
        setUIPositions()
        
        guard let positions = markerPositions else {  return }
        let subviews = trackerView.subviews.filter{ $0.tag > 499 }
        
        let trackerWidth = frame.size.width
        for i in 0 ..< positions.count {
            
            let marker = subviews[ i ]
            let position = positions[i]
            marker.frame = CGRect(x: (position * trackerWidth ), y: 0, width: 3.0, height: 3.0)
        }
    }
    
    
    func set(leftValue  : CGFloat , rightValue: CGFloat) {
        
        self.leftValue = leftValue
        self.rightValue = rightValue
        self.setNeedsLayout()
    }
    
    func setUIPositions()
    {
        let trackWidth = (self.bounds.size.width - 2 * knobRadius)
        let leftImageViewRect =  CGRect(x: leftValue *  trackWidth , y: 0, width: knobRadius * 2.0, height: knobRadius * 2.0)
        leftImageView.frame = leftImageViewRect
        
        let rightImageViewRect = CGRect(x: rightValue *  trackWidth , y: 0, width: knobRadius * 2.0, height: knobRadius * 2.0)
        rightImageView.frame = rightImageViewRect
        
        
        let selectedTrackWidth = (rightValue - leftValue) * trackWidth
        let selectedTrackRect = CGRect(x: leftValue *  trackWidth , y: 0, width: selectedTrackWidth, height: 3.0)
        selectedTrackView.frame = selectedTrackRect
    }
    
    func createMarkersAt(positions : [CGFloat]) {
        
        addedMarkers.forEach { $0.removeFromSuperview() }
        addedMarkers.removeAll()
        
        markerPositions = positions
        var tag = 500
        for position in positions {
        
            let trackWidth = (self.bounds.size.width - 2 * knobRadius)
            let xPosition = position * trackWidth
            let marker = UIView(frame: CGRect(x: xPosition, y: 0 , width: 3.0, height: 3.0 ))
            marker.tag = tag
            tag = tag + 1
            marker.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            addedMarkers.append(marker)
            trackerView.addSubview(marker)
            trackerView.bringSubviewToFront(marker)
        }
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }

    private func commonInit() {
        backgroundColor = .white
        self.addSubview(trackerView)
        trackerView.backgroundColor = UIColor(displayP3Red: (230.0 / 255.0), green: (230.0 / 255.0), blue: (230.0 / 255.0), alpha: 1.0)
        
        selectedTrackView.backgroundColor = selectedTrackColor
        //To Add color for dark mode
        trackerView.backgroundColor = AppColors.sliderTrackColor
        
        leftImageView.image = AppImages.sliderHandle
        leftImageView.isUserInteractionEnabled = true
        rightImageView.image = AppImages.sliderHandle
        rightImageView.isUserInteractionEnabled = true
        
        self.addSubview(leftImageView)
        self.addSubview(rightImageView)
        trackerView.addSubview(selectedTrackView)

        
        let leftGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan))
        leftImageView.addGestureRecognizer(leftGestureRecognizer)

        
        let rightGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleRightPan))
        rightImageView.addGestureRecognizer(rightGestureRecognizer)
    }
     
    @IBAction func handleLeftPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.location(in: self)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            var xCoordinate = max(translation.x , 0.0 )

            let trackWidth = (self.bounds.size.width - 2 * knobRadius)
            
            //Upper end limit
            if xCoordinate > (trackWidth - knobRadius - spacing) {
                xCoordinate = trackWidth - knobRadius - spacing
            }
                    
            leftValue = max(xCoordinate / trackWidth,0.0)
            // Pushing right knob to keep distance between two
            
            if (xCoordinate > (rightImageView.center.x - spacingBetweenKnobs - spacing )) {
                let rightKnobCenter = xCoordinate + spacingBetweenKnobs
                rightValue = min(rightKnobCenter / trackWidth , 1.0)
           }
            
            self.setNeedsLayout()
            sendActions(for: .valueChanged)

        }
        else if gestureRecognizer.state == .ended {
            sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func handleRightPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            
            let trackWidth = (self.bounds.size.width - 2 * knobRadius)
            let location = gestureRecognizer.location(in:self).x
            var xCoordinate = location
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
            // Lower Limit
            if xCoordinate < (spacingBetweenKnobs ) {
                xCoordinate = (spacingBetweenKnobs )
            }
            
            rightValue = min(xCoordinate / trackWidth, 1.0)
            
             // Pushing left knob to keep distance between two
            if (xCoordinate - spacingBetweenKnobs < leftImageView.center.x - spacing ) {
                let leftKnobCenter = xCoordinate - spacingBetweenKnobs
                leftValue = max(leftKnobCenter/trackWidth, 0.0)
            }
            
            self.setNeedsLayout()
            sendActions(for: .valueChanged)
        }
        else if gestureRecognizer.state == .ended {
            sendActions(for: .touchUpInside)
        }
    }
}
