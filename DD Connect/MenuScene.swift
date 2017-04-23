//
//  GameScene.swift
//  DD Connect
//
//  Created by Sahil Ambardekar on 4/9/17.
//  Copyright © 2017 DROP TABLE teams;--. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    private var centerNode: SKShapeNode!
    private var selectedNode: String = ""
    private var selectedLocation: CGPoint!
    var menuDelegate: MenuSceneDelegate?
    private var mode: Mode = .Information
    private var staffMenuItems: [String] = []
    private var menuTitles: [String] {
        switch mode {
        case .Information:
            return ["City Status", "Events", "Locations"]
        case .Hero:
            return ["Report", "Contact"]
        case .Staff:
            return staffMenuItems
        }
    }
    
    func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let location = convertPoint(fromView: sender.location(in: view!))
            if let name = nodes(at: location).first?.name {
                menuDelegate?.didClickMenuItem(title: name)
            }
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // remove gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // setup center node with physics body
        let centerNodeRadius = frame.width * 0.3
        let logo = SKTexture(imageNamed: "DD Logo")
        centerNode = SKShapeNode(circleOfRadius: centerNodeRadius)
        centerNode.fillTexture = logo
        centerNode.fillColor = UIColor.white
        centerNode.physicsBody = SKPhysicsBody(circleOfRadius: centerNodeRadius)
        centerNode.physicsBody?.mass = 1
        centerNode.physicsBody?.restitution = 0.75
        centerNode.physicsBody?.isDynamic = false
        centerNode.physicsBody?.categoryBitMask = 0b0001
        addChild(centerNode)
        setupOtherNodes()
    }
    
    func setupOtherNodes() {
        let centerNodeRadius = frame.width * 0.3
        let otherNodeRadius = frame.width * 0.15
        let locations = (menuTitles.count == 3) ? [CGPoint(x: 4, y: otherNodeRadius + 80 - frame.height / 2),
                         CGPoint(x: frame.width / 2 - otherNodeRadius - 50, y: -otherNodeRadius - 80 + frame.height / 2),
                         CGPoint(x: -frame.width / 2 + otherNodeRadius + 50, y: -otherNodeRadius - 80 + frame.height / 2)] : [CGPoint(x: 4, y: otherNodeRadius + 80 - frame.height / 2),
                                                                                                                              CGPoint(x: -4, y: -otherNodeRadius - 80 + frame.height / 2)]
        var x = 0
        for location in locations {
            x += 1
            let name = menuTitles[x-1]
            let positiveX = location.x > 0
            let texture = SKTexture(imageNamed: name)
            let otherNode = SKShapeNode(circleOfRadius: otherNodeRadius)
            otherNode.fillColor = UIColor.white
            otherNode.fillTexture = texture
            otherNode.physicsBody = SKPhysicsBody(circleOfRadius: otherNodeRadius)
            otherNode.physicsBody?.collisionBitMask = 0b0001
            otherNode.physicsBody?.mass = 1
            otherNode.physicsBody?.restitution = 0.75
            otherNode.name = menuTitles[x-1]
            otherNode.physicsBody?.linearDamping = 6
            otherNode.position = location
            
            addChild(otherNode)
            
            let links = 8
            let dx = otherNode.position.x - centerNode.position.x
            let dy = otherNode.position.y - centerNode.position.y
            let slope = dy/dx
            
            var distance = centerNodeRadius - 50
            // this was derived with the distance formula
            // p1 is the point that will link the centerNode to the first link
            var x = ((!positiveX) ? -1 : 1) * distance / sqrt(pow(slope, 2) + 1)
            var y = slope * x
            let p1 = CGPoint(x: x, y: y)
            
            distance = otherNodeRadius - 50
            // the sign is based off of where the two are relative to each other; include if later
            x = (((positiveX) ? -1 : 1) * distance / sqrt(pow(slope, 2) + 1)) + otherNode.position.x
            y = ((positiveX) ? -1 : 1) * slope * (distance / sqrt(pow(slope, 2) + 1)) + otherNode.position.y
            let p2 = CGPoint(x: x, y: y)
            
            distance = p2.distance(from: p1)
            
            let linkLength = distance / CGFloat(links)
            let angle = atan(slope)
            
            let firstLink = getLinkNode(length: linkLength, name: name)
            firstLink.position = CGPoint(x: p1.x, y: p1.y)
            firstLink.zRotation = angle
            addChild(firstLink)
            physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: centerNode.physicsBody!, bodyB: firstLink.physicsBody!, anchor: firstLink.position))
            var lastLink: SKNode = firstLink
            for i in 1...links-1 {
                let link = getLinkNode(length: linkLength, name: name)
                link.position = CGPoint(x: p1.x + ((positiveX) ? 1 : -1) * CGFloat(i) * linkLength * cos(angle), y: p1.y + ((positiveX) ? 1 : -1) * CGFloat(i) * linkLength * sin(angle))
                link.zRotation = angle
                addChild(link)
                physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: lastLink.physicsBody!, bodyB: link.physicsBody!, anchor: (positiveX) ? link.position : lastLink.position))
                lastLink = link
            }
            physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: lastLink.physicsBody!, bodyB: otherNode.physicsBody!, anchor: p2))
        }
    }
    
    func getLinkNode(length: CGFloat, name: String) -> SKShapeNode {
        let linkNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: length, height: 10))
        linkNode.physicsBody = SKPhysicsBody(rectangleOf: linkNode.frame.size)
        linkNode.physicsBody?.collisionBitMask = 0b0000
        linkNode.physicsBody?.categoryBitMask = 0b0010
        linkNode.fillColor = UIColor.gray
        linkNode.physicsBody?.mass = 0.3
        linkNode.zPosition = -10
        linkNode.name = name
        return linkNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if selectedNode != "" {
            let node = childNode(withName: selectedNode)!
            let dx = selectedLocation.x - node.position.x
            let dy = selectedLocation.y - node.position.y
            let dt: CGFloat = 1.0/20.0
            node.physicsBody?.velocity = CGVector(dx: dx/dt, dy: dy/dt)
        }
    }
    
    func switchMode(to: Mode) {
        physicsWorld.removeAllJoints()
        physicsWorld.gravity = CGVector(dx: 0, dy: 30)
        self.centerNode.fillTexture = SKTexture(imageNamed: to.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            for child in (self.scene!.children) {
                if child != self.centerNode {
                    child.removeFromParent()
                }
            }
            self.mode = to
            self.setupOtherNodes()
        })
    }
    
    // MARK: Handle Touch Events
    
    func touchDown(atPoint pos : CGPoint) {
        selectedNode = nodes(at: pos).first?.name ?? ""
        selectedLocation = pos
    }
    
    func touchMoved(toPoint pos : CGPoint, touch: UITouch) {
        selectedLocation = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if selectedNode == "" {
            // check to see if some menu item was selected
        }
        selectedNode = ""
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self), touch: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}

extension CGPoint {
    func distance(from: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - x, 2) + pow(from.y - y, 2))
    }
}

protocol MenuSceneDelegate {
    func didClickMenuItem(title: String)
}
