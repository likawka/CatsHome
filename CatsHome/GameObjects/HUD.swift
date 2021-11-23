//
//  HUD.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/23/21.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    let scoreLabel = SKLabelNode(fontNamed:"mangat")
    let livesLabel = SKLabelNode(fontNamed:"mangat")
    let tapToStartLabel = SKLabelNode(fontNamed: "mangat")
    let containerSize: CGSize
    
    
    init(size: CGSize) {
        containerSize = size
        super.init()
        
        for i in 0 ... 1{
            let background = SKSpriteNode(imageNamed: "background")
            background.size = size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: size.width/2, y: size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: size.width * 0.20, y: size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        livesLabel.text = "Lives: 5"
        livesLabel.fontSize = 60
        livesLabel.fontColor = .black
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLabel.position = CGPoint(x: size.width * 0.67, y: size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        addChild(livesLabel)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 130
        tapToStartLabel.fontColor = .black
        tapToStartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tapToStartLabel.position = CGPoint(x: size.width * 0.28, y: size.height * 0.45)
        tapToStartLabel.alpha = 0
        tapToStartLabel.zPosition = 100
        addChild(tapToStartLabel)
    }
    
    func start() {
        let moveOnToScreenAction = SKAction.moveTo(y: containerSize.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented, doesn't matter")
    }
    
    func setScore(score: Int) {
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    func hideTapToStart() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
    }
    
    func setLivesCount(livesCount: Int) {
        livesLabel.text = "Lives: \(livesCount)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
    }
}
