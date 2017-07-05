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
        let fadeInAction = SCNAction.fadeIn(duration: 1.5)
        runAction(fadeInAction)
    }
    
    func blow() {
        let fadeOutAction = SCNAction.fadeOut(duration: 0.5)
        let scaleOutAction = SCNAction.scale(to: 30, duration: 0.5)
        let blowAction = SCNAction.group([scaleOutAction, fadeOutAction])
        
        let removeFromParentAction = SCNAction.run { (node) in
            self.parent?.removeFromParentNode()
        }
        
        let animationSequence = SCNAction.sequence([blowAction, removeFromParentAction])
        
        parent?.runAction(animationSequence)
    }
    
    func infiniteRotation() {
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 0.2))
        runAction(rotateAction)
    }
    
    func hasActionsRunning() -> Bool {
        if hasActions {
            return true
        } else {
            if let parent = parent, parent.hasActions {
                return true
            }
        }
        
        return false
    }
}
