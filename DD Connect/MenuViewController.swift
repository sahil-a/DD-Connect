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
    
    private var inInformationMode: Bool = true

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
        if inInformationMode {
            switch title {
            case "Locations":
                performSegue(withIdentifier: "Locations", sender: self)
            default:
                break
            }
        }
    }
}
