//
//  FoursquareManager.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/23/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import UIKit
import MapKit

private let clientId = "WDLOKGIA2MN5M5V2530MXLZNL2A45Z5M0ZKWHLIJUXYWPWOV"
private let clientSecret = "PU5HZ1MVAKCEWYAZVD1U4TLT2R1ACISCFS4JVGMQFNNCGPXZ"

class FoursquareManager: NSObject {
    
    var accessToken: String!
    var venues: [VenueModel] = []
    
    class func sharedManager() -> FoursquareManager {
        
        struct Static {
            static let instance = FoursquareManager()
        }
        return Static.instance
    }
    
    func searchVenuesWithCoordinate(_ coordinate: CLLocationCoordinate2D, query: String, limit: String, completion: ((Error?) -> ())?) {
        let client = FoursquareAPIClient(clientId: clientId, clientSecret: clientSecret)
        
        let parameter: [String: String] = [
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
            "query": query,
            "limit": limit,
            "near": "Ho Chi Minh",
        ];
        
        client.request(path: "venues/suggestcompletion", parameter: parameter) {
            [weak self] result in
            switch result {
            case let .success(data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseJson<ResponseVenue>.self, from: data)
                    self?.venues = response.response.minivenues
                    completion?(nil)
                } catch {
                    completion?(error)
                }
            case let .failure(error):
                completion?(error)
            }
        }
    }
    
    func searchVenuesRecommend(_ coordinate: CLLocationCoordinate2D, limit: String, completion: ((RecommendModel?, Error?) -> ())?) {
        let client = FoursquareAPIClient(clientId: clientId, clientSecret: clientSecret)

        let parameter: [String: String] = [
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
            "limit": limit,
            "near": "",
            ];

        client.request(path: "venues/explore", parameter: parameter) {
        result in
            switch result {
            case let .success(data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseJson<ResponseRecommend>.self, from: data)
                    completion?(response.response.groups[0], nil)
                } catch {
                    completion?(nil, error)
                }
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }
    
    func getDetailVenue(_ idVenue: String, completion: ((DetailModel? ,Error?) -> ())?) {
        let client = FoursquareAPIClient(clientId: clientId, clientSecret: clientSecret)
        
        let parameter: [String: String] = [
            "VENUE_ID": idVenue,
            ];
        
        client.request(path: "venues/\(idVenue)", parameter: parameter) {
             result in
            switch result {
            case let .success(data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response = try decoder.decode(ResponseJson<ResponseDetail>.self, from: data)
                    completion?(response.response.venue, nil)
                } catch {
                    completion?(nil,error)
                }
            case let .failure(error):
                completion?(nil,error)
            }
        }
    }
}

