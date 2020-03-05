//
//  ATNotificationLabel.swift
//
//
//  Created by Admin on 06/12/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private let edgeMargin:CGFloat = 6.0

private class BadgeInfo {
    // the index that the button in categories
    var index: Int = -1
    var badgeLabel: UILabel? = nil
    var numberOfBadge: Int = -1
}


public class ATCategoryNavBar: UIView {
    public weak var delegate: ATCategoryNavBarDelegate?
    public weak var internalDelegate: ATCategoryNavBarDelegate?
    
    fileprivate var barStyle: ATCategoryNavBarStyle
    
    fileprivate var categories: [ATCategoryItem]
    
    fileprivate var separators = [UIView]()
    
    fileprivate lazy var buttons = [ATCategoryButton]()
    
    // each key is the index from categories or buttons
    fileprivate lazy var badgeDict = [Int : BadgeInfo]()
    
    fileprivate lazy var scrollView: UIScrollView = UIScrollView(frame: self.bounds)
    
    // this tag relects any changes in VC switching
    fileprivate var currentButtonTag: Int = 0
    
    // this button keeps track of which button being tapped previously
    fileprivate weak var previousButton: ATCategoryButton?
    
    fileprivate lazy var buttonHeight: CGFloat = self.bounds.height
    
    fileprivate lazy var buttonFont: UIFont = self.barStyle.defaultFont
    
    fileprivate lazy var oldNavScrollPosition: CGPoint = CGPoint.zero
    
    /// Is the UI setup
    fileprivate var isSetup = false
    
    fileprivate lazy var indicator: UIView = {
        let view = UIView()
        view.frame.size.height = self.barStyle.indicatorHeight
        view.frame.origin.y = self.bounds.height - self.barStyle.indicatorHeight
        view.backgroundColor = self.barStyle.indicatorColor
        self.scrollView.addSubview(view)
        return view
    }()
    
