//
//  WriteReportViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class WriteReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sideButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var titleField: CustomTextField!
    var reportType: ReportType!
    @IBOutlet weak var titleLabel: UILabel!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField = CustomTextField.instanceFromNib()
        titleField.frame = CGRect(x: 15, y: 145, width: view.frame.width - 30, height: 35)
        titleField.textField.placeholder = "Report Title"
        view.addSubview(titleField)
        switch reportType! {
        case .General:
            titleLabel.text = "Report General"
        case .Crime:
            titleLabel.text = "Report Crime"
        case .Homeless:
            titleLabel.text = "Report Homeless"
        case .Graffiti:
            titleLabel.text = "Report Graffiti"
        }
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary // TODO: set to .camera before testing on real device
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            thumbnailImageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImageView.image = image
        }
        sideButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func sendReport() {
        let image = thumbnailImageView.image
        let report = Report(image: image, imageRef: nil, body: textView.text, title: titleField.text, type: reportType)
        let firebaseHelper = FirebaseHelper()
        firebaseHelper.makeReport(report: report) { success in
            if success {
                let alert = UIAlertController(title: "Report Submitted", message: "Your report was submitted successfully. Thank you for your contribution towards the Discovery District!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (_) in
                    self.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "Your report was not submitted successfully. Please check your internet connection or try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func sideButtonTapped() {
        if thumbnailImageView.image == nil {
            present(imagePicker, animated: true)
        } else {
            thumbnailImageView.image = nil
            sideButton.setImage(#imageLiteral(resourceName: "Attachment"), for: .normal)
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
