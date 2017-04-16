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
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.17
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
}
