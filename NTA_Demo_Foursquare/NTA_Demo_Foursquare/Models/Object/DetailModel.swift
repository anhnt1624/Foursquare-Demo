//
//  DetailVenue.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/25/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation

struct DetailModel: Decodable {
    var idVenue: String = ""
    var name: String = ""
    var rating: Double? = 0
    var contact: Contact? = nil
    var stats: Stats? = nil
    var beenHere: BeenHere? = nil
    var tips: Tip? = nil
    var location: Location? = nil
    var photos: Photo? = nil
    var price: Price? = nil
    
    private enum CodingKeys : String, CodingKey {
        case name
        case idVenue = "id"
        case stats
        case beenHere
        case tips
        case location
        case photos
        case price
        case contact
        case rating
    }
}

struct Contact: Decodable {
    let phone: String?
}

struct Price: Decodable {
    let tier: Int?
    let message: String?
    let currency: String?
}

struct Stats: Decodable {
    let tipCount: Int?
    let usersCount: Int?
    let checkinsCount: Int?
    let visitsCount: Int?
}

struct BeenHere: Decodable {
    let count: Int?
}

struct Photo: Decodable {
    let groups: [GroupsPhoto]?
    let count: Int?
}

struct GroupsPhoto: Decodable {
    let type: String?
    let name: String?
    let count: Int?
    let items: [ItemsPhoto]?
}

struct ItemsPhoto: Decodable {
    var idItemsPhoto: String? = ""
    var prefix: String? = ""
    var suffix: String? = ""
    
    var photoUrl: String {
        return String(format: "%@%@%@", prefix!, "300x150", suffix!)
    }
    
    private enum CodingKeys : String, CodingKey {
        case prefix
        case suffix
        case idItemsPhoto = "id"
    }
}

