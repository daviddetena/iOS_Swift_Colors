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
    private var setPointAngle = M_PI_2      // Top point
    
    // Set limit angles using 30 deg as reference (M_PI/6)
    private var maxAngle = 7 * M_PI / 6
    private var minAngle = 0 - (M_PI / 6)
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
        imgKnobBase.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(UIImage(named:"img_switch_on"), for: .selected)
    }
    
    // MARK: - Actions
    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        
        if btnSwitch.isSelected {
            // Show imgKnob
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
            resetKnob()
        }
        else{
            // Dark gray background
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
    
    // MARK: - UIView settings
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK: - UIView touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Distance from image center to the point the user touched
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
            // Reset start point and angle when we stopped touching our image
            if touch.view == imgKnob{
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
                // Calculate angle as we drag
                let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                // Calculate distance from the previous point
                let angleDif = deltaAngle - angle
                let newTransform = startTransform.rotated(by: -angleDif) // for image
                let lastSetPointAngle = setPointAngle
                
                // Check we are inside min & max limits (add the distance we moved to previous angle)
                setPointAngle = setPointAngle + Double(angleDif)
                if setPointAngle >= minAngle && setPointAngle <= maxAngle {
                    // If inside the bounds, change bgcolor, apply transform, and chain transforms
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1.0)
                    imgKnob.transform = newTransform
                    self.startTransform = newTransform
                } else {
                    // If overbounded, set at limits
                    setPointAngle = lastSetPointAngle
                }
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    // MARK: - Utils
    
    /// Map circle colors except for our limits
    ///
    /// - Parameter angle: source angle
    /// - Returns: hue value (0-1)
    private func colorValueFromAngle(angle: Double) -> CGFloat{
        let hueValue = (angle - minAngle) * (360 / (maxAngle - minAngle))
        return CGFloat(hueValue / 360)
    }
    
    /// Check if we touch inside the image
    private func touchIsInKnobWithDistance(distance: CGFloat) -> Bool{
        // If radius > distance we are not in the knob image
        if distance > (imgKnob.bounds.height / 2) {
            return false
        }
        return true
    }
    
    /// Pythagoras' theorem
    ///
    /// - Parameter point: source point
    /// - Returns: Distance from the center to the specified point
    private func calculateDistanceFromCenter(_ point: CGPoint) -> CGFloat{
        let center = CGPoint(x: imgKnob.bounds.size.width / 2.0, y: imgKnob.bounds.size.height / 2.0)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dx) + (dy * dy))
    }
    
    private func resetKnob(){
        view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        // Start point to its default point
        imgKnob.transform = CGAffineTransform.identity
        setPointAngle = M_PI_2
    }
}

