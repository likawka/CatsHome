//
//  Explosion.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class Explosion {
    let explosionSound = SKAction.playSoundFileNamed("vaseFall.mp3", waitForCompletion: false)
    let sprite: SKSpriteNode
    
    init(spawnPosition: CGPoint) {
        sprite = SKSpriteNode(imageNamed: "explosion")
        sprite.position = spawnPosition
        sprite.zPosition = 3
        sprite.setScale(0)
        
        let scaleIn = SKAction.scale(to: 1.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        sprite.run(explosionSequence)
    }
}
