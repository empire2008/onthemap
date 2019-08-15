//
//  AccountResponse.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 11/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

struct AccountResponse: Codable {
    let user: UserInfo
}

struct UserInfo: Codable {
    let first_name: String
    let last_name: String
}
