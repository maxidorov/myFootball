//
//  ColorsForMatchState.swift
//  myFootball
//
//  Created by Maxim Sidorov on 30.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let matchFinished = UIColor.init(red: 54/255.0, green: 203/255.0, blue: 89/255.0, alpha: 1)
    static let matchScheduled = UIColor.init(red: 37/255.0, green: 124/255.0, blue: 201/255.0, alpha: 1)
    static let matchInPlay = UIColor.init(red: 220/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1)
    
    static func colorForMatchStatus(_ status: String) -> UIColor {
        switch status {
        case "FINISHED":
            return .matchFinished
        case "SCHEDULED":
            return .matchScheduled
        case "IN_PLAY":
            return .matchInPlay
        default:
            return .black
        }
    }
}
