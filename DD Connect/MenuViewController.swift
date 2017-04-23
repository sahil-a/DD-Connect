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
            // TODO: remove these stats once development is complete
            view.showsFPS = true
            view.showsNodeCount = true
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
            let available = ["Report"]
            switch title {
            case let x where available.contains(x):
                performSegue(withIdentifier: x, sender: self)
            default:
                break
            }
        }
    }
    
    @IBAction func firstLogoClicked() {
        let modes: [Mode] = [.Information, .Hero, .Staff]
        let currentIndex = modes.index(of: mode)!
        let nextIndex = (currentIndex + 1) % 3
        let firstIndex = (nextIndex + 1) % 3
        let secondIndex = (firstIndex + 1) % 3
        ((view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
        firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
        secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
        mode = modes[nextIndex]
        disableModeSwitching()
    }
    
    @IBAction func secondLogoClicked() {
        let modes: [Mode] = [.Information, .Hero, .Staff]
        let currentIndex = modes.index(of: mode)!
        let nextIndex = (currentIndex + 2) % 3
        let firstIndex = (nextIndex + 1) % 3
        let secondIndex = (firstIndex + 1) % 3
        ((view as! SKView).scene as! MenuScene).switchMode(to: modes[nextIndex])
        firstLogo.setImage(UIImage(named: modes[firstIndex].rawValue), for: .normal)
        secondLogo.setImage(UIImage(named: modes[secondIndex].rawValue), for: .normal)
        mode = modes[nextIndex]
        disableModeSwitching()
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
    case Information = "DD Logo"
    case Hero = "DD Logo Red"
    case Staff = "DD Logo Green"
}
