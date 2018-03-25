//
//  TipModel.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/25/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation

struct Tip: Decodable {
    let count: Int?
    let groups: [GroupsTip]?
}

struct GroupsTip: Decodable {
    let type: String?
    let name: String?
    let count: Int?
    let items: [ItemTip]?
}

struct ItemTip: Decodable {
    let idItemsTip: String?
    let text: String?
    private enum CodingKeys : String, CodingKey {
        case text
        case idItemsTip = "id"
    }
}
