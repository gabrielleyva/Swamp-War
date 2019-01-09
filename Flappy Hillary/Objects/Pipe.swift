//
//  Pipe.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/18/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import Foundation
import SpriteKit

class Pipe: SKSpriteNode {
    
    var moveAndRemovePipes:SKAction?
    var pipePair: SKNode?
    
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
    
    func preparePipePhysics(pipe: SKSpriteNode) -> SKPhysicsBody {
        pipe.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: pipe.size.width / 2 - 20 , y: 0 , width: 40, height: pipe.size.height))
        pipe.physicsBody?.categoryBitMask = pipeCategory
        pipe.physicsBody?.contactTestBitMask = birdCategory
        pipe.physicsBody?.isDynamic = false
        
        return pipe.physicsBody!
        
    }
    
    func getRandomObstacle(height: CGFloat) -> SKSpriteNode {
        var texture = SKTexture()
        let num =  arc4random_uniform(13)
        
        switch num {
        case 0:
            texture = SKTexture(image: #imageLiteral(resourceName: "o1"))
            break
        case 1:
            texture = SKTexture(image: #imageLiteral(resourceName: "o2"))
            break
        case 2:
            texture = SKTexture(image: #imageLiteral(resourceName: "o3"))
            break
        case 3:
            texture = SKTexture(image: #imageLiteral(resourceName: "o4"))
            break
        case 4:
            texture = SKTexture(image: #imageLiteral(resourceName: "o5"))
            break
        case 5:
            texture = SKTexture(image: #imageLiteral(resourceName: "o6"))
            break
        case 6:
            texture = SKTexture(image: #imageLiteral(resourceName: "o7"))
            break
        case 7:
            texture = SKTexture(image: #imageLiteral(resourceName: "o8"))
            break
        case 8:
            texture = SKTexture(image: #imageLiteral(resourceName: "o9"))
            break
        case 9:
            texture = SKTexture(image: #imageLiteral(resourceName: "o10"))
            break
        case 10:
            texture = SKTexture(image: #imageLiteral(resourceName: "o11"))
            break
        case 11:
            texture = SKTexture(image: #imageLiteral(resourceName: "o12"))
            break
        case 12:
            texture = SKTexture(image: #imageLiteral(resourceName: "o13"))
            break
            
        default:
            print("none")
            break
        }
        
        let obstacle = SKSpriteNode(texture: texture)
        obstacle.position = CGPoint(x: 60, y: height)
        obstacle.zPosition = 1
        
        return obstacle
    }
    
    func createPipes(width: CGFloat, height: CGFloat) {
        pipePair = SKNode()
        pipePair?.position = CGPoint(x: width + 100, y: 0)
        pipePair?.zPosition = -10
        
        let y =  arc4random() % UInt32(height / 4)
        
        let pipe1 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "obstacle")))
        pipe1.xScale = getSizeBasedOnDevice(height: height, normalSize: 0.6)
        pipe1.yScale = getSizeBasedOnDevice(height: height, normalSize: 0.6)
        pipe1.anchorPoint = .zero
        pipe1.color = .orange
        pipe1.position = CGPoint(x: 0, y: CGFloat(y) - getPositionBasedOnDevice(height: height, position: 100.0))
        pipe1.physicsBody = preparePipePhysics(pipe: pipe1)
        
        let pipe2 = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "obstacle")))
        pipe2.xScale = getSizeBasedOnDevice(height: height, normalSize: 0.6)
        pipe2.yScale = getSizeBasedOnDevice(height: height, normalSize: 0.6)
        pipe2.anchorPoint = .zero
        pipe2.color = .orange
        pipe2.position = CGPoint(x: 0, y: height +  getPositionBasedOnDevice(height: height, position: 30.0) + CGFloat(y))
        pipe2.physicsBody = preparePipePhysics(pipe: pipe2)
        pipe2.yScale = getSizeBasedOnDevice(height: height, normalSize: -0.6)
        
        pipe1.addChild(getRandomObstacle(height: pipe1.size.height))
        
        let obstacle2 = getRandomObstacle(height: pipe2.size.height)
        obstacle2.yScale = -1
        pipe2.addChild(obstacle2)
        
        pipePair?.addChild(pipe1)
        pipePair?.addChild(pipe2)
        
        self.prepareActions(width: width)
        pipePair?.run(moveAndRemovePipes!)
    }
    
    func prepareActions(width: CGFloat) {
        let move = SKAction.move(to: CGPoint(x: -(width + 150), y: 0), duration: 8)
        let remove = SKAction.removeFromParent()
        moveAndRemovePipes = SKAction.sequence([move, remove])
    }
}
