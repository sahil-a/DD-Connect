//
//  Report.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Report {
    let image: UIImage?
    let imageRef: String?
    let body: String
    let title: String
    let type: ReportType
    
    func delete() {
        let root: FIRDatabaseReference = FIRDatabase.database().reference()
        root.child("reports").child(title).removeValue()
    }
}

enum ReportType: String {
    case Graffiti = "graffiti"
    case Homeless = "homelessness"
    case General = "other"
    case Crime = "crime"
}
