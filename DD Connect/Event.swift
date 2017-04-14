//
//  Event.swift
//  Discovery District: Connect
//
//  Created by Sahil Ambardekar on 3/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation

struct Event {
    let name: String
    let address: String
    let date: String
    let description: String
    let likes: Int
    let dislikes: Int
    let rsvpEmail: String
    let imageRef: String
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
}
