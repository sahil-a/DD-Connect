//
//  Location.swift
//  Discovery District: Connect
//
//  Created by Sahil Ambardekar on 3/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation

struct Location {
    let name: String
    let address: String
    let description: String
    let likes: Int
    let dislikes: Int
    let category: LocationType
    let reviews: [Review]
}

enum LocationType: String {
    case Shopping
    case Food
    case Sightseeing
}
