//
//  ViewController.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

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
        
        addObject()
    }
    
    func addObject() {
        let object = Object()
        object.loadModel()
        
        let xPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        let yPos = randomPosition(lowerBound: -1.5, upperBound: 1.5)
        
        object.position = SCNVector3(xPos, yPos, -1)
        
        sceneView.scene.rootNode.addChildNode(object)
    }
    
    //MARK: actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.name == "vase" {
                    node.parent?.removeFromParentNode()
                    addObject()
                }
            }
        }
    }
    
    //MARK: helpers
    
    func randomPosition (lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
}

