//
//  GroupedFlightCell.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 04/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

// In Grouped flights, multiple flights can have same departure time (e.g. one stop ) and/or arrival time (e.g. multiple stops flights )
// Following structure is used to identify flight with departure time and fk value.
// Departure Time is used to show time labels in segmented control above flights table.
struct TimeFK {
    let departurTime : String
    let fk : String
}

@available(iOS 13.0, *) protocol  GroupedFlightCellDelegate : AnyObject {
    func addToTrip(journey : Journey)
    func setPinnedFlightAt(_ flightKey: String , isPinned : Bool)
    func shareFlightAt(_ indexPath : IndexPath)
    func navigateToFlightDetailFor(journey : Journey, selectedIndex: IndexPath)
    func shareJourney(journey : [Journey])
    func navigateToFlightDetailFor(journey : Journey)
}

@available(iOS 13.0, *) class GroupedFlightCell: UITableViewCell {
    //MARK:- View Outlets
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var expandCollapseButton: UIButton!
    @IBOutlet weak var collaspableTableView: UITableView!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var downArrow: UIButton!
    //MARK:- Constraints Outlets
    @IBOutlet weak var timeSegmentBGViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var downArrowButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomWhitePatchVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var timeSegmentBGView: UIView!
    
    
    //MARK:- State variables
    var flightGroup = JourneyOnewayDisplay([])
    var buttonTapped : (() -> ()) = {}
    weak var delegate : GroupedFlightCellDelegate?
    var timeArray = [TimeFK]()
    var currentJourney : Journey?
    
