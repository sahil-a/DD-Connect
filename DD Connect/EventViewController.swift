//
//  EventViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/22/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

import UIKit

class EventViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill in all the fields
        descriptionLabel.text = event.description
        addressLabel.text = "Address: \(event.address)"
        dateLabel.text = "Date: \(event.date)"
        titleLabel.text = event.name
        dislikeButton.setTitle("Dislike (\(event.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(event.likes))", for: .normal)
        let firebaseHelper = FirebaseHelper()
        firebaseHelper.download(from: event.imageRef) { image in
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
            event.dislikes -= 1
            dislikeButton.alpha = 0.4
        } else {
            event.dislikes += 1
            dislikeButton.alpha = 1
            if (likeButton.alpha == 1) {
                event.likes -= 1
                likeButton.alpha = 0.4
            }
        }
        dislikeButton.setTitle("Dislike (\(event.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(event.likes))", for: .normal)
        event.updateLikes()
    }
    
    @IBAction func liked(_ sender: Any) {
        if likeButton.alpha == 1 {
            event.likes -= 1
            likeButton.alpha = 0.4
        } else {
            event.likes += 1
            likeButton.alpha = 1
            if (dislikeButton.alpha == 1) {
                event.dislikes -= 1
                dislikeButton.alpha = 0.4
            }
        }
        dislikeButton.setTitle("Dislike (\(event.dislikes))", for: .normal)
        likeButton.setTitle("Like (\(event.likes))", for: .normal)
        event.updateLikes()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
