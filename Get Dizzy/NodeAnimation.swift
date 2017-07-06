//
//  NodeAnimation.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

extension SCNNode {
    
    func fadeIn() {
        let fadeInAction = SCNAction.fadeIn(duration: 0.5)
        runAction(fadeInAction)
    }
    
    func blow(completion: (() -> Void)? = nil) {
        let fadeOutAction = SCNAction.fadeOut(duration: 0.6)
        let scaleOutAction = SCNAction.scale(to: 30, duration: 0.6)
        let blowAction = SCNAction.group([scaleOutAction, fadeOutAction])
        
        let completionAction = SCNAction.run { (node) in
            self.reset()
            if let completion = completion {
                completion()
            }
        }
        
        let animationSequence = SCNAction.sequence([blowAction, completionAction])
        
        runAction(animationSequence)
    }
    
    func reset() {
        scale = SCNVector3(x: 1, y: 1, z: 1)
        opacity = 0
    }
    
    func infiniteRotation() {
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.2))
        runAction(rotateAction)
    }
}
