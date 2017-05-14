//
//  GasFeedApiClient.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

enum FourSquareCategoryId: String {
    case gasStation = "4bf58dd8d48988d113951735"
    case food = "4d4b7105d754a06374d81259"
    case bar = "4bf58dd8d48988d116941735"
}

class FourSquareClient: NSObject {
    
    private let CLIENT_ID = "QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL"
    private let CLIENT_SECRET = "W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU"
    
    private let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
    
    static let sharedInstance = FourSquareClient()
    
    static var overrideId: FourSquareCategoryId?
    
    func fetchLocations(_ categoryId: FourSquareCategoryId, near: String = "Mountain View", success: @escaping ([NSDictionary]) -> (), error: @escaping (Error) -> ()) {
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&near=\(near),CA&categoryId=\(categoryId.rawValue)"
        fetchLocations(queryString: queryString, success: success, error: error)
    }
    
    func fetchLocations(_ categoryId: FourSquareCategoryId, ll: String, limit: Int, radius: Double, success: @escaping ([NSDictionary]) -> (), error: @escaping (Error) -> ()) {
        var searchId = categoryId.rawValue
        if let overrideId = FourSquareClient.overrideId {
            searchId = overrideId.rawValue
        }
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&ll=\(ll)&categoryId=\(searchId)&llAcc=\(radius)&limit=\(limit)"
        fetchLocations(queryString: queryString, success: success, error: error)
    }
    
    func fetchLocations(queryString: String, success: @escaping ([NSDictionary]) -> (), error: @escaping (Error) -> ()) {
        let url = URL(string: baseUrlString + queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let request = URLRequest(url: url)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    let results = responseDictionary.value(forKeyPath: "response.venues") as! [NSDictionary]
                    success(results)
                }
            }
        });
        task.resume()
    }

}
