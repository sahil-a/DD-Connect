//
//  CustomTextField.swift
//  Scheduling Pro
//
//  Created by Sahil Ambardekar on 1/19/17.
//  Copyright © 2017 sahil. All rights reserved.
//

import UIKit

class CustomTextField: UIView, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editingIndicatorView: UIView!
    var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    let editingColor = UIColor(colorLiteralRed: 152 / 255, green: 226 / 255, blue: 171 / 255, alpha: 1)
    let normalColor = UIColor(colorLiteralRed: 203 / 255, green: 203 / 255, blue: 203 / 255, alpha: 1)
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingIndicatorView.backgroundColor = editingColor
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        editingIndicatorView.backgroundColor = normalColor
    }
    class func instanceFromNib() -> CustomTextField {
        return UINib(nibName: "CustomTextField", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTextField
    }
}
