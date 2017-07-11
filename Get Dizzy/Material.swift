//
//  Material.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 11/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

class Material: SCNMaterial {
    
    private static var materials: [String: SCNMaterial] = [:]
    
    //MARK: public
    
    class var rustedIron: SCNMaterial {
        get {
            return material(named: "rustediron-streaks")
        }
    }
    
    class var woodenFloor: SCNMaterial {
        get {
            return material(named: "sculptedfloorboards")
        }
    }
    
    class var granite: SCNMaterial {
        get {
            return material(named: "granitesmooth")
        }
    }
    
    class var stone: SCNMaterial {
        get {
            return material(named: "carvedlimestoneground")
        }
    }
    
    class var gold: SCNMaterial {
        get {
            return material(named: "gold-scuffed")
        }
    }
    
    //MARK: helpers
    
    private class func material(named name: String) -> SCNMaterial {
        
        if let material = materials[name] {
            return material
        } else {
            let material = createMaterial(named: name)
            materials[name] = material
            return material
        }
    }
    
    private class func createMaterial(named name: String) -> SCNMaterial {
        
        let material = SCNMaterial()
        
        material.lightingModel = SCNMaterial.LightingModel.physicallyBased
        
        let path = "Assets.scnassets/Materials/\(name)/\(name)"
        material.diffuse.contents = UIImage(named: "\(path)-albedo.png")
        material.roughness.contents = UIImage(named: "\(path)-roughness.png")
        material.metalness.contents = UIImage(named: "\(path)-metal.png")
        material.normal.contents = UIImage(named: "\(path)-normal.png")
        
        material.diffuse.wrapS = SCNWrapMode.repeat
        material.diffuse.wrapT = SCNWrapMode.repeat
        material.roughness.wrapS = SCNWrapMode.repeat
        material.roughness.wrapT = SCNWrapMode.repeat
        material.metalness.wrapS = SCNWrapMode.repeat
        material.metalness.wrapT = SCNWrapMode.repeat
        material.normal.wrapS = SCNWrapMode.repeat
        material.normal.wrapT = SCNWrapMode.repeat
        
        return material
    }
}
