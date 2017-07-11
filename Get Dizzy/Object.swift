//
//  Object.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class Object: SCNNode {
    
    static let dimensionScale: CGFloat = 0.2
    
    class func cube() -> Object {
        let object = Object()
        let cube = SCNBox.init(width: dimensionScale, height: dimensionScale, length: dimensionScale, chamferRadius: 0)
        cube.materials = [Material.stone]
        let node = SCNNode(geometry: cube)
        object.addChildNode(node)
        return object
    }
    
    class func sphere() -> Object {
        let object = Object()
        let sphere = SCNSphere.init(radius: dimensionScale)
        sphere.materials = [Material.rustedIron]
        let node = SCNNode(geometry: sphere)
        object.addChildNode(node)
        return object
    }
    
    class func pyramid() -> Object {
        let object = Object()
        let pyramid = SCNPyramid.init(width: dimensionScale, height: dimensionScale, length: dimensionScale)
        pyramid.materials = [Material.woodenFloor]
        let node = SCNNode(geometry: pyramid)
        object.addChildNode(node)
        return object
    }
    
    class func ring() -> Object {
        let object = Object()
        let torus = SCNTorus.init(ringRadius: dimensionScale, pipeRadius: dimensionScale*0.2)
        torus.materials = [Material.gold]
        let node = SCNNode(geometry: torus)
        object.addChildNode(node)
        return object
    }
}
