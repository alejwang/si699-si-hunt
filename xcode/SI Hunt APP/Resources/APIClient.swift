
//
//  APIClient.swift
//  Event FInder
//
//  Created by Alejandro Wang on 2/26/19.
//  Copyright © 2019 Alejandro Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class APIClient {
    
    static func register(withUsername username: String, password: String, completion: @escaping () -> Void) {
        print("> Sending register request from API Client")
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request("https://alejwang.pythonanywhere.com/register", method: .post, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("> JSON: \(json)")
            }
        }
        completion()
    }
    
    static func login(withUsername username: String, password: String, completion: @escaping () -> Void) {
        print("> Sending login request  from API Client")
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request("https://alejwang.pythonanywhere.com/auth", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let json = response.result.value as? [String: AnyObject] {
                print("> JSON: \(json)")
                UserDefaults.standard.removeObject(forKey: "access_token")
                if let access_token = json["access_token"] {
                    print("> Access token is: \(access_token)")
                    UserDefaults.standard.set(access_token, forKey: "access_token")
                }
            }
            completion()
        }
    }
    
    static func getProfile(withUsername username: String,completion: @escaping (JSON?) -> Void) {
        print("> Sending getProfile request")
        Alamofire.request("https://alejwang.pythonanywhere.com/profile/\(username)", method: .get,  encoding: JSONEncoding.default).responseJSON { response in
                if response.result.isSuccess{
                    let json : JSON = JSON(response.result.value!)
                    if json["message"].string != nil {
                        completion(nil)
                    }
                    print("> JSON: \(json)")
                    completion(json)
                }
                else{
                    print("Error")
                    completion(nil)
                }
        }
    }
    
    static func getTagList(completion: @escaping (JSON?) -> Void) {
        print("> Sending getTagList request")
        Alamofire.request("https://alejwang.pythonanywhere.com/tags", method: .get,  encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess{
                let json : JSON = JSON(response.result.value!)
                print("> JSON: \(json)")
                completion(json)
            }
            else{
                print("Error")
                completion(nil)
            }
        }
    }
    
    static func getLeaderboard(completion: @escaping (JSON?) -> Void) {
        print("> Sending getLeaderboard request")
        Alamofire.request("https://alejwang.pythonanywhere.com/leaderboard", method: .get,  encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess{
                let json : JSON = JSON(response.result.value!)
                if json["message"].string != nil {
                    completion(nil)
                }
                print("> JSON: \(json)")
                completion(json)
            }
            else{
                print("Error")
                completion(nil)
            }
        }
    }
//
//    static func getEvents(completion: @escaping (_ events: [(name: String,description: String, capacity: Int, organizer_id: Int, organizer_name: String, start_time: String, end_time: String, location_id: Int, location_name: String, location_is_armap_available: Bool, is_published: Bool, pub_date: String)]) -> Void) {
//        AF.request("https://alejwang.pythonanywhere.com/events", method: .get).responseJSON { response in
//            if let json = response.result.value as? [String: AnyObject] {
//                var eventsToReturn = [(name: String, description: String, capacity: Int, organizer_id: Int, organizer_name: String, start_time: String, end_time: String, location_id: Int, location_name: String, location_is_armap_available: Bool, is_published: Bool, pub_date: String)]()
//                if let events = json["event_results"] as? [[String: AnyObject]] {
//                    for event in events {
//                        eventsToReturn.append((name: event["name"] as! String,
//                                               description: event["description"] as! String,
//                                               capacity: event["capacity"] as! Int,
//                                               organizer_id: event["organizer_id"] as! Int,
//                                               organizer_name: event["organizer_name"] as! String,
//                                               start_time: event["start_time"] as! String,
//                                               end_time: event["end_time"] as! String,
//                                               location_id: event["location_id"] as! Int,
//                                               location_name: event["location_name"] as! String,
//                                               location_is_armap_available: event["location_is_armap_available"] as! Bool,
//                                               is_published: event["is_published"] as! Bool,
//                                               pub_date: event["pub_date"] as! String ))
//                    }
//                }
//                completion(eventsToReturn)
//            }
//        }
//    }
}
