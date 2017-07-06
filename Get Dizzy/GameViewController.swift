//
//  GameViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

//MARK: Game Settings
let SCENARIO_LIMIT: Float = 2.0
let NUMBER_OF_OBJECTS: Int = 30
let TIME_TO_FINISH: Int = 20

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
        
        configureUI()
        
        // create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
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
        for _ in 0..<NUMBER_OF_OBJECTS {
            addObject()
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
        
        object.blow {
            object.position = self.random3DPosition()
            object.fadeIn()
        }
    }
    
    func addObject() {
        
        // load object and your model
        let object = Object()
        object.loadModel()
        
        // set a random position in scene
        object.position = random3DPosition()
        
        // set the first state of the object for the animations
        object.opacity = 0
        
        // add this object in scene
        sceneView.scene.rootNode.addChildNode(object)
        
        objects.append(object)
    }
    
    func hideAllObjects() {
        for object in objects {
            object.blow()
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
                
                if node.name == "vase" && node.hasActions == false {
                    destroyObject(object: node)
                }
            }
        }
    }
    
    //MARK: UI helpers
    
    func configureUI() {
        splashView.layer.cornerRadius = 10
        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = goButton.frame.size.height/2
        
        hudView.layer.cornerRadius = 6
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
    
    func randomPosition (lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    func random3DPosition() -> SCNVector3 {
        let xPos = randomPosition(lowerBound: -SCENARIO_LIMIT, upperBound: SCENARIO_LIMIT)
        let yPos = randomPosition(lowerBound: -SCENARIO_LIMIT, upperBound: SCENARIO_LIMIT)
        let zPos = randomPosition(lowerBound: -0.6, upperBound: -1)
        return SCNVector3(xPos, yPos, zPos)
    }
}

