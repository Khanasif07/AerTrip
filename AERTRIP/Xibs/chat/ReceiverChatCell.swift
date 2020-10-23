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
        
        self.messageLabel.attributedText = getAttributedText(msgObj: msgObj)
        
//        if !msgObj.delta.isEmpty && !msgObj.msg.isEmpty {
//            self.messageLabel.text = "\(msgObj.delta)\n\(msgObj.msg)"
//        } else if !msgObj.delta.isEmpty {
//             self.messageLabel.text = "\(msgObj.delta)"
//        }else {
//            self.messageLabel.text = msgObj.msg
//        }
        
        
//        self.messageLabel.text = !msgObj.delta.isEmpty ? "\(msgObj.delta)\n\(msgObj.msg)" : msgObj.msg
    }
    
    private func getAttributedText(msgObj: MessageModel) -> NSMutableAttributedString {
        
        var finalStr = NSMutableAttributedString()
        
        let deltaTextArr = msgObj.delta.components(separatedBy: " | ")
        var paragraphDeltaText = ""
        deltaTextArr.forEach { (str) in
            paragraphDeltaText = paragraphDeltaText + str + "\n"
        }
        if paragraphDeltaText.hasSuffix("\n") {
            paragraphDeltaText.removeLast()
        }
        let deltaAttStr = NSMutableAttributedString(string: paragraphDeltaText, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeBlack.withAlphaComponent(0.6), NSAttributedString.Key.font: AppFonts.Regular.withSize(14)])
        
        if !msgObj.depart.isEmpty && !msgObj.origin.isEmpty && !msgObj.destination.isEmpty {
            let resultStr = LocalizedString.hereAreYourResults.localized
            var resultMutableStr = NSMutableAttributedString()
            if !deltaAttStr.string.isEmpty {
                resultMutableStr = NSMutableAttributedString(string: resultStr + "\n", attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18)])
                resultMutableStr.append(deltaAttStr)
            } else {
                resultMutableStr = NSMutableAttributedString(string: resultStr, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18)])
            }
            finalStr = resultMutableStr
        } else {
            let resultStr = NSMutableAttributedString(string: msgObj.msg, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18)])
            if msgObj.showDetails {
                let deltaStr = deltaAttStr.mutableString.appending("\n")
                let newDeltaAttStr = NSMutableAttributedString(string: deltaStr, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeBlack.withAlphaComponent(0.6), NSAttributedString.Key.font: AppFonts.Regular.withSize(14)])
                newDeltaAttStr.append(resultStr)
                finalStr = newDeltaAttStr
            } else {
                finalStr = resultStr
            }
        }
        return finalStr
    }
}
