//
//  BookingInfoNotesCellTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 01/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInfoNotesCellTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var noteLabel: UILabel!
    
    // MARK: - Variables
    var flightDetail: [BookingFlightDetail]? {
        didSet {
            self.configureCell()
        }
    }
    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        noteLabel.attributedText = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
    }

    // Helper methods
    
    private func setUpFont() {
        self.noteLabel.font = AppFonts.Regular.withSize(14.0)
        
    }
    
    private func setUpTextColor() {
        self.noteLabel.textColor = AppColors.themeBlack
    }
    
    private func configureCell() {
        
        //        1 pc: Most airline typically allow 23 kgs per piece.
        //        23 kg: Max 3 pieces can be carried weighing total 23 kg.
        //        Baggage details are indicative and subject to change without prior notice.
        
        //        noteLabel
        //        BaggageDetailsMessage
        
        var displayTxt = ""
        
        func filterDisplayText(text: String) {
            if !displayTxt.contains(text) {
                if displayTxt != ""{
                    displayTxt.append("\n")
                }
                displayTxt.append(text)
            }
        }
        
        flightDetail?.forEach({ (flight) in
            
            if let object = flight.baggage?.checkInBg?.adult {
                filterDisplayText(text: getCheckInDataToShow(info: object))
            }
            
            if let object = flight.baggage?.checkInBg?.child {
                filterDisplayText(text: getCheckInDataToShow(info: object))
            }
            
            if let object = flight.baggage?.checkInBg?.infant {
                filterDisplayText(text: getCheckInDataToShow(info: object))
            }
            
        })
        
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 15
        style.paragraphSpacingBefore = 16
        
        if !displayTxt.isEmpty {
            displayTxt = "*   " + displayTxt + "\n"
            displayTxt = displayTxt + "•   Baggage details are indicative and subject to change without prior notice."
        } else {
            displayTxt = "•   Baggage details are indicative and subject to change without prior notice."
        }
        
        
        let title = NSMutableAttributedString(string: displayTxt, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
        if !displayTxt.isEmpty, displayTxt.contains(":") {
            let inx = displayTxt.range(of: ":")
            let index: Int = displayTxt.distance(from: displayTxt.startIndex, to: inx!.lowerBound)
            
            let font:UIFont = AppFonts.SemiBold.withSize(14)
            title.addAttributes([.font:font], range: NSRange(location: 0, length: index))
        }
        
        noteLabel.attributedText = title
    }
    
    
    private func getCheckInDataToShow(info: BaggageInfo) -> String {
        
        let weight = info.weight
        let pieces = info.piece
        let max_pieces = info.maxPieces
        let max_weight = info.maxWeight
        
        
//        if weight == "0" || weight == "0 Kg"{
//            return ""
//        }else if weight == "-9"{
//            return LocalizedString.NoInfo.localized
//        }else if !weight.isEmpty && max_weight.isEmpty && max_pieces.isEmpty && (pieces == "0 pc" || pieces == "0" || pieces == ""){
//            return "" // only weight present
//        }else if !pieces.isEmpty && weight.isEmpty && max_weight.isEmpty && max_pieces.isEmpty {
//            if pieces == "0 pc" || pieces == "0" {
//                return ""
//            }
//            //return pieces // only pieces present
//            return "\(pieces) : Most airline typically allow 23 kgs per piece."
//        }
//        else if !max_weight.isEmpty && !pieces.isEmpty && weight.isEmpty && max_pieces.isEmpty {
//            // only max_weight and  pieces present
//            if pieces == "0 pc" || pieces == "0" {
//                return ""
//            }
//
//            return ""
//
//        }else if !weight.isEmpty && !max_pieces.isEmpty && max_weight.isEmpty && (pieces == "0 pc" || pieces == "0" || pieces == "") {
//            // only weight and  max_pieces present
//            return "\(weight) : Max \(max_pieces) pieces can be carried weighing total \(weight)"
//
//        }
//        return LocalizedString.na.localized.uppercased()
     
        
        
        
        
        if pieces != "-9" && pieces != "" && pieces != "0 pc" && max_weight == ""
        {
            return "\(pieces) : Most airline typically allow 23 kgs per piece."
        }
        
        if weight != "-9" && weight != "" && max_pieces != ""  && max_pieces != "0 pc"
        {
            var pc = ""
            if max_pieces.contains(find: " "){
                let pieces = max_pieces.components(separatedBy: " ")
                if pieces.count > 0{
                    pc = pieces[0]
                }
            }

            return "\(weight) : Max \(pc) pieces can be carried weighing total \(weight)"
        }
        
        if pieces != "" && max_weight != ""
        {
            if pieces != "0 pc"{
                let pc = pieces.components(separatedBy: " ")
                let weights = max_weight.components(separatedBy: " ")
                
                if pc.count > 0, weights.count > 0{
                    if let intmax_weight = Int(weights[0]), let intPieces = Int(pc[0]){
                        if intmax_weight != 0{
                            let str1 = "\(intmax_weight*intPieces) kg"
                            let str2 = " (\(intPieces) pc X \(intmax_weight) kg)"
                            
                            var displayNote = ""
                            
                            if intPieces == 1{
                                displayNote = "\(str1)\(str2) : Max \(intPieces) piece of \(intmax_weight) kg each can be carried weighing total \(str1)."
                            }else{
                                displayNote = "\(str1)\(str2) : Max \(intPieces) pieces of \(intmax_weight) kg each can be carried weighing total \(str1)."
                            }
                            
                            return displayNote
                        }
                    }
                }
            }
        }
        
        return ""
    }
    
}
