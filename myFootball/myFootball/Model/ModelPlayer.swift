//
//  ModelPlayer.swift
//  myFootball
//
//  Created by Maxim Sidorov on 29.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import Foundation

struct ModelPlayer: Codable {
    let id: Int?
    let name: String?
    let position: String?
    let dateOfBirth: String?
    let countryOfBirth: String?
    let nationality: String?
    let shirtNumber: Int?
    let role: String?
}
