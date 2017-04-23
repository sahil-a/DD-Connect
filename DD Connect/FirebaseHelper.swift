//
//  FirebaseHelper.swift
//  Discovery District: Connect
//
//  Created by Sahil Ambardekar on 3/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
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
                                      rsvpEmail: rawEvent["rsvpEmail"] as! String,
                                      imageRef: rawEvent["imageRef"] as! String,
                                      thumbnailRef: rawEvent["thumbnailRef"] as! String)
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
                                            category: LocationType(rawValue: rawLocation["category"] as! String)!,
                                            reviews: reviews,
                                            imageRef: rawLocation["imageRef"] as! String,
                                            hours: rawLocation["hours"] as! String,
                                            thumbnailRef: rawLocation["thumbnailRef"] as! String)
                    locations.append(location)
                }
                completion(locations)
            }
        }) { (_) in
            completion(nil)
        }
    }
    
    func getAnnouncements(_ completion: @escaping ([Announcement]?) -> Void) {
        root.child("announcements").observeSingleEvent(of: .value, with: { (snapshot) in
            if let rawAnnouncements = (snapshot.value as? [String: String]) {
                var announcements = [Announcement]()
                for (title, description) in rawAnnouncements {
                    announcements.append(Announcement(title: title, description: description))
                }
                completion(announcements)
            }
        }) { (_) in
            completion(nil)
        }
    }
    
    func upload(image: UIImage, to: String, completion: @escaping (Bool) -> Void) {
        let storage = FIRStorage.storage(url: "gs://dd-connect.appspot.com/")
        let childRef = storage.reference().child(to)
        let _ = childRef.put(UIImageJPEGRepresentation(image, 1)!, metadata: nil) { (meta, error) in
            completion(error == nil)
        }
    }
    
    func download(from: String, completion: @escaping (UIImage?) -> Void) {
        let storage = FIRStorage.storage(url: "gs://dd-connect.appspot.com/")
        let childRef = storage.reference().child(from)
        // max size is 15MB
        childRef.data(withMaxSize: 15 * 1024 * 1024) { data, error in
            if error != nil {
                completion(nil)
            } else {
                let image = UIImage(data: data!)
                completion(image)
            }
        }
    }
    
    func makeReport(report: Report, completion: @escaping (Bool) -> Void) {
        // this function uses fake lag, the report is made in the background
        var data = [
            "body": report.body,
            "type": report.type.rawValue
        ]
        if let image = report.image {
            upload(image: image, to: "\(report.title).jpeg", completion: {_ in})
            data["imageRef"] = "\(report.title).jpeg"
        }
        root.child("reports").child(report.title).setValue(data)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // fake lag
            completion(true)
        })
    }
    
    func getReports(completion: @escaping ([Report]?) -> Void) {
        root.child("reports").observeSingleEvent(of: .value, with: { (snapshot) in
            if let rawReports = (snapshot.value as? [String: [String: String]]) {
                var reports = [Report]()
                for (title, rawReport) in rawReports {
                    let report = Report(image: nil, imageRef: rawReport["imageRef"], body: rawReport["body"]!, title: title, type: ReportType(rawValue: rawReport["imageRef"]!)!)
                    reports.append(report)
                }
                completion(reports)
            }
        }) { (_) in
            completion(nil)
        }
    }
}

