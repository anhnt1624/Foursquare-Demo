//
//  RecommendModel.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/25/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation

struct RecommendModel : Decodable {
    var type: String = ""
    var name: String = ""
    var items: [Item]? = nil
    
    private enum CodingKeys : String, CodingKey {
        case type
        case name
        case items
    }
}

struct Item : Decodable {
    var tips: [ItemTip]?
    var venue: DetailModel?
    
    private enum CodingKeys : String, CodingKey {
        case tips
        case venue
    }
}
