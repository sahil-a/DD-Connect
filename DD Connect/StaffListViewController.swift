//
//  StaffListViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/23/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit

class StaffListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var officials: [Official] = []
    var emailField: CustomTextField!
    var phoneField: CustomTextField!
    var appDelegate: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let helper = FirebaseHelper()
        helper.getOfficials { officials in
            if let officials = officials {
                self.officials = officials
                self.collectionView.reloadData()
            }
        }
        emailField = CustomTextField.instanceFromNib()
        emailField.frame = CGRect(x: 15, y: 145, width: view.frame.width - 30, height: 35)
        emailField.textField.placeholder = "Your Email"
        emailField.text = appDelegate.currentOfficial.email ?? ""
        view.addSubview(emailField)
        phoneField = CustomTextField.instanceFromNib()
        phoneField.frame = CGRect(x: 15, y: 190, width: view.frame.width - 30, height: 35)
        phoneField.textField.placeholder = "Your Phone"
        phoneField.textField.keyboardType = .numberPad
        phoneField.text = appDelegate.currentOfficial.phone ?? ""
        view.addSubview(phoneField)
    }
    
    @IBAction func back() {
        dismiss(animated: true)
        let email = emailField.text
        if email.contains("@") {
            self.appDelegate.currentOfficial.email = email
        }
        let phone = phoneField.text
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        if phone.characters.count >= 9 && phone.characters.reduce(true) { !alphabet.contains("\($1)") && $0 } {
            self.appDelegate.currentOfficial.phone = phone
        }
        self.appDelegate.currentOfficial.updateContactDetails()
    }
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return officials.count
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
        let label = UILabel(frame: CGRect(x: 25, y: -8, width: cell.frame.width * 0.6 , height: cell.frame.height))
        label.font = label.font.withSize(16)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.text = officials[indexPath.row].name
        cell.addSubview(label)
        let secondaryLabel = UILabel(frame: CGRect(x: 25, y: 12, width: cell.frame.width * 0.6, height: cell.frame.height))
        secondaryLabel.font = secondaryLabel.font.withSize(13.5)
        secondaryLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        secondaryLabel.text = officials[indexPath.row].position
        secondaryLabel.numberOfLines = 6
        cell.addSubview(secondaryLabel)
        var i = 1
        if let _ = officials[indexPath.row].email {
            let emailButton = UIButton(frame: CGRect(x: -15 + width - 50 * CGFloat(i), y: (height - 40) / 2, width: 40, height: 40))
            emailButton.setImage(#imageLiteral(resourceName: "Email"), for: .normal)
            emailButton.tag = indexPath.row
            emailButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            emailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
            emailButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
            emailButton.addTarget(self, action: #selector(ContactViewController.email), for: .touchUpInside)
            cell.addSubview(emailButton)
            i += 1
        }
        if let _ = officials[indexPath.row].phone {
            let phoneButton = UIButton(frame: CGRect(x: -15 + width - 50 * CGFloat(i), y: (height - 40) / 2, width: 40, height: 40))
            phoneButton.setImage(#imageLiteral(resourceName: "Phone"), for: .normal)
            phoneButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
            phoneButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
            phoneButton.tag = indexPath.row
            phoneButton.addTarget(self, action: #selector(ContactViewController.call), for: .touchUpInside)
            cell.addSubview(phoneButton)
        }
        return cell
    }
    
    func email(sender: UIButton) {
        let email = officials[sender.tag].email!
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func call(sender: UIButton) {
        let phone = officials[sender.tag].phone!
        if let url = URL(string: "tel:\(phone)") {
            UIApplication.shared.open(url)
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

