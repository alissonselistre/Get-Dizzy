//
//  GameViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    
    //MARK: vars
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var destroyedCountLabel: UILabel!
    @IBOutlet weak var timeLeftCountLabel: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var objects: [Object] = []
    
    var destroyedCount: Int = 0 {
        didSet {
            self.destroyedCountLabel.text = "\(destroyedCount)"
        }
    }
    
    var timeLeftCount: Int = 0 {
        didSet {
            self.timeLeftCountLabel.text = "\(timeLeftCount)"
        }
    }
    
    //MARK: view methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupScene()
        setupLights()
        setupPhysics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // start the scene session with the World Tracking Session Configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        sceneView.session.run(configuration)
        
        loadObjects()
    }
    
    //MARK: control methods
    
    func loadObjects() {
        
        let baseObjects = [
            Object.cube(),
            Object.pyramid(),
            Object.sphere(),
            Object.ring()
        ]
        
        for i in 0..<(NUMBER_OF_OBJECTS) {
            
            var index = i
            while index >= baseObjects.count {
                index -= baseObjects.count
            }
            
            let object = baseObjects[index].clone()
            object.opacity = 0
            objects.append(object)
            sceneView.scene.rootNode.addChildNode(object)
        }
    }
    
    func startGame() {
        
        destroyedCount = 0
        
        setUItoStartGame {
            self.regressiveCounter(starting: TIME_TO_FINISH)
            self.showObjects()
        }
    }
    
    func endGame () {
        hideAllObjects()
        setUItoEndGame()
    }
    
    func regressiveCounter(starting counter: Int) {
        timeLeftCount = counter
        
        if counter == 0 {
            endGame()
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                let newCounter = counter - 1
                self.regressiveCounter(starting: newCounter)
            }
        }
    }
    
    func showObject(object: SCNNode) {
        object.position = random3DPosition()
        addObjectPhysics(object: object)
        object.fadeIn()
    }
    
    func showObjects() {
        for object in objects {
            showObject(object: object)
        }
    }
    
    func hideObject(object: SCNNode, completion: (() -> Void)? = nil) {
        removePhysics(object: object)
        object.fadeOut {
            if let completion = completion {
                completion()
            }
        }
    }
    
    func hideAllObjects() {
        for object in objects {
            hideObject(object: object)
        }
    }
    
    func destroyObject(object: SCNNode) {
        hideObject(object: object) {
            self.showObject(object: object)
        }
    }
    
    //MARK: actions
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        startGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.hasActions == false {
                    if node.name == "ring" {
                        destroyedCount += 1
                        destroyObject(object: node)
                    } else if node.name == "object" {
                        if destroyedCount > 0 {
                            destroyedCount -= 1
                        }
                        destroyObject(object: node)
                    }
                }
            }
        }
    }
    
    //MARK: SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
    }
    
    //MARK: UI helpers
    
    func setupUI() {
        splashView.layer.cornerRadius = 10
        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        hudView.layer.cornerRadius = 6
    }
    
    func setupScene() {
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
    }
    
    func setupLights() {
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = false
        
        let environmentImage = UIImage(named:"Assets.scnassets/Environments/spherical.jpg")
        sceneView.scene.lightingEnvironment.contents = environmentImage
    }
    
    func setupPhysics() {
        
        // creates a box to be the scenario limit
        let wallThickness: CGFloat = 0.001
        let scenarioDiameter = CGFloat(SCENARIO_RADIUS * 2)
        
        // geometries
        let frontWall = SCNBox.init(width: scenarioDiameter, height: scenarioDiameter, length: wallThickness, chamferRadius: 0)
        let backWall = SCNBox.init(width: scenarioDiameter, height: scenarioDiameter, length: wallThickness, chamferRadius: 0)
        let leftWall = SCNBox.init(width: wallThickness, height: scenarioDiameter, length: scenarioDiameter, chamferRadius: 0)
        let rightWall = SCNBox.init(width: wallThickness, height: scenarioDiameter, length: scenarioDiameter, chamferRadius: 0)
        let roof = SCNBox.init(width: scenarioDiameter, height: wallThickness, length: scenarioDiameter, chamferRadius: 0)
        let ground = SCNBox.init(width: scenarioDiameter, height: wallThickness, length: scenarioDiameter, chamferRadius: 0)
        
        // materials
        let frontWallMaterial = SCNMaterial()
        frontWallMaterial.diffuse.contents = UIColor.red.withAlphaComponent(0.3)
        frontWall.materials = [frontWallMaterial]
        
        let backWallMaterial = SCNMaterial()
        backWallMaterial.diffuse.contents = UIColor.blue.withAlphaComponent(0.3)
        backWall.materials = [backWallMaterial]
        
        let leftWallMaterial = SCNMaterial()
        leftWallMaterial.diffuse.contents = UIColor.green.withAlphaComponent(0.3)
        leftWall.materials = [leftWallMaterial]
        
        let rightWallMaterial = SCNMaterial()
        rightWallMaterial.diffuse.contents = UIColor.yellow.withAlphaComponent(0.3)
        rightWall.materials = [rightWallMaterial]
        
        let roofMaterial = SCNMaterial()
        roofMaterial.diffuse.contents = UIColor.cyan.withAlphaComponent(0.3)
        roof.materials = [roofMaterial]
        
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
        ground.materials = [groundMaterial]
        
        // nodes
        let frontWallNode = SCNNode.init(geometry: frontWall)
        frontWallNode.name = "frontWall"
        frontWallNode.position = SCNVector3.init(0, 0, -SCENARIO_RADIUS)
        
        let backWallNode = SCNNode.init(geometry: backWall)
        backWallNode.name = "backWall"
        backWallNode.position = SCNVector3.init(0, 0, SCENARIO_RADIUS)
        
        let leftWallNode = SCNNode.init(geometry: leftWall)
        leftWallNode.name = "leftWall"
        leftWallNode.position = SCNVector3.init(-SCENARIO_RADIUS, 0, 0)
        
        let rightWallNode = SCNNode.init(geometry: rightWall)
        rightWallNode.name = "rightWall"
        rightWallNode.position = SCNVector3.init(SCENARIO_RADIUS, 0, 0)
        
        let roofNode = SCNNode.init(geometry: roof)
        roofNode.name = "roof"
        roofNode.position = SCNVector3.init(0, SCENARIO_RADIUS, 0)
        
        let groundNode = SCNNode.init(geometry: ground)
        groundNode.name = "ground"
        groundNode.position = SCNVector3.init(0, -SCENARIO_RADIUS, 0)
        
        // physic bodies
        addScenarioPhysics(scenarioPiece: frontWallNode)
        addScenarioPhysics(scenarioPiece: backWallNode)
        addScenarioPhysics(scenarioPiece: leftWallNode)
        addScenarioPhysics(scenarioPiece: rightWallNode)
        addScenarioPhysics(scenarioPiece: roofNode)
        addScenarioPhysics(scenarioPiece: groundNode)
        
        sceneView.scene.rootNode.addChildNode(frontWallNode)
        sceneView.scene.rootNode.addChildNode(backWallNode)
        sceneView.scene.rootNode.addChildNode(leftWallNode)
        sceneView.scene.rootNode.addChildNode(rightWallNode)
        sceneView.scene.rootNode.addChildNode(roofNode)
        sceneView.scene.rootNode.addChildNode(groundNode)
        
        sceneView.scene.physicsWorld.gravity = SCNVector3.init(0, 0, 0)
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    func setUItoStartGame(completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0
        }) { (success) in
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func setUItoEndGame(completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0.7
        }) { (success) in
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    //MARK: helpers
    
    func randomValue(from min: Float, to max: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (min - max) + max
    }
    
    func random3DPosition() -> SCNVector3 {
        let spawnAreaRadius = SCENARIO_RADIUS * 0.5
        let xPos = randomValue(from: -spawnAreaRadius, to: spawnAreaRadius)
        let yPos = randomValue(from: -spawnAreaRadius, to: spawnAreaRadius)
        let zPos = randomValue(from: -spawnAreaRadius, to: spawnAreaRadius)
        return SCNVector3(xPos, yPos, zPos)
    }
    
    func addObjectPhysics(object: SCNNode) {
        let physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: nil)
        physicsBody.mass = 1
        physicsBody.damping = 0
        physicsBody.categoryBitMask = CollisionCategory.Object.rawValue
        object.childNodes.first?.physicsBody = physicsBody
    }
    
    func addScenarioPhysics(scenarioPiece: SCNNode) {
        let physicsBody = SCNPhysicsBody.init(type: SCNPhysicsBodyType.kinematic, shape: nil)
        physicsBody.categoryBitMask = CollisionCategory.Ground.rawValue
        physicsBody.contactTestBitMask = CollisionCategory.Object.rawValue
        scenarioPiece.physicsBody = physicsBody
    }
    
    func removePhysics(object: SCNNode) {
        object.childNodes.first?.physicsBody = nil
    }
}

