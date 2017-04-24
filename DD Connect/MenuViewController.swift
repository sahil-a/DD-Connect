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
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
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
    
    func move(_ steps: Int) {
        let modes: [Mode] = [.Information, .Hero, .Staff]
        let currentIndex = modes.index(of: mode)!
        let nextIndex = (currentIndex + steps) % 3
        if modes[nextIndex] == .Staff {
            let alertVC = UIAlertController(title: "Staff Authentication", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                let usernameField = alertVC.textFields![0]
                let passwordField = alertVC.textFields![1]
                let helper = FirebaseHelper()
                helper.checkStaffLogin(username: usernameField.text!, password: passwordField.text!) { success, official in
                    if success {
                        let firstIndex = (nextIndex + 1) % 3
                        let secondIndex = (firstIndex + 1) % 3
                        ((self.view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
                        self.firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
                        self.secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
                        self.mode = modes[nextIndex]
                        self.disableModeSwitching()
                        (UIApplication.shared.delegate as! AppDelegate).currentOfficial = official!
                    } else {
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
            let firstIndex = (nextIndex + 1) % 3
            let secondIndex = (firstIndex + 1) % 3
            ((view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
            firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
            secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
            mode = modes[nextIndex]
            disableModeSwitching()
        }
    }
    
    func disableModeSwitching() {
        firstLogo.isEnabled = false
        secondLogo.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.firstLogo.isEnabled = true
            self.secondLogo.isEnabled = true
        })
    }
}


enum Mode: String {
    case Information = "DD Logo Blue"
    case Hero = "DD Logo Red"
    case Staff = "DD Logo Green"
}
