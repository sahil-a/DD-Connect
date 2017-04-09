//
//  FirebaseHelper.swift
//  Discovery District: Connect
//
//  Created by Sahil Ambardekar on 3/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FirebaseHelper {
    var root: FIRDatabaseReference!
    init() {
        root = FIRDatabase.database().reference()
    }
    
    func getEvents(_ completion: @escaping ([Event]?) -> Void) {
        root.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            if let rawEvents = (snapshot.value as? [String: [String: Any]]) {
                var events = [Event]()
                for (name, rawEvent) in rawEvents {
                    let event = Event(name: name,
                                      address: rawEvent["address"] as! String,
                                      date: rawEvent["date"] as! String,
                                      description: rawEvent["description"] as! String,
                                      likes: rawEvent["likes"] as! Int,
                                      dislikes: rawEvent["dislikes"] as! Int,
                                      rsvpEmail: rawEvent["rsvpEmail"] as! String)
                    events.append(event)
                }
                completion(events)
            }
        }) { (_) in
            completion(nil)
        }
    }
    
    func getLocations(_ completion: @escaping ([Location]?) -> Void) {
        root.child("locations").observeSingleEvent(of: .value, with: { (snapshot) in
            if let rawLocations = (snapshot.value as? [String: [String: Any]]) {
                var locations = [Location]()
                for (name, rawLocation) in rawLocations {
                    var reviews = [Review]()
                    let rawReviews = (rawLocation["reviews"] as? [String: [String: Any]]) ?? [:]
                    for (title, rawReview) in rawReviews {
                        let review = Review(title: title,
                                            body: rawReview["body"] as! String,
                                            name: rawReview["name"] as! String,
                                            stars: rawReview["stars"] as! Int)
                        reviews.append(review)
                    }
                    let location = Location(name: name,
                                            address: rawLocation["address"] as! String,
                                            description: rawLocation["description"] as! String,
                                            likes: rawLocation["likes"] as! Int,
                                            dislikes: rawLocation["dislikes"] as! Int,
                                            category: LocationType(rawValue: rawLocation["category"] as! String)! ,
                                            reviews: reviews)
                    locations.append(location)
                }
                completion(locations)
            }
        }) { (_) in
            completion(nil)
        }
    }
}

