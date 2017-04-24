//
//  Official.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Official {
    let name: String
    let position: String
    var phone: String?
    var email: String?
    let username: String
    
    func updateContactDetails() {
        let root: FIRDatabaseReference = FIRDatabase.database().reference()
        if let email = email {
            root.child("officials").child(username).child("email").setValue(email)
        }
        if let phone = phone {
            root.child("officials").child(username).child("phone").setValue(phone)
        }
    }
}