    func addTopRoundedCornerToView(targetView:UIView?, desiredCurve:CGFloat?)
    {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    fileprivate lazy var bgMaskView: UIView = {
        let maskView = UIView()
        maskView.backgroundColor = self.barStyle.bgMaskViewColor
        maskView.layer.masksToBounds = true
        maskView.layer.cornerRadius = (self.barStyle.defaultFont.pointSize + edgeMargin) * 0.5
        return maskView
    }()
    
    
    public init(frame: CGRect, categories: [ATCategoryItem], barStyle: ATCategoryNavBarStyle) {
        self.categories = categories
        self.barStyle = barStyle
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        if barStyle.isEmbeddedToView && frame != .zero {
            setupUI()
            isSetup = true
        }
        
    }

    public override var frame: CGRect {
        didSet {
            if !barStyle.isEmbeddedToView && frame != .zero && isSetup == false {
                setupUI()
                isSetup = true
            }
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public func setItem(item: ATCategoryItem, for index:Int) {
        guard index >= 0 && index < categories.count else {
            fatalError("index out of bound")
        }
        
        let btn = buttons[index]
        categories.remove(at: index)
        categories.insert(item, at: index)
        setup(btn, with: item, atIndex: index)
    }
    
    public func select(at index: Int) {
        guard index >= 0 && index < categories.count else {
            fatalError("index out of bound")
        }
        
        let btn = buttons[index]
        titleBtnTapped(btn)
    }
    
    public func setBadge(atIndex index:Int, numberOfBadge: Int) {
        guard index >= 0 && index < categories.count else {
            fatalError("index out of bound")
        }
        
        let btn = buttons[index]

        if let badgeInfo = badgeDict[index]{
            badgeInfo.numberOfBadge = numberOfBadge
            addBadgeToBtn(btn: btn, badgeInfo: badgeInfo)
        }else{
            let badgeInfo = BadgeInfo()
            badgeInfo.index = index
            badgeInfo.numberOfBadge = numberOfBadge
            badgeDict[index] = badgeInfo
            addBadgeToBtn(btn: btn, badgeInfo: badgeInfo)
        }
        
    }
    
    private func addBadgeToBtn(btn: ATCategoryButton, badgeInfo: BadgeInfo) {
        // Removing process
        if badgeInfo.numberOfBadge == 0 {
            guard let badgeLabel = badgeInfo.badgeLabel else {
                return
            }
            badgeLabel.removeFromSuperview()
            badgeDict.removeValue(forKey: badgeInfo.index)
            return
        }
        
        // In case there's alrady a badgeLabel, remove it now.
        if let badgeLabel = badgeInfo.badgeLabel {
            badgeLabel.removeFromSuperview()
        }
        
        // Adding process
        btn.layoutSubviews()
        
        
        let item = self.categories[badgeInfo.index]
        
        var referenceFrame: CGRect
        // Image has a higher priority
        if (item.normalImage != nil || item.selectedImage != nil),
            let imageViewFrame = btn.imageView?.frame, imageViewFrame != CGRect.zero {
            referenceFrame = imageViewFrame
        }else if let _ = item.title, let labelFrame = btn.titleLabel?.frame{
            referenceFrame = labelFrame
        }else{
            printDebug("category at section:(badgeInfo.index) doesn't have a valid AHCategoryItem")
            return
        }
        
        let badgeLabel = UILabel()
        badgeLabel.textAlignment = .center

        
        if badgeInfo.numberOfBadge == 1 {
            badgeLabel.backgroundColor = barStyle.badgeBackgroundColor
            badgeLabel.frame.size = barStyle.badgeDotSize
            badgeLabel.frame.origin.x = referenceFrame.maxX
            badgeLabel.frame.origin.y = referenceFrame.origin.y
            badgeLabel.layer.cornerRadius = barStyle.badgeDotSize.height * 0.5
            badgeLabel.layer.borderColor = barStyle.badgeBorderColor.cgColor
            badgeLabel.layer.borderWidth = barStyle.badgeBorderWidth
            badgeLabel.layer.masksToBounds = true
            btn.addSubview(badgeLabel)
            badgeInfo.badgeLabel = badgeLabel
            return
        }
        
        badgeLabel.backgroundColor = barStyle.badgeBackgroundColor
        badgeLabel.textColor = barStyle.badgeTextColor
        badgeLabel.font = barStyle.badgeTextFont
        badgeLabel.text = "\(badgeInfo.numberOfBadge)"
        badgeLabel.sizeToFit()
        let oldFrame = badgeLabel.frame
        badgeLabel.frame.size = CGSize(width: oldFrame.width + 5.0, height: oldFrame.height)
        badgeLabel.frame.origin.x = referenceFrame.maxX
        badgeLabel.frame.origin.y = referenceFrame.origin.y - badgeLabel.frame.size.height * 0.5
        var cornerRadius = 0.0
        
        if badgeInfo.numberOfBadge > 1 &&  badgeInfo.numberOfBadge < 10 {
            cornerRadius = Double(badgeLabel.intrinsicContentSize.height * 0.5 - 1.0)
            
        }else if badgeInfo.numberOfBadge >= 10 {
            cornerRadius = Double(badgeLabel.intrinsicContentSize.height * 0.5)
        }
        badgeLabel.layer.cornerRadius = CGFloat(cornerRadius)
        badgeLabel.layer.borderColor = barStyle.badgeBorderColor.cgColor
        badgeLabel.layer.borderWidth = barStyle.badgeBorderWidth
        badgeLabel.layer.masksToBounds = true
        btn.addSubview(badgeLabel)
        badgeInfo.badgeLabel = badgeLabel
        
    }
    
}

//MARK:- Setups
fileprivate extension ATCategoryNavBar {
    func setupUI() {
        setupBottomSeparator()
        setupScrollView()
        addButtons()
        setupIndicator()
        setupBgMaskView()

    }
    func setupBottomSeparator() {
        guard barStyle.showBottomSeparator else {
            return
        }
        let separator = UIView()
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        separator.backgroundColor = barStyle.bottomSeparatorColor
        self.addSubview(separator)
    }
    func setupScrollView(){
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = barStyle.isScrollable
        scrollView.contentInset = barStyle.contentInset
        addSubview(scrollView)
    }
    
    
    func setup(_ btn: ATCategoryButton, with item: ATCategoryItem, atIndex index:Int) {
        btn.imageView?.contentMode = .scaleAspectFill
        btn.tag = index
        btn.isHighlighted = false
        if let itemTitle = item.title {
            btn.setTitle(itemTitle, for: .normal)
            if btn.tag == 0 {
                btn.setTitleColor(barStyle.selectedColor, for: .normal)
            }else{
                btn.setTitleColor(barStyle.normalColor, for: .normal)
            }
            btn.titleLabel?.textAlignment = .center
            btn.setTitleFont(font: barStyle.defaultFont, for: .normal)
            btn.setTitleFont(font: barStyle.selectedFont, for: .selected)
            if index == 0 {
                btn.isSelected = true
                previousButton = btn
            }
            else {
                btn.isSelected = false
            }
        }
        
        if let normalImage = item.normalImage {
            btn.setImage(normalImage, for: .normal)
        }
        
        if let selectedImage = item.selectedImage {
            btn.setImage(selectedImage, for: .selected)
        }
    }
    
    func addButtons() {
        for i in 0..<categories.count {
            let btn = ATCategoryButton()
            let item = categories[i]
            setup(btn, with: item, atIndex: i)
            
            var x: CGFloat = 0.0
            let y: CGFloat = 0.0
            var width: CGFloat = 0.0
            let height = self.buttonHeight
            let textWidth: CGFloat = btn.intrinsicContentSize.width
            
            
            
            if barStyle.isScrollable {
                // scrollabel, each label has its own width according to its text
                width = textWidth + barStyle.itemPadding * 2
                if i > 0 {
                    let previousBtn = buttons[i - 1]
                    x = previousBtn.frame.maxX + barStyle.interItemSpace
                }
                // special adjustment for the first button
                if i == 0 {
                    x = barStyle.interItemSpace * 0.5
                }
            }else{
                if barStyle.layoutAlignment == .left {
                    width = textWidth + barStyle.itemPadding * 2
                    if i > 0 {
                        let previousBtn = buttons[i - 1]
                        x = previousBtn.frame.maxX + barStyle.interItemSpace
                    }
                    // special adjustment for the first button
                    if i == 0 {
                        x = barStyle.interItemSpace * 0.5
                    }
                }else {
                    width = self.bounds.width / CGFloat(categories.count)
                    
                    if i > 0 {
                        x = width * CGFloat(i)
                    }
                }
            }
            
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.addTarget(self, action: #selector(titleBtnTapped(_:)), for: .touchUpInside)
            buttons.append(btn)
            
            scrollView.addSubview(btn)

            let contentWidth:CGFloat = buttons.last!.frame.maxX + barStyle.interItemSpace * 0.5
            let contentHeight:CGFloat = self.bounds.height
            scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
            
        }
    }
    
    func setupIndicator() {
        guard barStyle.showIndicator else {
            return
        }
        let defaultBtn = buttons[0]
        let width: CGFloat = defaultBtn.intrinsicContentSize.width
        indicator.frame.size.width = width
        indicator.center.x = defaultBtn.center.x
    }
    
    func setupBgMaskView() {
        guard barStyle.showBgMaskView else {
            return
        }
        let defaultBtn = buttons[0]
        let width: CGFloat = defaultBtn.intrinsicContentSize.width
        
        if let customMask = barStyle.bgMaskView {
            bgMaskView = customMask
        }
        scrollView.insertSubview(bgMaskView, at: 0)
        
        bgMaskView.frame.size.width = width + 2 * edgeMargin
        bgMaskView.frame.size.height = barStyle.defaultFont.pointSize + 2 * edgeMargin
        bgMaskView.center.x = defaultBtn.center.x
        bgMaskView.frame.origin.y = (self.bounds.height - bgMaskView.frame.size.height) * 0.5 + 1.0 // the 1.0 is just a little adjustment
    }
    
    
    /// Use view.intrinsicContentSize
    func getTextWidth(for label: UILabel) -> CGFloat {
        
        let font = barStyle.defaultFont
        let height: CGFloat = self.bounds.height // certain
        let boundSize = CGSize(width: CGFloat(Float.greatestFiniteMagnitude), height: height)
        let textWidth = (label.text! as NSString).boundingRect(with: boundSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).width
        
        return textWidth
    }
    
}


//MARK:- Event Handling
private extension ATCategoryNavBar {
    @objc func titleBtnTapped(_ btn: ATCategoryButton) {
        guard btn.tag != currentButtonTag else {
            // prevent mutiple tapping on the same button
            return
        }
        
        previousButton?.isSelected = false
        btn.isSelected = true
        previousButton = btn
        
        delegate?.categoryNavBar(self, willSwitchIndexFrom: currentButtonTag, to: btn.tag)
        internalDelegate?.categoryNavBar(self, willSwitchIndexFrom: currentButtonTag, to: btn.tag)
        
        handleBtnSwitching(currentBtn: btn, shouldCallDelegate: false)
        handleIndicator(currentBtn: btn)
        handleBgMaskView(currentBtn: btn)
        
        delegate?.categoryNavBar(self, didSwitchIndexTo: btn.tag)
        internalDelegate?.categoryNavBar(self, didSwitchIndexTo: btn.tag)
    }
    
    func handleBtnSwitching(currentBtn: ATCategoryButton, shouldCallDelegate: Bool = true) {
        
        let previousBtn = buttons[currentButtonTag]
        
        previousBtn.setTitleColor(barStyle.normalColor, for: .normal)
        currentBtn.setTitleColor(barStyle.selectedColor, for: .normal)
        currentButtonTag = currentBtn.tag
        
        if shouldCallDelegate {
            delegate?.categoryNavBar(self, didSwitchIndexTo: currentButtonTag)
            internalDelegate?.categoryNavBar(self, didSwitchIndexTo: currentButtonTag)
        }
        
        if barStyle.isScrollable, self.scrollView.contentSize.width > self.scrollView.frame.width {
            scrollToCenter(currentBtn: currentBtn)
        }
    }
    
    func handleIndicator(currentBtn: ATCategoryButton) {
        guard barStyle.showIndicator else {
            return
        }
        
        let width = currentBtn.intrinsicContentSize.width
        if barStyle.showBarSelectionAnimation {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.indicator.frame.size.width = width
                self?.indicator.center.x = currentBtn.center.x
            }
        }else{
            self.indicator.frame.size.width = width
            self.indicator.center.x = currentBtn.center.x
        }
        
    }
    
    func handleBgMaskView(currentBtn: ATCategoryButton) {
        guard barStyle.showBgMaskView else {
            return
        }
        let width = currentBtn.intrinsicContentSize.width
        if barStyle.showBarSelectionAnimation {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let sSelf = self else {return}
                sSelf.bgMaskView.frame.size.width = width + 2 * edgeMargin
                sSelf.bgMaskView.center.x = currentBtn.center.x
            }
        }else{
            self.bgMaskView.frame.size.width = width + 2 * edgeMargin
            self.bgMaskView.center.x = currentBtn.center.x
        }
        
    }
    
    func scrollToCenter(currentBtn: ATCategoryButton, animated: Bool = true) {
        guard barStyle.isScrollable else {
            return
        }
        
        var centerX = currentBtn.center.x - scrollView.bounds.width * 0.5
        if centerX < 0.0 {
            // for labels positioned on the left side of scrollView.bounds.width * 0.5
            centerX = 0.0
            
        }
        
        // the x position for the last screen of the scroll
        let maxLeftEdge = scrollView.contentSize.width - bounds.width
        if centerX > maxLeftEdge{
            centerX = maxLeftEdge
        }
        scrollView.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: true)
        
//
//        scrollView.setContentOffset(CGPoint(x: currentBtn.x, y: 0.0), animated: animated)
//        oldNavScrollPosition = scrollView.contentOffset
    }
}


extension ATCategoryNavBar: ATCategoryContainerDelegate {
    public func categoryContainer(_ container: UIView, didSwitchIndexTo toIndex: Int) {
        guard toIndex < buttons.count else {
            return
        }

        let currentBtn = buttons[toIndex]
        
        handleBtnSwitching(currentBtn: currentBtn)
        handleIndicator(currentBtn: currentBtn)
        handleBgMaskView(currentBtn: currentBtn)
        
        previousButton?.isSelected = false
        currentBtn.isSelected = true
        previousButton = currentBtn
    }
    
