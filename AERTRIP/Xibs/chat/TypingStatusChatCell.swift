//
//  TypingStatusChatCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class TypingStatusChatCell: UITableViewCell {
    
    @IBOutlet weak var dotsView: AMDots!
    
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let bubbleImage = UIImage(named: "White Chat bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 25, bottom: 17, right: 25), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.bubbleImageView.image = bubbleImage
        
        dotsView.colors = [#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]
        dotsView.backgroundColor = UIColor.clear
        dotsView.animationType = .jump
        dotsView.dotSize = 5
          dotsView.animationDuration = 1.4
        dotsView.spacing = 5
        dotsView.aheadTime = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
