//
//  DateManager.swift
//  myFootball
//
//  Created by Maxim Sidorov on 28.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import Foundation

struct DateManager {
    static func today() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
}

extension Date {
    func toSting() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: self)
        return formattedDate
    }
}
