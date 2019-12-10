//
//  FavoritesVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 30.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController {
    
    var tableView: UITableView!
    
    var savedFavoritesTeams: [NSManagedObject] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Favorites"
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        setUpTableView()
        fetchFavoriteTeams()
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
    
    @objc func addTapped() {
        let searchTeamVC = SearchTeamVC.shared
        searchTeamVC.parentVCDelegate = self
        present(searchTeamVC, animated: true, completion: nil)
    }
    
    func fetchFavoriteTeams() {
        do {
            savedFavoritesTeams = try CoreDataManager.shared.fetch(entityName: "FavoriteTeam")
        } catch {
            print("Could not fetch. \(error.localizedDescription)")
        }
    }
    
    func addFavoriteTeam(teamId: Int, teamName: String) {
        do {
            let favoriteTeam = try CoreDataManager.shared.save(entityName: "FavoriteTeam",keyedValues: ["id": teamId, "name": teamName])
            savedFavoritesTeams.append(favoriteTeam)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteFavoriteTeam(index: Int) {
        let teamToDelete = savedFavoritesTeams[index]
        do {
            try CoreDataManager.shared.delete(object: teamToDelete)
            savedFavoritesTeams.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFavoritesTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = savedFavoritesTeams[indexPath.row].value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteTeamId = savedFavoritesTeams[indexPath.row].value(forKey: "id") as? Int
        let favoriteTeamName = savedFavoritesTeams[indexPath.row].value(forKey: "name") as? String
        let favoriteTeamDetailVC = TeamDetailVC(teamId: favoriteTeamId, teamName: favoriteTeamName)
        navigationController?.pushViewController(favoriteTeamDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteFavoriteTeam(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavoritesVC: UITableViewDelegate { }
