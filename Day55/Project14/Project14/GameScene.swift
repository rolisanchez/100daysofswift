//
//  GameScene.swift
//  Project14
//
//  Created by Victor Rolando Sanchez Jara on 2/29/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: Properties
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var numRounds = 0

    // MARK: Override Functions
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        createSlots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            
            if node.name == "charFriend" {
                // they shouldn't have whacked this penguin
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
            } else if node.name == "charEnemy" {
                // they should have whacked this one
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
            }
            
            if let smokeParticles = SKEmitterNode(fileNamed: "PenguinSmoke") {
                smokeParticles.position = whackSlot.position
                smokeParticles.zPosition = 1
                addChild(smokeParticles)
            }
        }
    }
    
    // MARK: Other Methods
    func createSlots(){
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            
            addChild(gameOver)
            
            let finalScore = SKLabelNode(fontNamed: "Chalkduster")
            finalScore.text = "Final Score: \(score)"
            finalScore.position = CGPoint(x: 512, y: 220)
            finalScore.horizontalAlignmentMode = .center
            finalScore.fontSize = 54
            finalScore.zPosition = 1
            
            addChild(finalScore)
            
            gameScore.isHidden = true
            
            run(SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion:false))
            
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
            mudParticles.position =  slots[0].position
            mudParticles.zPosition = 1
            addChild(mudParticles)
        }
        
        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
            if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
                mudParticles.position =  slots[1].position
                mudParticles.zPosition = 1
                addChild(mudParticles)
            }
        }
        if Int.random(in: 0...12) > 8 {
            slots[2].show(hideTime: popupTime)
            if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
                mudParticles.position =  slots[2].position
                mudParticles.zPosition = 1
                addChild(mudParticles)
            }
        }
        if Int.random(in: 0...12) > 10 {
            slots[3].show(hideTime: popupTime)
            if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
                mudParticles.position =  slots[3].position
                mudParticles.zPosition = 1
                addChild(mudParticles)
            }
            
        }
        if Int.random(in: 0...12) > 11 {
            slots[4].show(hideTime: popupTime)
            if let mudParticles = SKEmitterNode(fileNamed: "MudParticle") {
                mudParticles.position =  slots[4].position
                mudParticles.zPosition = 1
                addChild(mudParticles)
            }
        }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
