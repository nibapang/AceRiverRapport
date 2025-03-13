//
//  GameScene.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import Foundation
import SpriteKit

//MARK: Scene

class RapportGameScene: SKScene {
    
    weak var gameDelegate: RapportGameSceneDelegate?
    
    private var snake: [SKShapeNode] = []
    private var moveDirection = CGVector(dx: 1, dy: 0)
    private var blocks: [SKSpriteNode] = []
    private let snakeSize: CGFloat = 10
    private let moveSpeed: CGFloat = 0.1
    private var lastUpdateTime: TimeInterval = 0
    
    var setGameOver: ((_ isWin: Bool)->Void)?
    
    var score: Int = 0 {
        didSet {
            gameDelegate?.didUpdateScore(score)
            if score % 5 == 0 {
                level += 1
            }
        }
    }
    
    var level: Int = 1 {
        didSet {
            gameDelegate?.didUpdateLevel(level)
        }
    }
    
    // Add new properties for poker theme
    private let suits = ["♠️", "♥️", "♣️", "♦️"]
    private let cardValues = ["A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
    private let suitColors: [String: UIColor] = [
        "♠️": .black,
        "♥️": .red,
        "♣️": .black,
        "♦️": .red
    ]
    
    override func didMove(to view: SKView) {
        setupGame()
    }
    
    private func setupGame() {
        // Create initial snake
        createSnake()
        
        // Create blocks
        createBlocks()
        
        // Setup gesture recognizers
        setupControls()
    }
    
    private func createSnake() {
        // Create initial snake segments
        for i in 0...5 {
            let segment = SKShapeNode(circleOfRadius: snakeSize/2)
            segment.fillColor = .yellow
            segment.position = CGPoint(x: size.width/2 - CGFloat(i) * snakeSize,
                                     y: size.height/2)
            addChild(segment)
            snake.append(segment)
        }
    }
    
    private func createBlocks() {
        // Create random blocks with poker cards
        for _ in 0...5 {
            let block = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 70))
            block.name = "card"
            
            // Round corners to look like cards
            block.color = .white
            block.colorBlendFactor = 1.0
            
            let randomX = CGFloat.random(in: 40...size.width-40)
            let randomY = CGFloat.random(in: 40...size.height-40)
            block.position = CGPoint(x: randomX, y: randomY)
            
            // Add card value and suit
            let randomSuit = suits.randomElement() ?? "♠️"
            let randomValue = cardValues.randomElement() ?? "A"
            
            // Create value label
            let valueLabel = SKLabelNode(text: "\(randomValue)\(randomSuit)")
            valueLabel.fontSize = 24
            valueLabel.fontName = "HelveticaNeue-Bold"
            valueLabel.fontColor = suitColors[randomSuit]
            valueLabel.verticalAlignmentMode = .center
            
            // Store the numeric value as user data
            let numericValue = convertCardValueToPoints(value: randomValue)
            block.userData = NSMutableDictionary()
            block.userData?.setValue(numericValue, forKey: "points")
            
            block.addChild(valueLabel)
            blocks.append(block)
            addChild(block)
        }
    }
    
    private func setupControls() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            moveDirection = CGVector(dx: 1, dy: 0)
        case .left:
            moveDirection = CGVector(dx: -1, dy: 0)
        case .up:
            moveDirection = CGVector(dx: 0, dy: 1)
        case .down:
            moveDirection = CGVector(dx: 0, dy: -1)
        default:
            break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTime
        if deltaTime < moveSpeed / Double(level) {
            return
        }
        
        lastUpdateTime = currentTime
        moveSnake()
        checkCollisions()
    }
    
    private func moveSnake() {
        guard let head = snake.first else { return }
        
        let newHead = SKShapeNode(circleOfRadius: snakeSize/2)
        newHead.fillColor = .yellow
        newHead.position = CGPoint(
            x: head.position.x + moveDirection.dx * snakeSize,
            y: head.position.y + moveDirection.dy * snakeSize
        )
        
        // Add new head
        snake.insert(newHead, at: 0)
        addChild(newHead)
        
        // Remove tail
        snake.last?.removeFromParent()
        snake.removeLast()
    }
    
    private func checkCollisions() {
        guard let head = snake.first else { return }
        
        // Check block collisions
        for block in blocks {
            if head.frame.intersects(block.frame) {
                if let points = block.userData?.value(forKey: "points") as? Int {
                    score += points
                    
                    // Create floating score effect
                    showFloatingScore(points: points, at: block.position)
                }
                repositionBlock(block)
            }
        }
        
        // Check wall collisions
        if head.position.x < 0 || head.position.x > size.width ||
           head.position.y < 0 || head.position.y > size.height {
            isPaused = true
            setGameOver?(false)
        }
    }
    
    private func showFloatingScore(points: Int, at position: CGPoint) {
        let floatingText = SKLabelNode(text: "+\(points)")
        floatingText.position = position
        floatingText.fontSize = 24
        floatingText.fontName = "Impact"
        floatingText.fontColor = .white
        addChild(floatingText)
        
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 1.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let group = SKAction.group([moveUp, fadeOut])
        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        floatingText.run(sequence)
    }
    
    private func repositionBlock(_ block: SKSpriteNode) {
        let randomX = CGFloat.random(in: 40...size.width-40)
        let randomY = CGFloat.random(in: 40...size.height-40)
        block.position = CGPoint(x: randomX, y: randomY)
        
        // Update card value and suit
        let randomSuit = suits.randomElement() ?? "♠️"
        let randomValue = cardValues.randomElement() ?? "A"
        
        if let label = block.children.first as? SKLabelNode {
            label.text = "\(randomValue)\(randomSuit)"
            label.fontColor = suitColors[randomSuit]
        }
        
        // Update points value
        let numericValue = convertCardValueToPoints(value: randomValue)
        block.userData?.setValue(numericValue, forKey: "points")
    }
    
    private func convertCardValueToPoints(value: String) -> Int {
        switch value {
        case "A":
            return 14
        case "K":
            return 13
        case "Q":
            return 12
        case "J":
            return 11
        default:
            return Int(value) ?? 10
        }
    }
    
    func resetGame() {
        snake.forEach { $0.removeFromParent() }
        blocks.forEach { $0.removeFromParent() }
        snake.removeAll()
        blocks.removeAll()
        score = 0
        level = 1
        moveDirection = CGVector(dx: 1, dy: 0)
        
        // Setup new game
        setupGame()
        isPaused = false
    }
    
}
