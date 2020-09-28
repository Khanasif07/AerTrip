//
//  ReceiverChatCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ReceiverChatCell : UITableViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.messageLabel.font = AppFonts.Regular.withSize(18)
        let bubbleImage = UIImage(named: "White Chat bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 25, bottom: 17, right: 25), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.bubbleImageView.image = bubbleImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func populateData(msgObj : MessageModel){
        populateMsg(msgObj : msgObj)
        self.contentView.isHidden = msgObj.isHidden
    }
    
    func populateMsg(msgObj : MessageModel){
        
        if !msgObj.delta.isEmpty && !msgObj.msg.isEmpty {
            self.messageLabel.text = "\(msgObj.delta)\n\(msgObj.msg)"
        } else if !msgObj.delta.isEmpty {
             self.messageLabel.text = "\(msgObj.delta)"
        }else {
            self.messageLabel.text = msgObj.msg
        }
        
        
//        self.messageLabel.text = !msgObj.delta.isEmpty ? "\(msgObj.delta)\n\(msgObj.msg)" : msgObj.msg
    }
}
