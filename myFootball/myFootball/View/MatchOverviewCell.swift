//
//  TodayVCCell.swift
//  myFootball
//
//  Created by Maxim Sidorov on 27.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class MatchOverviewCell: UITableViewCell {
    
    public static let reuseId = "TodayVCCell"
    
    var awayTeamId: Int?
    var homeTeamId: Int?
    
    var competitionNameLabel = UILabel()
    
    var scoreLabel = UILabel()
    var homeTeamNameLabel = UILabel()
    var awayTeamNameLabel = UILabel()
    var statusLabel = UILabel()
    
    var homeTeamLogoImageView = UIImageView()
    var awayTeamLogoImageView = UIImageView()
    
    var parentViewControllerDelegate: UIViewController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let screenWidth = UIScreen.main.bounds.width
        
        contentView.frame.size = CGSize(width: screenWidth, height: 200)
        contentView.backgroundColor = .white
        
        contentView.addSubview(competitionNameLabel)
        
        competitionNameLabel.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 30)
        competitionNameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        competitionNameLabel.textColor = .lightGray
        competitionNameLabel.textAlignment = .center
        competitionNameLabel.backgroundColor = .white
        
        contentView.addSubview(scoreLabel)
        scoreLabel.frame.size = CGSize(width: 170, height: 70)
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 74)
        scoreLabel.center.x = contentView.center.x
        scoreLabel.center.y = contentView.center.y
        scoreLabel.backgroundColor = .white
        
        let teamNameLabelsHeight: CGFloat = 40
        let teamNameLabelsFont = UIFont(name: "HelveticaNeue-Medium", size: 12)
        let teamNameLabelsTextColor: UIColor = .lightGray
        
        contentView.addSubview(homeTeamNameLabel)
        homeTeamNameLabel.backgroundColor = .white
        homeTeamNameLabel.textColor = teamNameLabelsTextColor
        homeTeamNameLabel.font = teamNameLabelsFont
        homeTeamNameLabel.frame.size = CGSize(width: screenWidth / 2, height: teamNameLabelsHeight)
        homeTeamNameLabel.center.y += contentView.frame.height - teamNameLabelsHeight
        homeTeamNameLabel.textAlignment = .center
        
        let homeTeamNameLabelTap = UITapGestureRecognizer(target: self, action: #selector(homeTeamNameLabelPressed))
        homeTeamNameLabel.addGestureRecognizer(homeTeamNameLabelTap)
        homeTeamNameLabel.isUserInteractionEnabled = true
        
        contentView.addSubview(awayTeamNameLabel)
        awayTeamNameLabel.backgroundColor = .white
        awayTeamNameLabel.textColor = teamNameLabelsTextColor
        awayTeamNameLabel.font = teamNameLabelsFont
        awayTeamNameLabel.frame.size = CGSize(width: screenWidth / 2, height: teamNameLabelsHeight)
        awayTeamNameLabel.center.x += contentView.frame.size.width / 2
        awayTeamNameLabel.center.y += contentView.frame.height - teamNameLabelsHeight
        awayTeamNameLabel.textAlignment = .center
        
        let awayTeamNameLabelTap = UITapGestureRecognizer(target: self, action: #selector(awayTeamNameLabelPressed))
        awayTeamNameLabel.addGestureRecognizer(awayTeamNameLabelTap)
        awayTeamNameLabel.isUserInteractionEnabled = true
        
        let statusLabelHeight = 30
        let statusLabelFont = UIFont(name: "HelveticaNeue-Medium", size: 12)
        let statusLabelOffset = 20
        
        contentView.addSubview(statusLabel)
        statusLabel.backgroundColor = .white
        statusLabel.frame = CGRect(x: statusLabelOffset, y: 0, width: Int(screenWidth / CGFloat(4)), height:  statusLabelHeight)
        statusLabel.textAlignment = .left
        statusLabel.textColor = .lightGray
        statusLabel.font = statusLabelFont
        
//        let teamLogoImageViewSize: CGFloat = 80
//
//        contentView.addSubview(homeTeamLogoImageView)
//        homeTeamLogoImageView.backgroundColor = .black
//        homeTeamLogoImageView.frame = CGRect(x: 0, y: 0, width: teamLogoImageViewSize, height: teamLogoImageViewSize)
//        homeTeamLogoImageView.center.x = contentView.center.x * (1 / 2)
//        homeTeamLogoImageView.center.y = contentView.center.y
//
//        contentView.addSubview(awayTeamLogoImageView)
//        awayTeamLogoImageView.backgroundColor = .black
//        awayTeamLogoImageView.frame = CGRect(x: 0, y: 0, width: teamLogoImageViewSize, height: teamLogoImageViewSize)
//        awayTeamLogoImageView.center.x = contentView.center.x * (3 / 2)
//        awayTeamLogoImageView.center.y = contentView.center.y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func homeTeamNameLabelPressed() {
        parentViewControllerDelegate.present(TeamDescriptionVC(teamId: homeTeamId!, teamName: homeTeamNameLabel.text!), animated: true, completion: nil)
    }
    
    @objc
    private func awayTeamNameLabelPressed() {
        parentViewControllerDelegate.present(TeamDescriptionVC(teamId: awayTeamId!, teamName: awayTeamNameLabel.text!), animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
