//
//  AerinCustomPopoverVC+TableView.swift
//  AERTRIP
//
//  Created by Rishabh on 23/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

extension AerinCustomPopoverVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatVm.messages.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.chatVm.messages[indexPath.row].msgSource {
        case .me, .other, .seeResultsAgain:
                return UITableView.automaticDimension
            default:
                return 53
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.chatVm.messages[indexPath.row].msgSource {
        case .me:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatCell", for: indexPath) as? SenderChatCell else {
                fatalError("SenderChatCell not found")
            }
            cell.populateData(msgObj: self.chatVm.messages[indexPath.row])
            return cell
            
        case .other:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatCell", for: indexPath) as? ReceiverChatCell else {
                fatalError("ReceiverChatCell not found")
            }
            cell.populateData(msgObj: self.chatVm.messages[indexPath.row])
            return cell
            
        case .seeResultsAgain:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeeResultsAgainCell", for: indexPath) as? SeeResultsAgainCell else {
                fatalError("SeeResultsAgainCell not found")
            }
            return cell
            
        case .typing:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TypingStatusChatCell", for: indexPath) as? TypingStatusChatCell else {
                fatalError("TypingStatusChatCell not found")
            }
            cell.loader.play()
            cell.contentView.alpha = 1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        if let receiverCell = tableView.cellForRow(at: indexPath) as? ReceiverChatCell {
            self.chatVm.messages[indexPath.row].showDetails = !self.chatVm.messages[indexPath.row].showDetails
            receiverCell.populateMsg(msgObj: self.chatVm.messages[indexPath.row])
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if self.chatVm.messages[indexPath.row].showDetails {
                FirebaseEventLogs.shared.logAerinEvents(with: FirebaseEventLogs.EventsTypeName.ShowDetails)
            } else {
                FirebaseEventLogs.shared.logAerinEvents(with: FirebaseEventLogs.EventsTypeName.HideDetails)
            }
            
        }
        
        if let _ = tableView.cellForRow(at: indexPath) as? SeeResultsAgainCell, let cachedMessageModel = chatVm.lastCachedResultModel {
            moveFurtherWhenallRequiredInformationSubmited(data: cachedMessageModel)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
        
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
        guard let _ = cell as? TypingStatusChatCell else { return }
        
//        invalidateTypingCellTimer()
        
     //   self.dotsView?.removeFromSuperview()
//        if self.chatVm.messages[indexPath.row].msgSource == .typing {
//
//        }
        
        
    }
    
}
