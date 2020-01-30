//
//  ATNotificationLabel.swift
//
//
//  Created by Admin on 06/12/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private enum ATCurrentScrollDirection{
    case scrollLeft
    case scrollright
}


class ATPageContainerView: UIView {

    var interControllerSpacing: CGFloat = 0.0
    
    var childVCs: [UIViewController]
    weak var delegate: ATCategoryContainerDelegate?
    weak var parentVC: UIViewController!
    
    fileprivate lazy var pageVC: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: self.interControllerSpacing])
    
    fileprivate weak var pageScrollView: UIScrollView?
    fileprivate weak var pageControl: UIPageControl?
    
    /// this will be nil after each transition, and before "willTransitionTo pendingViewControllers:" is called
    fileprivate var willTransitionToIndex: Int?
    
    /// this will be nil after "willTransitionTo pendingViewControllers:" is called
    fileprivate var currentDirection: ATCurrentScrollDirection?
    
    fileprivate var currentIndex: Int = 0
    
    fileprivate lazy var controllerWidth: CGFloat = self.bounds.width + self.interControllerSpacing
    
    
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupPageVC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupPageVC(){
        
        pageVC.delegate = self
        pageVC.dataSource = self
        for view in pageVC.view.subviews {
            if view.isKind(of: UIPageControl.self) {
                view.removeFromSuperview()
            }
            if view.isKind(of: UIScrollView.self) {
                pageScrollView = view as? UIScrollView
                pageScrollView?.delegate = self
                pageScrollView?.delaysContentTouches = false
            }
        }
        pageVC.view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        pageVC.view.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 37.0)
        
        pageVC.willMove(toParent: self.parentVC)
        self.parentVC.addChild(pageVC)
        pageVC.didMove(toParent: self.parentVC)
        pageVC.view.willMove(toSuperview: self)
        addSubview(pageVC.view)
        pageVC.view.didMoveToSuperview()
        
        pageVC.setViewControllers([childVCs.first!], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    func selectPage(atIndex: Int) {
        guard atIndex >= 0 && atIndex < childVCs.count else { return }
        guard atIndex != currentIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = (atIndex > currentIndex) ? .forward : .reverse
        
        let vc = childVCs[atIndex]
        pageVC.setViewControllers([vc], direction: direction, animated: true) { (_) in
            self.currentIndex = atIndex
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}

extension ATPageContainerView: UIScrollViewDelegate {
    
    
    
    /// this method is called a few times before "willTransitionTo pendingViewControllers" which determines willTransitionToIndex
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard pageScrollView === scrollView, let willTransitionToIndex = willTransitionToIndex else {
            return
        }
        /*
         The current visible vcontroller is always
            at (self.bounds.width + interControllerSpacing, 0)
                or in this code, (controllerWidth, 0)
         
         when scrolling to left, contentOffset.x is within [controllerWidth, controllerWidth * 2];
         when scrolling to right, contentOffset.x is within [0, controllerWidth];
         
         So the current visible controller is always at the middle of the scrollView
 
        */
//        print("width:\(controllerWidth) offset:\(scrollView.contentOffset)")
        
        

        if scrollView.contentOffset.x == self.controllerWidth {
            // this condition will be satisfied once, for both failed transition cases when scrolling left or scrolling right. And it will result to contentOffset.x == self.controllerWidth. Do nothing, instead of figuring out which case it is for this current call.
            return
        }
        
        let willScrollDrection: ATCurrentScrollDirection = (scrollView.contentOffset.x > self.controllerWidth) ? .scrollLeft : .scrollright
        
        if currentDirection != nil && (currentDirection != willScrollDrection) {
            return
        }
        
        currentDirection = willScrollDrection
        
        var fromIndex: Int = 0
        var toIndex: Int = 0
        let progress: CGFloat = abs(scrollView.contentOffset.x - self.controllerWidth) /  self.controllerWidth
        
        
        // willTransitionToIndex will always be [0, childVCs.count]
        if willScrollDrection == .scrollLeft {
            // scrolling to left, willTransitionToIndex will always be > 0
            fromIndex = willTransitionToIndex - 1
            toIndex = willTransitionToIndex
        }else{
            // scrolling to right,
            fromIndex = willTransitionToIndex + 1
            toIndex = willTransitionToIndex
        }
        
        currentIndex = fromIndex

        delegate?.categoryContainer(self, transitioningFromIndex: fromIndex, toIndex: toIndex, progress: progress)
        
    }
}


extension ATPageContainerView: UIPageViewControllerDelegate{
    /// this method will be called when a new visible controller, other than current controller, appears.
    /// this method will not be called when dragging beyond the first or the last controller. And it determines willTransitionToIndex. willTransitionToIndex will not be out of bound.
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        guard let vc = pendingViewControllers.first else {
            return
        }
        guard let index = childVCs.firstIndex(of: vc) else {return}
        willTransitionToIndex = index
        currentDirection = nil

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let willTransitionToIndex = willTransitionToIndex else { return }
        
        if completed {
            currentIndex = willTransitionToIndex
            delegate?.categoryContainer(self, didSwitchIndexTo: willTransitionToIndex)
        }
        
        // nil every time after the delegate
        self.willTransitionToIndex = nil
    }

    

    func pageViewControllerSupportedInterfaceOrientations(_ pageViewController: UIPageViewController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}



extension ATPageContainerView: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        
        
        guard let index = childVCs.firstIndex(of: viewController), index - 1 >= 0 else {
            return nil
        }
        
        return childVCs[index - 1]
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = childVCs.firstIndex(of: viewController), index + 1 < childVCs.count else {
            return nil
        }
        
        return childVCs[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return childVCs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return 0
    }
}



extension ATPageContainerView: ATCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: ATCategoryNavBar, didSwitchIndexTo toIndex: Int) {
        self.selectPage(atIndex: toIndex)
    }
}









