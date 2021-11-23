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
    
    let scoreLabel = SKLabelNode(fontNamed:"mangat")
    
    var livesNumb = 5
    let livesLabel = SKLabelNode(fontNamed:"mangat")
    
    var levelNumber = 0
    
    
    var fingerLocation = CGPoint()
    var player = SKSpriteNode(imageNamed: "playerCat")
    
    let bulletSound = SKAction.playSoundFileNamed("pewPoP0.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("vaseFall.mp3", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode(fontNamed: "mangat")
    
    
    enum gameState{
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    
    
    
    struct PhysicsCategories{
        static let None   : UInt32 = 0
        static let Player : UInt32 = 0b1 //1 binary
        static let Bullet : UInt32 = 0b10 //2 binary
        static let Enemy   : UInt32 = 0b100 //4 binary
    }
    
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    var gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = (19.0/15.0)
        let playebleWigth = (size.height / maxAspectRatio)
        let margin = ((size.width - playebleWigth) / 2.0)
        
        gameArea = CGRect(x: margin / 2, y: 0, width:playebleWigth, height:size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // розміщення бекграунда + гравець
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0 ... 1{
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: -self.size.height )
        
        // x:self.frame.midX, y:player.size.height/2 + 10
        // x: self.size.width/2, y: self.size.height * 0.2
        
        player.zPosition = 2
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = .black
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.20, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        
        livesLabel.text = "Lives: 5"
        livesLabel.fontSize = 60
        livesLabel.fontColor = .black
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLabel.position = CGPoint(x: self.size.width * 0.67, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 130
        tapToStartLabel.fontColor = .black
        tapToStartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        tapToStartLabel.position = CGPoint(x: self.size.width * 0.28, y: self.size.height * 0.45)
        tapToStartLabel.alpha = 0
        tapToStartLabel.zPosition = 100
        addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
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
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 20 || gameScore == 40 || gameScore == 50 {
            startNewLevel()
        }
    }
    
    func startGame(){
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveCatOnToScreenAction = SKAction.moveTo(y: self.size.width/3.5, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startLevelSequence = SKAction.sequence([moveCatOnToScreenAction, startLevelAction])
        
        player.run(startLevelSequence)
    }
    
    
    
    func loseLives(){
        
        livesNumb -= 1
        livesLabel.text = "Lives: \(livesNumb)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
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
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
        // 32:00
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
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask  = PhysicsCategories.Enemy
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet,bulletSound, deleteBullet])
        
        bullet.run(bulletSequence)
        
    }
    
    func spawnEnemy() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXEnd/3, y: -self.size.height*1.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyVase")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Bullet | PhysicsCategories.Player
        
        
        
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 5) // замінити на менше число!
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseLives)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amoundToRotate = atan2(dx, dy)
        
        enemy.zRotation = amoundToRotate
        
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
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width*1.5 {
                player.position.x = gameArea.maxX - player.size.width*1.5
                
            }
            if player.position.x < gameArea.minX + player.size.width*1.5{
                player.position.x = gameArea.minX + player.size.width*1.5
                
            }
            if player.position.x < fingerLocation.x{
                
                let flip = SKAction.scaleX(to: -1, duration: 0)
                player.setScale(1.0)
                let changeColor = SKAction.run( { self.player.texture = SKTexture(imageNamed: "playerCat")})
                let action = SKAction.sequence([flip, changeColor] )
                player.run(action)
                
            } else{
                player.setScale(1);
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


