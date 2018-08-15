//
//  DSSScreenshotCell.swift
//  DSSAppStore
//
//  Created by David on 04/08/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

class DSSScreenshotCell: DSSBaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var app: DSSApp? {
        didSet {
            screeeshotCollectionView.reloadData()
        }
    }
    
    
    private let cellId = "cellId"
    
    let screeeshotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        screeeshotCollectionView.dataSource = self
        screeeshotCollectionView.delegate = self
        addSubview(screeeshotCollectionView)
        addSubview(dividerLineView)
        addConstraintsWithFormat("H:|[v0]|", views: screeeshotCollectionView)
        addConstraintsWithFormat("H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:|[v0][v1(1)]|", views: screeeshotCollectionView, dividerLineView)
        screeeshotCollectionView.register(DSSScreenshotImageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.Screenshots?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = screeeshotCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DSSScreenshotImageCell
        if let imageName = app?.Screenshots?[indexPath.row] {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: frame.height - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    private class DSSScreenshotImageCell: DSSBaseCell {
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.backgroundColor = .lightGray
            return iv
        }()
        
        override func setupViews() {
            super.setupViews()
            
            addSubview(imageView)
            addConstraintsWithFormat("H:|[v0]|", views: imageView)
            addConstraintsWithFormat("V:|[v0]|", views: imageView)
        }
    }
}
