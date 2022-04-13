//
//  GameScene.swift
//  OrangeTree
//
//  Created by Victoria Treue on 11/8/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    var boundary = SKNode()
    var numberOfLevels: UInt32 = 4
    
    
    // Load .sks Game Level Scenes
    static func load(level: Int) -> GameScene? {
        return GameScene(fileNamed: "Level-\(level)")
    }
    
    
    // Acts like the viewDidLoad in Apps (delelegate and basic view set ups come here)
    override func didMove(to view: SKView) {
        orangeTree = childNode(withName: "tree") as? SKSpriteNode
        
        // Set contact delegate
        physicsWorld.contactDelegate = self
        
        // Configure Shape Node
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        // Set up the boundaries equal to game boundaries
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        boundary.position = .zero
        addChild(boundary)
        
        // Add Sun Button to screen (to change levels randomly)
        let sun = SKSpriteNode(imageNamed: "Sun")
        sun.name = "sun"
        sun.position.x = size.width - (sun.size.width * 1.5)
        sun.position.y = size.height - (sun.size.height * 0.75)
        addChild(sun)
    }
    
    
    // MARK: - Flying Fruit Implementation
    
    // First Touch on Orange Tree
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the location of the touch on the screen
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Check if the touch was on the orange tree
        if atPoint(location).name == "tree" {
            
            // Create the orange and add it to the scene at the touch location
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            // Store the location of the touch
            touchStart = location
        }
        
        // Check wether the sun was tapped and change the level
        for node in nodes(at: location) {
            if node.name == "sun" {

                let n = Int( arc4random() % numberOfLevels + 1)
                if let scene = GameScene.load(level: n) {
                    scene.scaleMode = .aspectFill
                    if let view = view { view.presentScene(scene) }
                }
            }
        }
        
    }
    
    
    // Following function allows user to drag orange back (like AngryBirds)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the location of the touch on the screen
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Update the position of the orange tree to the current location
        orange?.position = location
        
        // Draw the firing vector
        let path = UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        shapeNode.path = path.cgPath
    }
    
    
    // When user stops moving finger and lets go of the orange - > orange should start flying
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the location of the touch on the screen
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Get the differe between the start and end point as a vector
        let differenceX = (touchStart.x - location.x) * 0.5
        let differenceY = (touchStart.y - location.y) * 0.5
        let vector = CGVector(dx: differenceX, dy: differenceY)
        
        // Set the orange dynamic again and apply the vector as an impulse
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        
        // Remove the path from shapeNode
        shapeNode.path = nil
    }
}


// MARK: - Extension: Skull Interaction

extension GameScene: SKPhysicsContactDelegate {
    
    // Called when the physicsWorld detects two nodes colliding
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        // Check that the bodies collieded hard enough
        if contact.collisionImpulse > 20 {
            if nodeA?.name == "skull" {
                // Remove skull from screen
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                // Remove skull from screen
                removeSkull(node: nodeB!)
            }
        }
    }
    
    // Remove object from screen (in this case, our skull object)
    func removeSkull (node: SKNode) {
        node.removeFromParent()
    }
}
