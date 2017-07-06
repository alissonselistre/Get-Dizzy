//
//  GameViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

//MARK: Game Settings
let SCENARIO_LIMIT: Float = 1.5
let NUMBER_OF_OBJECTS: Int = 10
let TIME_TO_FINISH: Int = 15

class GameViewController: UIViewController {
    
    //MARK: vars
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var hudView: UIView!
    @IBOutlet weak var destroyedCountLabel: UILabel!
    @IBOutlet weak var timeLeftCountLabel: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
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
    }
    
    //MARK: control methods
    
    func startGame() {
        
        self.destroyedCount = 0
        
        setUItoStartGame {
            for _ in 0..<NUMBER_OF_OBJECTS {
                self.addObject()
            }
            
            self.regressiveCounter(starting: TIME_TO_FINISH)
        }
    }
    
    func endGame () {
        removeAllObjects()
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
    
    func objectDestroyed(object: SCNNode) {
        object.blow()
        destroyedCount += 1
        addObject()
    }
    
    func addObject() {
        
        // load object and your model
        let object = Object()
        object.loadModel()
        
        // set a random position in scene
        let xPos = randomPosition(lowerBound: -SCENARIO_LIMIT, upperBound: SCENARIO_LIMIT)
        let yPos = randomPosition(lowerBound: -SCENARIO_LIMIT, upperBound: SCENARIO_LIMIT)
        let zPos = randomPosition(lowerBound: -0.6, upperBound: -1)
        object.position = SCNVector3(xPos, yPos, zPos)
        
        // set the first state of the object for the animations
        object.opacity = 0
        
        // add this object in scene
        sceneView.scene.rootNode.addChildNode(object)
        
        // object animations
        object.infiniteRotation()
        object.fadeIn()
    }
    
    func removeAllObjects() {
        for node in sceneView.scene.rootNode.childNodes {
            node.blow()
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
                
                if node.name == "vase" && node.hasActionsRunning() == false {
                    objectDestroyed(object: node)
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
}

