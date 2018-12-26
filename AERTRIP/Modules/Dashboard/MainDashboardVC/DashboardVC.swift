//
//  DashboardVC.swift
//  AERTRIP
//
//  Created by Admin on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var innerScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentContainerView: UIView!

    //segment views
    @IBOutlet weak var aerinView: UIView!
    @IBOutlet weak var flightsView: UIView!
    @IBOutlet weak var hotelsView: UIView!
    @IBOutlet weak var tripsView: UIView!

    @IBOutlet weak var aerinLabel: UILabel!
    @IBOutlet weak var flightsLabel: UILabel!
    @IBOutlet weak var hotelsLabel: UILabel!
    @IBOutlet weak var tripsLabel: UILabel!

    private var previousOffset = CGPoint.zero
    private var mainScrollViewOffset = CGPoint.zero

    var itemWidth : CGFloat {
        return aerinView.width
    }

    enum SelectedOption : Int {

        case aerin = 0
        case flight = 1
        case hotels = 2
        case trips = 3
    }

    var selectedOption : SelectedOption = .aerin

    override func viewDidLoad() {
        super.viewDidLoad()
        resetItems()

        aerinView.transform = .identity
        aerinView.alpha = 1.0
    }

    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        let guideHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        let fullHeight = UIScreen.main.bounds.size.height

        innerScrollViewHeightConstraint.constant = UIScreen.main.bounds.size.height - (fullHeight - guideHeight) - segmentContainerView.bounds.height
    }

    //MARK:- Private
    private func resetItems(){

        aerinView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        aerinView.alpha = 0.5
        flightsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        flightsView.alpha = 0.5
        hotelsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        hotelsView.alpha = 0.5
        tripsView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        tripsView.alpha = 0.5
    }
}

extension DashboardVC : UIScrollViewDelegate{


    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == mainScrollView{

            let t = scrollView.contentOffset.y/(headerView.height + headerView.origin.y)
            let transform = max(1.0 - t/4.0, 0.75)

            if scrollView.contentOffset.y - mainScrollViewOffset.y > 0{
                let valueMoved = scrollView.contentOffset.y - mainScrollViewOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateUpLabels(with: headerValueMoved)
            }else{

                let valueMoved = mainScrollViewOffset.y - scrollView.contentOffset.y
                let headerValueMoved = valueMoved/(headerView.height + headerView.origin.y)
                updateDownLabels(with: headerValueMoved)
            }

            switch selectedOption{

                case .aerin: aerinView.transform = CGAffineTransform(scaleX: transform, y: transform)
                case .flight: flightsView.transform = CGAffineTransform(scaleX: transform, y: transform)
                case .hotels: hotelsView.transform = CGAffineTransform(scaleX: transform, y: transform)
                case .trips: tripsView.transform = CGAffineTransform(scaleX: transform, y: transform)
            }

            mainScrollViewOffset = scrollView.contentOffset

        }else{

            //only perform size animation on horizontal scroll if outermost is at the top

            let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
            let offset = scrollView.contentOffset

            if offset.x - previousOffset.x > 0{

                //as we want on scale of 0.0 to 1.0 so i divide it by the width
                let valueMoved = offset.x - previousOffset.x
                let tabValueMoved = valueMoved/scrollView.bounds.width

                let t = (offset.x - scrollView.bounds.width * CGFloat(page))/scrollView.bounds.width

                let increaseTransform = min(t/4.0 + 0.75, CGFloat(1.0))
                let decreaseTransform = max(1.0 - t/4.0, 0.75)

                animateForPage(moved: tabValueMoved, page: page, isForward: true, increaseSize: increaseTransform, decreaseSize : decreaseTransform)

            }else{

                let valueMoved = previousOffset.x - offset.x
                let tabValueMoved = valueMoved/scrollView.bounds.width

                let t = (offset.x - scrollView.bounds.width * CGFloat(page))/scrollView.bounds.width

                let increaseTransform = min(t/4.0 + 0.75, CGFloat(1.0))
                let decreaseTransform = max(1.0 - t/4.0, 0.75)

                animateForPage(moved: tabValueMoved, page: page, isForward: false, increaseSize: increaseTransform, decreaseSize : decreaseTransform)
            }

            previousOffset = scrollView.contentOffset
        }
    }

    private func updateUpLabels(with alpha : CGFloat){

        aerinLabel.alpha = max(aerinLabel.alpha - alpha, 0.0)
        flightsLabel.alpha = max(flightsLabel.alpha - alpha, 0.0)
        hotelsLabel.alpha = max(hotelsLabel.alpha - alpha, 0.0)
        tripsLabel.alpha = max(tripsLabel.alpha - alpha, 0.0)
    }

    private func updateDownLabels(with alpha : CGFloat){

        aerinLabel.alpha = min(aerinLabel.alpha + alpha, 1.0)
        flightsLabel.alpha = min(flightsLabel.alpha + alpha, 1.0)
        hotelsLabel.alpha = min(hotelsLabel.alpha + alpha, 1.0)
        tripsLabel.alpha = min(tripsLabel.alpha + alpha, 1.0)
    }

    private func animateForPage(moved : CGFloat, page : Int, isForward : Bool, increaseSize : CGFloat, decreaseSize : CGFloat){

        guard let currentOption = SelectedOption(rawValue: page) else {return}
        selectedOption = currentOption

        if isForward{
            switch currentOption{
                case .aerin:
                    aerinView.alpha = max(aerinView.alpha - moved, 0.5)
                    flightsView.alpha = min(flightsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y == 0{
                        aerinView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                        flightsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                    }
                case .flight:
                    flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                    hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y == 0{
                        flightsView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                        hotelsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                    }
                case .hotels:
                    hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                    tripsView.alpha = min(tripsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y == 0{
                        hotelsView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                        tripsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                    }
                case .trips: break
            }
        }else{

            switch currentOption{
                case .aerin:
                    flightsView.alpha = max(flightsView.alpha - moved, 0.5)
                    aerinView.alpha = min(aerinView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y == 0{
                        flightsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                        aerinView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                    }

                case .flight:
                    hotelsView.alpha = max(hotelsView.alpha - moved, 0.5)
                    flightsView.alpha = min(flightsView.alpha + moved, 1.0)

                    if mainScrollView.contentOffset.y == 0{
                        hotelsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                        flightsView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                    }
                case .hotels:

                    tripsView.alpha = max(tripsView.alpha - moved, 0.5)
                    hotelsView.alpha = min(hotelsView.alpha + moved, 1.0)
                    if mainScrollView.contentOffset.y == 0{
                        tripsView.transform = CGAffineTransform(scaleX: increaseSize, y: increaseSize)
                        hotelsView.transform = CGAffineTransform(scaleX: decreaseSize, y: decreaseSize)
                    }
                case .trips: break
            }
        }
    }
}
