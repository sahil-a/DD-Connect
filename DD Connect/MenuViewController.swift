//
//  GameViewController.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/9/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CryptoSwift

class MenuViewController: UIViewController, MenuSceneDelegate {
    
    var mode: Mode = .Information
    @IBOutlet weak var firstLogo: UIButton!
    @IBOutlet weak var secondLogo: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene") as? MenuScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.menuDelegate = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Menu Delegate
    func didClickMenuItem(title: String) {
        // find the correct segue for the current mode and execute it
        if mode == .Information {
            let available = ["Locations", "City Status", "Events"]
            switch title {
            case let x where available.contains(x):
                performSegue(withIdentifier: x, sender: self)
            default:
                break
            }
        } else if mode == .Hero {
            let available = ["Report", "Contact"]
            switch title {
            case let x where available.contains(x):
                performSegue(withIdentifier: x, sender: self)
            default:
                break
            }
        } else if mode == .Staff {
            let available = ["Staff List", "Reports", "Announcements"]
            switch title {
            case let x where available.contains(x):
                performSegue(withIdentifier: x, sender: self)
            default:
                break
            }
        }
    }
    
    @IBAction func firstLogoClicked() {
        move(1)
    }
    
    @IBAction func secondLogoClicked() {
        move(2)
    }
    
    // a function that moves the menu order by a certain number of steps
    // the starting order is information, hero, staff
    func move(_ steps: Int) {
        let modes: [Mode] = [.Information, .Hero, .Staff]
        let currentIndex = modes.index(of: mode)!
        let nextIndex = (currentIndex + steps) % 3
        
        // the staff mode needs authentication
        if modes[nextIndex] == .Staff {
            
            // authenticate with an alert with two fields
            let alertVC = UIAlertController(title: "Staff Authentication", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                let usernameField = alertVC.textFields![0]
                let passwordField = alertVC.textFields![1]
                let helper = FirebaseHelper()
                // check with hashed password on database
                helper.checkStaffLogin(username: usernameField.text!, password: passwordField.text!) { success, official in
                    if success {
                        // switch the mode
                        let firstIndex = (nextIndex + 1) % 3
                        let secondIndex = (firstIndex + 1) % 3
                        ((self.view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
                        self.firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
                        self.secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
                        self.mode = modes[nextIndex]
                        // disable mode switching until the animation is complete
                        self.disableModeSwitching()
                        // save the authenticated official
                        (UIApplication.shared.delegate as! AppDelegate).currentOfficial = official!
                    } else {
                        // alert the user that the credentials were incorrect
                        let wrongAlert = UIAlertController(title: "Incorrect Credentials", message: "Your credentials do not match any registered users. If you have forgotten your credentials please contact your supervisor", preferredStyle: .alert)
                        wrongAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(wrongAlert, animated: true)
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertVC.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Username"
            }
            alertVC.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Password"
            }
            
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true)
        } else {
            // switch the mode
            let firstIndex = (nextIndex + 1) % 3
            let secondIndex = (firstIndex + 1) % 3
            ((view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
            firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
            secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
            mode = modes[nextIndex]
            // disable mode switching until the animation is complete
            disableModeSwitching()
        }
    }
    
    func disableModeSwitching() {
        // disable other mode buttons for 4 seconds (the duration of the mode switching animation)
        firstLogo.isEnabled = false
        secondLogo.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.firstLogo.isEnabled = true
            self.secondLogo.isEnabled = true
        })
    }
}

// the raw string value is the logo for each mode
enum Mode: String {
    case Information = "DD Logo Blue"
    case Hero = "DD Logo Red"
    case Staff = "DD Logo Green"
}
