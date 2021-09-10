//
//  LongPressViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 23/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class LongPressViewController: UIViewController {

    let headerView : UIView
    let sourceRect : CGRect
    
    @IBOutlet weak var baseView: UIView!
    internal required init?(coder aDecoder: NSCoder) {
        self.headerView = UIView(frame: .zero)
        sourceRect = .zero
        super.init(coder: aDecoder)
    }
    
    init(headerView : UIView , sourceRect : CGRect) {
        
        self.headerView = headerView
        self.sourceRect = sourceRect
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK:- View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: sourceRect.size.height)
        self.view.insertSubview(headerView, aboveSubview: baseView)
        self.view.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDismiss))
        swipeGesture.direction = .down
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        baseView.alpha = 0.0
        super.viewWillAppear(animated)
    }

    func animateViewsToShow() {
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.baseView.alpha = 1.0
//            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
//            self.headerView.frame = self.sourceRect
//
//        })
    }
    
    @objc func swipeToDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}
