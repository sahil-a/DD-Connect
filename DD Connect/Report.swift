//
//  Report.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import Foundation
import UIKit

struct Report {
    let image: UIImage?
    let imageRef: String?
    let body: String
    let title: String
    let type: ReportType
}

enum ReportType: String {
    case Graffiti = "graffiti"
    case Homeless = "homelessness"
    case General = "other"
    case Crime = "crime"
}