    var currentSelectedIndex : Int?
//    var selectionViewFrame = CGRect(x: 0, y: 0, width: 58, height: 30)
    let selectionView = UIView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setupCollectionView()
//        selectionView.alpha = 0.0
        selectionView.backgroundColor = UIColor.AertripColor.withAlphaComponent(0.10)
        selectionView.layer.cornerRadius = 15.0
        //timeSegmentBGView.addSubview(selectionView)
        timeCollectionView.addSubview(selectionView)
        timeCollectionView.sendSubviewToBack(selectionView)
        timeSegmentBGView.clipsToBounds = true
        selectionView.frame = CGRect(x: 0, y: 0, width: 58, height: 30)
    }
    
    func setupTableView() {
        collaspableTableView.estimatedRowHeight  = 131
        collaspableTableView.rowHeight = UITableView.automaticDimension
        collaspableTableView.register(UINib(nibName: "SingleJourneyCell", bundle: nil), forCellReuseIdentifier: "SingleJourneyCell")
        collaspableTableView.isScrollEnabled = false
        collaspableTableView.separatorStyle = .none
    }
    
    func setupCollectionView() {
        timeCollectionView.register(UINib(nibName: "TimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeCollectionViewCell")
        timeCollectionView.dataSource = self
        timeCollectionView.delegate = self
        timeCollectionView.allowsSelection = true
        timeCollectionView.allowsMultipleSelection = false
        resultsCollectionView.registerCell(nibName: SingleJourneyCollectionViewCell.reusableIdentifier)
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
        resultsCollectionView.allowsSelection = true
        resultsCollectionView.allowsMultipleSelection = false
        resultsCollectionView.isPagingEnabled = true
        resultsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func expandCollapsedToggled(_ sender: UIButton) {
        
        flightGroup.isCollapsed = !flightGroup.isCollapsed
        
        UIView.animate(withDuration: 0.4) {
            
            if sender.transform ==  .identity {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.999)
            }
            else {
                sender.transform = CGAffineTransform.identity;
            }
        }
        buttonTapped()
    }
    
    @IBAction func collapseTableButtonTapped(_ sender: UIButton) {
        flightGroup.isCollapsed = !flightGroup.isCollapsed
        buttonTapped()
    }
    
    func setVaulesFrom( journey: JourneyOnewayDisplay) {
       
        flightGroup = journey
        
        let arrowImage = !flightGroup.isCollapsed ? UIImage(named:"DownArrow") : UIImage(named:"UpArrow")
        expandCollapseButton.setImage(arrowImage, for: .normal)
        
        let timeFKArray = journey.journeyArray.map{ return TimeFK(departurTime: $0.dt, fk: $0.fk) }
//        timeFKArray.sort(by : { $0.departurTime < $1.departurTime })
//        flightGroup.journeyArray.sort(by : { $0.dt < $1.dt })
        timeArray = timeFKArray
      
        if flightGroup.selectedFK == String() {
//            flightGroup.selectedFK = flightGroup.getJourneyWithLeastHumanScore().fk
            
            flightGroup.selectedFK = flightGroup.first.fk
        }
        
        if currentSelectedIndex == nil {
          //   if  let selectedDepartureIndex = timeArray.firstIndex(where: { $0.fk == flightGroup.selectedFK}) {
                currentSelectedIndex = 0
          //  }
        }
        
        updateViewConstraints()
        timeCollectionView.reloadData()
        collaspableTableView.reloadData()
        resultsCollectionView.reloadData()
       delay(seconds: 0.1) {
            let indexPath = IndexPath(row: self.currentSelectedIndex ?? 0, section: 0)
                   self.timeCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            
            self.resultsCollectionView.scrollToItem(at: IndexPath(item: self.currentSelectedIndex ?? 0, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            
            self.setSelectionViewFrame(animate: false)
//            self.layoutIfNeeded()
//            self.layoutSubviews()
//            print("\(journey.fare)....\(self.currentSelectedIndex).....\(self.selectionView.frame)")
       }
       
        summaryLabel.text = String(journey.count) + " flights at same price"
    }
    
    
    func setImageto( imageView : UIImageView , url : String , index : Int ) {
        if let image = collaspableTableView.resourceFor(urlPath: url , forView: index) {
            
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.roundedRectImageFromImage(image: resizedImage, imageSize: CGSize(width: 24.0, height: 24.0), cornerRadius: 2.0)
        }
    }
    
     func updateViewConstraints() {
        if flightGroup.isCollapsed == false {
            self.timeSegmentBGViewHeight.constant = 0
            tableViewTop.constant = 50.0
            self.tableViewHeight.constant = CGFloat((flightGroup.journeyArray.count ) * 131)
            downArrowButtonHeight.constant = 44
            bottomWhitePatchVIewHeight.constant = 22
            self.resultsCollectionView.isHidden = true
            self.collaspableTableView.isHidden = false
            self.selectionView.alpha = 0
        }else{
            self.timeSegmentBGViewHeight.constant = 30
            self.tableViewHeight.constant = 147
            tableViewTop.constant = 90.0
            downArrowButtonHeight.constant = 0
            bottomWhitePatchVIewHeight.constant = 0
            self.resultsCollectionView.isHidden = false
            self.collaspableTableView.isHidden = true
            self.selectionView.alpha = 1
        }
    }
    
    func getJourneyObj(indexPath : IndexPath) -> Journey? {
        
        var selectedJourney  : Journey?

//        if self.flightGroup.isCollapsed {
//            let flightGroup = self.flightGroup
//            let departureTime = flightGroup.selectedFK
//            if let journey = flightGroup.getJourneyWith(fk: departureTime) {
//                selectedJourney = journey
//            }
//        }
//        else {
            selectedJourney = flightGroup.journeyArray[indexPath.row]
       // }
        return selectedJourney
    }
    
    func setSelectionViewFrame(animate : Bool) {
        
//        guard  let selectedIndices = timeCollectionView.indexPathsForSelectedItems else{
//            print("Selected Cell not found")
//            return }
        
        let selectedIndex = IndexPath(item: currentSelectedIndex ?? 0, section: 0)
    
        guard  let attributes = timeCollectionView.layoutAttributesForItem(at: selectedIndex) else {
            print("Attributed not found")
            return }
        
        let duration : Double
        if animate  {
            duration = 0.3
        }
        else {
            duration = 0.0
        }
        
        UIView.animate(withDuration: duration) {
            self.selectionView.center = attributes.center
            self.selectionView.alpha = 1.0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.currentSelectedIndex = 0
        currentSelectedIndex = nil
        collaspableTableView.tableFooterView = nil
        expandCollapseButton.transform = .identity
//        selectionView.alpha = 0.0
    }
}


@available(iOS 13.0, *)
extension GroupedFlightCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightGroup.isCollapsed ? 1 : flightGroup.journeyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let journey = getJourneyObj(indexPath: indexPath) {
                return getSingleJourneyCell(indexPath: indexPath, journey: journey)
        }
        return UITableViewCell()
    }
    
    func getSingleJourneyCell (indexPath : IndexPath , journey : Journey?  ) -> UITableViewCell {
         
         if let cell =  collaspableTableView.dequeueReusableCell(withIdentifier: "SingleJourneyCell") as? SingleJourneyCell{
             
             if #available(iOS 13, *) {
                 if cell.baseView.interactions.isEmpty{
                     let interaction = UIContextMenuInteraction(delegate: self)
                     cell.baseView.addInteraction(interaction)
                 }
             }
             
             cell.selectionStyle = .none
             cell.setTitlesFrom( journey : journey)
             if let logoArray = journey?.airlineLogoArray {
                 
                 switch logoArray.count {
                 case 1 :
                     cell.logoTwo.isHidden = true
                     cell.logoThree.isHidden = true
                     setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                 case 2 :
                     cell.logoThree.isHidden = true
                     setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                     setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                     
                 case 3 :
                     setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                     setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                     setImageto(imageView: cell.logoThree, url:logoArray[2] , index:  indexPath.row)
                 default:
                     break
                 }
             }
             return cell
         }
         assertionFailure("Failed to create SingleJourneyCell cell ")
         
         return UITableViewCell()
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let selectedJourney = getJourneyObj(indexPath: indexPath) {
               self.currentJourney = selectedJourney
               self.delegate?.navigateToFlightDetailFor(journey: selectedJourney, selectedIndex: indexPath)
           }
       }
    
}

