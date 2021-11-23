////
////  GameStartScene.swift
////  CatsHome
////
////  Created by Iryna Zinko on 11/15/21.
////



import Foundation
import SpriteKit
import GameplayKit


class GameStartScene: SKScene {
    
    let startGame = SKLabelNode(fontNamed: "mangat")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "gameStartBack")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "mangat")
        gameBy.text = "Iryna Zinko"
        gameBy.fontSize = 50
        gameBy.fontColor = .black
        gameBy.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.68)
        gameBy.zPosition = 1
        addChild(gameBy)
        
        let nameGame = SKLabelNode(fontNamed: "mangat")
        nameGame.text = "Cat's Home"
        nameGame.fontSize = 175
        nameGame.fontColor = .black
        nameGame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        nameGame.zPosition = 1
        addChild(nameGame)
        
        
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = .black
        startGame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        startGame.zPosition = 1
        startGame.name = "startButton"
        addChild(startGame)
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeIyTapped = atPoint(pointOfTouch)
            
            if nodeIyTapped.name == "startButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
        
    }
    
    
    
}
