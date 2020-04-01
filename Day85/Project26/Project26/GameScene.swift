//
//  GameScene.swift
//  Project26
//
//  Created by Victor Rolando Sanchez Jara on 3/30/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate  {
    // MARK: Properties
    let availableLevels = 1...2 // Change right number on range if adding Level 3
    var currentLevel = 1 {
        didSet {
            loadLevel(level: currentLevel)
        }
    } // Start at level 1
    
    // Characters in Level File:
    let WALL: Character = "x"
    let VORTEX: Character = "v"
    let STAR: Character = "s"
    let FINISH: Character = "f"
    let TELEPORT: Character = "t"
    let TELEPORT_POINT: Character = "p"

    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!

    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false

    // MARK: Override Methods
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        currentLevel = 1
        createPlayer()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }

        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    // MARK: Other Methods
    func removePastLevel() {
        for node in self.children {
            if node.name == "wall" || node.name == "vortex" || node.name == "star" || node.name == "finish" || node.name == "teleport" {
                node.removeFromParent()
            }
        }
    }
    func loadLevel(level: Int) {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level\(level).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level\(level).txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        // If we edit the text file in Xcode, it adds an extra empty line.
        // If we choose to use Xcode to edit the text files, we need to remove the last line that is empty, so it doesn't make the whole level shift
        // Otherwise just use an editor like VS Code to make the levels
//        lines.removeLast()
    
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == WALL {
                    // load wall
                    loadWall(at: position)
                } else if letter == VORTEX  {
                    // load vortex
                    loadVortex(at: position)
                } else if letter == STAR  {
                    // load star
                    loadStar(at: position)
                } else if letter == FINISH  {
                    // load finish
                    loadFinish(at: position)
                } else if letter == TELEPORT  {
                    // load teleport
                    loadTeleport(at: position)
                } else if letter == TELEPORT_POINT {
                    // load teleport point
                    loadTeleportPoint(at: position)
                }else if letter == " " {
                    // this is an empty space – do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func loadWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.name = "wall"
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleport(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.color = .red
        node.colorBlendFactor = 1.0
        node.name = "teleport"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadTeleportPoint(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "teleport")
        node.color = .cyan
        node.colorBlendFactor = 1.0
        node.name = "teleportPoint"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func loadFinish(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "teleport" {
            physicsWorld.gravity = .zero
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            var teleportPointNodes = [SKNode]()
            for child in self.children {
                if child.name == "teleportPoint" {
                    teleportPointNodes.append(child)
                }
            }
            let randomTeleportNode = teleportPointNodes.randomElement()!
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let moveToTeleport = SKAction.move(to: randomTeleportNode.position, duration: 0.1)
            let scaleBack = SKAction.scale(to: 1, duration: 0.25)
            let sequence = SKAction.sequence([move, scale, moveToTeleport, scaleBack])
            
            
            player.run(sequence) { [weak self] in
                self?.isGameOver = false
                self?.player.physicsBody?.isDynamic = true
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // Give lots of points when finishing a level!
            score += 10
            // Check if there is a next level available
            if availableLevels.contains(currentLevel+1) {
                player.physicsBody?.isDynamic = false
                isGameOver = true
                
                let move = SKAction.move(to: node.position, duration: 0.25)
                let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let moveToStart = SKAction.move(to: CGPoint(x: 96, y: 672), duration: 0.1)
                let sequence = SKAction.sequence([move, scale, moveToStart, remove])
                
                
                player.run(sequence) { [weak self] in
                    self?.physicsWorld.gravity = .zero
                    self?.removePastLevel()
                    self?.currentLevel += 1
                    self?.createPlayer()
                    self?.isGameOver = false
                }
            } else {
                // If there is no next level, win game
                player.physicsBody?.isDynamic = false
                isGameOver = true
                
                let move = SKAction.move(to: node.position, duration: 0.25)
                let scale = SKAction.scale(to: 0.0001, duration: 0.25)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([move, scale, remove])
                
                player.run(sequence)
                
                let winLabel = SKLabelNode(fontNamed: "Chalkduster")
                winLabel.text = "YOU WIN!"
                winLabel.horizontalAlignmentMode = .center
                winLabel.position = CGPoint(x: 512, y: 384)
                addChild(winLabel)
               
            }
        }
    }
}
