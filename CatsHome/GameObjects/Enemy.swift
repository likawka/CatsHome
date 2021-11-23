//
//  Enemy.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Enemy: SKNode {
    let sprite: SKSpriteNode
    let endPoint: CGPoint
    let startPoint: CGPoint
    
    init(gameArea: CGRect) {
        let randomXStart = Utils.random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = Utils.random(min: gameArea.minX, max: gameArea.maxX)
        startPoint = CGPoint(x: randomXStart, y: gameArea.maxY*1.2)
        endPoint = CGPoint(x: randomXEnd/3, y: -gameArea.minY*1.2)
        
        sprite = SKSpriteNode(imageNamed: "enemyVase")
        sprite.name = "Enemy"
        sprite.setScale(1)
        sprite.position = startPoint
        sprite.zPosition = 2
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        
        sprite.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        sprite.physicsBody!.collisionBitMask = PhysicsCategories.None
        sprite.physicsBody!.contactTestBitMask = PhysicsCategories.Bullet | PhysicsCategories.Player
        
        super.init()
        self.addChild(sprite)
    }
    
    // SKNode
    //  |    \
    // Player HUD
    
    // 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented, doesn't matter")
    }
    
    func start(onLoseLife: @escaping () -> Void) {
        let moveEnemy = SKAction.move(to: endPoint, duration: 5) // замінити на менше число!
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(onLoseLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        sprite.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amoundToRotate = atan2(dx, dy)
        
        sprite.zRotation = amoundToRotate
    }
}
