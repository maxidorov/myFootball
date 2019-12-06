//
//  ModelTeamDescription.swift
//  myFootball
//
//  Created by Maxim Sidorov on 29.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import Foundation

struct ModelTeamDescription: Codable {
    let id: Int?
    let name: String?
    let activeCompetitions: [ModelActiveCompetition]?
    let shortName: String?
    let website: String?
    let crestUrl: String?
    let squad: [ModelPlayer]?
    let lastUpdated: String?
}
