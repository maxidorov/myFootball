//
//  TodayVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 25.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class SomeVC: UIViewController {
    
    private var layout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Today"
//        self.navigationItem.largeTitleDisplayMode = .always;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white
        
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumLineSpacing = 20
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height),
                                          collectionViewLayout: layout)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false

//        let safeArea = view.safeAreaLayoutGuide

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        collectionView.register(SomeVCCell.self, forCellWithReuseIdentifier: SomeVCCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
}

extension SomeVC: UICollectionViewDelegate {
    
}

extension SomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SomeVCCell.reuseId, for: indexPath) as! SomeVCCell
        cell.backgroundColor = .red
        cell.layer.shadowOpacity = 1
        return cell
    }
}
