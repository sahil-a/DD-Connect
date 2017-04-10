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
    
    override func didMove(to view: SKView) {
        
        // remove gravity and add edge boundary physics body
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // setup center node with physics body
        let centerNodeRadius = frame.width * 0.3
        centerNode = SKShapeNode(circleOfRadius: centerNodeRadius)
        centerNode.fillColor = UIColor(red:0.42, green:0.70, blue:1.00, alpha:1.00)
        centerNode.physicsBody = SKPhysicsBody(circleOfRadius: centerNodeRadius)
        centerNode.physicsBody?.collisionBitMask = 0
        centerNode.physicsBody?.mass = 1
        centerNode.physicsBody?.restitution = 0.75
        centerNode.physicsBody?.isDynamic = false
        addChild(centerNode)
        
       
        let otherNodeRadius = frame.width * 0.15
        let locations = [CGPoint(x: frame.width / 2 - otherNodeRadius - 50, y: otherNodeRadius + 50 - frame.height / 2),
                         CGPoint(x: -frame.width / 2 + otherNodeRadius + 50, y: otherNodeRadius + 50 - frame.height / 2),
                         CGPoint(x: frame.width / 2 - otherNodeRadius - 50, y: -otherNodeRadius - 50 + frame.height / 2),
                         CGPoint(x: -frame.width / 2 + otherNodeRadius + 50, y: -otherNodeRadius - 50 + frame.height / 2)]
        var x = 0
        for location in locations {
            x += 1
            let positiveX = location.x > 0
            let positiveY = location.y > 0
            let otherNode = SKShapeNode(circleOfRadius: otherNodeRadius)
            otherNode.fillColor = UIColor(red:1.00, green:0.65, blue:0.60, alpha:1.00)
            otherNode.physicsBody = SKPhysicsBody(circleOfRadius: otherNodeRadius)
            otherNode.physicsBody?.collisionBitMask = 0
            otherNode.physicsBody?.mass = 1
            otherNode.physicsBody?.restitution = 0.75
            otherNode.name = "otherNode\(x)"
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
        
            let firstLink = getLinkNode(length: linkLength)
            firstLink.position = CGPoint(x: p1.x, y: p1.y)
            firstLink.zRotation = angle
            addChild(firstLink)
            physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: centerNode.physicsBody!, bodyB: firstLink.physicsBody!, anchor: firstLink.position))
            var lastLink: SKNode = firstLink
            for i in 1...links-1 {
                let link = getLinkNode(length: linkLength)
                link.position = CGPoint(x: p1.x + ((positiveX) ? 1 : -1) * CGFloat(i) * linkLength * cos(angle), y: p1.y + ((positiveX) ? 1 : -1) * CGFloat(i) * linkLength * sin(angle))
                link.zRotation = angle
                addChild(link)
                physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: lastLink.physicsBody!, bodyB: link.physicsBody!, anchor: (positiveX) ? link.position : lastLink.position))
                lastLink = link
            }
            physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: lastLink.physicsBody!, bodyB: otherNode.physicsBody!, anchor: p2))
        }
    }
    
    func getLinkNode(length: CGFloat) -> SKShapeNode {
        let linkNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: length, height: 10))
        linkNode.physicsBody = SKPhysicsBody(rectangleOf: linkNode.frame.size)
        linkNode.physicsBody?.collisionBitMask = 0
        linkNode.fillColor = UIColor.gray
        linkNode.physicsBody?.mass = 0.3
        linkNode.zPosition = -10
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
    
    // MARK: Handle Touch Events
    
    func touchDown(atPoint pos : CGPoint) {
        selectedNode = nodes(at: pos).first?.name ?? ""
        selectedLocation = pos
    }
    
    func touchMoved(toPoint pos : CGPoint, touch: UITouch) {
        if (nodes(at: pos).first?.name ?? "-") == selectedNode {
            selectedLocation = pos
        }
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
