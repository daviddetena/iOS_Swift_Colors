//
//  ViewController.swift
//  Colors
//
//  Created by David de Tena on 20/02/2017.
//  Copyright © 2017 David de Tena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgKnobBase: UIImageView!
    @IBOutlet weak var imgKnob: UIImageView!
    
    private var deltaAngle: CGFloat?
    private var startTransform: CGAffineTransform?
    
    // Start point
    private var setPointAngle = M_PI_2
    
    // Set bounds by using 30deg as the reference angle
    private var maxAngle = 7 * M_PI / 6
    private var minAngle = 0 - (M_PI / 6)
    
    
    // MARK: - UIView settings
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
        imgKnob.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(UIImage(named: "img_switch_on"), for: .selected)
    }
    
    
    // MARK: - Actions
    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if btnSwitch.isSelected {
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
            resetKnob()
        } else {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
    
    // MARK: - UI touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let delta = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(delta)
            if touchIsInKnobWithDistance(distance: dist) {
                startTransform = imgKnob.transform
                let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = delta.x - center.x
                let deltaY = delta.y - center.y
                deltaAngle = atan2(deltaY, deltaX)
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == imgKnob {
                deltaAngle = nil
                startTransform = nil
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first,
            let deltaAngle = deltaAngle,
            let startTransform = startTransform,
            touch.view == imgKnob {
            let position = touch.location(in: imgKnob)
            let dist = calculateDistanceFromCenter(position)
            if touchIsInKnobWithDistance(distance: dist) {
                // Calculate angle as dragging
                let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                // Calculate the distance between current and previous angles
                let angleDif = deltaAngle - angle
                let newTransform = startTransform.rotated(by: -angleDif) // for image
                let lastSetPointAngle = setPointAngle
                
                // Check we are inside min & max bounds
                // Add the distance moved to the previous angle
                setPointAngle = setPointAngle + Double(angleDif)
                if setPointAngle >= minAngle && setPointAngle <= maxAngle {
                    // If inside the bounds, change bgcolor, apply transform and chain transforms
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1.0)
                    imgKnob.transform = newTransform
                    self.startTransform = newTransform
                } else {
                    // If outside bounds, set to bound
                    setPointAngle = lastSetPointAngle
                }
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    
    // MARK: - Utils
    private func colorValueFromAngle(angle: Double) -> CGFloat {
        let hueValue = (angle - minAngle) * (360 / (maxAngle - minAngle))
        return CGFloat(hueValue / 360)
    }
    
    private func touchIsInKnobWithDistance(distance: CGFloat) -> Bool {
        if distance > (imgKnob.bounds.height / 2) { // estamos calculando el radio
            return false
        }
        return true
    }
    
    // Pythagoras theorem
    private func calculateDistanceFromCenter(_ point: CGPoint) -> CGFloat {
        let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dx) + (dy * dy))
    }
    
    private func resetKnob() {
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        imgKnob.transform = CGAffineTransform.identity
        setPointAngle = M_PI_2
    }
    
}
