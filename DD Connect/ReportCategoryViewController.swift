//
//  ReportCategoryViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class ReportCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReportDeleteObserver {

    var reportType: ReportType!
    var selectedReport: Report!
    private var reports: [Report] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load reports from firebase
        let firebaseHelper = FirebaseHelper()
        firebaseHelper.getReports { reports in
            if let reports = reports {
                self.reports = reports.filter { $0.type == self.reportType }
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func didDeleteReport(report: Report) {
        reports = reports.filter { $0.title != report.title }
        collectionView.reloadData()
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reports.count    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let width = collectionView.frame.width - 30
        let height: CGFloat = 66
        let size = CGSize(width: width, height: height)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.frame.size = size
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowOpacity = 0.17
        cell.layer.shadowRadius = 3
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.masksToBounds = false
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        label.font = label.font.withSize(16)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.text = reports[indexPath.row].title
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 7, bottom: 20, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedReport = reports[indexPath.row]
        performSegue(withIdentifier: "report", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "report" {
            let toVC = segue.destination as! ViewReportViewController
            toVC.report = selectedReport
            toVC.deleteObserver = self
        }
    }
    
}

protocol ReportDeleteObserver {
    func didDeleteReport(report: Report)
}


