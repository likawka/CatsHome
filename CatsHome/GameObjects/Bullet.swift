//
//  Bullet.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Bullet {
    let bullet: SKSpriteNode
    let bulletSound = SKAction.playSoundFileNamed("pewPoP0.mp3", waitForCompletion: false)
    
    init(position: CGPoint) {
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = position
        bullet.zPosition = 1
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask  = PhysicsCategories.Enemy
    }
    
    func start(screenSize: CGSize) {
        let moveBullet = SKAction.moveTo(y: screenSize.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet, bulletSound, deleteBullet])
        
        bullet.run(bulletSequence)
    }
}
