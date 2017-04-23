//
//  CityStatusViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/22/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class CityStatusViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var occupancyLabel: UILabel!
    private var announcements: [Announcement] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load all simulated data from current API helper
        let currentHelper = CurrentHelper()
        currentHelper.getAccessToken { (token) in
            guard let token = token else { return }
            currentHelper.getLatestTemperatureMeasures(accessToken: token) { temp in
                if let tempMeasures = temp {
                    self.temperatureLabel.text = "\(tempMeasures.mean)°"
                }
            }
            currentHelper.getLatestHumidity(accessToken: token) { humidity in
                if let humidity = humidity {
                    self.humidityLabel.text = "\(Int(humidity * 100))%"
                }
            }
        }
        
        // load announcements from firebase
        let firebaseHelper = FirebaseHelper()
        firebaseHelper.getAnnouncements { announcements in
            if let announcements = announcements {
                self.announcements = announcements
                self.collectionView.reloadData()
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcements.count    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let width = collectionView.frame.width - 30
        let height: CGFloat = 86
        let size = CGSize(width: width, height: height)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.frame.size = size
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowOpacity = 0.17
        cell.layer.shadowRadius = 3
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.masksToBounds = false
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: cell.frame.width * 0.25 , height: cell.frame.height))
        label.font = label.font.withSize(16)
        label.numberOfLines = 4
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.text = announcements[indexPath.row].title
        cell.addSubview(label)
        let secondaryLabel = UILabel(frame: CGRect(x: cell.frame.width * 0.25 + 25 + 20, y: 0, width: cell.frame.width * 0.75 - 75, height: cell.frame.height))
        secondaryLabel.font = secondaryLabel.font.withSize(13.5)
        secondaryLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        secondaryLabel.text = announcements[indexPath.row].description
        secondaryLabel.numberOfLines = 6
        cell.addSubview(secondaryLabel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 7, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
