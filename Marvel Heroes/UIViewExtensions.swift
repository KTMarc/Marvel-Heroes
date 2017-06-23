//
//  UIViewExtensions.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 14/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
Holds some short hand animations
 */

extension UIView {

    @objc func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)
    }
    
    @objc func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}


