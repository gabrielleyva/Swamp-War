//
//  Floor.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/19/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import Foundation
import SpriteKit

class Floor: SKSpriteNode {
    
    var floor = [SKSpriteNode]()
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(color: SKColor, length: CGFloat) {
        let size = CGSize(width: length, height: length);
        self.init(texture:nil, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareFloor(width: CGFloat) -> SKSpriteNode {
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "floor"))
        
        let floor1 = SKSpriteNode(texture: texture)
        floor1.size = CGSize(width: width, height: 75)
        floor1.anchorPoint = .zero
        floor1.position = CGPoint(x: 0, y: 0)
        floor.append(floor1)
        
        let floor2 = SKSpriteNode(texture: texture)
        floor2.size = CGSize(width: width, height: 75)
        floor2.anchorPoint = .zero
        floor2.position = CGPoint(x: floor1.size.width - 1, y: 0)
        floor.append(floor2)
        
        let dummy = SKSpriteNode()
        dummy.anchorPoint = .zero
        dummy.color = .orange
        dummy.position = CGPoint(x: 0, y: CGFloat(32.5))
        dummy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor1.size.width, height: CGFloat(75)))
        dummy.physicsBody?.isDynamic = false
        dummy.physicsBody?.categoryBitMask = pipeCategory
        dummy.physicsBody?.contactTestBitMask = birdCategory
        
        return dummy
    }
    
    func moveFloor() {
        floor[0].position = CGPoint(x: floor[0].position.x-3, y: floor[0].position.y)
        floor[1].position = CGPoint(x: floor[1].position.x-3, y: floor[1].position.y)
        
        if (floor[0].position.x   < -floor[0].size.width) {
            floor[0].position = CGPoint(x: floor[1].position.x + floor[1].size.width, y: floor[0].position.y)
        }
        
        if (floor[1].position.x  < -floor[1].size.width) {
            floor[1].position = CGPoint(x: floor[0].position.x + floor[0].size.width, y: floor[1].position.y)
        }
    }
}
