//
//  GameOverScene.swift
//  CatsHome
//
//  Created by Iryna Zinko on 11/6/21.
//

import Foundation
import SpriteKit
import GameplayKit



class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "mangat")

    override func didMove(to view: SKView) {
    
    let background = SKSpriteNode(imageNamed: "gameOverBack")
    background.size = self.size
    background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    background.zPosition = 0
    self.addChild(background)
        
        
    let gameOverLabel = SKLabelNode(fontNamed: "mangat")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 172 // 170
        gameOverLabel.fontColor = .red
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameOverLabel.position = CGPoint(x: self.size.width * 0.21, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
    addChild(gameOverLabel)
        
    let scoreLabel = SKLabelNode(fontNamed: "mangat")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 140
        scoreLabel.fontColor = .red
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.5)
        scoreLabel.zPosition = 1
    addChild(scoreLabel)
        
        
        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScore{
            highScore = gameScore
            defaults.set(highScore, forKey: "highScoreSaved")
        }

        
        let highScoreLabel = SKLabelNode(fontNamed: "mangat")
        highScoreLabel.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.4)
        highScoreLabel.text = "HighScore: \(highScore)"
        highScoreLabel.fontSize = 140
        highScoreLabel.fontColor = .red
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 160
        restartLabel.fontColor = .red
        restartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        restartLabel.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.25)
        restartLabel.zPosition = 1
        addChild(restartLabel)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
                
            
        }
    }
}
    
