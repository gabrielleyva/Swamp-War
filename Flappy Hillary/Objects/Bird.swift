//
//  Bird.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/18/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import Foundation
import SpriteKit

class Bird: SKSpriteNode {
    
    var animationTextures: [SKTexture]?
    var birdIsActive = false
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    convenience init(color: SKColor, length: CGFloat) {
        let size = CGSize(width: length, height: length)
        self.init(texture:nil, color: color, size: size)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func prepareBirdPhysics(view: UIView) {
        
        let subtraction = getSizeBasedOnDevice(view: view, normalSize: 5)
        print ("SUbtraction: ", subtraction)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - subtraction, height: self.size.height - subtraction))
        
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.restitution = 0
        
        if view.frame.size.height < 667 {
        self.physicsBody?.density = 1.5
        } else {
            self.physicsBody?.density = 1.0
        }
        
        
        self.physicsBody?.categoryBitMask = birdCategory
        self.physicsBody?.contactTestBitMask = pipeCategory
        
        birdIsActive = true
    }
}
