//
//  TeamDetailVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 05.12.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class TeamDetailVC: UIViewController {
    
    var teamId: Int!
    var teamName: String!
    
    var tableView = UITableView()
    var matches = [ModelMatch]()
    
    var startDate = Date() - 60 * 60 * 24 * 7
    var endDate = Date()
    
    init(teamId: Int?, teamName: String?) {
        self.teamId = teamId
        self.teamName = teamName
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.teamId = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = teamName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(chooseDate))
        
        setUpTableView()
        loadMatchesOverviewAndUpdateTableView()
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
    
    func loadMatchesOverviewAndUpdateTableView() {
        let groupLoadMatches = DispatchGroup()
        groupLoadMatches.enter()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        NetworkManager.shared.getTeamsMatchesDuringPeriod(teamId: teamId, dateFrom: startDate, dateTo: endDate) { (result) in
            switch result {
            case .success(let response):
                if let matches = response.matches {
                    self.matches = matches
                    groupLoadMatches.leave()
                } else {
                    // smth goes wrong
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        groupLoadMatches.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    @objc
    private func chooseDate() {
        let datePickerVC = DatePickerVC([startDate, endDate])
        datePickerVC.parentVCDelegate = self
        present(datePickerVC, animated: true, completion: nil)
    }
}

extension TeamDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = "\(startDate.toSting().replacingOccurrences(of: "-", with: ".")) ― \(endDate.toSting().replacingOccurrences(of: "-", with: "."))"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchOverviewCell.reuseId, for: indexPath) as! MatchOverviewCell
        cell.selectionStyle = .none
        
        let match = matches[indexPath.row - 1]
        
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
        
        return indexPath.row == 0 ? 44.0 : 200.0
    }
}

extension TeamDetailVC: UITableViewDelegate { }
