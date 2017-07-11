//
//  Object.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class Object: SCNNode {
    
    let dimensionScale: CGFloat = 0.2
    
    func loadCubeModel() {
        let cube = SCNBox.init(width: dimensionScale, height: dimensionScale, length: dimensionScale, chamferRadius: 0)
        cube.materials = [Material.stone]
        let node = SCNNode(geometry: cube)
        addChildNode(node)
    }
    
    func loadSphereModel() {
        let sphere = SCNSphere.init(radius: dimensionScale)
        sphere.materials = [Material.rustedIron]
        let node = SCNNode(geometry: sphere)
        addChildNode(node)
    }
    
    func loadPyramidModel() {
        let pyramid = SCNPyramid.init(width: dimensionScale, height: dimensionScale, length: dimensionScale)
        pyramid.materials = [Material.woodenFloor]
        let node = SCNNode(geometry: pyramid)
        addChildNode(node)
    }
    
    func loadRingModel() {
        let torus = SCNTorus.init(ringRadius: dimensionScale, pipeRadius: dimensionScale*0.2)
        torus.materials = [Material.gold]
        let node = SCNNode(geometry: torus)
        addChildNode(node)
    }
    
    func loadModel() {
        
        guard let virtualObjectScene = SCNScene(named: "Assets.scnassets/Models/Vase/vase.scn") else { return }
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }
}
