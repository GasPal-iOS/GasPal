//
//  GasFeedApiClient.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class FourSquareClient: NSObject {
    
    private let CLIENT_ID = "QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL"
    private let CLIENT_SECRET = "W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU"
    
    private let baseUrlString = "https://api.foursquare.com/v2/venues/search?"
    
    static let sharedInstance = FourSquareClient()
    
    func fetchLocations(_ query: String, near: String = "Mountain View", success: @escaping ([NSDictionary]) -> (), error: @escaping (Error) -> ()) {
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&near=\(near),CA&query=\(query)"
        fetchLocations(queryString: queryString, success: success, error: error)
    }
    
    func fetchLocations(_ query: String, ll: String, limit: Int, radius: Double, success: @escaping ([NSDictionary]) -> (), error: @escaping (Error) -> ()) {
        let queryString = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20141020&ll=\(ll)&query=\(query)&llAcc=\(radius)&limit=\(limit)"
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
