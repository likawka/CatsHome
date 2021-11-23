//
//  Player.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Player: SKNode {
    let sprite: SKSpriteNode
    enum FacingDirection {
        case left
        case right
    }
    
    override init() {
        sprite = SKSpriteNode(imageNamed: "playerCat")
        sprite.setScale(1)
        
        sprite.zPosition = 2
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.affectedByGravity = false
        
        sprite.physicsBody!.categoryBitMask = PhysicsCategories.Player
        sprite.physicsBody!.collisionBitMask = PhysicsCategories.None
        sprite.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        super.init()
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented, doesn't matter")
    }
    
    func getPosition() -> CGPoint {
        return self.sprite.position
    }
    
    func getSize() -> CGSize {
        return self.sprite.size
    }
    
    func moveTo(point: CGPoint) {
        self.sprite.position = point
    }
    
    func flip(direction: FacingDirection) {
        var action: SKAction
        switch direction {
        case .left:
            action = SKAction.scaleX(to: -1, duration: 0.1)
        case .right:
            action = SKAction.scaleX(to: 1, duration: 0.1)
        }
        self.sprite.run(action)
    }
    
    func createBullet(onCreate: (Bullet) -> Void) {
        let bullet = Bullet(position: sprite.position)
        onCreate(bullet)
    }
}
