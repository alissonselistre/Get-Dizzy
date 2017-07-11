//
//  GameViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

//MARK: Game Settings
let SCENARIO_RADIUS: Float = 1.5 // in meters
let NUMBER_OF_OBJECTS: Int = 20
let TIME_TO_FINISH: Int = 20 // in seconds

class GameViewController: UIViewController {
    
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
    
    func showObjects() {
        for object in objects {
            object.position = random3DPosition()
            object.fadeIn()
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
    
    func destroyObject(object: SCNNode) {
        destroyedCount += 1
        
        object.fadeOut() {
            object.position = self.random3DPosition()
            object.fadeIn()
        }
    }
    
    func hideAllObjects() {
        for object in objects {
            object.fadeOut()
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
                    destroyObject(object: node)
                }
            }
        }
    }
    
    //MARK: UI helpers
    
    func setupUI() {
        splashView.layer.cornerRadius = 10
        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        hudView.layer.cornerRadius = 6
    }
    
    func setupScene() {
        // create a new scene
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
        let xPos = randomValue(from: -SCENARIO_RADIUS, to: SCENARIO_RADIUS)
        let yPos = randomValue(from: -0.5, to: SCENARIO_RADIUS)
        let zPos = randomValue(from: -SCENARIO_RADIUS, to: SCENARIO_RADIUS)
        return SCNVector3(xPos, yPos, zPos)
    }
}

