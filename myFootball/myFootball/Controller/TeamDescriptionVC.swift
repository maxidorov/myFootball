//
//  TeamDescriptionVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 29.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class TeamDescriptionVC: UIViewController {
    
    var teamId: Int!
    var teamName: String!
    var team: ModelTeamDescription!
    
    var teamNameLabel = UILabel()
//    var teamLogoImageView = UIImageView()
    
    var tableView = UITableView()
    var teamInfo = [[String]]()
    var sectionTitles = ["COACHES", "PLAYERS", "WEBSITE", "LAST UPDATED"]
    
    init(teamId: Int?, teamName: String?) {
        self.teamId = teamId
        self.teamName = teamName
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.teamId = nil
        self.teamName = nil
    }
    
    let webView: WKWebView = {
        let mySVGImage = ""
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let wv = WKWebView(frame: .zero, configuration: configuration)
        wv.scrollView.isScrollEnabled = false
        wv.loadHTMLString(mySVGImage, baseURL: nil)
        return wv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadTeamDescriptionAndUpdateInfo()
    }
    
    
    private func setupUI() {
        
        view.addSubview(teamNameLabel)
        
        teamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        teamNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        teamNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        teamNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        teamNameLabel.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        teamNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        teamNameLabel.textAlignment = .center
        teamNameLabel.backgroundColor = .white
        teamNameLabel.textColor = .black
        teamNameLabel.text = teamName!
        
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: teamNameLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        view.addSubview(teamLogoImageView)
//
//        teamLogoImageView.translatesAutoresizingMaskIntoConstraints = false
//        teamLogoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        teamLogoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        teamLogoImageView.topAnchor.constraint(equalTo: teamNameLabel.bottomAnchor).isActive = true
//        teamLogoImageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        teamLogoImageView.heightAnchor.constraint(equalTo: teamLogoImageView.widthAnchor).isActive = true
        
//        view.addSubview(webView)
//        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    private func updateInfo() {
//        print(team.crestUrl)
//        if let teamCrestUrl = team.crestUrl {
//            if let url = URL(string: teamCrestUrl) {
//                let request = URLRequest(url: url)
//                webView.load(request)
//                webView.isUserInteractionEnabled = false
//                webView.contentMode = .center
//                let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
//                let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//                let wkUController = WKUserContentController()
//                wkUController.addUserScript(userScript)
//                let wkWebConfig = WKWebViewConfiguration()
//                wkWebConfig.userContentController = wkUController
//                let webView = WKWebView(frame: self.view.bounds, configuration: wkWebConfig)
//                webView.contentMode = .scaleToFill
//            }
//        }
        tableView.reloadData()
    }
    
    private func loadTeamDescriptionAndUpdateInfo() {
        let groupLoadTeamDescriprion = DispatchGroup()
        groupLoadTeamDescriprion.enter()
        NetworkManager.shared.getTeamDescription(teamId: teamId!) { (result) in
            switch result {
            case .success(let response):
                self.team = response
                var teamCoaches = [String]()
                var teamPlayers = [String]()
                for man in self.team.squad! {
                    switch man.role! {
                    case "COACH":
                        teamCoaches.append(man.name!)
                    case "PLAYER":
                        teamPlayers.append(man.name!)
                    default:
                        break
                    }
                }
                teamCoaches.sort()
                teamPlayers.sort()
                var teamLastUpdated = [String]()
                teamLastUpdated.append(self.team.lastUpdated!)
                
                self.teamInfo.append(teamCoaches)
                self.teamInfo.append(teamPlayers)
                self.teamInfo.append([self.team.website!])
                self.teamInfo.append(teamLastUpdated)
                
                groupLoadTeamDescriprion.leave()
            case .failure(let error):
                print(error)
            }
        }
        groupLoadTeamDescriprion.notify(queue: DispatchQueue.main) {
            self.updateInfo()
        }
    }
}

extension TeamDescriptionVC: UITableViewDelegate {
    
}

extension TeamDescriptionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        teamInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        teamInfo[section].count
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return sectionTitles
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = .white

        let sectionLabel = UILabel(frame: CGRect(x: 8,
                                                 y: 0,
                                                 width: tableView.bounds.size.width,
                                                 height: tableView.bounds.size.height))
        sectionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        sectionLabel.textColor = .lightGray
        sectionLabel.text = sectionTitles[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = teamInfo[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let svc = SFSafariViewController(url: URL(string: teamInfo[indexPath.section][indexPath.row])!)
            present(svc, animated: true, completion: nil)
        }
    }
}
