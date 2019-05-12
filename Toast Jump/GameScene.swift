//
//  GameScene.swift
//  Toast Jump
//
//  Created by Neil Poulin on 5/11/19.
//  Copyright © 2019 Kinecho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    
//    var toastNode = SKSpriteNode(imageNamed: "toast")
    var toasterNode = SKSpriteNode(imageNamed: "toaster-cartoon")
    var isFlying = false
    override func sceneDidLoad() {

        self.lastUpdateTime = 0        

        
        let ground = createGround()
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

//        configureToast()
        configureToaster()
        
//        addChild(toastNode)
        addChild(toasterNode)
        addChild(ground)
    }
    
    func createGround() -> SKShapeNode{
        // Create the ground node and physics body
        var splinePoints = [CGPoint(x: -size.width, y: -size.height/2 + 400),
            CGPoint(x: 0, y: -size.height/2 + 100),
            CGPoint(x: size.width, y: -size.height/2 + 400)]
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.75
        ground.physicsBody?.isDynamic = false
        
        
        return ground
    }
    
    func getToasterTop() -> CGFloat{
        let toasterHeight = toasterNode.size.height
        return -size.height/2 + toasterHeight
    }
    
    func configureToaster(){
        let toasterHeight = toasterNode.size.height
        toasterNode.position = CGPoint(x: 0, y: -size.height/2 + toasterHeight/2)        
    }
    
    func createToast() -> SKSpriteNode {
        let toastNode = SKSpriteNode(imageNamed: "toast")
        self.configureToast(toastNode)
        self.addChild(toastNode)
        return toastNode
    }
    
    func configureToast(_ toastNode: SKSpriteNode){
        toastNode.scale(to: CGSize(width: toastNode.size.width * 0.2, height: toastNode.size.height * 0.2))
        
        let body = SKPhysicsBody(texture: toastNode.texture!, size: toastNode.size)
//        let body = SKPhysicsBody(rectangleOf: CGSize(width: toastNode.size.width, height: toastNode.size.height))
        toastNode.physicsBody = body
        let toastHeight = toastNode.size.height
        
        toastNode.position = CGPoint(x: 0, y: getToasterTop())
        
        toastNode.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        let toastNode = createToast()
        toastNode.physicsBody?.velocity.dy = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 2000)) + 1000
        toastNode.physicsBody?.affectedByGravity = true
        toastNode.physicsBody?.isDynamic = true
        let duration = Double(GKRandomSource.sharedRandom().nextInt(upperBound: 100)) * 0.05
        toastNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: duration)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
