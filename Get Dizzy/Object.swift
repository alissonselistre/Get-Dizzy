//
//  Object.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class Object: SCNNode {
    
    func loadModel() {
        
        guard let virtualObjectScene = SCNScene(named: "Models.scnassets/vase/vase.scn") else { return }
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }
}
