//
//  ReportCategoriesViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class ReportCategoriesViewController: UIViewController {
    
    var reportType: ReportType!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func graffiti() {
        reportType = .Graffiti
        performSegue(withIdentifier: "selectCategory", sender: self)
    }
    
    @IBAction func crime() {
        reportType = .Crime
        performSegue(withIdentifier: "selectCategory", sender: self)
    }

    @IBAction func homeless() {
        reportType = .Homeless
        performSegue(withIdentifier: "selectCategory", sender: self)
    }
    
    @IBAction func general() {
        reportType = .General
        performSegue(withIdentifier: "selectCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategory" {
            let toVC = segue.destination as! ReportCategoryViewController
            toVC.reportType = reportType
        }
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
}
