//
//  ChatVC+TableView.swift
//  AERTRIP
//
//  Created by Appinventiv on 18/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


extension ChatVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatVm.messages.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatCell", for: indexPath) as? SenderChatCell else {
             printDebug("SenderChatCell not found")
             return UITableViewCell()
         }
        cell.populateData(msgObj: self.chatVm.messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
