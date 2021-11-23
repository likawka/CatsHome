//
//  GameScene.swift
//  CatsHome
//
//  Created by Iryna Zinko on 10/28/21.
//

import SpriteKit
import GameplayKit


var gameScore = 0



class GameScene: SKScene, SKPhysicsContactDelegate {
    var livesNumb = 5
    var levelNumber = 0
    var fingerLocation = CGPoint()
    var player: Player
    let hud: HUD
    
    enum gameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    var gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = (19.0/15.0)
        let playebleWigth = (size.height / maxAspectRatio)
        let margin = ((size.width - playebleWigth) / 2.0)
        
        gameArea = CGRect(x: margin / 2, y: 0, width:playebleWigth, height:size.height)
        self.player = Player()
        self.hud = HUD(size: size)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // розміщення бекграунда + гравець
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        
        // add hud
        self.addChild(hud)
        hud.start()
        
        // create player
        player = Player()
        player.moveTo(point: CGPoint(x: self.size.width/2, y: -self.size.height))
        self.addChild(player)
        
        startNewLevel()
    }
    
    var lastUpdateTime: TimeInterval = 0
    var delfaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        } else {
            delfaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(delfaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground
            }
            
            if background.position.y < (-self.size.height){
                background.position.y += self.size.height*2
                
            }
            
        }
        
    }
    
    func addScore(){
        gameScore += 1
        hud.setScore(score: gameScore)
        
        if gameScore == 10 || gameScore == 20 || gameScore == 40 || gameScore == 50 {
            startNewLevel()
        }
    }
    
    func startGame(){
        
        currentGameState = gameState.inGame
        
        hud.hideTapToStart()
        
        let moveCatOnToScreenAction = SKAction.moveTo(y: self.size.width/3.5, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startLevelSequence = SKAction.sequence([moveCatOnToScreenAction, startLevelAction])
        
        self.player.sprite.run(startLevelSequence)
    }
    
    
    
    func loseLives(){
        
        livesNumb -= 1
        hud.setLivesCount(livesCount: livesNumb)
        
        if livesNumb == 0{
            runGameOver()
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // якщо у ворога попали кігтиками
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            addScore()
            
            if body2.node != nil{
                if body2.node!.position.y > self.size.height{
                    return // якщо ворог знаходиться за межами верхньої частини екрана, «поверніться». Це припинить виконання цього коду тут, тому нічого не робитимемо, якщо ми не вдаримо ворога, коли він на екрані.
                }
                else{
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
        
        
        // якщо гравець влупився лицем в ворога
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            spawnExplosion(spawnPosition: body1.node!.position)
            spawnExplosion(spawnPosition: body2.node!.position)
            
            
            
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
            
        }
        
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint ){
        let explosion = Explosion(spawnPosition: spawnPosition)
        self.addChild(explosion)
    }
    
    
    func startNewLevel(){
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber{
        case 1: levelDuration =  3 // 1.2
        case 2: levelDuration =  2  // 0.5
        case 3: levelDuration =  0.8
        case 4: levelDuration =  0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
            
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        self.run(spawnForever, withKey: "spawningEnemies" )
        
    }
    
    // розробка кігтиків і атаки + звук
    func fireBullet() {
        player.createBullet { bullet in
            self.addChild(bullet)
            bullet.start(screenSize: self.size)
        }
    }
    
    func spawnEnemy() {
        let enemy = Enemy(gameArea: gameArea)
        self.addChild(enemy)
        enemy.start {
            self.loseLives()
        }
    }
    
    // стріляє, коли тикаєш
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            fingerLocation = touch.location(in: self)
            
        }
        
        if currentGameState == gameState.preGame{
            startGame()
        }
        else if currentGameState == gameState.inGame{
            fireBullet()
        }
    }
    
    
    // заставляє кота ворушитись за пальцем
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            let currentPostition = self.player.getPosition()
            let currentSize = self.player.getSize()
            
            if currentGameState == gameState.inGame{
                self.player.moveTo(point: CGPoint(x: currentPostition.x + amountDragged, y: currentPostition.y))
            }
            
            if currentPostition.x > gameArea.maxX - currentSize.width*1.5 {
                self.player.moveTo(point: CGPoint(x: gameArea.maxX - currentSize.width*1.5, y: currentPostition.y))
            }
            if currentPostition.x < gameArea.minX + currentSize.width*1.5{
                self.player.moveTo(point: CGPoint(x: gameArea.minX + currentSize.width*1.5, y: currentPostition.y))
            }
            if pointOfTouch.x < previousPointOfTouch.x {
                // rotate animation
                self.player.flip(direction: Player.FacingDirection.left)
            } else{
                self.player.flip(direction: Player.FacingDirection.right)
            }
            
        }
        
        
    }
    
    func runGameOver(){
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        
        self.run(changeSceneSequence)
        
        
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
}


