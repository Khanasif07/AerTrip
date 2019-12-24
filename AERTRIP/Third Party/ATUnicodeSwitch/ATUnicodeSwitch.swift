//
//  ATUnicodeSwitch.swift
//  ATUnicodeSwitch
//
//

import UIKit

@IBDesignable
class ATUnicodeSwitch: UIControl {
  
  @IBInspectable var sliderColor: UIColor = UIColor.clear {
    didSet {
      sliderView.backgroundColor = sliderColor
    }
  }
  
  
  @IBInspectable var textColorFront: UIColor = UIColor.darkGray {
    didSet {
      frontLabels[0].textColor = textColorFront
      frontLabels[1].textColor = textColorFront
    }
  }
  
  
  @IBInspectable var textColorBack: UIColor = UIColor.white {
    didSet {
      backgroundLabels[0].textColor = textColorBack
      backgroundLabels[1].textColor = textColorBack
    }
  }
  
//  @IBInspectable var  cornerRadius: CGFloat = 12.0 {
//    didSet {
//      layer.cornerRadius = cornerRadius
//      sliderView.layer.cornerRadius = cornerRadius - 2
//      layoutSlider()
//    }
//  }
  
  @IBInspectable var sliderInset: CGFloat = 2.0 {
    didSet {
      layoutSlider()
    }
  }
  
  @IBInspectable var titleLeft: String! {
    didSet {
      backgroundLabels[0].text = titleLeft
      frontLabels[0].text = titleLeft
    }
  }
  
  @IBInspectable var titleRight: String! {
    didSet {
      backgroundLabels[1].text = titleRight
      frontLabels[1].text = titleRight
    }
  }
  
    var selectedIndex: Int = -1
    
