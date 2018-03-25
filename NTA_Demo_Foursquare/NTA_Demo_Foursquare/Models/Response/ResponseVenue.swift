//
//  ResponseVenue.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/25/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation

struct ResponseVenue : Decodable {
    let minivenues: [VenueModel]
}
