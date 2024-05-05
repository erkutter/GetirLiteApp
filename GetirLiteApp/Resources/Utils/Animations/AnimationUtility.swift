//
//  StepperAnimations.swift
//  GetirLiteApp
//
//  Created by Erkut Ter on 24.04.2024.
//

import Foundation
import UIKit

struct AnimationUtility {

    static func fadeInView(_ view: UIView, duration: TimeInterval = 0.3) {
        UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: {
            view.isHidden = false
        })
    }

    static func fadeOutView(_ view: UIView, duration: TimeInterval = 0.3) {
        UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: {
            view.isHidden = true
        })
    }
    
    static func bounceTextChange(label: UILabel, newText: String, duration: TimeInterval = 0.4) {
        let scaleUpTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        let scaleDownTransform = CGAffineTransform.identity

        UIView.animate(withDuration: duration / 2, animations: {
            label.transform = scaleUpTransform
        }, completion: { _ in            
            label.text = newText
            UIView.animate(withDuration: duration / 2, animations: {
                label.transform = scaleDownTransform
            })
        })
    }
}
