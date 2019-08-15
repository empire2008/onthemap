//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 10/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

struct AddLocationRequest: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}
