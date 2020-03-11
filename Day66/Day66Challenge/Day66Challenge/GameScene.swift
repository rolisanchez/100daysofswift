//
//  GameScene.swift
//  Day66Challenge
//
//  Created by Victor Rolando Sanchez Jara on 3/11/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: Properties
    var flow: SKEmitterNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletsLabel: SKLabelNode!
    var bullets = 6 {
        didSet {
            bulletsLabel.text = "Bullets: \(bullets)"
        }
    }
    
    var remainingTimeLabel: SKLabelNode!
    var remainingTimeSeconds = 60 {
        didSet {
            remainingTimeLabel.text = "Remaining Time: \(remainingTimeSeconds)s"
        }
    }
    
    var reloadLabel: SKLabelNode!
    
    var isGameOver = false
    var enemiesCount = 0
    var timeInterval = 1.0
    
    // Timers
//    var gameTimer: Timer?
    var enemyTimer: Timer?
    
    // MARK: Lifecycle Methods
    override func didMove(to view: SKView) {
        
        
        backgroundColor = .blue
        
//        flow = SKEmitterNode(fileNamed: "FlowEmitter")!
//        flow.position = CGPoint(x: 1024, y: 384)
//        flow.advanceSimulationTime(10)
//        addChild(flow)
//        flow.zPosition = -1
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 700)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletsLabel.position = CGPoint(x: 1000, y: 700)
        bulletsLabel.horizontalAlignmentMode = .right
        addChild(bulletsLabel)
        
        bullets = 6
        
        remainingTimeLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingTimeLabel.position = CGPoint(x: 516, y: 700)
        remainingTimeLabel.horizontalAlignmentMode = .center
        addChild(remainingTimeLabel)
        
        remainingTimeSeconds = 60
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.name = "RELOAD"
        reloadLabel.text = "RELOAD"
        reloadLabel.position = CGPoint(x: 1000, y: 50)
        reloadLabel.horizontalAlignmentMode = .right
        addChild(reloadLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
//        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)

    }
    
    // MARK: Override Methods
    
    override func update(_ currentTime: TimeInterval) {
        // Performed every 16ms
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        
        
        for node in tappedNodes {
            if node.name == "RELOAD" {
                bullets = 6
            } else if bullets > 0 {
                if node.name == "Bad" {
                    score -= 1
                    node.removeFromParent()
                } else if node.name == "Good1" {
                    score += 1
                    node.removeFromParent()
                } else if node.name == "Good2" {
                    score += 2
                    node.removeFromParent()
                } else if node.name == "Good3" {
                    score += 3
                    node.removeFromParent()
                }
                bullets -= 1
                
            }
           
        }
    }
    
    // MARK: Other Methods
//    @objc func countDown() {
//        if remainingTimeSeconds == 0 {
//            isGameOver = true
//        } else {
//            remainingTimeSeconds -= 1
//        }
//    }
    
    @objc func createEnemy() {
        guard isGameOver == false else {
            enemyTimer?.invalidate()
            return
            
        }
        
        self.children.map { node in
            if node.position.x < -10 || node.position.x > 1050 {
                node.removeFromParent()
            }
        }
        
        enemiesCount += 1
        
        // Generate either bad or good targets. Adjust range to change probabilities. Now it's 50/50
        let randomGoodBad = Int.random(in: 0...1)
        var node: SKSpriteNode

        var xScale: CGFloat = 0.25
        var yScale: CGFloat = 0.25

        if randomGoodBad >= 1 {
            // Create good
            node = SKSpriteNode(imageNamed: "GoodBullsEye")
            // Randomize points for good target
            let randomGoodPoints = Int.random(in: 0...3)
            if randomGoodPoints == 0 {
                node.name = "Good1"
            } else if randomGoodPoints == 0 {
                node.name = "Good2"
                xScale *= 0.75
                yScale *= 0.75
            } else {
                node.name = "Good3"
                xScale *= 0.5
                yScale *= 0.5
            }

        } else {
            // Create bad
            node = SKSpriteNode(imageNamed: "BadBullsEye")
            node.name = "Bad"
        }

        node.xScale = xScale
        node.yScale = yScale

        let randomTopMiddleBottom = Int.random(in: 0...2)
        
        // Left + Top by default
        var xPosition = 50
        var yPosition = 600
        if randomTopMiddleBottom == 1 {
            // Middle + Right
            xPosition = 900
            yPosition = 450
        } else if randomTopMiddleBottom == 2 {
            // Bottom + Left
            yPosition = 300
        }
        
        node.position = CGPoint(x: xPosition, y: yPosition)
        addChild(node)
        
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.categoryBitMask = 1
        
        if randomTopMiddleBottom == 0 {
            // Left to Right
            node.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        } else if randomTopMiddleBottom == 1 {
            // Right to Left
            node.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        } else {
            // Left to Right
            node.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        }
        
        node.physicsBody?.angularVelocity = 0
        node.physicsBody?.linearDamping = 0
        node.physicsBody?.angularDamping = 0
        
//        let node = SKSpriteNode(imageNamed: "GoodBullsEye")
//        node.xScale = 0.25
//        node.yScale = 0.25
//        node.position = CGPoint(x: 900, y: 600)
//        addChild(node)
//
//        let node2 = SKSpriteNode(imageNamed: "BadBullsEye")
//        node2.xScale = 0.25
//        node2.yScale = 0.25
//        node2.position = CGPoint(x: 50, y: 450)
//        addChild(node2)
//
//        let node3 = SKSpriteNode(imageNamed: "BadBullsEye")
//        node3.xScale = 0.25
//        node3.yScale = 0.25
//        node3.position = CGPoint(x: 900, y: 300)
//        addChild(node3)
//
//        enemyTimer?.invalidate()
        
        // If we want variable enemies creation, we can create two timers. For sake of simplicity just using one
//        if enemiesCount % 20 == 0 {
//            timeInterval -= 0.1
//            enemyTimer?.invalidate()
//            enemyTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//        }
        
        if remainingTimeSeconds == 0 {
            isGameOver = true
        } else {
            remainingTimeSeconds -= 1
        }
        
    }
}
