//
//  LocationResponse.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 7/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

struct LocationsResponse:Codable {
    let results: [LocationInfo]
}

struct LocationInfo: Codable {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
}
