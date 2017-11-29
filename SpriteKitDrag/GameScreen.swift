//
//  GameScreen.swift
//  SpriteKitDrag
//
//  Created by Aytekin Meral on 29/11/2017.
//  Copyright © 2017 com.aytek. All rights reserved.
//

import UIKit
import SpriteKit


struct PhysicsCategory {
    static let none : UInt32 = 0x1 << 1
    static let boundary : UInt32 = 0x1 << 2
    static let box : UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let kNodeName = "movable"
    
    var nodeMove:SKSpriteNode?
    var lastPoint:CGPoint?
    var nodes:[SKSpriteNode] = []
    var canUpdate = false
    var nodeDragAnchor:CGPoint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = .blue
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.boundary
        physicsBody?.collisionBitMask = PhysicsCategory.boundary
        physicsBody?.restitution = 0
        
        let boundary = SKSpriteNode(color: .green, size: CGSize(width: 200, height: 20))
        boundary.position = CGPoint(x: size.width/2 , y:size.height/2)
        self.addChild(boundary)
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.frame.size)
        boundary.physicsBody?.restitution = 0
        boundary.physicsBody?.isDynamic = false
        boundary.physicsBody!.categoryBitMask = PhysicsCategory.box
        boundary.physicsBody!.contactTestBitMask = PhysicsCategory.boundary
        boundary.physicsBody!.collisionBitMask = PhysicsCategory.boundary | PhysicsCategory.box
        
        for i in 0 ... 10 {
            
            let node = SKSpriteNode(color: generateRandomPastelColor(), size: CGSize(width: 20, height: 20))
            node.name = kNodeName
            nodes.append(node)
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = true
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.restitution = 0
            node.physicsBody?.usesPreciseCollisionDetection = true
            node.physicsBody!.categoryBitMask = PhysicsCategory.box
            node.physicsBody!.contactTestBitMask = PhysicsCategory.box
            node.physicsBody!.collisionBitMask = PhysicsCategory.boundary | PhysicsCategory.box
            
            node.position = CGPoint(x: CGFloat(i) * 30 , y:100)
            
            self.addChild(node)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            let location = touch.location(in:self)
            let node: SKNode? = atPoint(location)
            
            
            if let nodeName = node?.name {
                nodeDragAnchor = touch.location(in:node!)
                if nodeName == kNodeName {
                    
                    canUpdate = true
                    nodeMove = node as? SKSpriteNode
                    lastPoint = location
                }
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: UITouch in touches {
            let location = touch.location(in:self)
            canUpdate = true
            
            if lastPoint != nil {
                lastPoint = location
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        canUpdate = false
        nodeDragAnchor = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        nodeDragAnchor = nil
        canUpdate = false
        for node in nodes {
            node.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        nodeMove = nil
        lastPoint = nil
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if canUpdate {
            if let node = nodeMove {
                if let point = lastPoint {
                    if let anchor = nodeDragAnchor {
                        
                        let vector = CGVector(dx: (point.x - node.position.x - anchor.x) * 20, dy:(point.y - node.position.y - anchor.y)  * 20)
                        node.physicsBody?.velocity = vector
                    }
                }
            }
        }
    }
    
    
    //////
    
    func didEnd(_ contact: SKPhysicsContact) {
        contact.bodyA.velocity = CGVector(dx: 0, dy: 0)
        contact.bodyB.velocity = CGVector(dx: 0, dy: 0)
    }
    
    
    func generateRandomPastelColor() -> UIColor {
        
        let randomColorGenerator = { ()-> CGFloat in
            let c = arc4random() % 156 + 100
            return CGFloat(c) / 256
        }
        
        let red: CGFloat = randomColorGenerator()
        let green: CGFloat = randomColorGenerator()
        let blue: CGFloat = randomColorGenerator()
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}



