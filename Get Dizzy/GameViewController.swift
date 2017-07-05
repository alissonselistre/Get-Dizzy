//
//  GameViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class GameViewController: UIViewController {
    
    //MARK: Game Settings
    let SCENARIO_LIMIT: Float = 1.5
    let NUMBER_OF_OBJECTS = 10
    let TIME_TO_FINISH = 15
    
    //MARK: vars
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: view methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // start the scene session with the World Tracking Session Configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        sceneView.session.run(configuration)
        
        startGame()
    }
    
    //MARK: control methods
    
    func startGame() {
        for _ in 0..<NUMBER_OF_OBJECTS {
            addObject()
        }
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
    
    //MARK: actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.name == "vase" && node.hasActionsRunning() == false {
                    node.blow()
                    addObject()
                }
            }
        }
    }
    
    @IBAction func addObjectButtonPressed(_ sender: UIButton) {
        addObject()
    }
    
    //MARK: helpers
    
    func randomPosition (lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
}

