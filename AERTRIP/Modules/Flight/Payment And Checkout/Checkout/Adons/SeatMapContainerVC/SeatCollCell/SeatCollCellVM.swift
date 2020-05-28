//
//  SeatCollCellVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SeatCollCellVM {
    
    enum DeckType {
        case main
        case upper
    }
    
    enum PlaneSeatsLayout {
        case four
        case six
        case ten
        
        enum SeatSectionType {
            case number(Int)
            case blank
        }
        
        func getSeatSectionArr() -> [SeatSectionType] {
            var sectionArr = [SeatSectionType]()
            switch self {
            case .four:
                sectionArr = [.number(4), .number(3), .blank, .number(2), .number(1)]
            case .six:
                sectionArr = [.number(6), .number(5), .number(4), .blank, .number(3), .number(2), .number(1)]
            case .ten:
                sectionArr = [.number(10), .number(9), .number(8), .blank, .number(7), .number(6), .number(5), .number(4), .blank, .number(3), .number(2), .number(1)]
            }
            return sectionArr
        }
    }
    
    private var charStr = Int(("A" as UnicodeScalar).value)
    var totalSections = 0
    var currentDeck: DeckType = .main
    var seatData = SeatMapModel.SeatMapRow()

    func getUnicodeScalarStringFor(_ sec: PlaneSeatsLayout.SeatSectionType) -> String {
        switch sec {
        case .blank:
            return ""
        case .number(let num):
            if let unicodeScalar = UnicodeScalar((num - 1) + charStr) {
                let str = "\(unicodeScalar)"
                return str
            }
            return ""
        }
    }

}
