//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 3/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var userPosted = LocationInfo(createdAt: "", firstName: "", lastName: "", latitude: 0, longitude: 0, mapString: "", mediaURL: "", objectId: "", uniqueKey: "", updatedAt: "")
        static var userList: [LocationInfo] = []
        static var sessionId: String = ""
        static var key = ""
    }
    
    enum EndPoint {
        case getSession
        case getPublicUser(String)
        case getLocations
        case getLimitLocations(Int)
        var stringValue: String{
            switch self {
            case .getSession: return "https://onthemap-api.udacity.com/v1/session"
            case .getPublicUser(let userId): return "https://onthemap-api.udacity.com/v1/users/\(userId)"
            case .getLocations: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .getLimitLocations(let amount): return  "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(amount)&order=-updatedAt"
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func getLocations(url: URL, completion: @escaping (LocationsResponse?, Error?) -> Void) {
        taskForGetRequest(url: url, responseType: LocationsResponse.self) { (response, error) in
            if let response = response{
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }
            else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func requestSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let loginSession = LoginSession(udacity: SessionRequest(username: username, password: password))
        
        taskForPostRequest(url: EndPoint.getSession.url, responseType: LoginResponse.self, body: loginSession) { (response, error) in
            if let response = response{
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
//    class func taskForGetRequestSkipData<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
//        let task = URLSession.shared.dataTask(with: url) { oriData, response, error in
//            guard let oriData = oriData else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
//            let range = (5..<oriData.count)
//            let data = oriData.subdata(in: range)
//            do{
//                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            }
//            catch{
//                do{
//                    let errorResponse = try JSONDecoder().decode(ClientError.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                }
//                catch{
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
//            print("DATA: \(String(data: data, encoding: .utf8))")
//            let range = (5..<originalData.count)
//            let data = originalData.subdata(in: range)
            do{
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch{
                do{
                    let errorResponse = try JSONDecoder().decode(ClientError.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func postLocation(completion: @escaping (Bool, Error?) -> Void){
        let locationRequest = AddLocationRequest(uniqueKey: Auth.key, firstName: "Kutoloji", lastName: "Ohio", mapString: Auth.userPosted.mapString, mediaURL: Auth.userPosted.mediaURL, latitude: Auth.userPosted.latitude, longitude: Auth.userPosted.longitude)
        print("LocationData = \(Auth.userPosted)")
        let body = try? JSONEncoder().encode(locationRequest)
        
        var request = URLRequest(url: EndPoint.getLocations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do{
                let resposeObject = try JSONDecoder().decode(AddLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
            catch{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        let data = try? JSONEncoder().encode(body)
        guard let body = data else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { originalData, reponse, error in
            guard let originalData = originalData else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = (5..<originalData.count)
            let data = originalData.subdata(in: range)
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch{
                do{
                    let errorResponse = try JSONDecoder().decode(ClientError.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
