//
//  SessionRequest.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 4/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

struct LoginSession: Codable {
    let udacity: SessionRequest
}

struct SessionRequest: Codable {
    let username: String
    let password: String
}