     public func categoryContainer(_ container: UIView, transitioningFromIndex fromIndex:Int, toIndex:Int, progress: CGFloat) {
        guard barStyle.showTransitionAnimation else {
            return
        }
        guard fromIndex >= 0, fromIndex < buttons.count else {
            return
        }
        guard toIndex >= 0, toIndex < buttons.count else {
            return
        }
        
        makeColorTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
        makeIndicatorTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
//        makeScrollViewTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
        makeBgMaskViewTransition(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
    func makeScrollViewTransition(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        guard (scrollView.width) < indicator.x else { return }

        let fromBtn = buttons[fromIndex]
        let toBtn = buttons[toIndex]

        let deltaX = ((toBtn.x - fromBtn.x) * 1.0) * progress

        printDebug("scroll.x \(scrollView.contentOffset.x) add \(deltaX) = \(oldNavScrollPosition.x)")
        scrollView.setContentOffset(CGPoint(x: (oldNavScrollPosition.x + deltaX), y: scrollView.contentOffset.y), animated: false)
    }
    
    func makeIndicatorTransition(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        guard barStyle.showIndicator else {
            return
        }
        
        let fromBtn = buttons[fromIndex]
        let toBtn = buttons[toIndex]
        
        let fromWidth = fromBtn.intrinsicContentSize.width
        let toWidth = toBtn.intrinsicContentSize.width
        
        let deltaX = (toBtn.center.x - fromBtn.center.x) * progress
        let deltaWidth = toWidth - fromWidth
        
        indicator.center.x = fromBtn.center.x + deltaX
        indicator.frame.size.width = fromWidth + deltaWidth * progress
    }
    
    func makeColorTransition(fromIndex: Int, toIndex: Int, progress: CGFloat){
        let fromBtn = buttons[fromIndex]
        let toBtn = buttons[toIndex]
        
        let colorDifferences = UIColor.getRGBDelta(first: barStyle.selectedColor, second: barStyle.normalColor)
        
        let redDiff = colorDifferences.0 * progress
        let greenDiff = colorDifferences.1 * progress
        let blueDiff = colorDifferences.2 * progress
        
        let fromColorComp = barStyle.selectedColor.getRGBComponents()
        let fromRed = fromColorComp.0 - redDiff
        let fromGreen = fromColorComp.1 - greenDiff
        let fromBlue = fromColorComp.2 - blueDiff
        let fromColor = UIColor(displayP3Red: fromRed, green: fromGreen, blue: fromBlue, alpha: 1.0)
        
        let toColorComp = barStyle.normalColor.getRGBComponents()
        let toRed = toColorComp.0 + redDiff
        let toGreen = toColorComp.1 + greenDiff
        let toBlue = toColorComp.2 + blueDiff
        let toColor = UIColor(displayP3Red: toRed, green: toGreen, blue: toBlue, alpha: 1.0)
        
        fromBtn.setTitleColor(fromColor, for: .normal)
        toBtn.setTitleColor(toColor, for: .normal)
    }
    
    func makeBgMaskViewTransition(fromIndex: Int, toIndex: Int, progress: CGFloat) {
        guard barStyle.showBgMaskView else {
            return
        }
        let fromBtn = buttons[fromIndex]
        let toBtn = buttons[toIndex]
        let fromWidth = fromBtn.intrinsicContentSize.width
        let toWidth = toBtn.intrinsicContentSize.width
        
        let deltaWidth = (toWidth - fromWidth) * progress
        let deltaX = (toBtn.center.x - fromBtn.center.x) * progress

        let width = fromWidth + deltaWidth + 2 * edgeMargin
        let x = fromBtn.center.x + deltaX
       
        self.bgMaskView.frame.size.width = width
        self.bgMaskView.center.x = x
        
    }
}







