//
//  Event.swift
//  Discovery District: Connect
//
//  Created by Sahil Ambardekar on 3/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Event {
    let name: String
    let address: String
    let date: String
    let description: String
    var likes: Int
    var dislikes: Int
    let rsvpEmail: String
    let imageRef: String
    let thumbnailRef: String
    var popularity: Int {
        get {
            let dLikes = likes - dislikes
            switch dLikes {
            case let x where x <= 0:
                return 1
            case let x where x < 2:
                return 2
            default:
                return 3
            }
        }
    }
    func updateLikes() {
        let root: FIRDatabaseReference = FIRDatabase.database().reference()
        root.child("events/\(name)/likes").setValue(likes)
        root.child("events/\(name)/dislikes").setValue(dislikes)
    }
}
