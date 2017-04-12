//
//  HeaderView.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/10/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        layer.cornerRadius = 30
    }
}
