//
//  LocationsViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/10/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    private var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let helper = FirebaseHelper()
        helper.getLocations { (locations) in
            if let locations = locations {
                self.locations = locations
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
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
        let label = UILabel(frame: CGRect(x: 80, y: -7, width: cell.frame.width - 20 , height: cell.frame.height))
        label.font = label.font.withSize(16)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.text = locations[indexPath.row].name
        cell.addSubview(label)
        let secondaryLabel = UILabel(frame: CGRect(x: 80, y: 11, width: cell.frame.width - 20 - size.height - 70, height: cell.frame.height))
        secondaryLabel.font = secondaryLabel.font.withSize(12)
        secondaryLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        secondaryLabel.text = locations[indexPath.row].description
        cell.addSubview(secondaryLabel)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.height, height: size.height))
        imageView.layer.cornerRadius = size.height / 2
        imageView.layer.masksToBounds = true
        cell.addSubview(imageView)
        let helper = FirebaseHelper()
        helper.download(from: locations[indexPath.row].imageRef) { (image) in
            if let image = image {
                imageView.image = image
            }
        }
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
