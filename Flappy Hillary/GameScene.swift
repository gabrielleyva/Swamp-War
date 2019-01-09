//
//  GameScene.swift
//  Flappy Hillary
//
//  Created by Gabriel I Leyva Merino on 12/18/17.
//  Copyright © 2017 Will Clark. All rights reserved.
//

import SpriteKit
import GameplayKit


let birdCategory:UInt32 = 0x1 << 0
let pipeCategory:UInt32 = 0x1 << 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird: Bird!
    var background: Background!
    var highScoreLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score = 0
    var highScore = 0
    var start: Bool!
    var gameOver: Bool!
    var floor: Floor!
    var mainLabel: SKLabelNode!
    var viewController: GameViewController!
    var deaths = 0

    override func didMove(to view: SKView) {
        
        //important game variables
        start = false
        gameOver = false
        highScore = UserDefaults.standard.integer(forKey: "high-score")
        deaths = UserDefaults.standard.integer(forKey: "deaths")
        
        //Physics World Set Up
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = .zero
        
        // Create and prepare objects of the game
        self.prepareBackground()
        self.prepareFloor()
        self.prepareBird()
        self.prepareHighScoreLabel()
        self.prepareScoreLabel()
        self.prepareTopBoundary()
        self.prepareMainLabel(text: "Tap To Play")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print (getSizeBasedOnDevice(view: self.view!, normalSize: 50))
        if (start == false) {
            self.prepareSpawnAction()
            self.mainLabel.isHidden = true
        }
        
        start = true
        if (self.bird.birdIsActive && gameOver == false) {
            self.bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: getSizeBasedOnDevice(view: self.view!, normalSize: 50)))
        } else if (gameOver == false) {
            self.bird.prepareBirdPhysics(view: self.view!)
        }
        
        if (gameOver) {
            self.restartGame()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        self.bird.position.x = (self.frame.width / 2)
        self.bird.physicsBody?.allowsRotation = false
        
        if start && gameOver == false{
            //move  obstacles
        }
        
        if gameOver == false {
            self.floor.moveFloor()
            self.background.moveBackground()
        }
    }
    
    func prepareTopBoundary() {
        let dummy = SKSpriteNode()
        dummy.anchorPoint = .zero
        dummy.color = .orange
        dummy.position = CGPoint(x: 0, y: self.view!.frame.size.height + CGFloat(75))
        dummy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.view!.frame.size.width, height: CGFloat(1)))
        dummy.physicsBody?.isDynamic = false
        dummy.physicsBody?.categoryBitMask = pipeCategory
        dummy.physicsBody?.contactTestBitMask = birdCategory
        self.addChild(dummy)
    }
    
    func prepareBackground() {
        background = Background()
        background.anchorPoint = .zero
        background.prepare(width: self.view!.frame.size.width, height: self.view!.frame.size.height)
        self.addChild(background.background[0])
        self.addChild(background.background[1])
    }
    
    func prepareBird() {
        bird = Bird(texture: SKTexture(image: #imageLiteral(resourceName: "trumpLose")))
        bird.xScale = getSizeBasedOnDevice(view: self.view!, normalSize: 0.5)
        bird.yScale = getSizeBasedOnDevice(view: self.view!, normalSize: 0.5)
        bird.position = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        bird.color = .black
        self.addChild(bird)
    }
    
    func prepareFloor() {
        floor = Floor()
        self.addChild(floor.prepareFloor(width: self.frame.size.width))
        self.addChild(self.floor.floor[0])
        self.addChild(self.floor.floor[1])
        
    }
    
    func prepareScoreLabel() {
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.width - 21, y: self.frame.height - self.highScoreLabel.frame.size.height - 75)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 21
        scoreLabel.fontName = "Funny & Cute"
        self.addChild(scoreLabel)
    }
    
    func prepareHighScoreLabel() {
        highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.width - 21, y: self.frame.height - 60)
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.zPosition = 5
        highScoreLabel.fontSize = 21
        highScoreLabel.fontName = "Funny & Cute"
        self.addChild(highScoreLabel)
    }
    
    @objc func createObstacles() {
        let obstacle = Pipe()
        obstacle.createPipes(width: self.frame.size.width, height: self.frame.size.height)
        self.addChild(obstacle.pipePair!)
        
    }
    
    func restartGame(){
        let scene = GameScene(size: (self.view?.bounds.size)!)
        scene.scaleMode = .aspectFill
        self.viewController.hideFeatureView()
        scene.viewController = self.viewController
        self.view?.presentScene(scene)
    }
    
    func gameIsOver() {
        self.bird.birdIsActive = false
        self.mainLabel.text = "Game Over!"
        self.mainLabel.isHidden = false
        self.bird.texture = SKTexture(image: #imageLiteral(resourceName: "trumpWin"))
        self.removeAllActions()
        self.viewController.score = self.score
       
        for child in self.children {
            child.removeAllActions()
        }
        
        if score > highScore {
            self.highScoreLabel.text = "High Score: \(score)"
            UserDefaults.standard.set(score, forKey: "high-score")
        }
        
        if deaths > 3 {
            deaths = 0
            self.viewController.presentFullAdView()
        }
        
        UserDefaults.standard.set(deaths, forKey: "deaths")
        
        self.viewController.prepareGameOverView()
    }
    
     func didBegin(_ contact: SKPhysicsContact) {
        print("Game Over")
        if (gameOver == false) {
            gameOver = true
            deaths += 1
            self.gameIsOver()
        }
    }
    
    @objc func increaseScore() {
        score += 1
        self.scoreLabel.text = "Score: \(score)"
    }
    
    func prepareMainLabel(text: String) {
        mainLabel = SKLabelNode()
        mainLabel.position = CGPoint(x: self.size.width / 2, y: self.frame.size.height / 1.4)
        mainLabel.text = text
        mainLabel.horizontalAlignmentMode = .center
        mainLabel.zPosition = 5
        mainLabel.fontSize = 38
        mainLabel.fontName = "Funny & Cute"
        self.addChild(mainLabel)
    }
    
    func prepareSpawnAction() {
        let spawn = SKAction.perform(#selector(createObstacles), onTarget: self)
        let delay = SKAction.wait(forDuration: 1.5)
        let updateScore = SKAction.perform(#selector(increaseScore), onTarget: self)
        let spawnAndDelay = SKAction.sequence([spawn, delay, updateScore])
        let runForever = SKAction.repeatForever(spawnAndDelay)
        self.run(runForever)
    }

}
