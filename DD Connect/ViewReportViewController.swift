//
//  ViewReportViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class ViewReportViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reportTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var borderImageView: UIImageView!
    var deleteObserver: ReportDeleteObserver?
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch report.type {
        case .General:
            titleLabel.text = "General Report"
        case .Crime:
            titleLabel.text = "Crime Report"
        case .Homeless:
            titleLabel.text = "Homeless Report"
        case .Graffiti:
            titleLabel.text = "Graffiti Report"
        }
        textView.text = report.body
        reportTitleLabel.text = report.title
        if let imageRef = report.imageRef {
            let helper = FirebaseHelper()
            helper.download(from: imageRef) { image in
                if let image = image {
                    self.imageView.image = image
                    self.borderImageView.isHidden = false
                }
            }
        }
    }

    @IBAction func deleteReport() {
        deleteObserver?.didDeleteReport(report: report)
        report.delete()
        dismiss(animated: true)
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
}
