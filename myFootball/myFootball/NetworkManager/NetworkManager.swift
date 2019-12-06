//
//  Networking.swift
//  myFootball
//
//  Created by Maxim Sidorov on 25.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static public var shared = NetworkManager()
    
    private var mainUrlString = "https://api.football-data.org/v2/"
    private var mainHeader = "X-Auth-Token"
    private var apiKey = "16a8aa08826540289790c301878144e6"
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let jsonDecoder = JSONDecoder()
    
    private init() { }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    func getTodayMatches(completion: ((Result<ModelMatchesResponse>) -> Void)?) {
        mainSession(request: getTodayMatchesRequest(), completion: completion)
    }
    
    func getTeamDescription(teamId id: Int, completion: ((Result<ModelTeamDescription>) -> Void)?) {
        mainSession(request: getTeamDescriptionRequest(id), completion: completion)
    }
    
    func getTeamsFromArea(area: Area, completion: ((Result<ModelTeams>) -> Void)?) {
        mainSession(request: getTeamsFromAreaRequest(area), completion: completion)
    }
    
    func getTeamsMatchesDuringPeriod(teamId id: Int, dateFrom: Date, dateTo: Date, completion: ((Result<ModelMatchesResponse>) -> Void)?) {
        mainSession(request: getTeamsMatchesDuringPeriodRequest(id, dateFrom, dateTo), completion: completion)
    }
 
    private func getTodayMatchesRequest() -> URLRequest {
        let today = DateManager.today()
        let urlString = mainUrlString + "matches?dateFrom=\(today)&dateTo=\(today)"
        return getRequestWithMainHeader(urlString)
    }
    
    private func getTeamDescriptionRequest(_ id: Int) -> URLRequest {
        let urlString = mainUrlString + "teams/\(id)"
        return getRequestWithMainHeader(urlString)
    }
    
    private func getTeamsFromAreaRequest(_ area: Area) -> URLRequest {
        let urlString = mainUrlString + "teams?areas=\(area.rawValue)"
        return getRequestWithMainHeader(urlString)
    }
    
    private func getTeamsMatchesDuringPeriodRequest(_ id: Int, _ dateFrom: Date, _ dateTo: Date) -> URLRequest {
        let urlString = mainUrlString + "teams/\(id)/matches?dateFrom=\(dateFrom.toSting())&dateTo=\(dateTo.toSting())"
        return getRequestWithMainHeader(urlString)
    }
    
    private func getRequestWithMainHeader(_ urlString: String) -> URLRequest {
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: mainHeader)
        return request
    }
    
    private func mainSession<T: Codable>(request: URLRequest, completion: ((Result<T>) -> Void)?) {
        session.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data, error == nil else {
                print(error?.localizedDescription ?? "mainSession error")
                completion?(.failure(error!))
                return
            }
//            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
//            if let json = json {
//                print(json.description)
//            }
            do {
                let decodedData = try self.jsonDecoder.decode(T.self, from: jsonData)
                completion?(.success(decodedData))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
}

extension NetworkManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
