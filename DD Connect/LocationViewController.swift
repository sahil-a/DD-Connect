//
//  LocationViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/22/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill in all the fields
        descriptionLabel.text = location.description
        addressLabel.text = "Address: \(location.address)"
        hoursLabel.text = "Hours: \(location.hours)"
        titleLabel.text = location.name
        dislikeButton.setTitle("Dislike (\(location.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(location.likes))", for: .normal)
        let firebaseHelper = FirebaseHelper()
        firebaseHelper.download(from: location.imageRef) { image in
            if let image = image {
                self.imageView.image = image
            }
        }
        
        // make disliked and liked labels faded
        dislikeButton.alpha = 0.4
        likeButton.alpha = 0.4
    }
    
    @IBAction func disliked(_ sender: Any) {
        if dislikeButton.alpha == 1 {
            location.dislikes -= 1
            dislikeButton.alpha = 0.4
        } else {
            location.dislikes += 1
            dislikeButton.alpha = 1
            if (likeButton.alpha == 1) {
                location.likes -= 1
                likeButton.alpha = 0.4
            }
        }
        dislikeButton.setTitle("Dislike (\(location.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(location.likes))", for: .normal)
        location.updateLikes()
    }
    
    @IBAction func liked(_ sender: Any) {
        if likeButton.alpha == 1 {
            location.likes -= 1
            likeButton.alpha = 0.4
        } else {
            location.likes += 1
            likeButton.alpha = 1
            if (dislikeButton.alpha == 1) {
                location.dislikes -= 1
                dislikeButton.alpha = 0.4
            }
        }
        dislikeButton.setTitle("Dislike (\(location.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(location.likes))", for: .normal)
        location.updateLikes()
    }
    
    @IBAction func writeReview(_ sender: Any) {
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
