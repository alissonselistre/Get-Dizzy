//
//  NodeAnimation.swift
//  Get Dizzy
//
//  Created by Alisson L. Selistre on 04/07/17.
//  Copyright © 2017 Alisson. All rights reserved.
//

import ARKit

extension SCNNode {
    
    //MARK: animations
    
    func fadeIn(completion: (() -> Void)? = nil) {
        let fadeInAction = SCNAction.fadeIn(duration: 0.3)
        animateWithCompletion(animation: fadeInAction, completion: completion)
    }
    
    func fadeOut(completion: (() -> Void)? = nil) {
        let fadeOutAction = SCNAction.fadeOut(duration: 0.3)
        animateWithCompletion(animation: fadeOutAction, completion: completion)
    }
    
    //MARK: helpers
    
    private func animateWithCompletion(animation: SCNAction, completion: (() -> Void)? = nil) {
        
        var animationSequence = [animation]
        
        if let completion = completion {
            let completionAction = SCNAction.run { (node) in
                completion()
            }
            animationSequence.append(completionAction)
        }
        
        runAction(SCNAction.sequence(animationSequence))
    }
}
