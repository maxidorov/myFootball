//
//  TodayVCCell.swift
//  myFootball
//
//  Created by Maxim Sidorov on 25.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class SomeVCCell: UICollectionViewCell {
    
    public static let reuseId = "SomeVCCell"
    
    public var labelTeamOne = UILabel()
    public var labelTeamTwo = UILabel()
    public var labelScore = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
