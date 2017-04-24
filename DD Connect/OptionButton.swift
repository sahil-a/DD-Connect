//
//  OptionButton.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class OptionButton: UIButton {
    
    var arrowImageView: UIImageView!
 
    override func didMoveToSuperview() {
        if arrowImageView == nil {
            arrowImageView = UIImageView(frame: CGRect(x: frame.width - 27, y: frame.height / 2 - (11 / 2), width: 7, height: 11))
            arrowImageView.image = #imageLiteral(resourceName: "arrow")
            addSubview(arrowImageView)
        }
        layer.shadowPath = CGPath(roundedRect: bounds, cornerWidth: frame.height / 2, cornerHeight: frame.height / 2, transform: nil)
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = false
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.17
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        backgroundColor = UIColor.white
    }
}
