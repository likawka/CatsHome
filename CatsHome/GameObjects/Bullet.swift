//
//  Bullet.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Bullet {
    let sprite: SKSpriteNode
    let bulletSound = SKAction.playSoundFileNamed("pewPoP0.mp3", waitForCompletion: false)
    
    init(position: CGPoint) {
        sprite = SKSpriteNode(imageNamed: "bullet")
        sprite.name = "Bullet"
        sprite.setScale(1)
        sprite.position = position
        sprite.zPosition = 1
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        
        sprite.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        sprite.physicsBody!.collisionBitMask = PhysicsCategories.None
        sprite.physicsBody!.contactTestBitMask  = PhysicsCategories.Enemy
    }
    
    func start(screenSize: CGSize) {
        let moveBullet = SKAction.moveTo(y: screenSize.height + sprite.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, bulletSound, deleteBullet])
        
        sprite.run(bulletSequence)
    }
}
