//
//  GameScene.swift
//  Project29
//
//  Created by Victor Rolando Sanchez Jara on 4/8/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: Properties
    weak var viewController: GameViewController!

    var buildings = [BuildingNode]()

    // MARK: Override Methods
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: Other Methods
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
        
    func launch(angle: Int, velocity: Int) {
    }
}
