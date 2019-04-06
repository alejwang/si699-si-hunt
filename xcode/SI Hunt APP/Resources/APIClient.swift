
//
//  APIClient.swift
//  Event FInder
//
//  Created by Alejandro Wang on 2/26/19.
//  Copyright © 2019 Alejandro Wang. All rights reserved.
//

import Foundation
import Alamofire


class APIClient {
    static func register(withUsername username: String, password: String, completion: @escaping () -> Void) {
        print("Sending request")
        let parameters: Parameters = ["username": username, "password": password]
        Alamofire.request("https://alejwang.pythonanywhere.com/register", method: .post, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
        completion()
    }
    
    static func login(withUsername username: String, password: String, completion: @escaping () -> Void) {
        print("> Sending login request")
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
