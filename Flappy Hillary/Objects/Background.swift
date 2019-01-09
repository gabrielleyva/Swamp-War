//
//  BackGround.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/29/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode {
    
    var background = [SKSpriteNode]()
    
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
    
    func prepare(width: CGFloat, height: CGFloat) {
        
        let texture = SKTexture(image:#imageLiteral(resourceName: "background"))
        
        let background1 = SKSpriteNode(texture: texture)
        background1.anchorPoint = .zero
        background1.size = CGSize(width: texture.size().width, height: height)
        background1.position = CGPoint(x: 0, y: 72)
        background1.zPosition = -15
        background.append(background1)
        
        let background2 = SKSpriteNode(texture: texture)
        background2.anchorPoint = .zero
        background2.size = CGSize(width: texture.size().width, height: height)
        background2.position = CGPoint(x: background1.size.width - 1, y: 72)
        background2.zPosition = -15
        background.append(background2)
        
    }
    
    func moveBackground() {
        background[0].position = CGPoint(x: background[0].position.x-1, y: background[0].position.y)
        background[1].position = CGPoint(x: background[1].position.x-1, y: background[1].position.y)
        
        if (background[0].position.x  < -background[0].size.width) {
            background[0].position = CGPoint(x: background[1].position.x + background[1].size.width, y: background[0].position.y)
        }
        
        if (background[1].position.x  < -background[1].size.width) {
            background[1].position = CGPoint(x: background[0].position.x + background[0].size.width, y: background[1].position.y)
        }
    }
}
