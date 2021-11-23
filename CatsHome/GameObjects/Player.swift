//
//  Player.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Player {
    let playerSprite: SKSpriteNode
    enum FacingDirection {
        case left
        case right
    }
    
    init() {
        self.playerSprite = SKSpriteNode(imageNamed: "playerCat")
        playerSprite.setScale(1)
        
        // x:self.frame.midX, y:player.size.height/2 + 10
        // x: self.size.width/2, y: self.size.height * 0.2
        
        playerSprite.zPosition = 2
        
        playerSprite.physicsBody = SKPhysicsBody(rectangleOf: playerSprite.size)
        playerSprite.physicsBody!.affectedByGravity = false
        
        playerSprite.physicsBody!.categoryBitMask = PhysicsCategories.Player
        playerSprite.physicsBody!.collisionBitMask = PhysicsCategories.None
        playerSprite.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
    }
    
    func getPosition() -> CGPoint {
        return self.playerSprite.position
    }
    
    func getSize() -> CGSize {
        return self.playerSprite.size
    }
    
    func moveTo(point: CGPoint) {
        self.playerSprite.position = point
    }
    
    func flip(direction: FacingDirection) {
        var action: SKAction
        switch direction {
        case .left:
            action = SKAction.scaleX(to: -1, duration: 0.1)
        case .right:
            action = SKAction.scaleX(to: 1, duration: 0.1)
        }
        self.playerSprite.run(action)
    }
    
    func createBullet(onCreate: (Bullet) -> Void) {
        let bullet = Bullet(position: playerSprite.position)
        onCreate(bullet)
    }
}
