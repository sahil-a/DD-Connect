//
//  ReportViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    private var reportType: ReportType!
    
    @IBAction func reportGraffiti() {
        reportType = .Graffiti
        performSegue(withIdentifier: "write", sender: self)
    }
    
    @IBAction func reportCrime() {
        reportType = .Crime
        performSegue(withIdentifier: "write", sender: self)
    }
    
    @IBAction func reportHomeless() {
        reportType = .Homeless
        performSegue(withIdentifier: "write", sender: self)
    }
    
    @IBAction func reportGeneral() {
        reportType = .General
        performSegue(withIdentifier: "write", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "write" {
            let toVC = segue.destination as! WriteReportViewController
            toVC.reportType = reportType
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}