    var font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body) {
      didSet {
          for label in backgroundLabels {
              label.font = font
          }

          for label in frontLabels {
              label.font = font
          }
      }
  }
  
  private var backgroundLabels: [UILabel] = []
   var sliderView: UIView!
   var sliderOuterView:UIView!
  private var frontLabels: [UILabel] = []
  private var sliderWidth: CGFloat { return bounds.width / 2 }
  
  // MARK: Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    setupBackground()
    setupBackgroundLabels()
    setupSliderView()
    setupFrontLabels()
  }
  
  private func setupBackground() {
    isUserInteractionEnabled = true
    layer.cornerRadius = cornerRadius
  }
  
  private func setupBackgroundLabels() {
    for index in 0...1 {
      let label = UILabel()
      label.tag = index
      label.font = font
      label.textColor = textColorBack
      label.adjustsFontSizeToFitWidth = true
      label.textAlignment = .center
      addSubview(label)
      backgroundLabels.append(label)
      
      label.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ATUnicodeSwitch.handleRecognizerTap(recognizer:)))
      label.addGestureRecognizer(recognizer)
    }
  }
  
  private func setupSliderView() {
    let sliderView = UIView()
   // let sliderOuterView = UIView()
    
    sliderView.backgroundColor = sliderColor
   // sliderOuterView.backgroundColor = UIColor.red
    //sliderView.clipsToBounds = true
    let sliderRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ATUnicodeSwitch.sliderMoved(recognizer:)))
    sliderView.addGestureRecognizer(sliderRecognizer)
    self.sliderView = sliderView
   // self.sliderOuterView = sliderOuterView
    addSubview(sliderView)
   // sliderOuterView.addSubview(sliderView)
    
  }
  
  private func setupFrontLabels() {
    for _ in 0...1 {
      let label = UILabel()
      label.font = font
      label.textColor = textColorFront
      label.adjustsFontSizeToFitWidth = true
      label.textAlignment = .center
      sliderView.addSubview(label)
      frontLabels.append(label)
    }
  }
  
  // MARK: Layout
  
  private func layoutSlider() {
    layoutSliderView(index: selectedIndex)
    layoutBackgroundLabels()
    layoutFrontLabels()
  }
  
  private func layoutSliderView(index: Int) {
    sliderView.frame = CGRect(x: sliderWidth * CGFloat(index) + sliderInset, y: sliderInset, width: sliderWidth - sliderInset * 2, height: bounds.height - sliderInset * 2)
   // sliderOuterView.frame = CGRect(x: (sliderWidth * CGFloat(index) + sliderInset ) - 2, y: sliderInset, width: self.frame.size.width / 2,height:  self.frame.size.width / 2)
  }
  
  private func layoutBackgroundLabels() {
    for index in 0...1 {
      let label = backgroundLabels[index]
      label.frame = CGRect(x: CGFloat(index) * sliderWidth, y: 0, width: sliderWidth, height: bounds.height)
    }
  }
  
  private func layoutFrontLabels() {
    let offsetX = sliderView.frame.origin.x - sliderInset
    for index in 0...1 {
      let label = frontLabels[index]
      label.frame = CGRect(x: CGFloat(index) * sliderWidth - sliderInset - offsetX, y: -sliderInset, width: sliderWidth, height: bounds.height)
    }
  }
  
  // MARK: Set Selection
  
  func setSelectedIndex(index: Int, animated: Bool) {
 //   assert(index >= 0 && index < 2)
    updateSlider(index: index, animated: false)
  }
  
  // MARK: Update Slider
  
  private func updateSlider(index: Int, animated: Bool) {
    animated ? updateSliderWithAnimation(index: index) : updateSliderWithoutAnimation(index: index)
  }
  
  private func updateSliderWithoutAnimation(index: Int) {
    updateSlider(index: index)
    updateSelectedIndex(index: index)
  }
  
  private func updateSlider(index: Int) {
    layoutSliderView(index: index)
    layoutFrontLabels()
  }
  
   func updateSelectedIndex(index: Int) {
    if selectedIndex != index {
      selectedIndex = index
      sendActions(for: UIControl.Event.valueChanged)
    }
  }
  
  private func updateSliderWithAnimation(index: Int) {
    let duration = calculateAnimationDuration(index: index)
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: { () -> Void in
      self.updateSlider(index: index)
      }, completion: { (finished) -> Void in
        self.updateSelectedIndex(index: index)
    })
  }
  
  private func calculateAnimationDuration(index: Int) -> TimeInterval {
    let targetX = sliderWidth * CGFloat(index) + sliderInset
    let distance = targetX - sliderView.frame.origin.x
    _ = TimeInterval(distance / 300)
    return 0
 //   return duration
  }
  
  // MARK: UITapGestureRecognizer
  
  @objc func handleRecognizerTap(recognizer: UITapGestureRecognizer) {
    let index = recognizer.view!.tag
    updateSliderWithAnimation(index: index)
  }
  
  // MARK: UIPanGestureRecognizer
  
  @objc func sliderMoved(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .changed:
      panGestureRecognizerChanged(recognizer: recognizer)
    case .ended, .cancelled, .failed:
      panGestureRecognizerFinished(recognizer: recognizer)
    default:
      return
    }
  }
    
  private func panGestureRecognizerChanged(recognizer: UIPanGestureRecognizer) {
    let minPos = sliderInset
    let maxPos = minPos + sliderView.bounds.width
    
    let translation = recognizer.translation(in: recognizer.view!)
    recognizer.view!.center.x += translation.x
    recognizer.setTranslation(CGPoint.zero, in: recognizer.view!)
      
    if sliderView.frame.origin.x < minPos {
      sliderView.frame.origin.x = minPos
    } else if sliderView.frame.origin.x > maxPos {
      sliderView.frame.origin.x = maxPos
    }
    
    layoutFrontLabels()
  }
    
  private func panGestureRecognizerFinished(recognizer: UIPanGestureRecognizer) {
    let index = sliderView.center.x > sliderWidth ? 1 : 0
    updateSliderWithAnimation(index: index)
  }
  
}
