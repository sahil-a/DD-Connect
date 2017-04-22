//
//  CurrentHelper.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/22/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation
import Alamofire

class CurrentHelper {
    private let uaaURL = "https://8553482c-1d32-4d38-8597-2e56ab642dd3.predix-uaa.run.asv-pr.ice.predix.io/oauth/token"
    private let eventsURL = "https://ie-cities-events.run.asv-pr-pub.ice.predix.io/v2"
    private let envZoneID = "ics-IE-ENVIRONMENTAL"
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        Alamofire.request(uaaURL,
                          parameters: ["grant_type": "client_credentials"],
                          headers: ["Authorization": "Basic aGFja2F0aG9uOkBoYWNrYXRob24="]
            ).responseJSON { response in
                if let dict = response.result.value as? [String: Any] {
                    completion(dict["access_token"] as? String)
                } else {
                    completion(nil)
                }
        }
    }
    
    func getLatestTemperatureMeasures(accessToken: String, completion: @escaping (TemperatureMeasures?) -> Void) {
        Alamofire.request("\(eventsURL)/assets/ENV-STG-HYP1062-internal/events",
            parameters: ["eventType": "TEMPERATURE",
                         "startTime": "1490911237353",
                         "endTime": "\(Int(Date().timeIntervalSince1970) * 1000)"],
            headers: ["Authorization": "Bearer \(accessToken)",
                "Predix-Zone-Id": envZoneID]).responseJSON { response in
                    if let data = response.result.value as? [String: Any] {
                        if let content = data["content"] as? [[String: Any]] {
                            guard content.count > 0 else {
                                completion(nil)
                                return
                            }
                            if let measuresData = content.last!["measures"] as? [String: Int] {
                                func toFahrenheit(_ t: Int) -> Int {
                                    return Int(Double(t) * 0.1 * 9 / 5 - 459.67)
                                }
                                let max = toFahrenheit(measuresData["max"]!)
                                let min = toFahrenheit(measuresData["min"]!)
                                let mean = toFahrenheit(measuresData["mean"]!)
                                let measures = TemperatureMeasures(max: max, min: min, mean: mean)
                                completion(measures)
                            }
                        }
                    } else {
                        completion(nil)
                    }
        }
    }
    
    // returns latest humidity as a value from 0...1 where 1+ is the most humid
    func getLatestHumidity(accessToken: String, completion: @escaping (Double?) -> Void) {
        Alamofire.request("\(eventsURL)/assets/ENV-STG-HYP1062-internal/events",
            parameters: ["eventType": "HUMIDITY",
                         "startTime": "1490911237353",
                         "endTime": "\(Int(Date().timeIntervalSince1970) * 1000)"],
            headers: ["Authorization": "Bearer \(accessToken)",
                "Predix-Zone-Id": envZoneID]).responseJSON { response in
                    if let data = response.result.value as? [String: Any] {
                        if let content = data["content"] as? [[String: Any]] {
                            guard content.count > 0 else {
                                completion(nil)
                                return
                            }
                            if let measuresData = content.last!["measures"] as? [String: Int] {
                                completion(Double(measuresData["mean"]!) * 0.01 / 450)
                                // this method returns the relative humidity (pa water vapor) / (saturated pa water vapor)
                                // the current API only returns the (pa water vapor) and 
                                // it is divided by 450, the (saturated pa water vapor) [at 20 degrees fahrenheit]
                                // TODO: use temperature to adjust the saturated pa water vapor
                            }
                        }
                    } else {
                        completion(nil)
                    }
        }
    }

}