//MARK:- CollectionView Data Source and Delegate Methods
@available(iOS 13.0, *)
extension GroupedFlightCell : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flightGroup.journeyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.timeCollectionView {
            
            let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
            let currentTimeFK = timeArray[indexPath.row]
            let currentTime = currentTimeFK.departurTime
            let currentFK = currentTimeFK.fk
            cell.timeLabel.text = currentTime
            if  let journey = flightGroup.getJourneyWith(fk: currentFK) {
                cell.isPinnedView.isHidden = !(journey.isPinned ?? false)
            }
            return cell
            
        } else {
            
            let cell = resultsCollectionView.dequeueReusableCell(withReuseIdentifier: "SingleJourneyCollectionViewCell", for: indexPath) as! SingleJourneyCollectionViewCell
            if #available(iOS 13, *) {
                          if cell.baseView.interactions.isEmpty{
                              let interaction = UIContextMenuInteraction(delegate: self)
                              cell.baseView.addInteraction(interaction)
                          }
                      }
            if let journey = getJourneyObj(indexPath: indexPath) {
                cell.setTitlesFrom(journey: journey)
                
                if let logoArray = journey.airlineLogoArray {
                    
                    switch logoArray.count {
                    case 1 :
                        cell.logoTwo.isHidden = true
                        cell.logoThree.isHidden = true
                        setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    case 2 :
                        cell.logoThree.isHidden = true
                        setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                        setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                        
                    case 3 :
                        setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                        setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                        setImageto(imageView: cell.logoThree, url:logoArray[2] , index:  indexPath.row)
                    default:
                        break
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.timeCollectionView ? 6 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == self.timeCollectionView ? 6 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView == self.timeCollectionView ? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) : UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       return collectionView == self.timeCollectionView ? CGSize(width: 58, height: 30) : CGSize(width: collectionView.frame.width, height: 139)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.timeCollectionView {
            currentSelectedIndex = indexPath.item
            flightGroup.selectedFK = timeArray[indexPath.row].fk
            collaspableTableView.reloadData()
            setSelectionViewFrame(animate: true)
            self.timeCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.resultsCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: true)
            
        } else {
            if let selectedJourney = getJourneyObj(indexPath: indexPath) {
                self.currentJourney = selectedJourney
                self.delegate?.navigateToFlightDetailFor(journey: selectedJourney, selectedIndex: indexPath)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.resultsCollectionView { return }

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                if scrollView != self.resultsCollectionView { return }
                guard let indexPath =  self.resultsCollectionView.indexPathForItem(at: scrollView.contentOffset) else { return }
                print(indexPath.item)
            currentSelectedIndex = indexPath.item
                 flightGroup.selectedFK = timeArray[indexPath.item].fk
                 collaspableTableView.reloadData()
                 setSelectionViewFrame(animate: true)
        self.timeCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)

    }
    
}

