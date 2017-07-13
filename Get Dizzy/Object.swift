//
//  Object.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class Object: SCNNode {

    //MARK: public
    
    class func cube() -> Object {
        let object = Object()
        
        let scale = CGFloat(SCENARIO_RADIUS * 0.06)
        
        let cube = SCNBox.init(width: scale, height: scale, length: scale, chamferRadius: 0)
        cube.materials = [Material.stone]
        
        let node = SCNNode(geometry: cube)
        node.name = "object"
        
        object.addChildNode(node)
        return object
    }
    
    class func sphere() -> Object {
        let object = Object()
        
        let scale = CGFloat(SCENARIO_RADIUS * 0.06)
        
        let sphere = SCNSphere.init(radius: scale)
        sphere.materials = [Material.rustedIron]
        
        let node = SCNNode(geometry: sphere)
        node.name = "object"
        
        object.addChildNode(node)
        return object
    }
    
    class func pyramid() -> Object {
        let object = Object()
        
        let scale = CGFloat(SCENARIO_RADIUS * 0.07)
        
        let pyramid = SCNPyramid.init(width: scale, height: scale, length: scale)
        pyramid.materials = [Material.woodenFloor]
        
        let node = SCNNode(geometry: pyramid)
        node.name = "object"
        
        object.addChildNode(node)
        return object
    }
    
    class func ring() -> Object {
        let object = Object()
        
        let scale = CGFloat(SCENARIO_RADIUS * 0.03)
        
        let torus = SCNTorus.init(ringRadius: scale, pipeRadius: scale*0.2)
        torus.materials = [Material.gold]
        
        let node = SCNNode(geometry: torus)
        node.name = "ring"
        
        object.addChildNode(node)
        return object
    }
}
