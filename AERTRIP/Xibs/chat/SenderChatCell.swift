//
//  SenderChatCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 18/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SenderChatCell: UITableViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.messageLabel.font = AppFonts.Regular.withSize(18)
        let bubbleImage = UIImage(named: "outgoing-message-bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 25, bottom: 17, right: 25), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.bubbleImageView.image = bubbleImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func populateData(msgObj : MessageModel){
        self.messageLabel.text = msgObj.msg
        self.contentView.isHidden = msgObj.isHidden
    }
    
}
