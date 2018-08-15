//
//  ViewController.swift
//  DSSAppStore
//
//  Created by David on 29/05/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

class DSSFeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DSSCategoryCellDelegate {
    
    private let cellId = "celId"
    private let largeCellId = "largeCellId"
    private let headerId = "headerId"
    
//    var appCategories: [DSSAppCategory]?
    var featuredApps: DSSFeaturedApps?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "Featured Apps"
//        DSSAppCategory.fetchFeaturedApps { (appCategories) in
//            self.appCategories = appCategories
//            self.collectionView?.reloadData()
//        }
        
        fetchFeaturedApps()
        
        collectionView?.register(DSSCategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(DSSLargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        collectionView?.register(DSSHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionView?.register(DSSHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerId)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! DSSLargeCategoryCell
            if let appCategory = featuredApps?.categories?[indexPath.row] {
                cell.appCategory = appCategory
            }
//            cell.delegate = self
            
            return cell
        }
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DSSCategoryCell
        if let appCategory = featuredApps?.categories?[indexPath.row] {
            cell.appCategory = appCategory
        }
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = featuredApps?.categories?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 {
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DSSHeader
        header.appCategory = featuredApps?.bannerCategory
        return header
    }
    
    private func fetchFeaturedApps() {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        guard let url = URL(string: urlString) else {
            print("Filed to fetch featured apps.")
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch featured apps: ", error.localizedDescription)
                return
            }
            
            guard let htmlResponse = response as? HTTPURLResponse, (200...299).contains(htmlResponse.statusCode) else {
                print("Request ended with status different from: 200-299")
                return
            }
            
            guard let data = data else { return }
            do {
                let featuredApps = try JSONDecoder().decode(DSSFeaturedApps.self, from: data)
                self.featuredApps = featuredApps
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } catch {
                print("Failed to decode data obtained from server: ", error.localizedDescription)
            }
            }.resume()
    }
    
    func didSelectedApp(_ app: DSSApp) {
        let layout = UICollectionViewFlowLayout()
        let appDetailController = DSSAppDetailController(collectionViewLayout: layout)
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}


class DSSHeader: DSSCategoryCell {
    let bannerCellId = "bannerCellId"
    
    override func setupViews() {
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(DSSBannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        addSubview(appsCollectionView)
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! DSSBannerCell
        cell.app = appCategory?.apps?[indexPath.row]
        //        cell.backgroundColor = .green
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 + 50, height: frame.height)
    }
    
    private class DSSBannerCell: DSSAppCell {
        override func setupViews() {
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            imageView.layer.cornerRadius = 0
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        }
    }
}

class DSSLargeCategoryCell: DSSCategoryCell {
    let largeAppCellid = "largeAppCellid"
    
    
    override func setupViews() {
        super.setupViews()
        appsCollectionView.register(DSSLargeAppCell.self, forCellWithReuseIdentifier: largeAppCellid)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellid, for: indexPath) as! DSSLargeAppCell
        cell.app = appCategory?.apps?[indexPath.row]
//        cell.backgroundColor = .green
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    private class DSSLargeAppCell: DSSAppCell {
        override func setupViews() {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        }
    }
}

