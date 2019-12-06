//
//  ViewController.swift
//  myFootball
//
//  Created by Maxim Sidorov on 25.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    
    var current: UIViewController
    
    init() {
        let tabBarVC = TabBarVC()
        self.current = tabBarVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

