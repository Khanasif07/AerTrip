//
//  TypingStatusChatCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

import Lottie


class TypingStatusChatCell: UITableViewCell {
    
    @IBOutlet weak var dotsView: UIView!
    
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    let loader = AnimationView(name: "dot")

    
    
//    override func prepareForReuse() {
//        self.prepareForReuse()
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let bubbleImage = AppImages.White_Chat_bubble.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 25, bottom: 17, right: 25), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.bubbleImageView.image = bubbleImage
        dotsView.backgroundColor = UIColor.clear
//        dotsView.hidesWhenStopped = true
//        dotsView.colors = [#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]
//        dotsView.backgroundColor = UIColor.clear
//        dotsView.animationType = .jump
//        dotsView.dotSize = 5
//          dotsView.animationDuration = 1.4
//        dotsView.spacing = 5
//        dotsView.aheadTime = 1
       // dotsView.stop()
//        dotsView.start()
        
        setUpDots()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpDots(){
        loader.frame = dotsView.bounds
        loader.contentMode = .scaleAspectFill
        dotsView.addSubview(loader)
        loader.loopMode = .loop
//        loader.animationSpeed = 0.5
        loader.play()
    }
    
}
