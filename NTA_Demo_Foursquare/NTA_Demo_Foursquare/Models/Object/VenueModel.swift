//
//  VenueModel.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/25/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation

struct VenueModel : Decodable {
    var idVenue: String = ""
    var name: String = ""
    var location: Location? = nil
    var categories: [VenueCategory]? = nil
    
    private enum CodingKeys : String, CodingKey {
        case name
        case idVenue = "id"
        case location
        case categories
    }
}

struct Location: Decodable {
    let address: String?
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case address
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct VenueCategory: Decodable {
    let categoryId: String?
    let name: String?
    let icon: VenueCategoryIcon?
    
    private enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case name
        case icon
    }
}

struct VenueCategoryIcon: Decodable {
    let prefix: String?
    let suffix: String?
    
    var categoryIconUrl: String {
        return String(format: "%@%d%@", prefix!, 88, suffix!)
    }
    
    private enum CodingKeys: String, CodingKey {
        case prefix
        case suffix
    }
}
