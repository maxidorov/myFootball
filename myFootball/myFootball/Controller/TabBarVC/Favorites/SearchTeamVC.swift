//
//  SearchTeamVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 30.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class SearchTeamVC: UIViewController {
    
    static public var shared = SearchTeamVC()
    
    private init() {
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchBar = UISearchBar()
    var tableView = UITableView()
    
    var allTeams = [ModelTeamDescription]()
    var searchedTeams = [ModelTeamDescription]()
    
    var parentVCDelegate: FavoritesVC!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        loadAllTeams()
        setupSearchBar()
        setupTableView()
    }
    
    func loadAllTeams() {
//        let areas: [Area] = [.Europe, .Africa, .NorthAndCentralAmerica, .SouthAmerica, .Asia]
//        Загружаю только .Europe, потому что бесплатный API ставит лимит на 6 запросов в минуту
        let groupLoadTeams = DispatchGroup()
        groupLoadTeams.enter()
        NetworkManager.shared.getTeamsFromArea(area: .Europe) { (result) in
            switch result {
            case .success(let response):
                if let teams = response.teams {
                    for team in teams {
                        self.allTeams.append(team)
                    }
                    groupLoadTeams.leave()
                }
            case .failure(let error):
                print(error)
            }
        }
        groupLoadTeams.notify(queue: DispatchQueue.main) {
            self.allTeams.sort { (team1, team2) -> Bool in
                return team1.name! < team2.name!
            }
            self.filterTeams()
            self.tableView.reloadData()
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search team..."
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func filterTeams() {
        searchedTeams.removeAll()
        for team in self.allTeams {
            if (team.name?.lowercased().contains(searchBar.text!.lowercased()))! {
                searchedTeams.append(team)
            }
        }
    }
}

extension SearchTeamVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTeams()
        tableView.reloadData()
    }
}

extension SearchTeamVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedTeams.count == 0 && searchBar.text == "" {
            return allTeams.count
        }
        return searchedTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if searchedTeams.count == 0 && searchBar.text == "" {
            cell.textLabel?.text = allTeams[indexPath.row].name
        } else {
            cell.textLabel?.text = searchedTeams[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteTeam: ModelTeamDescription!
        if searchedTeams.isEmpty {
            favoriteTeam = allTeams[indexPath.row]
        } else {
            favoriteTeam = searchedTeams[indexPath.row]
        }
        searchBar.text = ""
        self.filterTeams()
        self.tableView.reloadData()
        parentVCDelegate.addFavoriteTeam(teamId: favoriteTeam.id!, teamName: favoriteTeam.name!)
        parentVCDelegate.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchTeamVC: UITableViewDelegate { }

extension SearchTeamVC: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
