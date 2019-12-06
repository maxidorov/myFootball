//
//  TodayVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 27.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class TodayVC: UIViewController {
    
    var tableView: UITableView!
    
    var matches = [ModelMatch]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Today"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpTableView()
        loadMatchesOverviewAndUpdateTableView()
        
        
        NetworkManager.shared.getTeamsMatchesDuringPeriod(teamId: 81, dateFrom: Date(), dateTo: Date()) { (result) in
            switch result {
            case .success(let response):
                for match in response.matches! {
                    print(match.awayTeam?.name!, match.homeTeam?.name!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadMatchesOverviewAndUpdateTableView() {        
        let groupLoadMatches = DispatchGroup()
        groupLoadMatches.enter()
        NetworkManager.shared.getTodayMatches { (result) in
            switch result {
            case .success(let response):
                self.matches = response.matches!
                groupLoadMatches.leave()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        groupLoadMatches.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    private func setUpTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.register(MatchOverviewCell.self, forCellReuseIdentifier: MatchOverviewCell.reuseId)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension TodayVC: UITableViewDelegate { }

extension TodayVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchOverviewCell.reuseId, for: indexPath) as! MatchOverviewCell
        
        let match = matches[indexPath.row]
        
        guard let awayTeamId = match.awayTeam?.id else { return cell }
        guard let homeTeamId = match.homeTeam?.id else { return cell }
        
        guard let homeTeamName = match.homeTeam?.name else { return cell }
        guard let awayTeamName = match.awayTeam?.name else { return cell }
        
        guard let matchStatus = match.status else { return cell }
        guard let matchCompetitionName = match.competition?.name else { return cell}
        
        cell.awayTeamId = awayTeamId
        cell.homeTeamId = homeTeamId
        
        cell.homeTeamNameLabel.text = homeTeamName
        cell.awayTeamNameLabel.text = awayTeamName
        
        cell.competitionNameLabel.text = matchCompetitionName.uppercased()
        cell.statusLabel.text = (matchStatus == "IN_PLAY" ? "LIVE" : matchStatus)
        
        cell.statusLabel.textColor = UIColor.colorForMatchStatus(match.status!)
        cell.parentViewControllerDelegate = self
        
        guard let homeTeamScore = match.score?.fullTime?.homeTeam,
            let awayTeamScore = match.score?.fullTime?.awayTeam else {
                cell.scoreLabel.text = "-:-"
                return cell
        }
        
        cell.scoreLabel.text = "\(awayTeamScore):\(homeTeamScore)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}