//MARK:- iOS 13 Contexual Menu Interaction UI 
@available(iOS 13.0, *) extension GroupedFlightCell : UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // As when collapsed we need to get selected cell based on selected time , we need to get journey object based on selectedJourneyTimeProperty
            
            if self.flightGroup.isCollapsed {
          
                let locationInCollectionView = interaction.location(in: self.resultsCollectionView)
                guard let indexPath = self.resultsCollectionView.indexPathForItem(at: locationInCollectionView) else { return nil }
                let currentJourney  = self.flightGroup.journeyArray[indexPath.row]
                let fk = currentJourney.fk
                let isPinned = currentJourney.isPinned
                return self.makeMenusFor(journey : currentJourney ,flightKey : fk , markPinned : isPinned ?? false)
        
            }
        else {
                let locationInTableView = interaction.location(in: self.collaspableTableView)
                guard let indexPath = self.collaspableTableView.indexPathForRow(at: locationInTableView) else { return nil }
                let currentJourney  = self.flightGroup.journeyArray[indexPath.row]
                let fk = currentJourney.fk
                let isPinned = currentJourney.isPinned
                return self.makeMenusFor(journey : currentJourney ,flightKey : fk , markPinned : isPinned ?? false)
        }
            
        return nil
    }
}
    
    func makeMenusFor(journey : Journey ,  flightKey: String , markPinned : Bool) -> UIMenu {
        
        // Pin Action
        let pinTitle : String
        if markPinned {
            pinTitle = "Unpin"
        }
        else {
            pinTitle = "Pin"
        }
        let pin = UIAction(title:  pinTitle , image: UIImage(systemName: "pin" ), identifier: nil) { [weak self] (action) in
            
            self?.delegate?.setPinnedFlightAt(flightKey, isPinned: !markPinned)
            self?.collaspableTableView.reloadData()
            self?.timeCollectionView.reloadData()
        }
        // share action
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) {  (action) in
            self.delegate?.shareJourney(journey: [journey])
        }
        
        // Add to Trip Action
        let addToTrip = UIAction(title: "Add To Trip", image: UIImage(systemName: "map" ), identifier: nil) { [weak self] (action) in
            
            self?.delegate?.addToTrip(journey: journey)
        }
        return UIMenu(title: "", children: [pin, share, addToTrip])
    }
}

@available(iOS 13.0, *)
extension GroupedFlightCell  {

    //    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //            let configuration = UISwipeActionsConfiguration(actions: createSwipeActionForLeftOrientation(indexPath))
    //            return configuration
    //    }
    //
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //        let configuration = UISwipeAc tionsConfiguration(actions: createSwipeActionsForRightOrientation(indexPath))
    //        return configuration
    //    }
    
    //MARK:-  Methods for TableviewCell Swipe Implementation

//      fileprivate func createSwipeActionForLeftOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
//
//          guard let currentJourney = getJourneyObj(indexPath: indexPath) else {
//              return [UIContextualAction]()
//          }
//
//          let flightKey = currentJourney.fk
//          let isPinned = currentJourney.isPinned ?? false
//          let backgroundColor = UIColor.OffWhiteColor
//
//              if currentJourney.isPinned ?? false {
//
//                  let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in
//
//                      if let strongSelf = self {
//
//                          strongSelf.delegate?.setPinnedFlightAt(flightKey, isPinned: !isPinned)
//                          strongSelf.collaspableTableView.reloadData()
//                          strongSelf.timeCollectionView.reloadData()
//                      }
//
//                     completionHandler(true)
//                  })
//                  pinAction.backgroundColor = backgroundColor
//                  if let cgImageX =  UIImage(named: "Unpin")?.cgImage {
//                      pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
//                  }
//
//                  return [pinAction]
//
//              }
//              else {
//
//                  let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in
//
//                      if let strongSelf = self {
//
//                          strongSelf.delegate?.setPinnedFlightAt(flightKey, isPinned: !isPinned)
//                          strongSelf.collaspableTableView.reloadData()
//                          strongSelf.timeCollectionView.reloadData()
//
//                      }
//                      completionHandler(true)
//                  })
//
//                  pinAction.backgroundColor = backgroundColor
//                  if let cgImageX =  UIImage(named: "Pin")?.cgImage {
//                      pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
//                  }
//
//                  return [pinAction]
//
//              }
//      }
//
//
//
//      fileprivate func createSwipeActionsForRightOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
//
//          let currentJourney = flightGroup.journeyArray[indexPath.row]
//          let backgroundColor = UIColor.OffWhiteColor
//
//          let shareAction = UIContextualAction(style: .normal, title: nil , handler: { (action, view , completionHandler) in
//              self.delegate?.shareJourney(journey: currentJourney)
//              completionHandler(true)
//          })
//
//          if let cgImageX =  UIImage(named: "Share")?.cgImage {
//              shareAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
//          }
//
//          shareAction.backgroundColor =  backgroundColor
//
//          let addToTripAction = UIContextualAction(style: .normal, title: nil, handler: { [weak self]  (action, view , completionHandler)  in
//
//              if let strongSelf = self {
//                  strongSelf.delegate?.addToTrip(journey: currentJourney)
//              }
//              completionHandler(true)
//          })
//          addToTripAction.backgroundColor = backgroundColor
//
//          if let cgImageX =  UIImage(named: "AddToTrip")?.cgImage {
//              addToTripAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
//          }
//
//          return [addToTripAction, shareAction]
//      }
    
}
