//
//  DSSModels.swift
//  DSSAppStore
//
//  Created by David on 31/05/18.
//  Copyright © 2018 DS_Systems. All rights reserved.
//

import UIKit

struct DSSFeaturedApps: Decodable {
    var bannerCategory: DSSAppCategory?
    var categories: [DSSAppCategory]?
}

struct DSSAppCategory: Decodable {
    var name: String?
    var apps: [DSSApp]?
    var type: String?
    
//    static func fetchFeaturedApps(completion: @escaping ([DSSAppCategory]) -> ()) {
//        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
//        var appCategories = [DSSAppCategory]()
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                guard let error = error else { return }
//                print(error)
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
//
//                for dict in json["categories"] as! [[String: AnyObject]] {
//                    let appCategory = DSSAppCategory()
//                    appCategory.setValuesFrom(dictionary: dict)
//                    appCategories.append(appCategory)
//                }
//
//                DispatchQueue.main.async {
//                    completion(appCategories)
//                }
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
//    func setValuesFrom(dictionary: [String: AnyObject]) {
//        name = dictionary["name"] as? String
//        apps = [DSSApp]()
//        for appDictionary in dictionary["apps"] as! [[String: Any]] {
//            let app = DSSApp()
//            app.setValuesFrom(dictionary: appDictionary)
//            apps?.append(app)
//        }
//    }

//    THIS IS A TEST FUNCTION
//    static func sampleAppCategories() -> [DSSAppCategory] {
//        let bestNewAppsCategory = DSSAppCategory()
//        bestNewAppsCategory.name = "Best new apps"
//
//        var apps = [DSSApp]()
//
//        let frozenApp = DSSApp()
//        frozenApp.name = "Disney built it: Frozen"
//        frozenApp.imageName = "frozen"
//        frozenApp.category = "Entertainment"
//        frozenApp.price = NSNumber(floatLiteral: 3.99)
//        apps.append(frozenApp)
//
//        bestNewAppsCategory.apps = apps
//
//        let bestNewGamesCategory = DSSAppCategory()
//        bestNewGamesCategory.name = "Best new games"
//
//        var bestNewGamesApps = [DSSApp]()
//        let telepaintApp = DSSApp()
//        telepaintApp.name = "Telepaint"
//        telepaintApp.category = "Games"
//        telepaintApp.imageName = "telepaint"
//        telepaintApp.price = NSNumber(floatLiteral: 2.99)
//
//        bestNewGamesApps.append(telepaintApp)
//
//        bestNewGamesCategory.apps = bestNewGamesApps
//
//        return [bestNewAppsCategory, bestNewGamesCategory]
//    }
}

struct DSSApp: Decodable {
    var Id: Int?
    var Name: String?
    var Category: String?
    var ImageName: String?
    var Price: Float?
    
    let description: String?
    let appInformation: [DSSAppInformation]?
    let Screenshots: [String]?
    
//    func setValuesFrom(dictionary: [String: Any]) {
//        id = dictionary["Id"] as? NSNumber
//        name = dictionary["Name"] as? String
//        category = dictionary["Category"] as? String
//        imageName = dictionary["ImageName"] as? String
//        price = dictionary["Price"] as? NSNumber
//    }
}

struct DSSAppDetail: Decodable {
    let Id: Int?
    let Name: String?
    let Category: String?
    let Price: Float?
    let ImageName: String?
    let description: String?
    let appInformation: [DSSAppInformation]?
    let Screenshots: [String]?
}

struct DSSAppInformation: Decodable {
    let Name: String?
    let Value: String?
}
