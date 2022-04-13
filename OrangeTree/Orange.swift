//
//  Orange.swift
//  OrangeTree
//
//  Created by Victoria Treue on 11/8/21.
//

import SpriteKit
import Foundation

class Orange: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Orange")
        let size = texture.size()
        let color = UIColor.clear
        
        super.init(texture: texture, color: color, size: size)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init (coder): \(aDecoder) has not not been implemented")
    }
}
