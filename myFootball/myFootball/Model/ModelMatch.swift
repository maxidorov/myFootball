//
//  ModelMatch.swift
//  myFootball
//
//  Created by Maxim Sidorov on 27.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import Foundation

struct ModelMatch: Codable {
    let id: Int?
    let competition: ModelCompetition?
    let homeTeam: ModelTeamDescription?
    let awayTeam: ModelTeamDescription?
    let score: ModelScore?
    let status: String?
    let utcDate: String?
}
