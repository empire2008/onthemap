//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 4/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable{
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct ClientError: Codable{
    let status: Int
    let error: String
}

extension ClientError: LocalizedError{
    var errorDescription: String? {
        return error
    }
}
